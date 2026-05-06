INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at)
VALUES 
    ('d0eebc99-9c0b-4ef8-bb6d-6bb9bd380d11', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'seed@clubapp.be', 'dummy_hash', now(), now(), now())
ON CONFLICT DO NOTHING;

INSERT INTO tags (id, name, category) VALUES
    ('c0eebc99-9c0b-4ef8-bb6d-6bb9bd380c11', 'Goedkoop Bier', 'vibe'),
    ('c0eebc99-9c0b-4ef8-bb6d-6bb9bd380c22', 'Dansen', 'activity'),
    ('c0eebc99-9c0b-4ef8-bb6d-6bb9bd380c33', 'Cocktails', 'drink'),
    ('c0eebc99-9c0b-4ef8-bb6d-6bb9bd380c44', 'Studentikoos', 'vibe'),
    ('c0eebc99-9c0b-4ef8-bb6d-6bb9bd380c55', 'Techno', 'music'),
    ('c0eebc99-9c0b-4ef8-bb6d-6bb9bd380c66', 'Live Music', 'activity'),
    ('c0eebc99-9c0b-4ef8-bb6d-6bb9bd380c77', 'Snacks', 'food'),
    ('c0eebc99-9c0b-4ef8-bb6d-6bb9bd380c88', 'Bowling', 'activity')
ON CONFLICT DO NOTHING;

INSERT INTO associations (id, name) VALUES
    ('b0eebc99-9c0b-4ef8-bb6d-6bb9bd380b11', 'VTK Gent'),
    ('b0eebc99-9c0b-4ef8-bb6d-6bb9bd380b22', 'VRG Gent'),
    ('b0eebc99-9c0b-4ef8-bb6d-6bb9bd380b33', 'Moeder Lies')
ON CONFLICT DO NOTHING;

INSERT INTO places (id, name, address, latitude, longitude, location_type, genre, event_name, start_time) VALUES
    ('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11', 'De Twitch', 'Overpoortstraat 9, 9000 Gent', 51.038580, 3.726210, 'club', 'Party', null, null),
    ('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a22', 'De Gouden Saté', 'Overpoortstraat 51, 9000 Gent', 51.037400, 3.725900, 'food', 'Frituur', null, null),
    ('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a33', 'Vooruit', 'Sint-Pietersnieuwstraat 23, 9000 Gent', 51.047800, 3.727500, 'club', 'Cultuur/Techno', null, null),
    
    ('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a44', 'Charlatan', 'Vlasmarkt 6, 9000 Gent', 51.056700, 3.728800, 'club', 'Alternative/Techno', null, null),
    ('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a55', 'Kompass Klub', 'Ottergemsesteenweg-Zuid 717, 9000 Gent', 51.018400, 3.731500, 'club', 'Techno', null, null),
    ('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a66', 'Kinky Star', 'Vlasmarkt 9, 9000 Gent', 51.056900, 3.728900, 'club', 'Rock/Live Music', null, null),
    
    ('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a77', 'Frituur Julien', 'Overpoortstraat 24, 9000 Gent', 51.037800, 3.726200, 'food', 'Frituur', null, null),
    ('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a88', 'Overpoort Bowl', 'Overpoortstraat 38, 9000 Gent', 51.038100, 3.726500, 'place', 'Activity', null, null),

    ('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a99', 'Sint-Pietersplein', 'Sint-Pietersplein, 9000 Gent', 51.041600, 3.727000, 'event', 'Festival', 'Student Kickoff', '14:00:00')
ON CONFLICT DO NOTHING;

INSERT INTO place_tags (place_id, tag_id) VALUES
    ('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11', 'c0eebc99-9c0b-4ef8-bb6d-6bb9bd380c11'), -- Twitch -> Goedkoop Bier
    ('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11', 'c0eebc99-9c0b-4ef8-bb6d-6bb9bd380c44'), -- Twitch -> Studentikoos
    ('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a33', 'c0eebc99-9c0b-4ef8-bb6d-6bb9bd380c22'), -- Vooruit -> Dansen
    ('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a33', 'c0eebc99-9c0b-4ef8-bb6d-6bb9bd380c55'), -- Vooruit -> Techno
    ('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a44', 'c0eebc99-9c0b-4ef8-bb6d-6bb9bd380c22'), -- Charlatan -> Dansen
    ('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a44', 'c0eebc99-9c0b-4ef8-bb6d-6bb9bd380c66'), -- Charlatan -> Live Music
    ('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a55', 'c0eebc99-9c0b-4ef8-bb6d-6bb9bd380c55'), -- Kompass -> Techno
    ('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a66', 'c0eebc99-9c0b-4ef8-bb6d-6bb9bd380c66'), -- Kinky Star -> Live Music
    ('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a77', 'c0eebc99-9c0b-4ef8-bb6d-6bb9bd380c77'), -- Julien -> Snacks
    ('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a88', 'c0eebc99-9c0b-4ef8-bb6d-6bb9bd380c88')  -- Bowl -> Bowling
ON CONFLICT DO NOTHING;

INSERT INTO association_places (association_id, place_id) VALUES
    ('b0eebc99-9c0b-4ef8-bb6d-6bb9bd380b11', 'a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11') -- VTK zit in de Twitch
ON CONFLICT DO NOTHING;

INSERT INTO opening_hours (place_id, day_of_week, open_time, close_time) VALUES
    ('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11', 4, '21:00', '05:00'), -- Twitch Donderdag
    ('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11', 5, '22:00', '04:00'), -- Twitch Vrijdag
    ('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a22', 4, '11:00', '06:00'), -- Gouden Saté Donderdag
    ('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a44', 5, '22:00', '06:00'), -- Charlatan Vrijdag
    ('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a55', 6, '23:00', '07:00')  -- Kompass Zaterdag
ON CONFLICT DO NOTHING;

INSERT INTO events (id, created_by, title, description, address, latitude, longitude, start_datetime, end_datetime, place_id) VALUES
    (
        'e0eebc99-9c0b-4ef8-bb6d-6bb9bd380e11', 
        'd0eebc99-9c0b-4ef8-bb6d-6bb9bd380d11', 
        'Gentse Feesten Pre-Party', 
        'Opwarming voor de Gentse Feesten', 
        'Vrijdagmarkt', 
        51.057300, 
        3.726500, 
        NOW() + INTERVAL '2 days', 
        NOW() + INTERVAL '2 days 6 hours', 
        null
    ),
    (
        'e0eebc99-9c0b-4ef8-bb6d-6bb9bd380e22', 
        'd0eebc99-9c0b-4ef8-bb6d-6bb9bd380d11', 
        'Zondag Techno Sessie', 
        'Zondag techno closing weekend', 
        'Vooruit', 
        51.047800, 
        3.727500, 
        NOW() + INTERVAL '5 days', 
        NOW() + INTERVAL '5 days 8 hours', 
        'a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a33'
    )
ON CONFLICT DO NOTHING;

INSERT INTO vibe_checks (place_id, is_positive) VALUES
    ('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11', true),
    ('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11', true),
    ('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11', false),
    ('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a22', true),
    ('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a33', true),
    ('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a44', true),
    ('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a44', true),
    ('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a55', true)
ON CONFLICT DO NOTHING;