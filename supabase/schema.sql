CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS postgis;

DO $$ BEGIN
    CREATE TYPE location_type AS ENUM ('club', 'food', 'emergency');
EXCEPTION
    WHEN duplicate_object THEN null;
END $$;

DO $$ BEGIN
    CREATE TYPE club_status AS ENUM ('open', 'event', 'closed');
EXCEPTION
    WHEN duplicate_object THEN null;
END $$;

CREATE TABLE venues (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name TEXT NOT NULL,
    address TEXT NOT NULL,
    latitude FLOAT8 NOT NULL,
    longitude FLOAT8 NOT NULL,
    location geography(POINT, 4326),
    location_type location_type NOT NULL DEFAULT 'club',
    genre TEXT,
    status club_status NOT NULL DEFAULT 'closed',
    event_name TEXT,
    organizer TEXT,
    promo TEXT,
    is_flash_promo_active BOOLEAN DEFAULT false,
    poi TEXT,
    crowd_level TEXT,
    wait_time TEXT,
    last_vibe_update TIMESTAMPTZ,
    is_vereniging BOOLEAN DEFAULT false,
    start_time TIME,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE tags (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name TEXT UNIQUE NOT NULL,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE facilities (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name TEXT UNIQUE NOT NULL,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE venue_tags (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    venue_id UUID NOT NULL REFERENCES venues(id) ON DELETE CASCADE,
    tag_id UUID NOT NULL REFERENCES tags(id) ON DELETE CASCADE,
    UNIQUE(venue_id, tag_id)
);

CREATE TABLE venue_facilities (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    venue_id UUID NOT NULL REFERENCES venues(id) ON DELETE CASCADE,
    facility_id UUID NOT NULL REFERENCES facilities(id) ON DELETE CASCADE,
    UNIQUE(venue_id, facility_id)
);

CREATE TABLE vibe_checks (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    venue_id UUID NOT NULL REFERENCES venues(id) ON DELETE CASCADE,
    crowd_level TEXT NOT NULL,
    energy INT CHECK (energy >= 1 AND energy <= 10),
    user_id UUID,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE squads (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    pin TEXT UNIQUE NOT NULL,
    created_by TEXT NOT NULL,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE squad_members (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    squad_id UUID NOT NULL REFERENCES squads(id) ON DELETE CASCADE,
    user_id TEXT NOT NULL,
    nickname TEXT NOT NULL,
    latitude FLOAT8 NOT NULL,
    longitude FLOAT8 NOT NULL,
    updated_at TIMESTAMPTZ DEFAULT NOW(),
    UNIQUE(squad_id, user_id)
);

CREATE TABLE profiles (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
    first_name TEXT NOT NULL,
    last_name TEXT NOT NULL,
    email TEXT NOT NULL,
    birthday DATE NOT NULL,
    nickname TEXT NOT NULL,
    avatar_url TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW(),
    UNIQUE(user_id)
);

CREATE INDEX idx_venues_location_type ON venues(location_type);
CREATE INDEX idx_venues_status ON venues(status);
CREATE INDEX idx_venues_location ON venues USING GIST(location);
CREATE INDEX idx_venue_tags_venue_id ON venue_tags(venue_id);
CREATE INDEX idx_venue_tags_tag_id ON venue_tags(tag_id);
CREATE INDEX idx_venue_facilities_venue_id ON venue_facilities(venue_id);
CREATE INDEX idx_venue_facilities_facility_id ON venue_facilities(facility_id);
CREATE INDEX idx_tags_name ON tags(name);
CREATE INDEX idx_facilities_name ON facilities(name);
CREATE INDEX idx_vibe_checks_venue_id ON vibe_checks(venue_id);
CREATE INDEX idx_vibe_checks_created_at ON vibe_checks(created_at DESC);
CREATE INDEX idx_squad_members_squad_id ON squad_members(squad_id);
CREATE INDEX idx_squad_members_user_id ON squad_members(user_id);
CREATE INDEX idx_profiles_user_id ON profiles(user_id);
CREATE INDEX idx_profiles_nickname ON profiles(nickname);

ALTER TABLE venues ENABLE ROW LEVEL SECURITY;
ALTER TABLE tags ENABLE ROW LEVEL SECURITY;
ALTER TABLE facilities ENABLE ROW LEVEL SECURITY;
ALTER TABLE venue_tags ENABLE ROW LEVEL SECURITY;
ALTER TABLE venue_facilities ENABLE ROW LEVEL SECURITY;
ALTER TABLE vibe_checks ENABLE ROW LEVEL SECURITY;
ALTER TABLE squads ENABLE ROW LEVEL SECURITY;
ALTER TABLE squad_members ENABLE ROW LEVEL SECURITY;
ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Public can read venues" ON venues FOR SELECT USING (true);
CREATE POLICY "Public can read tags" ON tags FOR SELECT USING (true);
CREATE POLICY "Public can read facilities" ON facilities FOR SELECT USING (true);
CREATE POLICY "Public can read venue_tags" ON venue_tags FOR SELECT USING (true);
CREATE POLICY "Public can read venue_facilities" ON venue_facilities FOR SELECT USING (true);
CREATE POLICY "Anyone can insert vibe_checks" ON vibe_checks FOR INSERT WITH CHECK (true);
CREATE POLICY "Public can read vibe_checks" ON vibe_checks FOR SELECT USING (true);

CREATE POLICY "Anyone can insert squads" ON squads FOR INSERT WITH CHECK (true);
CREATE POLICY "Anyone can read squads" ON squads FOR SELECT USING (true);

CREATE POLICY "Anyone can insert squad_members" ON squad_members FOR INSERT WITH CHECK (true);
CREATE POLICY "Anyone can read squad_members" ON squad_members FOR SELECT USING (true);
CREATE POLICY "Users can update own squad_member" ON squad_members FOR UPDATE USING (auth.uid()::text = user_id OR user_id IS NOT NULL);
CREATE POLICY "Users can delete own squad_member" ON squad_members FOR DELETE USING (auth.uid()::text = user_id OR user_id IS NOT NULL);

CREATE POLICY "Users can view own profile" ON profiles FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY "Users can update own profile" ON profiles FOR UPDATE USING (auth.uid() = user_id);
CREATE POLICY "Users can insert own profile" ON profiles FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY "Users can delete own profile" ON profiles FOR DELETE USING (auth.uid() = user_id);

ALTER PUBLICATION supabase_realtime ADD TABLE squad_members;

CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ language 'plpgsql';

CREATE OR REPLACE FUNCTION sync_venue_location()
RETURNS TRIGGER AS $$
BEGIN
    NEW.location = ST_SetSRID(ST_MakePoint(NEW.longitude, NEW.latitude), 4326);
    RETURN NEW;
END;
$$ language 'plpgsql';

CREATE TRIGGER update_venues_location_trigger
    BEFORE INSERT OR UPDATE OF latitude, longitude ON venues
    FOR EACH ROW
    EXECUTE FUNCTION sync_venue_location();

CREATE TRIGGER update_venues_updated_at
    BEFORE UPDATE ON venues
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_squad_members_updated_at
    BEFORE UPDATE ON squad_members
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_profiles_updated_at
    BEFORE UPDATE ON profiles
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

CREATE OR REPLACE FUNCTION create_squad(p_user_id TEXT, p_nickname TEXT, p_lat FLOAT8, p_lng FLOAT8)
RETURNS json
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
    v_pin TEXT;
    v_squad RECORD;
    v_member RECORD;
BEGIN
    v_pin := lpad(floor(random() * 1000000)::text, 6, '0');
    
    INSERT INTO squads (pin, created_by) VALUES (v_pin, p_user_id) RETURNING * INTO v_squad;
    
    INSERT INTO squad_members (squad_id, user_id, nickname, latitude, longitude)
    VALUES (v_squad.id, p_user_id, p_nickname, p_lat, p_lng) RETURNING * INTO v_member;
    
    RETURN json_build_object(
        'squad', row_to_json(v_squad),
        'member', row_to_json(v_member)
    );
END;
$$;

CREATE TABLE IF NOT EXISTS vibe_profiles (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
    total_vp INTEGER DEFAULT 0,
    current_level INTEGER DEFAULT 1,
    weekend_streak INTEGER DEFAULT 0,
    last_check_in TIMESTAMPTZ,
    visited_places UUID[] DEFAULT '{}',
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW(),
    UNIQUE(user_id)
);

CREATE TABLE IF NOT EXISTS vibe_actions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
    action_type TEXT NOT NULL,
    venue_id UUID REFERENCES venues(id) ON DELETE SET NULL,
    vp_earned INTEGER NOT NULL,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_vibe_profiles_user_id ON vibe_profiles(user_id);
CREATE INDEX IF NOT EXISTS idx_vibe_actions_user_id ON vibe_actions(user_id);
CREATE INDEX IF NOT EXISTS idx_vibe_actions_created_at ON vibe_actions(created_at DESC);

ALTER TABLE vibe_profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE vibe_actions ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can own vibe_profile" ON vibe_profiles 
    FOR ALL USING (auth.uid() = user_id);

CREATE POLICY "Users can own vibe_actions" ON vibe_actions 
    FOR ALL USING (auth.uid() = user_id);

ALTER PUBLICATION supabase_realtime ADD TABLE vibe_actions;

CREATE TABLE IF NOT EXISTS user_badges (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id TEXT NOT NULL,
    badge_type TEXT NOT NULL,
    unlocked_at TIMESTAMPTZ DEFAULT NOW(),
    xp_earned INTEGER DEFAULT 0,
    UNIQUE(user_id, badge_type)
);

CREATE TABLE IF NOT EXISTS squad_challenges (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    squad_id UUID NOT NULL REFERENCES squads(id) ON DELETE CASCADE,
    challenge_type TEXT NOT NULL,
    status TEXT DEFAULT 'available',
    started_at TIMESTAMPTZ DEFAULT NOW(),
    completed_at TIMESTAMPTZ,
    check_in_locations UUID[] DEFAULT '{}',
    current_progress INTEGER DEFAULT 0
);

CREATE TABLE IF NOT EXISTS safety_sessions (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id TEXT NOT NULL,
    checked_in_at TIMESTAMPTZ DEFAULT NOW(),
    location_lat DOUBLE PRECISION,
    location_lng DOUBLE PRECISION
);

CREATE INDEX IF NOT EXISTS idx_user_badges_user_id ON user_badges(user_id);
CREATE INDEX IF NOT EXISTS idx_squad_challenges_squad_id ON squad_challenges(squad_id);
CREATE INDEX IF NOT EXISTS idx_safety_sessions_user_id ON safety_sessions(user_id);

ALTER TABLE user_badges ENABLE ROW LEVEL SECURITY;
ALTER TABLE squad_challenges ENABLE ROW LEVEL SECURITY;
ALTER TABLE safety_sessions ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can own user_badges" ON user_badges 
    FOR ALL USING (user_id::text = auth.uid()::text);

CREATE POLICY "Squad members can view squad_challenges" ON squad_challenges 
    FOR SELECT USING (
        EXISTS (
            SELECT 1 FROM squad_members 
            WHERE squad_id = squad_challenges.squad_id 
            AND user_id::text = auth.uid()::text
        )
    );

CREATE POLICY "Users can own safety_sessions" ON safety_sessions 
    FOR ALL USING (user_id::text = auth.uid()::text);

CREATE TRIGGER update_vibe_profiles_updated_at
    BEFORE UPDATE ON vibe_profiles
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

-- ============================================
-- ANALYTICS & TELEMETRY (FASE 4)
-- ============================================

CREATE TABLE IF NOT EXISTS app_events (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id TEXT,
    event_name TEXT NOT NULL,
    event_data JSONB DEFAULT '{}'::jsonb,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_app_events_event_name ON app_events(event_name);
CREATE INDEX IF NOT EXISTS idx_app_events_created_at ON app_events(created_at DESC);

ALTER TABLE app_events ENABLE ROW LEVEL SECURITY;

-- Iedereen mag events posten (ook anonieme gebruikers), maar niemand mag ze lezen (behalve jij via het Supabase dashboard)
CREATE POLICY "Anyone can insert app_events" ON app_events FOR INSERT WITH CHECK (true);