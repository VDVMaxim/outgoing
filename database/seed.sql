-- ==========================================
-- SEED DATA VOOR CLUBS, TAGS & VERENIGINGEN
-- ==========================================

-- 1. Tags (Sfeer, faciliteiten, genres)
INSERT INTO tags (id, name, category) VALUES
    ('c0eebc99-9c0b-4ef8-bb6d-6bb9bd380c11', 'Goedkoop Bier', 'vibe'),
    ('c0eebc99-9c0b-4ef8-bb6d-6bb9bd380c22', 'Dansen', 'activity'),
    ('c0eebc99-9c0b-4ef8-bb6d-6bb9bd380c33', 'Cocktails', 'drink'),
    ('c0eebc99-9c0b-4ef8-bb6d-6bb9bd380c44', 'Studentikoos', 'vibe'),
    ('c0eebc99-9c0b-4ef8-bb6d-6bb9bd380c55', 'Techno', 'music')
ON CONFLICT DO NOTHING;

-- 2. Verenegingen (Associations)
INSERT INTO associations (id, name) VALUES
    ('b0eebc99-9c0b-4ef8-bb6d-6bb9bd380b11', 'VTK Gent'),
    ('b0eebc99-9c0b-4ef8-bb6d-6bb9bd380b22', 'VRG Gent'),
    ('b0eebc99-9c0b-4ef8-bb6d-6bb9bd380b33', 'Moeder Lies')
ON CONFLICT DO NOTHING;

-- 3. Locaties (OSM Places)
INSERT INTO osm_places (id, name, address, latitude, longitude, location_type, genre) VALUES
    ('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11', 'De Twitch', 'Overpoortstraat 9, 9000 Gent', 51.038580, 3.726210, 'club', 'Party'),
    ('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a22', 'De Gouden Saté', 'Overpoortstraat 51, 9000 Gent', 51.037400, 3.725900, 'food', 'Frituur'),
    ('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a33', 'Vooruit', 'Sint-Pietersnieuwstraat 23, 9000 Gent', 51.047800, 3.727500, 'event', 'Cultuur/Techno')
ON CONFLICT DO NOTHING;

-- 4. Koppel Tags aan Locaties
INSERT INTO place_tags (place_id, tag_id) VALUES
    ('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11', 'c0eebc99-9c0b-4ef8-bb6d-6bb9bd380c11'), -- Twitch -> Goedkoop Bier
    ('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11', 'c0eebc99-9c0b-4ef8-bb6d-6bb9bd380c44'), -- Twitch -> Studentikoos
    ('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a33', 'c0eebc99-9c0b-4ef8-bb6d-6bb9bd380c22'), -- Vooruit -> Dansen
    ('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a33', 'c0eebc99-9c0b-4ef8-bb6d-6bb9bd380c55')  -- Vooruit -> Techno
ON CONFLICT DO NOTHING;

-- 5. Koppel Verenigingen aan hun 'Stamkroeg' (Association Places)
INSERT INTO association_places (association_id, place_id) VALUES
    ('b0eebc99-9c0b-4ef8-bb6d-6bb9bd380b11', 'a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11') -- VTK zit in de Twitch
ON CONFLICT DO NOTHING;

-- 6. Voeg Openingstijden toe (day_of_week: 1=Maandag, 7=Zondag)
INSERT INTO opening_hours (place_id, day_of_week, open_time, close_time) VALUES
    ('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11', 4, '21:00', '05:00'), -- Twitch Donderdag
    ('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11', 5, '22:00', '04:00'), -- Twitch Vrijdag
    ('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a22', 4, '11:00', '06:00')  -- Gouden Saté Donderdag
ON CONFLICT DO NOTHING;

-- 7. Voeg wat Vibe Checks toe (zodat je kaart meteen hete/koude plekken toont)
-- (Omdat we geen specifieke user_id hebben, laten we die null voor anonieme checks)
INSERT INTO vibe_checks (place_id, is_positive) VALUES
    ('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11', true),
    ('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11', true),
    ('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11', false),
    ('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a22', true),
    ('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a33', true)
ON CONFLICT DO NOTHING;