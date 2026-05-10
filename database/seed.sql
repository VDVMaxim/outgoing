DELETE FROM vibe_checks;
DELETE FROM vibe_actions;
DELETE FROM user_badges;
DELETE FROM user_followers;
DELETE FROM association_members;
DELETE FROM association_places;
DELETE FROM association_tags;
DELETE FROM place_tags;
DELETE FROM opening_hours;
DELETE FROM events;
DELETE FROM profiles;
DELETE FROM vibe_profiles;
DELETE FROM squads;
DELETE FROM associations;
DELETE FROM places;
DELETE FROM tags;

INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at)
VALUES 
    ('d0eebc99-9c0b-4ef8-bb6d-6bb9bd380d11', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'max@clubapp.be', 'dummy', now(), now(), now()),
    ('d0eebc99-9c0b-4ef8-bb6d-6bb9bd380d22', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'sarah@clubapp.be', 'dummy', now(), now(), now()),
    ('d0eebc99-9c0b-4ef8-bb6d-6bb9bd380d33', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'tom@clubapp.be', 'dummy', now(), now(), now()),
    ('d0eebc99-9c0b-4ef8-bb6d-6bb9bd380d44', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'emma@clubapp.be', 'dummy', now(), now(), now()),
    ('d0eebc99-9c0b-4ef8-bb6d-6bb9bd380d55', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'lucas@clubapp.be', 'dummy', now(), now(), now()),
    ('d0eebc99-9c0b-4ef8-bb6d-6bb9bd380d66', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'lisa@clubapp.be', 'dummy', now(), now(), now()),
    ('d0eebc99-9c0b-4ef8-bb6d-6bb9bd380d77', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'kevin@clubapp.be', 'dummy', now(), now(), now())
ON CONFLICT (id) DO NOTHING;

INSERT INTO profiles (user_id, first_name, last_name, email, nickname, bio, avatar_url) VALUES
    ('d0eebc99-9c0b-4ef8-bb6d-6bb9bd380d11', 'Max', 'Vandenberg', 'max@clubapp.be', 'MadMax', 'Founder van de Squad. Altijd in voor een techno-feestje! 🎧', 'https://api.dicebear.com/7.x/avataaars/svg?seed=MadMax'),
    ('d0eebc99-9c0b-4ef8-bb6d-6bb9bd380d22', 'Sarah', 'Peeters', 'sarah@clubapp.be', 'SassySarah', 'Cocktail queen en dansvloer expert. 💃', 'https://api.dicebear.com/7.x/avataaars/svg?seed=Sarah'),
    ('d0eebc99-9c0b-4ef8-bb6d-6bb9bd380d33', 'Tom', 'Maes', 'tom@clubapp.be', 'TechnoTom', 'Geen nacht is te lang. 🦇', 'https://api.dicebear.com/7.x/avataaars/svg?seed=Tom'),
    ('d0eebc99-9c0b-4ef8-bb6d-6bb9bd380d44', 'Emma', 'Willems', 'emma@clubapp.be', 'EmmaW', 'Liefhebber van live muziek en gezellige bruine kroegen.', 'https://api.dicebear.com/7.x/avataaars/svg?seed=Emma'),
    ('d0eebc99-9c0b-4ef8-bb6d-6bb9bd380d55', 'Lucas', 'Dubois', 'lucas@clubapp.be', 'Luka', 'ESN Gent represent! 🌍', 'https://api.dicebear.com/7.x/avataaars/svg?seed=Luka'),
    ('d0eebc99-9c0b-4ef8-bb6d-6bb9bd380d66', 'Lisa', 'Bakker', 'lisa@clubapp.be', 'LisaB', 'Ik ken de beste kebab zaken van Gent uit m''n hoofd.', 'https://api.dicebear.com/7.x/avataaars/svg?seed=Lisa'),
    ('d0eebc99-9c0b-4ef8-bb6d-6bb9bd380d77', 'Kevin', 'De Smet', 'kevin@clubapp.be', 'KevDesign', 'UI Designer by day, party animal by night.', 'https://api.dicebear.com/7.x/avataaars/svg?seed=Kevin')
ON CONFLICT (user_id) DO UPDATE SET bio = EXCLUDED.bio, avatar_url = EXCLUDED.avatar_url;

INSERT INTO vibe_profiles (user_id, total_vp, current_level, weekend_streak) VALUES
    ('d0eebc99-9c0b-4ef8-bb6d-6bb9bd380d11', 2450, 4, 5),
    ('d0eebc99-9c0b-4ef8-bb6d-6bb9bd380d22', 1100, 3, 3),
    ('d0eebc99-9c0b-4ef8-bb6d-6bb9bd380d33', 850, 2, 2),
    ('d0eebc99-9c0b-4ef8-bb6d-6bb9bd380d44', 300, 2, 1),
    ('d0eebc99-9c0b-4ef8-bb6d-6bb9bd380d55', 120, 1, 0)
ON CONFLICT (user_id) DO NOTHING;

INSERT INTO tags (id, name, category) VALUES
    (gen_random_uuid(), 'Goedkoop Bier', 'vibe'),
    (gen_random_uuid(), 'Dansen', 'activity'),
    (gen_random_uuid(), 'Cocktails', 'drink'),
    (gen_random_uuid(), 'Studentikoos', 'vibe'),
    (gen_random_uuid(), 'Techno', 'music'),
    (gen_random_uuid(), 'House', 'music'),
    (gen_random_uuid(), 'Rock', 'music'),
    (gen_random_uuid(), 'Snacks', 'food'),
    (gen_random_uuid(), 'Gratis Water', 'facility'),
    (gen_random_uuid(), 'Chill Zone', 'facility'),
    (gen_random_uuid(), 'Buitenruimte', 'facility'),
    (gen_random_uuid(), 'Feestgericht', 'assoc_vibe'),
    (gen_random_uuid(), 'Internationaal', 'assoc_vibe'),
    (gen_random_uuid(), 'Wiskunde', 'study'),
    (gen_random_uuid(), 'Rechten', 'study'),
    (gen_random_uuid(), 'Geneeskunde', 'study'),
    (gen_random_uuid(), 'Gaming', 'hobby');

INSERT INTO associations (id, name, description, logo_url, banner_url) VALUES
    ('b0eebc99-9c0b-4ef8-bb6d-6bb9bd380b11', 'VTK Gent', 'Studentenvereniging voor burgerlijk ingenieurs en architecten.', 'https://api.dicebear.com/7.x/initials/svg?seed=VTK', 'https://images.unsplash.com/photo-1562774053-701939374585'),
    ('b0eebc99-9c0b-4ef8-bb6d-6bb9bd380b22', 'VRG Gent', 'Vlaams Rechtsgenootschap voor studenten Rechten.', 'https://api.dicebear.com/7.x/initials/svg?seed=VRG', 'https://images.unsplash.com/photo-1589829545856-d10d557cf95f'),
    ('b0eebc99-9c0b-4ef8-bb6d-6bb9bd380b33', 'Moeder Lies', 'Streekclub voor de Leiestreek.', 'https://api.dicebear.com/7.x/initials/svg?seed=ML', 'https://images.unsplash.com/photo-1533174072545-7a4b6ad7a6c3'),
    ('b0eebc99-9c0b-4ef8-bb6d-6bb9bd380b44', 'ESN Gent', 'Erasmus Student Network voor internationale studenten.', 'https://api.dicebear.com/7.x/initials/svg?seed=ESN', 'https://images.unsplash.com/photo-1523580494863-6f3031224c94'),
    ('b0eebc99-9c0b-4ef8-bb6d-6bb9bd380b55', 'VEK Gent', 'Vlaamse Economische Kring.', 'https://api.dicebear.com/7.x/initials/svg?seed=VEK', 'https://images.unsplash.com/photo-1526304640581-d334cdbbf45e');

INSERT INTO places (id, name, address, latitude, longitude, location_type, genre, promo) VALUES
    ('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11', 'De Twitch', 'Overpoortstraat 9, Gent', 51.038580, 3.726210, 'club', 'Party/Mainstream', 'Happy Hour: 22u-23u'),
    ('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a22', 'De Gouden Saté', 'Overpoortstraat 51, Gent', 51.037400, 3.725900, 'food', 'Frituur', 'Gratis saus bij een medium friet'),
    ('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a33', 'Vooruit', 'Sint-Pietersnieuwstraat 23, Gent', 51.047800, 3.727500, 'club', 'Techno/Alternative', null),
    ('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a44', 'Charlatan', 'Vlasmarkt 6, Gent', 51.056700, 3.728800, 'club', 'Eclectic/Rock', null),
    ('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a55', 'Kompass Klub', 'Ottergemsesteenweg-Zuid 717, Gent', 51.018400, 3.731500, 'club', 'Hard Techno', null),
    ('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a66', 'Kinky Star', 'Vlasmarkt 9, Gent', 51.056900, 3.728900, 'club', 'Alternative/Punk', null),
    ('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a77', 'Frituur Julien', 'Overpoortstraat 24, Gent', 51.037800, 3.726200, 'food', 'Frituur', null),
    ('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a88', 'Pink Flamingo', 'Vlasmarkt 12, Gent', 51.056500, 3.728500, 'club', '80s/Retro', 'Cocktail van de maand: €7'),
    ('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a99', 'Amigo', 'Stapelplein 27, Gent', 51.062000, 3.733000, 'club', 'House/Disco', null),
    ('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380b00', 'Overpoort Bowl', 'Overpoortstraat 38, Gent', 51.038100, 3.726500, 'place', 'Bowling/Bar', 'Studentenprijs: €5 per spel'),
    ('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380b01', 'Chinastraat', 'Stapelplein 41, Gent', 51.063500, 3.735000, 'club', 'Underground/Industrial', null),
    ('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380b02', 'Club 69', 'Oude Beestenmarkt 5, Gent', 51.054500, 3.729500, 'club', 'House/Techno', 'No Lockers tonight'),
    ('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380b03', 'Houtdok', 'Dok-Noord 7, Gent', 51.066500, 3.731000, 'place', 'Park/Chill', null);

INSERT INTO opening_hours (place_id, day_of_week, open_time, close_time) VALUES
    ('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11', 4, '21:00', '05:00'),
    ('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11', 5, '22:00', '06:00'),
    ('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a33', 5, '23:00', '07:00'),
    ('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a55', 6, '23:00', '08:00'),
    ('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a44', 3, '20:00', '04:00'),
    ('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a44', 4, '20:00', '05:00'),
    ('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a44', 5, '21:00', '06:00');

INSERT INTO events (id, created_by, title, description, address, latitude, longitude, start_datetime, end_datetime, place_id, association_id) VALUES
    (gen_random_uuid(), 'd0eebc99-9c0b-4ef8-bb6d-6bb9bd380d11', 'Techno Tuesday', 'De beste techno beats op een dinsdag.', 'Vooruit, Gent', 51.047800, 3.727500, now() + interval '1 day', now() + interval '1 day 6 hours', 'a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a33', null),
    (gen_random_uuid(), 'd0eebc99-9c0b-4ef8-bb6d-6bb9bd380d11', 'VTK Galabal', 'Het jaarlijkse galabal van VTK.', 'ICC Gent', 51.026900, 3.712600, now() + interval '5 days', now() + interval '5 days 8 hours', null, 'b0eebc99-9c0b-4ef8-bb6d-6bb9bd380b11'),
    (gen_random_uuid(), 'd0eebc99-9c0b-4ef8-bb6d-6bb9bd380d11', 'Overpoort Crawl', 'Een kroegentocht langs alle iconische bars.', 'Overpoortstraat, Gent', 51.038580, 3.726210, now() + interval '2 hours', now() + interval '10 hours', null, null),
    (gen_random_uuid(), 'd0eebc99-9c0b-4ef8-bb6d-6bb9bd380d11', 'Electronic Garden', 'Open-air house sessie in de stad.', 'Sint-Pietersplein, Gent', 51.042000, 3.727000, now() + interval '12 hours', now() + interval '20 hours', null, null),
    (gen_random_uuid(), 'd0eebc99-9c0b-4ef8-bb6d-6bb9bd380d11', 'ESN Welcome Party', 'Grootste internationaal studentenfeest van het semester.', 'Twitch, Gent', 51.038580, 3.726210, now() + interval '4 hours', now() + interval '10 hours', 'a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11', 'b0eebc99-9c0b-4ef8-bb6d-6bb9bd380b44'),
    (gen_random_uuid(), 'd0eebc99-9c0b-4ef8-bb6d-6bb9bd380d11', 'House Rhythms', 'Lekkere house platen heel de nacht lang.', 'Club 69, Gent', 51.054500, 3.729500, now() + interval '6 hours', now() + interval '14 hours', 'a0eebc99-9c0b-4ef8-bb6d-6bb9bd380b02', null),
    (gen_random_uuid(), 'd0eebc99-9c0b-4ef8-bb6d-6bb9bd380d11', 'Indie Rocks', 'Live bands en alternatieve muziek.', 'Charlatan, Gent', 51.056700, 3.728800, now() + interval '1 hour', now() + interval '7 hours', 'a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a44', null);

INSERT INTO vibe_checks (place_id, is_positive, created_at) VALUES
    ('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11', true, now() - interval '1 hour'),
    ('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11', true, now() - interval '45 minutes'),
    ('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a33', true, now() - interval '2 hours'),
    ('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a55', true, now() - interval '10 minutes'),
    ('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a44', true, now() - interval '1 hour'),
    ('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380b02', true, now() - interval '5 minutes');

INSERT INTO association_members (association_id, user_id, role) VALUES
    ('b0eebc99-9c0b-4ef8-bb6d-6bb9bd380b11', 'd0eebc99-9c0b-4ef8-bb6d-6bb9bd380d11', 'member'),
    ('b0eebc99-9c0b-4ef8-bb6d-6bb9bd380b11', 'd0eebc99-9c0b-4ef8-bb6d-6bb9bd380d33', 'member'),
    ('b0eebc99-9c0b-4ef8-bb6d-6bb9bd380b22', 'd0eebc99-9c0b-4ef8-bb6d-6bb9bd380d22', 'member'),
    ('b0eebc99-9c0b-4ef8-bb6d-6bb9bd380b44', 'd0eebc99-9c0b-4ef8-bb6d-6bb9bd380d55', 'member')
ON CONFLICT DO NOTHING;

INSERT INTO user_followers (follower_id, following_id) VALUES
    ('d0eebc99-9c0b-4ef8-bb6d-6bb9bd380d22', 'd0eebc99-9c0b-4ef8-bb6d-6bb9bd380d11'),
    ('d0eebc99-9c0b-4ef8-bb6d-6bb9bd380d33', 'd0eebc99-9c0b-4ef8-bb6d-6bb9bd380d11'),
    ('d0eebc99-9c0b-4ef8-bb6d-6bb9bd380d11', 'd0eebc99-9c0b-4ef8-bb6d-6bb9bd380d22')
ON CONFLICT DO NOTHING;