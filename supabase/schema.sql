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

-- Place tags (many-to-many relationship)
CREATE TABLE place_tags (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    place_id UUID NOT NULL REFERENCES places(id) ON DELETE CASCADE,
    tag TEXT NOT NULL,
    UNIQUE(place_id, tag)
);

-- Place facilities (many-to-many relationship)
CREATE TABLE place_facilities (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    place_id UUID NOT NULL REFERENCES places(id) ON DELETE CASCADE,
    facility TEXT NOT NULL,
    UNIQUE(place_id, facility)
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
CREATE TABLE squads (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    pin TEXT UNIQUE NOT NULL,
    created_by UUID NOT NULL,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Squad members (with real-time position updates)
CREATE TABLE squad_members (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    squad_id UUID NOT NULL REFERENCES squads(id) ON DELETE CASCADE,
    user_id UUID NOT NULL,
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
CREATE INDEX idx_place_facilities_place_id ON place_facilities(place_id);
CREATE INDEX idx_vibe_checks_place_id ON vibe_checks(place_id);
CREATE INDEX idx_vibe_checks_created_at ON vibe_checks(created_at DESC);
CREATE INDEX idx_squad_members_squad_id ON squad_members(squad_id);
CREATE INDEX idx_squad_members_user_id ON squad_members(user_id);
CREATE INDEX idx_profiles_user_id ON profiles(user_id);
CREATE INDEX idx_profiles_nickname ON profiles(nickname);

-- Enable Row Level Security (RLS)
ALTER TABLE places ENABLE ROW LEVEL SECURITY;
ALTER TABLE place_tags ENABLE ROW LEVEL SECURITY;
ALTER TABLE place_facilities ENABLE ROW LEVEL SECURITY;
ALTER TABLE vibe_checks ENABLE ROW LEVEL SECURITY;
ALTER TABLE squads ENABLE ROW LEVEL SECURITY;
ALTER TABLE squad_members ENABLE ROW LEVEL SECURITY;
ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;

-- Public read access for places (anyone can view clubs)
CREATE POLICY "Public can read places" ON places FOR SELECT USING (true);

-- Public read access for tags and facilities
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

-- Example: Insert sample data (uncomment to use)
-- INSERT INTO places (name, address, latitude, longitude, location_type, genre, status) VALUES
-- ('Club Nova', 'Main Street 123', 51.9225, 4.4792, 'club', 'Electronic', 'open'),
-- ('The Basement', 'Underground Ave 45', 51.9245, 4.4812, 'club', 'House', 'event'),
-- ('Food Court Central', 'Food Street 789', 51.9200, 4.4750, 'food', NULL, 'open');
