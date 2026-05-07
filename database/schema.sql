drop schema public cascade;
create schema public;

CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS postgis;

CREATE TABLE places (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
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

CREATE TABLE place_overrides (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    place_id UUID NOT NULL REFERENCES places(id) ON DELETE CASCADE,
    name TEXT,
    address TEXT,
    latitude FLOAT8,
    longitude FLOAT8,
    location geography(POINT, 4326),
    location_type TEXT,
    updated_by UUID REFERENCES auth.users(id),
    created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE opening_hours (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    place_id UUID NOT NULL REFERENCES places(id) ON DELETE CASCADE,
    day_of_week INT NOT NULL,
    open_time TIME NOT NULL,
    close_time TIME NOT NULL,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE tags (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name TEXT NOT NULL,
    category TEXT NOT NULL DEFAULT 'general', 
    created_at TIMESTAMPTZ DEFAULT NOW(),
    UNIQUE(name, category)
);

CREATE TABLE place_tags (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    place_id UUID NOT NULL REFERENCES places(id) ON DELETE CASCADE,
    tag_id UUID NOT NULL REFERENCES tags(id) ON DELETE CASCADE,
    UNIQUE(place_id, tag_id)
);

CREATE TABLE associations (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name TEXT UNIQUE NOT NULL,
    description TEXT,
    logo_url TEXT,
    banner_url TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE association_tags (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    association_id UUID NOT NULL REFERENCES associations(id) ON DELETE CASCADE,
    tag_id UUID NOT NULL REFERENCES tags(id) ON DELETE CASCADE,
    UNIQUE(association_id, tag_id)
);

CREATE TABLE association_places (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    association_id UUID NOT NULL REFERENCES associations(id) ON DELETE CASCADE,
    place_id UUID NOT NULL REFERENCES places(id) ON DELETE CASCADE,
    UNIQUE(association_id, place_id)
);

CREATE TABLE association_members (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    association_id UUID NOT NULL REFERENCES associations(id) ON DELETE CASCADE,
    user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
    role TEXT NOT NULL DEFAULT 'member',
    joined_at TIMESTAMPTZ DEFAULT NOW(),
    UNIQUE(association_id, user_id)
);

CREATE TABLE events (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    created_by UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    title TEXT NOT NULL,
    description TEXT,
    address TEXT,
    latitude FLOAT8 NOT NULL, 
    longitude FLOAT8 NOT NULL,
    location geography(POINT, 4326),
    start_datetime TIMESTAMPTZ NOT NULL,
    end_datetime TIMESTAMPTZ,
    image_url TEXT,
    place_id UUID REFERENCES places(id) ON DELETE SET NULL,
    association_id UUID REFERENCES associations(id) ON DELETE SET NULL,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE vibe_checks (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    place_id UUID REFERENCES places(id) ON DELETE CASCADE,
    event_id UUID REFERENCES events(id) ON DELETE CASCADE,
    is_positive BOOLEAN NOT NULL DEFAULT true,
    user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE user_event_saves (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    event_id UUID REFERENCES events(id) ON DELETE CASCADE,
    created_at TIMESTAMPTZ DEFAULT NOW()
);
CREATE UNIQUE INDEX idx_user_event_saves_event ON user_event_saves(user_id, event_id) WHERE event_id IS NOT NULL;

CREATE TABLE squads (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    pin TEXT UNIQUE NOT NULL,
    created_by UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE squad_members (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    squad_id UUID NOT NULL REFERENCES squads(id) ON DELETE CASCADE,
    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    nickname TEXT NOT NULL,
    latitude FLOAT8 NOT NULL,
    longitude FLOAT8 NOT NULL,
    updated_at TIMESTAMPTZ DEFAULT NOW(),
    UNIQUE(squad_id, user_id)
);

CREATE TABLE squad_pins (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    squad_id UUID NOT NULL REFERENCES squads(id) ON DELETE CASCADE,
    creator_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    latitude FLOAT8 NOT NULL,
    longitude FLOAT8 NOT NULL,
    target_time TIMESTAMPTZ NOT NULL,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE squad_pin_joins (
    pin_id UUID NOT NULL REFERENCES squad_pins(id) ON DELETE CASCADE,
    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    joined_at TIMESTAMPTZ DEFAULT NOW(),
    PRIMARY KEY (pin_id, user_id)
);

CREATE TABLE profiles (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
    first_name TEXT NOT NULL,
    last_name TEXT NOT NULL,
    email TEXT NOT NULL,
    nickname TEXT NOT NULL,
    avatar_url TEXT,
    bio TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW(),
    UNIQUE(user_id)
);

CREATE TABLE user_followers (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    follower_id UUID NOT NULL REFERENCES profiles(user_id) ON DELETE CASCADE,
    following_id UUID NOT NULL REFERENCES profiles(user_id) ON DELETE CASCADE,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    UNIQUE(follower_id, following_id)
);

CREATE TABLE user_push_tokens (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    token TEXT NOT NULL,
    platform TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW(),
    UNIQUE(user_id, token)
);

CREATE TABLE vibe_profiles (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
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

CREATE TABLE vibe_actions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
    action_type TEXT NOT NULL,
    place_id UUID REFERENCES places(id) ON DELETE SET NULL,
    event_id UUID REFERENCES events(id) ON DELETE SET NULL,
    vp_earned INTEGER NOT NULL,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE user_badges (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    badge_type TEXT NOT NULL,
    unlocked_at TIMESTAMPTZ DEFAULT NOW(),
    xp_earned INTEGER DEFAULT 0,
    UNIQUE(user_id, badge_type)
);

CREATE TABLE squad_challenges (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    squad_id UUID NOT NULL REFERENCES squads(id) ON DELETE CASCADE,
    challenge_type TEXT NOT NULL,
    status TEXT DEFAULT 'available',
    started_at TIMESTAMPTZ DEFAULT NOW(),
    completed_at TIMESTAMPTZ,
    check_in_locations UUID[] DEFAULT '{}',
    current_progress INTEGER DEFAULT 0
);

CREATE TABLE safety_sessions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    checked_in_at TIMESTAMPTZ DEFAULT NOW(),
    location_lat DOUBLE PRECISION,
    location_lng DOUBLE PRECISION
);

CREATE TABLE app_events (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
    event_name TEXT NOT NULL,
    event_data JSONB DEFAULT '{}'::jsonb,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE OR REPLACE VIEW places_view WITH (security_invoker = true) AS
WITH latest_overrides AS (
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
    GREATEST(op.updated_at, lo.created_at) AS updated_at
FROM places op
LEFT JOIN latest_overrides lo ON op.id = lo.place_id;

CREATE INDEX idx_osm_places_location_type ON places(location_type);
CREATE INDEX idx_osm_places_location ON places USING GIST(location);
CREATE INDEX idx_place_overrides_place_id_time ON place_overrides(place_id, created_at DESC);
CREATE INDEX idx_opening_hours_place_id ON opening_hours(place_id);
CREATE INDEX idx_place_tags_place_id ON place_tags(place_id);
CREATE INDEX idx_association_tags_association_id ON association_tags(association_id);
CREATE INDEX idx_association_places_place_id ON association_places(place_id);
CREATE INDEX idx_association_members_association_id ON association_members(association_id);
CREATE INDEX idx_association_members_user_id ON association_members(user_id);
CREATE INDEX idx_events_location ON events USING GIST(location);
CREATE INDEX idx_events_start_datetime ON events(start_datetime);
CREATE INDEX idx_vibe_checks_place_id ON vibe_checks(place_id);
CREATE INDEX idx_vibe_checks_event_id ON vibe_checks(event_id);
CREATE INDEX idx_squad_members_squad_id ON squad_members(squad_id);
CREATE INDEX idx_squad_pins_squad_id ON squad_pins(squad_id);
CREATE INDEX idx_user_followers_follower ON user_followers(follower_id);
CREATE INDEX idx_user_followers_following ON user_followers(following_id);
CREATE INDEX idx_user_push_tokens_user ON user_push_tokens(user_id);

ALTER TABLE places ENABLE ROW LEVEL SECURITY;
ALTER TABLE place_overrides ENABLE ROW LEVEL SECURITY;
ALTER TABLE opening_hours ENABLE ROW LEVEL SECURITY;
ALTER TABLE tags ENABLE ROW LEVEL SECURITY;
ALTER TABLE place_tags ENABLE ROW LEVEL SECURITY;
ALTER TABLE associations ENABLE ROW LEVEL SECURITY;
ALTER TABLE association_tags ENABLE ROW LEVEL SECURITY;
ALTER TABLE association_places ENABLE ROW LEVEL SECURITY;
ALTER TABLE association_members ENABLE ROW LEVEL SECURITY;
ALTER TABLE events ENABLE ROW LEVEL SECURITY;
ALTER TABLE user_event_saves ENABLE ROW LEVEL SECURITY;
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
ALTER TABLE user_followers ENABLE ROW LEVEL SECURITY;
ALTER TABLE user_push_tokens ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Public read access" ON places FOR SELECT USING (true);
CREATE POLICY "Public read access" ON place_overrides FOR SELECT USING (true);
CREATE POLICY "Public read access" ON opening_hours FOR SELECT USING (true);
CREATE POLICY "Public read access" ON tags FOR SELECT USING (true);
CREATE POLICY "Public read access" ON place_tags FOR SELECT USING (true);
CREATE POLICY "Public read access" ON associations FOR SELECT USING (true);
CREATE POLICY "Public read access" ON association_tags FOR SELECT USING (true);
CREATE POLICY "Public read access" ON association_places FOR SELECT USING (true);
CREATE POLICY "Public read access" ON association_members FOR SELECT USING (true);
CREATE POLICY "Public read access" ON events FOR SELECT USING (true);
CREATE POLICY "Public read access" ON vibe_checks FOR SELECT USING (true);
CREATE POLICY "Public read access" ON squads FOR SELECT USING (true);
CREATE POLICY "Public read access" ON squad_members FOR SELECT USING (true);
CREATE POLICY "Public read access" ON squad_pins FOR SELECT USING (true);
CREATE POLICY "Public read access" ON squad_pin_joins FOR SELECT USING (true);

CREATE POLICY "Public read access on followers" ON user_followers FOR SELECT USING (true);
CREATE POLICY "Users can follow others" ON user_followers FOR INSERT WITH CHECK (auth.uid() = follower_id);
CREATE POLICY "Users can unfollow" ON user_followers FOR DELETE USING (auth.uid() = follower_id);

CREATE POLICY "Users can manage own push tokens" ON user_push_tokens FOR ALL USING (auth.uid() = user_id);
CREATE POLICY "Users can manage their saves" ON user_event_saves FOR ALL USING (auth.uid() = user_id);

CREATE POLICY "Users can insert events" ON events FOR INSERT WITH CHECK (auth.uid() = created_by);
CREATE POLICY "Users can update own events" ON events FOR UPDATE USING (auth.uid() = created_by);
CREATE POLICY "Users can delete own events" ON events FOR DELETE USING (auth.uid() = created_by);

CREATE POLICY "Allow inserts" ON vibe_checks FOR INSERT WITH CHECK (true);
CREATE POLICY "Allow inserts" ON squads FOR INSERT WITH CHECK (true);
CREATE POLICY "Allow inserts" ON squad_members FOR INSERT WITH CHECK (true);
CREATE POLICY "Allow inserts" ON squad_pins FOR INSERT WITH CHECK (true);
CREATE POLICY "Allow inserts" ON squad_pin_joins FOR INSERT WITH CHECK (true);
CREATE POLICY "Allow inserts" ON app_events FOR INSERT WITH CHECK (true);

CREATE POLICY "Allow updates" ON squad_pins FOR UPDATE USING (true);
CREATE POLICY "Allow deletes" ON squad_pins FOR DELETE USING (true);
CREATE POLICY "Allow deletes" ON squad_pin_joins FOR DELETE USING (true);

CREATE POLICY "Users can update own squad_member" ON squad_members FOR UPDATE USING (true);
CREATE POLICY "Users can delete own squad_member" ON squad_members FOR DELETE USING (true);

CREATE POLICY "Public read access on profiles" ON profiles FOR SELECT USING (true);
CREATE POLICY "Users can update own profile" ON profiles FOR UPDATE USING (auth.uid() = user_id);
CREATE POLICY "Users can insert own profile" ON profiles FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY "Users can delete own profile" ON profiles FOR DELETE USING (auth.uid() = user_id);

CREATE POLICY "Public read access on vibe_profiles" ON vibe_profiles FOR SELECT USING (true);
CREATE POLICY "Users can manage own vibe_profile" ON vibe_profiles FOR ALL USING (auth.uid() = user_id);

CREATE POLICY "Public read access on vibe_actions" ON vibe_actions FOR SELECT USING (true);
CREATE POLICY "Users can manage own vibe_actions" ON vibe_actions FOR ALL USING (auth.uid() = user_id);

CREATE POLICY "Public read access on user_badges" ON user_badges FOR SELECT USING (true);
CREATE POLICY "Users can manage own user_badges" ON user_badges FOR ALL USING (user_id = auth.uid());

DO $$ BEGIN
    CREATE PUBLICATION supabase_realtime;
EXCEPTION
    WHEN duplicate_object THEN null;
END $$;

ALTER PUBLICATION supabase_realtime ADD TABLE squad_members;
ALTER PUBLICATION supabase_realtime ADD TABLE vibe_actions;
ALTER PUBLICATION supabase_realtime ADD TABLE squad_pins;
ALTER PUBLICATION supabase_realtime ADD TABLE squad_pin_joins;
ALTER PUBLICATION supabase_realtime ADD TABLE events;
ALTER PUBLICATION supabase_realtime ADD TABLE user_event_saves;
ALTER PUBLICATION supabase_realtime ADD TABLE user_followers;

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

CREATE TRIGGER update_osm_places_location_trigger
    BEFORE INSERT OR UPDATE OF latitude, longitude ON places
    FOR EACH ROW EXECUTE FUNCTION sync_place_location();

CREATE TRIGGER update_events_location_trigger
    BEFORE INSERT OR UPDATE OF latitude, longitude ON events
    FOR EACH ROW EXECUTE FUNCTION sync_place_location();

CREATE TRIGGER update_events_updated_at
    BEFORE UPDATE ON events
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_squad_members_updated_at
    BEFORE UPDATE ON squad_members
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_push_tokens_updated_at
    BEFORE UPDATE ON user_push_tokens
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE OR REPLACE FUNCTION create_squad(p_user_id UUID, p_nickname TEXT, p_lat FLOAT8, p_lng FLOAT8)
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
    RETURN json_build_object('squad', row_to_json(v_squad), 'member', row_to_json(v_member));
END;
$$;

CREATE OR REPLACE FUNCTION get_place_markers_in_viewport(
    min_lat FLOAT,
    min_lng FLOAT,
    max_lat FLOAT,
    max_lng FLOAT,
    search_query TEXT DEFAULT ''
)
RETURNS TABLE (
    id UUID,
    latitude FLOAT8,
    longitude FLOAT8,
    location_type TEXT,
    hotness_score INT,
    is_event BOOLEAN,
    is_flash_promo BOOLEAN
)
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
BEGIN
    RETURN QUERY
    SELECT 
        p.id,
        p.latitude,
        p.longitude,
        p.location_type,
        (
            SELECT COALESCE(SUM(CASE WHEN is_positive THEN 1 ELSE -1 END), 0)::INT 
            FROM vibe_checks vc 
            WHERE vc.place_id = p.id AND vc.created_at >= NOW() - INTERVAL '12 hours'
        ) AS hotness_score,
        (p.event_name IS NOT NULL OR p.start_time IS NOT NULL) AS is_event,
        (p.promo IS NOT NULL AND p.promo != '') AS is_flash_promo
    FROM places_view p
    WHERE p.location && ST_MakeEnvelope(min_lng, min_lat, max_lng, max_lat, 4326)::geography
    AND (search_query = '' OR p.name ILIKE '%' || search_query || '%');
END;
$$;

CREATE OR REPLACE FUNCTION get_event_markers_in_viewport(
    min_lat FLOAT,
    min_lng FLOAT,
    max_lat FLOAT,
    max_lng FLOAT,
    search_query TEXT DEFAULT ''
)
RETURNS TABLE (
    id UUID,
    latitude FLOAT8,
    longitude FLOAT8,
    hotness_score INT
)
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
BEGIN
    RETURN QUERY
    SELECT 
        e.id,
        e.latitude,
        e.longitude,
        (
            SELECT COALESCE(SUM(CASE WHEN is_positive THEN 1 ELSE -1 END), 0)::INT 
            FROM vibe_checks vc 
            WHERE vc.event_id = e.id AND vc.created_at >= NOW() - INTERVAL '12 hours'
        ) AS hotness_score
    FROM events e
    WHERE e.location && ST_MakeEnvelope(min_lng, min_lat, max_lng, max_lat, 4326)::geography
    AND (e.end_datetime IS NULL OR e.end_datetime > NOW())
    AND (search_query = '' OR e.title ILIKE '%' || search_query || '%'); 
END;
$$;

GRANT USAGE ON SCHEMA public TO postgres, anon, authenticated, service_role;
GRANT ALL ON ALL TABLES IN SCHEMA public TO postgres, anon, authenticated, service_role;
GRANT ALL ON ALL ROUTINES IN SCHEMA public TO postgres, anon, authenticated, service_role;
GRANT ALL ON ALL SEQUENCES IN SCHEMA public TO postgres, anon, authenticated, service_role;

INSERT INTO storage.buckets (id, name, public) VALUES ('avatars', 'avatars', true) ON CONFLICT DO NOTHING;

DROP POLICY IF EXISTS "Avatar images are publicly accessible." ON storage.objects;
DROP POLICY IF EXISTS "Users can upload their own avatar." ON storage.objects;
DROP POLICY IF EXISTS "Users can update their own avatar." ON storage.objects;
DROP POLICY IF EXISTS "Users can delete their own avatar." ON storage.objects;

CREATE POLICY "Avatar images are publicly accessible." ON storage.objects FOR SELECT USING (bucket_id = 'avatars');
CREATE POLICY "Users can upload their own avatar." ON storage.objects FOR INSERT WITH CHECK (bucket_id = 'avatars' AND auth.uid() = owner);
CREATE POLICY "Users can update their own avatar." ON storage.objects FOR UPDATE USING (bucket_id = 'avatars' AND auth.uid() = owner);
CREATE POLICY "Users can delete their own avatar." ON storage.objects FOR DELETE USING (bucket_id = 'avatars' AND auth.uid() = owner);