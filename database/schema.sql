-- ==========================================
-- 1. EXTENSIONS
-- ==========================================
-- Zorg ervoor dat de pg_uuidv7 of vergelijkbare extensie/functie aanstaat in Supabase
-- Als Supabase standaard uuid_generate_v7() nog niet herkent, gebruik dan tijdelijk gen_random_uuid() 
-- of activeer de juiste pg_uuidv7 extensie in je dashboard.
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS postgis;

-- ==========================================
-- 2. TABLES
-- ==========================================

-- De hoofd-tabel (Gevoed door OpenStreetMap)
CREATE TABLE osm_places (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v7(),
    name TEXT NOT NULL,
    address TEXT,
    latitude FLOAT8 NOT NULL,
    longitude FLOAT8 NOT NULL,
    location geography(POINT, 4326),
    location_type TEXT NOT NULL DEFAULT 'place',
    genre TEXT,
    event_name TEXT,
    organizer TEXT,
    promo TEXT,
    poi TEXT,
    opening_hours_raw TEXT,
    start_time TIME,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- De Shadow Table (Append-Only geschiedenis van aanpassingen)
CREATE TABLE place_overrides (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v7(),
    place_id UUID NOT NULL REFERENCES osm_places(id) ON DELETE CASCADE,
    name TEXT,
    address TEXT,
    latitude FLOAT8,
    longitude FLOAT8,
    location geography(POINT, 4326),
    location_type TEXT,
    updated_by UUID REFERENCES auth.users(id),
    created_at TIMESTAMPTZ DEFAULT NOW()
    -- GEEN unique constraint meer op place_id: we bouwen een historie op!
    -- GEEN updated_at meer, want we updaten rijen niet, we voegen nieuwe toe.
);

CREATE TABLE opening_hours (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v7(),
    place_id UUID NOT NULL REFERENCES osm_places(id) ON DELETE CASCADE,
    day_of_week INT NOT NULL,
    open_time TIME NOT NULL,
    close_time TIME NOT NULL,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Samengevoegde Tags & Facilities
CREATE TABLE tags (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v7(),
    name TEXT NOT NULL,
    category TEXT NOT NULL DEFAULT 'general', -- bijv. 'music', 'facility', 'vibe'
    created_at TIMESTAMPTZ DEFAULT NOW(),
    UNIQUE(name, category)
);

CREATE TABLE place_tags (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v7(),
    place_id UUID NOT NULL REFERENCES osm_places(id) ON DELETE CASCADE,
    tag_id UUID NOT NULL REFERENCES tags(id) ON DELETE CASCADE,
    UNIQUE(place_id, tag_id)
);

-- Verenegingen (Associations)
CREATE TABLE associations (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v7(),
    name TEXT UNIQUE NOT NULL,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE association_places (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v7(),
    association_id UUID NOT NULL REFERENCES associations(id) ON DELETE CASCADE,
    place_id UUID NOT NULL REFERENCES osm_places(id) ON DELETE CASCADE,
    UNIQUE(association_id, place_id)
);

CREATE TABLE vibe_checks (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v7(),
    place_id UUID NOT NULL REFERENCES osm_places(id) ON DELETE CASCADE,
    is_positive BOOLEAN NOT NULL DEFAULT true,
    user_id UUID,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE squads (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v7(),
    pin TEXT UNIQUE NOT NULL,
    created_by TEXT NOT NULL,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE squad_members (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v7(),
    squad_id UUID NOT NULL REFERENCES squads(id) ON DELETE CASCADE,
    user_id TEXT NOT NULL,
    nickname TEXT NOT NULL,
    latitude FLOAT8 NOT NULL,
    longitude FLOAT8 NOT NULL,
    updated_at TIMESTAMPTZ DEFAULT NOW(),
    UNIQUE(squad_id, user_id)
);

CREATE TABLE squad_pins (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v7(),
    squad_id UUID NOT NULL REFERENCES squads(id) ON DELETE CASCADE,
    creator_id TEXT NOT NULL,
    latitude FLOAT8 NOT NULL,
    longitude FLOAT8 NOT NULL,
    target_time TIMESTAMPTZ NOT NULL,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE squad_pin_joins (
    pin_id UUID NOT NULL REFERENCES squad_pins(id) ON DELETE CASCADE,
    user_id TEXT NOT NULL,
    joined_at TIMESTAMPTZ DEFAULT NOW(),
    PRIMARY KEY (pin_id, user_id)
);

CREATE TABLE profiles (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v7(),
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

CREATE TABLE IF NOT EXISTS vibe_profiles (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v7(),
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
    id UUID PRIMARY KEY DEFAULT uuid_generate_v7(),
    user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
    action_type TEXT NOT NULL,
    place_id UUID REFERENCES osm_places(id) ON DELETE SET NULL,
    vp_earned INTEGER NOT NULL,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS user_badges (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v7(),
    user_id TEXT NOT NULL,
    badge_type TEXT NOT NULL,
    unlocked_at TIMESTAMPTZ DEFAULT NOW(),
    xp_earned INTEGER DEFAULT 0,
    UNIQUE(user_id, badge_type)
);

CREATE TABLE IF NOT EXISTS squad_challenges (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v7(),
    squad_id UUID NOT NULL REFERENCES squads(id) ON DELETE CASCADE,
    challenge_type TEXT NOT NULL,
    status TEXT DEFAULT 'available',
    started_at TIMESTAMPTZ DEFAULT NOW(),
    completed_at TIMESTAMPTZ,
    check_in_locations UUID[] DEFAULT '{}',
    current_progress INTEGER DEFAULT 0
);

CREATE TABLE IF NOT EXISTS safety_sessions (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v7(),
    user_id TEXT NOT NULL,
    checked_in_at TIMESTAMPTZ DEFAULT NOW(),
    location_lat DOUBLE PRECISION,
    location_lng DOUBLE PRECISION
);

CREATE TABLE IF NOT EXISTS app_events (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v7(),
    user_id TEXT,
    event_name TEXT NOT NULL,
    event_data JSONB DEFAULT '{}'::jsonb,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- ==========================================
-- 3. THE MAGIC VIEW (Transparent for Flutter)
-- ==========================================
CREATE OR REPLACE VIEW places WITH (security_invoker = true) AS
WITH latest_overrides AS (
    -- Dit pakt dynamisch altijd de NIEUWSTE regel per place_id
    SELECT DISTINCT ON (place_id) *
    FROM place_overrides
    ORDER BY place_id, created_at DESC
)
SELECT 
    op.id,
    COALESCE(lo.name, op.name) AS name,
    COALESCE(lo.address, op.address) AS address,
    COALESCE(lo.latitude, op.latitude) AS latitude,
    COALESCE(lo.longitude, op.longitude) AS longitude,
    COALESCE(lo.location, op.location) AS location,
    COALESCE(lo.location_type, op.location_type) AS location_type,
    op.genre,
    op.event_name,
    op.organizer,
    op.promo,
    op.poi,
    op.opening_hours_raw,
    op.start_time,
    op.created_at,
    -- Als er een nieuwe override is, neem dan de tijd daarvan
    GREATEST(op.updated_at, lo.created_at) AS updated_at
FROM osm_places op
LEFT JOIN latest_overrides lo ON op.id = lo.place_id;

-- ==========================================
-- 4. INDEXES
-- ==========================================
CREATE INDEX idx_osm_places_location_type ON osm_places(location_type);
CREATE INDEX idx_osm_places_location ON osm_places USING GIST(location);
CREATE INDEX idx_place_overrides_place_id_time ON place_overrides(place_id, created_at DESC);
CREATE INDEX idx_opening_hours_place_id ON opening_hours(place_id);
CREATE INDEX idx_opening_hours_day_time ON opening_hours(day_of_week, open_time, close_time);
CREATE INDEX idx_place_tags_place_id ON place_tags(place_id);
CREATE INDEX idx_place_tags_tag_id ON place_tags(tag_id);
CREATE INDEX idx_association_places_place_id ON association_places(place_id);
CREATE INDEX idx_tags_name_category ON tags(name, category);
CREATE INDEX idx_vibe_checks_place_id ON vibe_checks(place_id);
CREATE INDEX idx_vibe_checks_created_at ON vibe_checks(created_at DESC);
CREATE INDEX idx_squad_members_squad_id ON squad_members(squad_id);
CREATE INDEX idx_squad_members_user_id ON squad_members(user_id);
CREATE INDEX idx_squad_pins_squad_id ON squad_pins(squad_id);
CREATE INDEX idx_squad_pin_joins_pin_id ON squad_pin_joins(pin_id);
CREATE INDEX idx_profiles_user_id ON profiles(user_id);
CREATE INDEX idx_profiles_nickname ON profiles(nickname);
CREATE INDEX IF NOT EXISTS idx_vibe_profiles_user_id ON vibe_profiles(user_id);
CREATE INDEX IF NOT EXISTS idx_vibe_actions_user_id ON vibe_actions(user_id);
CREATE INDEX IF NOT EXISTS idx_vibe_actions_created_at ON vibe_actions(created_at DESC);
CREATE INDEX IF NOT EXISTS idx_user_badges_user_id ON user_badges(user_id);
CREATE INDEX IF NOT EXISTS idx_squad_challenges_squad_id ON squad_challenges(squad_id);
CREATE INDEX IF NOT EXISTS idx_safety_sessions_user_id ON safety_sessions(user_id);
CREATE INDEX IF NOT EXISTS idx_app_events_event_name ON app_events(event_name);
CREATE INDEX IF NOT EXISTS idx_app_events_created_at ON app_events(created_at DESC);

-- ==========================================
-- 5. ROW LEVEL SECURITY (RLS) & POLICIES
-- ==========================================
ALTER TABLE osm_places ENABLE ROW LEVEL SECURITY;
ALTER TABLE place_overrides ENABLE ROW LEVEL SECURITY;
ALTER TABLE opening_hours ENABLE ROW LEVEL SECURITY;
ALTER TABLE tags ENABLE ROW LEVEL SECURITY;
ALTER TABLE place_tags ENABLE ROW LEVEL SECURITY;
ALTER TABLE associations ENABLE ROW LEVEL SECURITY;
ALTER TABLE association_places ENABLE ROW LEVEL SECURITY;
ALTER TABLE vibe_checks ENABLE ROW LEVEL SECURITY;
ALTER TABLE squads ENABLE ROW LEVEL SECURITY;
ALTER TABLE squad_members ENABLE ROW LEVEL SECURITY;
ALTER TABLE squad_pins ENABLE ROW LEVEL SECURITY;
ALTER TABLE squad_pin_joins ENABLE ROW LEVEL SECURITY;
ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE vibe_profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE vibe_actions ENABLE ROW LEVEL SECURITY;
ALTER TABLE user_badges ENABLE ROW LEVEL SECURITY;
ALTER TABLE squad_challenges ENABLE ROW LEVEL SECURITY;
ALTER TABLE safety_sessions ENABLE ROW LEVEL SECURITY;
ALTER TABLE app_events ENABLE ROW LEVEL SECURITY;

-- Public read policies
CREATE POLICY "Public can read osm_places" ON osm_places FOR SELECT USING (true);
CREATE POLICY "Public can read place_overrides" ON place_overrides FOR SELECT USING (true);
CREATE POLICY "Public can read opening_hours" ON opening_hours FOR SELECT USING (true);
CREATE POLICY "Public can read tags" ON tags FOR SELECT USING (true);
CREATE POLICY "Public can read place_tags" ON place_tags FOR SELECT USING (true);
CREATE POLICY "Public can read associations" ON associations FOR SELECT USING (true);
CREATE POLICY "Public can read association_places" ON association_places FOR SELECT USING (true);
CREATE POLICY "Public can read vibe_checks" ON vibe_checks FOR SELECT USING (true);
CREATE POLICY "Anyone can read squads" ON squads FOR SELECT USING (true);
CREATE POLICY "Anyone can read squad_members" ON squad_members FOR SELECT USING (true);
CREATE POLICY "Anyone can read squad_pins" ON squad_pins FOR SELECT USING (true);
CREATE POLICY "Anyone can read squad_pin_joins" ON squad_pin_joins FOR SELECT USING (true);

-- Insert policies
CREATE POLICY "Anyone can insert vibe_checks" ON vibe_checks FOR INSERT WITH CHECK (true);
CREATE POLICY "Anyone can insert squads" ON squads FOR INSERT WITH CHECK (true);
CREATE POLICY "Anyone can insert squad_members" ON squad_members FOR INSERT WITH CHECK (true);
CREATE POLICY "Anyone can insert squad_pins" ON squad_pins FOR INSERT WITH CHECK (true);
CREATE POLICY "Anyone can insert squad_pin_joins" ON squad_pin_joins FOR INSERT WITH CHECK (true);
CREATE POLICY "Anyone can insert app_events" ON app_events FOR INSERT WITH CHECK (true);

-- Authenticated users can create overrides
CREATE POLICY "Authenticated users can insert overrides" ON place_overrides FOR INSERT WITH CHECK (auth.uid() IS NOT NULL);

-- Update/Delete policies for squads and pins
CREATE POLICY "Anyone can update squad_pins" ON squad_pins FOR UPDATE USING (true);
CREATE POLICY "Anyone can delete squad_pins" ON squad_pins FOR DELETE USING (true);
CREATE POLICY "Anyone can delete squad_pin_joins" ON squad_pin_joins FOR DELETE USING (true);

-- User specific policies
CREATE POLICY "Users can update own squad_member" ON squad_members FOR UPDATE USING (auth.uid()::text = user_id OR user_id IS NOT NULL);
CREATE POLICY "Users can delete own squad_member" ON squad_members FOR DELETE USING (auth.uid()::text = user_id OR user_id IS NOT NULL);

CREATE POLICY "Users can view own profile" ON profiles FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY "Users can update own profile" ON profiles FOR UPDATE USING (auth.uid() = user_id);
CREATE POLICY "Users can insert own profile" ON profiles FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY "Users can delete own profile" ON profiles FOR DELETE USING (auth.uid() = user_id);

CREATE POLICY "Users can own vibe_profile" ON vibe_profiles FOR ALL USING (auth.uid() = user_id);
CREATE POLICY "Users can own vibe_actions" ON vibe_actions FOR ALL USING (auth.uid() = user_id);
CREATE POLICY "Users can own user_badges" ON user_badges FOR ALL USING (user_id::text = auth.uid()::text);
CREATE POLICY "Users can own safety_sessions" ON safety_sessions FOR ALL USING (user_id::text = auth.uid()::text);

-- Complex policies
CREATE POLICY "Squad members can view squad_challenges" ON squad_challenges 
    FOR SELECT USING (
        EXISTS (
            SELECT 1 FROM squad_members 
            WHERE squad_id = squad_challenges.squad_id 
            AND user_id::text = auth.uid()::text
        )
    );

-- ==========================================
-- 6. REALTIME PUBLICATIONS
-- ==========================================
ALTER PUBLICATION supabase_realtime ADD TABLE squad_members;
ALTER PUBLICATION supabase_realtime ADD TABLE vibe_actions;
ALTER PUBLICATION supabase_realtime ADD TABLE squad_pins;
ALTER PUBLICATION supabase_realtime ADD TABLE squad_pin_joins;

-- ==========================================
-- 7. FUNCTIONS & TRIGGERS
-- ==========================================
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ language 'plpgsql';

CREATE OR REPLACE FUNCTION sync_place_location()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.latitude IS NOT NULL AND NEW.longitude IS NOT NULL THEN
        NEW.location = ST_SetSRID(ST_MakePoint(NEW.longitude, NEW.latitude), 4326);
    END IF;
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Triggers for osm_places
CREATE TRIGGER update_osm_places_location_trigger
    BEFORE INSERT OR UPDATE OF latitude, longitude ON osm_places
    FOR EACH ROW
    EXECUTE FUNCTION sync_place_location();

CREATE TRIGGER update_osm_places_updated_at
    BEFORE UPDATE ON osm_places
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

-- Triggers for place_overrides (Alleen voor locatie, GEEN updated_at trigger meer nodig!)
CREATE TRIGGER update_place_overrides_location_trigger
    BEFORE INSERT OR UPDATE OF latitude, longitude ON place_overrides
    FOR EACH ROW
    EXECUTE FUNCTION sync_place_location();

-- Other Triggers
CREATE TRIGGER update_squad_members_updated_at
    BEFORE UPDATE ON squad_members
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_squad_pins_updated_at
    BEFORE UPDATE ON squad_pins
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_profiles_updated_at
    BEFORE UPDATE ON profiles
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_vibe_profiles_updated_at
    BEFORE UPDATE ON vibe_profiles
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

-- Custom App Functions
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

CREATE OR REPLACE FUNCTION get_places_in_viewport(
    min_lat FLOAT,
    min_lng FLOAT,
    max_lat FLOAT,
    max_lng FLOAT
)
RETURNS SETOF places
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
BEGIN
    RETURN QUERY
    SELECT *
    FROM places
    WHERE location && ST_MakeEnvelope(min_lng, min_lat, max_lng, max_lat, 4326)::geography;
END;
$$;

-- Opmerking: calculate_and_update_vibes() is verwijderd omdat we dit in de frontend of via Edge Functions berekenen!