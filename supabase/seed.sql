-- Seed data for Flutter Club App
-- Run this AFTER schema.sql in your Supabase SQL Editor

-- Places in Ghent
INSERT INTO places (name, address, latitude, longitude, location_type, genre, status, crowd_level, wait_time, is_vereniging, poi)
VALUES
  ('ClubCTRL', 'Stationsstraat 81, 9000 Gent', 51.0351, 3.7098, 'club', 'Electronic', 'open', 'medium', '10 min', false, 'Overpoort'),
  ('Charlatan', 'Vlasmarkt 23, 9000 Gent', 51.0569, 3.7175, 'club', 'Indie', 'open', 'quiet', 'no wait', false, 'Overpoort'),
  ('Trio', 'Vlasmarkt 25, 9000 Gent', 51.0568, 3.7174, 'club', 'House', 'event', 'busy', '15 min', false, 'Overpoort'),
  ('Mirano', 'Korenmarkt 3, 9000 Gent', 51.0540, 3.7208, 'club', 'Commercial', 'closed', NULL, NULL, false, 'Korenmarkt'),
  ('Decap', 'Sint-Niklaasstraat 13, 9000 Gent', 51.0552, 3.7196, 'club', 'Electronic', 'open', 'medium', '5 min', false, 'Overpoort'),
  ('Bar d''Officier', 'Korenmarkt 10, 9000 Gent', 51.0545, 3.7210, 'food', NULL, 'open', 'quiet', NULL, false, 'Korenmarkt'),
  ('Stadscafé', 'Sint-Baafsplein 1, 9000 Gent', 51.0538, 3.7178, 'food', NULL, 'open', 'medium', NULL, false, 'Belfort'),
  ('Upstairs', 'Korenmarkt 15, 9000 Gent', 51.0542, 3.7212, 'club', 'Cocktails', 'open', 'quiet', 'no wait', false, 'Korenmarkt');

-- Get the IDs for tagging
DO $$
DECLARE
    clubctrl_id UUID;
    charlatan_id UUID;
    trio_id UUID;
    mirano_id UUID;
    decap_id UUID;
    barofficier_id UUID;
BEGIN
    SELECT id INTO clubctrl_id FROM places WHERE name = 'ClubCTRL';
    SELECT id INTO charlatan_id FROM places WHERE name = 'Charlatan';
    SELECT id INTO trio_id FROM places WHERE name = 'Trio';
    SELECT id INTO mirano_id FROM places WHERE name = 'Mirano';
    SELECT id INTO decap_id FROM places WHERE name = 'Decap';
    SELECT id INTO barofficier_id FROM places WHERE name = 'Bar d''Officier';

    -- Tags for ClubCTRL
    INSERT INTO place_tags (place_id, tag) VALUES
      (clubctrl_id, 'dance'),
      (clubctrl_id, 'techno'),
      (clubctrl_id, 'underground'),
      (clubctrl_id, 'student');

    -- Tags for Charlatan
    INSERT INTO place_tags (place_id, tag) VALUES
      (charlatan_id, 'indie'),
      (charlatan_id, 'rock'),
      (charlatan_id, 'student'),
      (charlatan_id, 'chill');

    -- Tags for Trio
    INSERT INTO place_tags (place_id, tag) VALUES
      (trio_id, 'house'),
      (trio_id, 'dance'),
      (trio_id, 'student');

    -- Tags for Mirano
    INSERT INTO place_tags (place_id, tag) VALUES
      (mirano_id, 'mainstream'),
      (mirano_id, 'dance'),
      (mirano_id, 'crowded');

    -- Tags for Decap
    INSERT INTO place_tags (place_id, tag) VALUES
      (decap_id, 'techno'),
      (decap_id, 'electronic'),
      (decap_id, 'underground');

    -- Tags for Bar d'Officier
    INSERT INTO place_tags (place_id, tag) VALUES
      (barofficier_id, 'cocktails'),
      (barofficier_id, 'chill'),
      (barofficier_id, 'rooftop');

    -- Facilities for ClubCTRL
    INSERT INTO place_facilities (place_id, facility) VALUES
      (clubctrl_id, 'toilet'),
      (clubctrl_id, 'coat_check'),
      (clubctrl_id, 'smoking_area');

    -- Facilities for Charlatan
    INSERT INTO place_facilities (place_id, facility) VALUES
      (charlatan_id, 'toilet'),
      (charlatan_id, 'wheelchair_access'),
      (charlatan_id, 'outdoor');

    -- Facilities for Trio
    INSERT INTO place_facilities (place_id, facility) VALUES
      (trio_id, 'toilet'),
      (trio_id, 'vip_lounge'),
      (trio_id, 'coat_check');

    -- Facilities for Mirano
    INSERT INTO place_facilities (place_id, facility) VALUES
      (mirano_id, 'toilet'),
      (mirano_id, 'wheelchair_access'),
      (mirano_id, 'coat_check'),
      (mirano_id, 'vip_lounge');

    -- Facilities for Decap
    INSERT INTO place_facilities (place_id, facility) VALUES
      (decap_id, 'toilet'),
      (decap_id, 'smoking_area'),
      (decap_id, 'coat_check');

    -- Facilities for Bar d'Officier
    INSERT INTO place_facilities (place_id, facility) VALUES
      (barofficier_id, 'toilet'),
      (barofficier_id, 'wheelchair_access');

END $$;

-- Sample vibe checks (optional - for testing crowd levels)
-- Uncomment if you want some initial data
/*
INSERT INTO vibe_checks (place_id, crowd_level, energy, user_id)
SELECT id, 'medium', 7, NULL FROM places WHERE name = 'ClubCTRL';

INSERT INTO vibe_checks (place_id, crowd_level, energy, user_id)
SELECT id, 'quiet', 5, NULL FROM places WHERE name = 'Charlatan';

INSERT INTO vibe_checks (place_id, crowd_level, energy, user_id)
SELECT id, 'busy', 8, NULL FROM places WHERE name = 'Trio';
*/
