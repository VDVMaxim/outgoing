-- Supabase Database Schema for Flutter Club App
-- Run this SQL in your Supabase SQL Editor

-- Enable UUID extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Create enum for location types
DO $$ BEGIN
    CREATE TYPE location_type AS ENUM ('club', 'food', 'emergency');
EXCEPTION
    WHEN duplicate_object THEN null;
END $$;

-- Create enum for club status
DO $$ BEGIN
    CREATE TYPE club_status AS ENUM ('open', 'event', 'closed');
EXCEPTION
    WHEN duplicate_object THEN null;
END $$;

-- Places table (clubs, venues, points of interest)
CREATE TABLE places (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name TEXT NOT NULL,
    address TEXT NOT NULL,
    latitude FLOAT8 NOT NULL,
    longitude FLOAT8 NOT NULL,
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

-- Tags lookup table (reusable across places)
CREATE TABLE tags (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name TEXT UNIQUE NOT NULL,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Facilities lookup table (reusable across places)
CREATE TABLE facilities (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name TEXT UNIQUE NOT NULL,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Place tags (many-to-many relationship via junction table)
CREATE TABLE place_tags (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    place_id UUID NOT NULL REFERENCES places(id) ON DELETE CASCADE,
    tag_id UUID NOT NULL REFERENCES tags(id) ON DELETE CASCADE,
    UNIQUE(place_id, tag_id)
);

-- Place facilities (many-to-many relationship via junction table)
CREATE TABLE place_facilities (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    place_id UUID NOT NULL REFERENCES places(id) ON DELETE CASCADE,
    facility_id UUID NOT NULL REFERENCES facilities(id) ON DELETE CASCADE,
    UNIQUE(place_id, facility_id)
);

-- Vibe checks (crowd/energy ratings)
CREATE TABLE vibe_checks (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    place_id UUID NOT NULL REFERENCES places(id) ON DELETE CASCADE,
    crowd_level TEXT NOT NULL,
    energy INT CHECK (energy >= 1 AND energy <= 10),
    user_id UUID,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Squads (groups of users going to clubs together)
-- NOTE: created_by is TEXT to support custom string IDs
CREATE TABLE squads (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    pin TEXT UNIQUE NOT NULL,
    created_by TEXT NOT NULL,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Squad members (with real-time position updates)
-- NOTE: user_id is TEXT to support custom string IDs
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

-- Profiles table (for authenticated users)
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

-- Indexes for better query performance
CREATE INDEX idx_places_location_type ON places(location_type);
CREATE INDEX idx_places_status ON places(status);
CREATE INDEX idx_place_tags_place_id ON place_tags(place_id);
CREATE INDEX idx_place_tags_tag_id ON place_tags(tag_id);
CREATE INDEX idx_place_facilities_place_id ON place_facilities(place_id);
CREATE INDEX idx_place_facilities_facility_id ON place_facilities(facility_id);
CREATE INDEX idx_tags_name ON tags(name);
CREATE INDEX idx_facilities_name ON facilities(name);
CREATE INDEX idx_vibe_checks_place_id ON vibe_checks(place_id);
CREATE INDEX idx_vibe_checks_created_at ON vibe_checks(created_at DESC);
CREATE INDEX idx_squad_members_squad_id ON squad_members(squad_id);
CREATE INDEX idx_squad_members_user_id ON squad_members(user_id);
CREATE INDEX idx_profiles_user_id ON profiles(user_id);
CREATE INDEX idx_profiles_nickname ON profiles(nickname);

-- Enable Row Level Security (RLS)
ALTER TABLE places ENABLE ROW LEVEL SECURITY;
ALTER TABLE tags ENABLE ROW LEVEL SECURITY;
ALTER TABLE facilities ENABLE ROW LEVEL SECURITY;
ALTER TABLE place_tags ENABLE ROW LEVEL SECURITY;
ALTER TABLE place_facilities ENABLE ROW LEVEL SECURITY;
ALTER TABLE vibe_checks ENABLE ROW LEVEL SECURITY;
ALTER TABLE squads ENABLE ROW LEVEL SECURITY;
ALTER TABLE squad_members ENABLE ROW LEVEL SECURITY;
ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;

-- Public read access for places (anyone can view clubs)
CREATE POLICY "Public can read places" ON places FOR SELECT USING (true);

-- Public read access for tags and facilities
CREATE POLICY "Public can read tags" ON tags FOR SELECT USING (true);
CREATE POLICY "Public can read facilities" ON facilities FOR SELECT USING (true);
CREATE POLICY "Public can read place_tags" ON place_tags FOR SELECT USING (true);
CREATE POLICY "Public can read place_facilities" ON place_facilities FOR SELECT USING (true);

-- Anyone can insert vibe checks (anonymous)
CREATE POLICY "Anyone can insert vibe_checks" ON vibe_checks FOR INSERT WITH CHECK (true);

-- Anyone can read vibe checks (for viewing crowd levels)
CREATE POLICY "Public can read vibe_checks" ON vibe_checks FOR SELECT USING (true);

-- Allow authenticated users to manage squads (we'll use anon auth but with user_id)
CREATE POLICY "Anyone can insert squads" ON squads FOR INSERT WITH CHECK (true);
CREATE POLICY "Anyone can read squads" ON squads FOR SELECT USING (true);

-- Allow anyone to manage squad members
CREATE POLICY "Anyone can insert squad_members" ON squad_members FOR INSERT WITH CHECK (true);
CREATE POLICY "Anyone can read squad_members" ON squad_members FOR SELECT USING (true);
CREATE POLICY "Anyone can update squad_members" ON squad_members FOR UPDATE USING (true);
CREATE POLICY "Anyone can delete squad_members" ON squad_members FOR DELETE USING (true);

-- Profiles RLS policies (authenticated users can only access their own profile)
CREATE POLICY "Users can view own profile" ON profiles FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY "Users can update own profile" ON profiles FOR UPDATE USING (auth.uid() = user_id);
CREATE POLICY "Users can insert own profile" ON profiles FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY "Users can delete own profile" ON profiles FOR DELETE USING (auth.uid() = user_id);

-- Enable realtime for squad_members (for live position updates)
ALTER PUBLICATION supabase_realtime ADD TABLE squad_members;

-- Function to automatically update updated_at timestamp
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Trigger for places table
CREATE TRIGGER update_places_updated_at
    BEFORE UPDATE ON places
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

-- Trigger for squad_members table
CREATE TRIGGER update_squad_members_updated_at
    BEFORE UPDATE ON squad_members
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

-- Trigger for profiles table
CREATE TRIGGER update_profiles_updated_at
    BEFORE UPDATE ON profiles
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

-- ============================================
-- VIBE POINTS SYSTEM (MVP)
-- ============================================

-- Vibe Profiles (VP + Level + Streak per user)
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

-- Vibe Actions (audit trail for VP earning)
CREATE TABLE IF NOT EXISTS vibe_actions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
    action_type TEXT NOT NULL,
    place_id UUID REFERENCES places(id) ON DELETE SET NULL,
    vp_earned INTEGER NOT NULL,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Indexes for vibe tables
CREATE INDEX IF NOT EXISTS idx_vibe_profiles_user_id ON vibe_profiles(user_id);
CREATE INDEX IF NOT EXISTS idx_vibe_actions_user_id ON vibe_actions(user_id);
CREATE INDEX IF NOT EXISTS idx_vibe_actions_created_at ON vibe_actions(created_at DESC);

-- Enable RLS on vibe tables
ALTER TABLE vibe_profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE vibe_actions ENABLE ROW LEVEL SECURITY;

-- RLS Policies for vibe tables (users can only access their own data)
CREATE POLICY "Users can own vibe_profile" ON vibe_profiles 
    FOR ALL USING (auth.uid() = user_id);

CREATE POLICY "Users can own vibe_actions" ON vibe_actions 
    FOR ALL USING (auth.uid() = user_id);

-- Enable realtime for vibe_actions (optional - for live updates)
ALTER PUBLICATION supabase_realtime ADD TABLE vibe_actions;

-- ============================================
-- BADGES & CHALLENGES SYSTEM
-- ============================================

-- User Badges (using TEXT to match squad_members pattern)
CREATE TABLE IF NOT EXISTS user_badges (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id TEXT NOT NULL,
    badge_type TEXT NOT NULL,
    unlocked_at TIMESTAMPTZ DEFAULT NOW(),
    xp_earned INTEGER DEFAULT 0,
    UNIQUE(user_id, badge_type)
);

-- Squad Challenges
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

-- Safety First (I'm home safe) tracking
CREATE TABLE IF NOT EXISTS safety_sessions (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id TEXT NOT NULL,
    checked_in_at TIMESTAMPTZ DEFAULT NOW(),
    location_lat DOUBLE PRECISION,
    location_lng DOUBLE PRECISION
);

-- Indexes
CREATE INDEX IF NOT EXISTS idx_user_badges_user_id ON user_badges(user_id);
CREATE INDEX IF NOT EXISTS idx_squad_challenges_squad_id ON squad_challenges(squad_id);
CREATE INDEX IF NOT EXISTS idx_safety_sessions_user_id ON safety_sessions(user_id);

-- RLS
ALTER TABLE user_badges ENABLE ROW LEVEL SECURITY;
ALTER TABLE squad_challenges ENABLE ROW LEVEL SECURITY;
ALTER TABLE safety_sessions ENABLE ROW LEVEL SECURITY;

-- RLS Policies
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

-- Trigger for vibe_profiles table
CREATE TRIGGER update_vibe_profiles_updated_at
    BEFORE UPDATE ON vibe_profiles
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();
