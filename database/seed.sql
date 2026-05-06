-- 1. SEED USERS (Extra users toegevoegd voor de trending logica test)
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at)
VALUES 
    ('d0eebc99-9c0b-4ef8-bb6d-6bb9bd380d11', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'seed@clubapp.be', 'dummy_hash', now(), now(), now()),
    ('d0eebc99-9c0b-4ef8-bb6d-6bb9bd380d22', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'user2@clubapp.be', 'dummy_hash', now(), now(), now()),
    ('d0eebc99-9c0b-4ef8-bb6d-6bb9bd380d33', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'user3@clubapp.be', 'dummy_hash', now(), now(), now()),
    ('d0eebc99-9c0b-4ef8-bb6d-6bb9bd380d44', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'user4@clubapp.be', 'dummy_hash', now(), now(), now()),
    ('d0eebc99-9c0b-4ef8-bb6d-6bb9bd380d55', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'user5@clubapp.be', 'dummy_hash', now(), now(), now())
ON CONFLICT DO NOTHING;

-- 2. SEED TAGS (Oude tags + nieuwe tags voor verenigingen)
INSERT INTO tags (id, name, category) VALUES
    ('c0eebc99-9c0b-4ef8-bb6d-6bb9bd380c11', 'Goedkoop Bier', 'vibe'),
    ('c0eebc99-9c0b-4ef8-bb6d-6bb9bd380c22', 'Dansen', 'activity'),
    ('c0eebc99-9c0b-4ef8-bb6d-6bb9bd380c33', 'Cocktails', 'drink'),
    ('c0eebc99-9c0b-4ef8-bb6d-6bb9bd380c44', 'Studentikoos', 'vibe'),
    ('c0eebc99-9c0b-4ef8-bb6d-6bb9bd380c55', 'Techno', 'music'),
    ('c0eebc99-9c0b-4ef8-bb6d-6bb9bd380c66', 'Live Music', 'activity'),
    ('c0eebc99-9c0b-4ef8-bb6d-6bb9bd380c77', 'Snacks', 'food'),
    ('c0eebc99-9c0b-4ef8-bb6d-6bb9bd380c88', 'Bowling', 'activity'),
    
    -- Nieuwe tags specifiek voor de verenigingen (met UUID d11 - d66)
    ('c0eebc99-9c0b-4ef8-bb6d-6bb9bd380d11', 'Feestgericht', 'assoc_vibe'),
    ('c0eebc99-9c0b-4ef8-bb6d-6bb9bd380d22', 'Internationaal', 'assoc_vibe'),
    ('c0eebc99-9c0b-4ef8-bb6d-6bb9bd380d33', 'Wiskunde', 'study'),
    ('c0eebc99-9c0b-4ef8-bb6d-6bb9bd380d44', 'Rechten', 'study'),
    ('c0eebc99-9c0b-4ef8-bb6d-6bb9bd380d55', 'Cosplay', 'hobby'),
    ('c0eebc99-9c0b-4ef8-bb6d-6bb9bd380d66', 'Gaming', 'hobby')
ON CONFLICT DO NOTHING;

-- 3. SEED ASSOCIATIONS (Aangevuld met beschrijvingen, logos en banners + 2 extra verenigingen)
INSERT INTO associations (id, name, description, logo_url, banner_url) VALUES
    ('b0eebc99-9c0b-4ef8-bb6d-6bb9bd380b11', 'VTK Gent', 'De officiële studentenvereniging voor burgerlijk ingenieurs en architecten aan de UGent. Bekend om legendarische feestjes in de Twitch.', 'https://placehold.co/100x100/003366/FFF?text=VTK', 'https://placehold.co/400x200/003366/FFF?text=VTK+Banner'),
    ('b0eebc99-9c0b-4ef8-bb6d-6bb9bd380b22', 'VRG Gent', 'Het Vlaams Rechtsgenootschap is de kring voor en door studenten Rechten en Criminologie.', 'https://placehold.co/100x100/CC0000/FFF?text=VRG', 'https://placehold.co/400x200/CC0000/FFF?text=VRG+Banner'),
    ('b0eebc99-9c0b-4ef8-bb6d-6bb9bd380b33', 'Moeder Lies', 'De meest bruisende streekclub van Gent voor iedereen rond de Leiestreek.', 'https://placehold.co/100x100/006600/FFF?text=ML', 'https://placehold.co/400x200/006600/FFF?text=Moeder+Lies'),
    ('b0eebc99-9c0b-4ef8-bb6d-6bb9bd380b44', 'ESN Gent', 'Erasmus Student Network Gent. Connecting international students and organizing the best intercultural parties.', 'https://placehold.co/100x100/FF00FF/FFF?text=ESN', 'https://placehold.co/400x200/FF00FF/FFF?text=ESN+Banner'),
    ('b0eebc99-9c0b-4ef8-bb6d-6bb9bd380b55', 'Geek Guild', 'Dé community in Gent voor anime, cosplay, bordspellen en gaming enthousiastelingen.', 'https://placehold.co/100x100/333333/FFF?text=GG', 'https://placehold.co/400x200/333333/FFF?text=Geek+Guild')
ON CONFLICT (name) DO UPDATE 
SET description = EXCLUDED.description, logo_url = EXCLUDED.logo_url, banner_url = EXCLUDED.banner_url;

-- 4. SEED ASSOCIATION TAGS (Koppel tags aan verenigingen)
INSERT INTO association_tags (association_id, tag_id) VALUES
    -- VTK
    ('b0eebc99-9c0b-4ef8-bb6d-6bb9bd380b11', 'c0eebc99-9c0b-4ef8-bb6d-6bb9bd380d11'), -- Feestgericht
    ('b0eebc99-9c0b-4ef8-bb6d-6bb9bd380b11', 'c0eebc99-9c0b-4ef8-bb6d-6bb9bd380d33'), -- Wiskunde
    -- VRG
    ('b0eebc99-9c0b-4ef8-bb6d-6bb9bd380b22', 'c0eebc99-9c0b-4ef8-bb6d-6bb9bd380d11'), -- Feestgericht
    ('b0eebc99-9c0b-4ef8-bb6d-6bb9bd380b22', 'c0eebc99-9c0b-4ef8-bb6d-6bb9bd380d44'), -- Rechten
    -- Moeder Lies
    ('b0eebc99-9c0b-4ef8-bb6d-6bb9bd380b33', 'c0eebc99-9c0b-4ef8-bb6d-6bb9bd380d11'), -- Feestgericht
    ('b0eebc99-9c0b-4ef8-bb6d-6bb9bd380b33', 'c0eebc99-9c0b-4ef8-bb6d-6bb9bd380c11'), -- Goedkoop Bier
    -- ESN Gent
    ('b0eebc99-9c0b-4ef8-bb6d-6bb9bd380b44', 'c0eebc99-9c0b-4ef8-bb6d-6bb9bd380d22'), -- Internationaal
    ('b0eebc99-9c0b-4ef8-bb6d-6bb9bd380b44', 'c0eebc99-9c0b-4ef8-bb6d-6bb9bd380d11'), -- Feestgericht
    -- Geek Guild
    ('b0eebc99-9c0b-4ef8-bb6d-6bb9bd380b55', 'c0eebc99-9c0b-4ef8-bb6d-6bb9bd380d55'), -- Cosplay
    ('b0eebc99-9c0b-4ef8-bb6d-6bb9bd380b55', 'c0eebc99-9c0b-4ef8-bb6d-6bb9bd380d66')  -- Gaming
ON CONFLICT DO NOTHING;

-- 5. SEED ASSOCIATION MEMBERS (Voor Trending berekening: Oude leden vs Recente leden)
INSERT INTO association_members (association_id, user_id, role, joined_at) VALUES
    -- VTK (Grootste vereniging, maar oude joins: 3 leden)
    ('b0eebc99-9c0b-4ef8-bb6d-6bb9bd380b11', 'd0eebc99-9c0b-4ef8-bb6d-6bb9bd380d11', 'member', NOW() - INTERVAL '120 days'),
    ('b0eebc99-9c0b-4ef8-bb6d-6bb9bd380b11', 'd0eebc99-9c0b-4ef8-bb6d-6bb9bd380d22', 'member', NOW() - INTERVAL '60 days'),
    ('b0eebc99-9c0b-4ef8-bb6d-6bb9bd380b11', 'd0eebc99-9c0b-4ef8-bb6d-6bb9bd380d33', 'pending', NOW() - INTERVAL '40 days'),
    
    -- ESN Gent (Niet de grootste, maar wel 100% recente groei: 2 leden in laatste 30 dagen)
    ('b0eebc99-9c0b-4ef8-bb6d-6bb9bd380b44', 'd0eebc99-9c0b-4ef8-bb6d-6bb9bd380d44', 'member', NOW() - INTERVAL '5 days'),
    ('b0eebc99-9c0b-4ef8-bb6d-6bb9bd380b44', 'd0eebc99-9c0b-4ef8-bb6d-6bb9bd380d55', 'pending', NOW() - INTERVAL '1 days'),

    -- VRG Gent (Gemiddeld: 1 recent, 1 oud)
    ('b0eebc99-9c0b-4ef8-bb6d-6bb9bd380b22', 'd0eebc99-9c0b-4ef8-bb6d-6bb9bd380d11', 'member', NOW() - INTERVAL '200 days'),
    ('b0eebc99-9c0b-4ef8-bb6d-6bb9bd380b22', 'd0eebc99-9c0b-4ef8-bb6d-6bb9bd380d22', 'member', NOW() - INTERVAL '15 days'),

    -- Moeder Lies (Slechts 1 oud lid)
    ('b0eebc99-9c0b-4ef8-bb6d-6bb9bd380b33', 'd0eebc99-9c0b-4ef8-bb6d-6bb9bd380d33', 'member', NOW() - INTERVAL '300 days')
ON CONFLICT DO NOTHING;

-- 6. SEED PLACES
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

-- 7. SEED PLACE TAGS & ASSOCIATION PLACES
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
    ('b0eebc99-9c0b-4ef8-bb6d-6bb9bd380b11', 'a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11') -- VTK heeft Twitch als stamkroeg
ON CONFLICT DO NOTHING;

-- 8. SEED OPENING HOURS
INSERT INTO opening_hours (place_id, day_of_week, open_time, close_time) VALUES
    ('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11', 4, '21:00', '05:00'), -- Twitch Donderdag
    ('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11', 5, '22:00', '04:00'), -- Twitch Vrijdag
    ('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a22', 4, '11:00', '06:00'), -- Gouden Saté Donderdag
    ('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a44', 5, '22:00', '06:00'), -- Charlatan Vrijdag
    ('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a55', 6, '23:00', '07:00')  -- Kompass Zaterdag
ON CONFLICT DO NOTHING;

-- 9. SEED EVENTS (Inclusief een event gelinkt aan een vereniging!)
INSERT INTO events (id, created_by, title, description, address, latitude, longitude, start_datetime, end_datetime, place_id, association_id) VALUES
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
        null,
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
        'a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a33',
        null
    ),
    (
        'e0eebc99-9c0b-4ef8-bb6d-6bb9bd380e33', 
        'd0eebc99-9c0b-4ef8-bb6d-6bb9bd380d11', 
        'VTK Galabal', 
        'Het galabal van het jaar voor alle VTK leden en sympathisanten!', 
        'ICC Gent', 
        51.026900, 
        3.712600, 
        NOW() + INTERVAL '10 days', 
        NOW() + INTERVAL '11 days', 
        null,
        'b0eebc99-9c0b-4ef8-bb6d-6bb9bd380b11' -- Gelinkt aan VTK
    )
ON CONFLICT DO NOTHING;

-- 10. SEED VIBE CHECKS
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