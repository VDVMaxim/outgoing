DELETE FROM venue_facilities;
DELETE FROM venue_tags;
DELETE FROM squad_members;
DELETE FROM squads;
DELETE FROM vibe_checks;
DELETE FROM profiles;
DELETE FROM venues;
DELETE FROM facilities;
DELETE FROM tags;

INSERT INTO tags (name) VALUES
  ('Dance'), ('Techno'), ('House'), ('R&B'), ('Hip-Hop'), ('Pop'), ('Student'),
  ('Kring'), ('Underground'), ('Mainstream'), ('Chill'), ('Rooftop'), ('Outdoor'),
  ('VIP'), ('Cocktails'), ('Pintjes'), ('Flash Promo'), ('Gratis Inkom'), ('Gratis Water'),
  ('Chillzone'), ('Smoke Area'), ('Studenten'), ('Commercial'), ('All-round'),
  ('Electronic'), ('Indie'), ('Rock'), ('Metal'), ('Latin'), ('Reggae'), ('Jazz'), ('Soul');

INSERT INTO facilities (name) VALUES
  ('Toilet'), ('Vestiaire'), ('Rookzone'), ('Buitenterras'), ('Rolstoeltoegang'),
  ('VIP Lounge'), ('Gratis Water'), ('Lounge'), ('Airco'), ('Lockers'), ('Cashless'),
  ('Eerste Hulp'), ('Omroep'), ('Douches'), ('Garderobe'), ('Kluisjes'), ('Parkeren'),
  ('Camera''s');

INSERT INTO venues (name, address, latitude, longitude, location_type, genre, status, event_name, organizer, promo, is_flash_promo_active, poi, crowd_level, wait_time, is_vereniging)
VALUES
  ('ClubCTRL', 'Stationsstraat 81, 9000 Gent', 51.0351, 3.7098, 'club', 'Electronic', 'open', NULL, NULL, 'Flash: 1+1 Gratis Shotjes', true, 'Overpoort', 'medium', '10 min', false),
  ('Charlatan', 'Vlasmarkt 23, 9000 Gent', 51.0569, 3.7175, 'club', 'Indie', 'open', NULL, NULL, NULL, false, 'Overpoort', 'quiet', 'no wait', false),
  ('Trio', 'Vlasmarkt 25, 9000 Gent', 51.0568, 3.7174, 'club', 'House', 'event', 'House Night', 'Studentenvereniging', 'Gratis shots om 23:00', false, 'Overpoort', 'busy', '15 min', false),
  ('Decap', 'Sint-Niklaasstraat 13, 9000 Gent', 51.0552, 3.7196, 'club', 'Techno', 'open', NULL, NULL, 'VIP Tafel deal: 100 euro incl. fles', false, 'Overpoort', 'medium', '5 min', false),
  ('De Salamander', 'Overpoortstraat 11, 9000 Gent', 51.0387, 3.7252, 'club', 'Party/Techno', 'event', 'Kringfeest VTK', 'Vlaamse Technische Kring', 'Gratis Vat om 23:00', false, 'Overpoort', 'vibes', 'no wait', true),
  ('Yucca', 'Overpoortstraat 15, 9000 Gent', 51.0384, 3.7251, 'club', 'Commercial', 'open', 'Studentenavond', NULL, NULL, false, 'Overpoort', 'quiet', 'no wait', false),
  ('Canard Bizar', 'Overpoortstraat 4, 9000 Gent', 51.0389, 3.7256, 'club', 'All-round', 'closed', NULL, NULL, NULL, false, 'Overpoort', NULL, NULL, false),
  ('Tweedekamer', 'Overpoortstraat 28, 9000 Gent', 51.0392, 3.7248, 'club', 'Various', 'open', NULL, NULL, 'Ladies Night: Gratis inkom', false, 'Overpoort', 'medium', '5 min', false),
  ('Mirano', 'Korenmarkt 3, 9000 Gent', 51.0540, 3.7208, 'club', 'Commercial', 'closed', NULL, NULL, NULL, false, 'Korenmarkt', NULL, NULL, false),
  ('Upstairs', 'Korenmarkt 15, 9000 Gent', 51.0542, 3.7212, 'club', 'Cocktails', 'open', NULL, NULL, NULL, false, 'Korenmarkt', 'quiet', 'no wait', false),
  ('Bar d''Officier', 'Korenmarkt 10, 9000 Gent', 51.0545, 3.7210, 'club', 'Cocktails', 'open', NULL, NULL, NULL, false, 'Korenmarkt', 'quiet', 'no wait', false),
  ('Stadscafé', 'Sint-Baafsplein 1, 9000 Gent', 51.0538, 3.7178, 'club', NULL, 'open', NULL, NULL, NULL, false, 'Belfort', 'medium', NULL, false),
  ('De Pint', 'Vrijdagmarkt 5, 9000 Gent', 51.0372, 3.7245, 'club', NULL, 'open', NULL, NULL, 'Pintjes: 2 euro', false, 'Vrijdagmarkt', 'medium', NULL, false),
  ('Blaffende Vis', 'Bijlokehof 1, 9000 Gent', 51.0360, 3.7235, 'club', NULL, 'event', 'Kringfeest', 'KVG Gent', 'Gratis inkom voor 00:00', false, 'Bijloke', 'vibes', 'no wait', true),
  ('Hof van Liere', 'Karel Van Manderstraat 11, 9000 Gent', 51.0375, 3.7238, 'club', NULL, 'open', NULL, NULL, NULL, false, 'Overpoort', 'quiet', NULL, false),
  ('De Drank', 'Sint-Amandsstraat 10, 9000 Gent', 51.0380, 3.7242, 'club', NULL, 'open', NULL, NULL, NULL, false, 'Overpoort', 'quiet', NULL, false),
  ('Café Central', 'Korenmarkt 8, 9000 Gent', 51.0543, 3.7205, 'club', NULL, 'open', NULL, NULL, 'Daily specials', false, 'Korenmarkt', 'medium', NULL, false),
  ('De Stoom', 'Sint-Michielsstraat 5, 9000 Gent', 51.0368, 3.7230, 'club', NULL, 'event', 'Open Mic Night', NULL, 'Gratis optredens', false, 'Overpoort', 'vibes', NULL, false),
  ('De Prof', 'Naamsestraat 34, 3000 Leuven', 50.8778, 4.7011, 'club', 'Dance', 'event', 'Fakbar Night', 'Leuven Studenten', 'Gratis shots om 23:00', false, 'Oude Markt', 'busy', '5 min', true),
  ('Café Belge', 'Oude Markt 35, 3000 Leuven', 50.8783, 4.7003, 'club', 'Student/Party', 'open', NULL, NULL, NULL, false, 'Oude Markt', 'vibes', 'no wait', false),
  ('The Hive', 'Naamsestraat 60, 3000 Leuven', 50.8775, 4.7020, 'club', 'Various', 'event', 'Exam Party', 'Leuven Studenten', 'Gratis inkom voor 22:00', false, 'Oude Markt', 'vibes', '10 min', true),
  ('Café Exterior', 'Oude Markt 13, 3000 Leuven', 50.8788, 4.6998, 'club', NULL, 'open', NULL, NULL, NULL, false, 'Oude Markt', 'medium', NULL, false),
  ('Café Monarch', 'Oude Markt 20, 3000 Leuven', 50.8785, 4.7000, 'club', NULL, 'open', NULL, NULL, NULL, false, 'Oude Markt', 'quiet', NULL, false),
  ('Café Playing', 'Muntstraat 6, 3000 Leuven', 50.8790, 4.7005, 'club', NULL, 'open', NULL, NULL, NULL, false, 'Muntstraat', 'quiet', NULL, false),
  ('De Rompomp', 'Brusselsestraat 40, 3000 Leuven', 50.8765, 4.7015, 'club', NULL, 'open', NULL, NULL, NULL, false, 'Brusselsestraat', 'medium', NULL, false),
  ('Café Mummie', 'Schaamstraat 51, 3000 Leuven', 50.8770, 4.7025, 'club', 'Various', 'event', 'Studentenfuif', NULL, 'VIP Deals beschikbaar', false, 'Schaamstraat', 'vibes', '15 min', false);

INSERT INTO venues (name, address, latitude, longitude, location_type, genre, status, poi, crowd_level)
VALUES
  ('Frituur nr.1', 'Overpoortstraat 5, 9000 Gent', 51.0385, 3.7255, 'food', NULL, 'open', 'Overpoort', 'busy'),
  ('Manhattan Buff', 'Vlasmarkt 15, 9000 Gent', 51.0567, 3.7172, 'food', NULL, 'open', 'Overpoort', 'medium'),
  ('Taco Bar', 'Sint-Baafsplein 5, 9000 Gent', 51.0540, 3.7180, 'food', NULL, 'open', 'Belfort', 'quiet'),
  ('Pasta Basta', 'Naamsestraat 20, 3000 Leuven', 50.8780, 4.7010, 'food', NULL, 'open', 'Oude Markt', 'medium'),
  ('Burger King', 'Brusselsestraat 25, 3000 Leuven', 50.8768, 4.7018, 'food', NULL, 'open', 'Brusselsestraat', 'busy');

DO $$
DECLARE
    clubctrl_id UUID; charlatan_id UUID; trio_id UUID; decap_id UUID; salamander_id UUID; yucca_id UUID;
    canard_id UUID; tweedekamer_id UUID; mirano_id UUID; upstairs_id UUID; bardofficier_id UUID;
    stadscafe_id UUID; depint_id UUID; blaffendevis_id UUID; hofvanliere_id UUID; drank_id UUID;
    central_id UUID; deStoom_id UUID; deprof_id UUID; cafebelge_id UUID; thehive_id UUID; exterior_id UUID;
    monarch_id UUID; playing_id UUID; rompomp_id UUID; mummie_id UUID;
    
    dance_id UUID; techno_id UUID; house_id UUID; student_id UUID; chill_id UUID; mainstream_id UUID;
    underground_id UUID; cocktail_id UUID; rooftop_id UUID; outdoor_id UUID; vip_id UUID; flashpromo_id UUID;
    gratisinko_id UUID; pintjes_id UUID; studenten_id UUID; commercial_id UUID; allround_id UUID;
    electronic_id UUID; indie_id UUID; rock_id UUID; various_id UUID; various2_id UUID;
    
    toilet_id UUID; vestiaire_id UUID; rookzone_id UUID; buitenterras_id UUID; rolstoel_id UUID;
    viplounge_id UUID; gratiswater_id UUID; lounge_id UUID; airco_id UUID; cashless_id UUID;
BEGIN
    SELECT id INTO clubctrl_id FROM venues WHERE name = 'ClubCTRL';
    SELECT id INTO charlatan_id FROM venues WHERE name = 'Charlatan';
    SELECT id INTO trio_id FROM venues WHERE name = 'Trio';
    SELECT id INTO decap_id FROM venues WHERE name = 'Decap';
    SELECT id INTO salamander_id FROM venues WHERE name = 'De Salamander';
    SELECT id INTO yucca_id FROM venues WHERE name = 'Yucca';
    SELECT id INTO canard_id FROM venues WHERE name = 'Canard Bizar';
    SELECT id INTO tweedekamer_id FROM venues WHERE name = 'Tweedekamer';
    SELECT id INTO mirano_id FROM venues WHERE name = 'Mirano';
    SELECT id INTO upstairs_id FROM venues WHERE name = 'Upstairs';
    SELECT id INTO bardofficier_id FROM venues WHERE name = 'Bar d''Officier';
    SELECT id INTO stadscafe_id FROM venues WHERE name = 'Stadscafé';
    SELECT id INTO depint_id FROM venues WHERE name = 'De Pint';
    SELECT id INTO blaffendevis_id FROM venues WHERE name = 'Blaffende Vis';
    SELECT id INTO hofvanliere_id FROM venues WHERE name = 'Hof van Liere';
    SELECT id INTO drank_id FROM venues WHERE name = 'De Drank';
    SELECT id INTO central_id FROM venues WHERE name = 'Café Central';
    SELECT id INTO deStoom_id FROM venues WHERE name = 'De Stoom';
    SELECT id INTO deprof_id FROM venues WHERE name = 'De Prof';
    SELECT id INTO cafebelge_id FROM venues WHERE name = 'Café Belge';
    SELECT id INTO thehive_id FROM venues WHERE name = 'The Hive';
    SELECT id INTO exterior_id FROM venues WHERE name = 'Café Exterior';
    SELECT id INTO monarch_id FROM venues WHERE name = 'Café Monarch';
    SELECT id INTO playing_id FROM venues WHERE name = 'Café Playing';
    SELECT id INTO rompomp_id FROM venues WHERE name = 'De Rompomp';
    SELECT id INTO mummie_id FROM venues WHERE name = 'Café Mummie';
    
    SELECT id INTO dance_id FROM tags WHERE name = 'Dance';
    SELECT id INTO techno_id FROM tags WHERE name = 'Techno';
    SELECT id INTO house_id FROM tags WHERE name = 'House';
    SELECT id INTO student_id FROM tags WHERE name = 'Student';
    SELECT id INTO chill_id FROM tags WHERE name = 'Chill';
    SELECT id INTO mainstream_id FROM tags WHERE name = 'Mainstream';
    SELECT id INTO underground_id FROM tags WHERE name = 'Underground';
    SELECT id INTO cocktail_id FROM tags WHERE name = 'Cocktails';
    SELECT id INTO rooftop_id FROM tags WHERE name = 'Rooftop';
    SELECT id INTO outdoor_id FROM tags WHERE name = 'Outdoor';
    SELECT id INTO vip_id FROM tags WHERE name = 'VIP';
    SELECT id INTO flashpromo_id FROM tags WHERE name = 'Flash Promo';
    SELECT id INTO gratisinko_id FROM tags WHERE name = 'Gratis Inkom';
    SELECT id INTO pintjes_id FROM tags WHERE name = 'Pintjes';
    SELECT id INTO studenten_id FROM tags WHERE name = 'Studenten';
    SELECT id INTO commercial_id FROM tags WHERE name = 'Commercial';
    SELECT id INTO allround_id FROM tags WHERE name = 'All-round';
    SELECT id INTO electronic_id FROM tags WHERE name = 'Electronic';
    SELECT id INTO indie_id FROM tags WHERE name = 'Indie';
    SELECT id INTO rock_id FROM tags WHERE name = 'Rock';
    SELECT id INTO various_id FROM tags WHERE name = 'Dance';
    
    SELECT id INTO toilet_id FROM facilities WHERE name = 'Toilet';
    SELECT id INTO vestiaire_id FROM facilities WHERE name = 'Vestiaire';
    SELECT id INTO rookzone_id FROM facilities WHERE name = 'Rookzone';
    SELECT id INTO buitenterras_id FROM facilities WHERE name = 'Buitenterras';
    SELECT id INTO rolstoel_id FROM facilities WHERE name = 'Rolstoeltoegang';
    SELECT id INTO viplounge_id FROM facilities WHERE name = 'VIP Lounge';
    SELECT id INTO gratiswater_id FROM facilities WHERE name = 'Gratis Water';
    SELECT id INTO lounge_id FROM facilities WHERE name = 'Lounge';
    SELECT id INTO airco_id FROM facilities WHERE name = 'Airco';
    SELECT id INTO cashless_id FROM facilities WHERE name = 'Cashless';
    
    INSERT INTO venue_tags (venue_id, tag_id) VALUES
      (clubctrl_id, dance_id), (clubctrl_id, techno_id), (clubctrl_id, underground_id), (clubctrl_id, flashpromo_id),
      (charlatan_id, indie_id), (charlatan_id, rock_id), (charlatan_id, student_id), (charlatan_id, chill_id),
      (trio_id, dance_id), (trio_id, house_id), (trio_id, student_id),
      (decap_id, techno_id), (decap_id, underground_id), (decap_id, electronic_id), (decap_id, vip_id),
      (salamander_id, student_id), (salamander_id, gratisinko_id), (salamander_id, chill_id),
      (yucca_id, commercial_id), (yucca_id, studenten_id),
      (canard_id, allround_id), (canard_id, cocktail_id),
      (tweedekamer_id, student_id),
      (mirano_id, mainstream_id), (mirano_id, dance_id),
      (upstairs_id, chill_id), (upstairs_id, cocktail_id),
      (bardofficier_id, cocktail_id), (bardofficier_id, chill_id),
      (stadscafe_id, outdoor_id), (stadscafe_id, chill_id),
      (depint_id, pintjes_id), (depint_id, student_id),
      (blaffendevis_id, student_id),
      (hofvanliere_id, chill_id),
      (drank_id, cocktail_id),
      (central_id, pintjes_id),
      (deStoom_id, chill_id),
      (deprof_id, dance_id), (deprof_id, student_id), (deprof_id, gratisinko_id),
      (cafebelge_id, pintjes_id), (cafebelge_id, student_id),
      (thehive_id, dance_id), (thehive_id, student_id),
      (exterior_id, outdoor_id),
      (monarch_id, chill_id),
      (playing_id, student_id),
      (rompomp_id, chill_id),
      (mummie_id, various_id);
    
    INSERT INTO venue_facilities (venue_id, facility_id) VALUES
      (clubctrl_id, toilet_id), (clubctrl_id, vestiaire_id), (clubctrl_id, rookzone_id), (clubctrl_id, cashless_id),
      (charlatan_id, toilet_id), (charlatan_id, rolstoel_id), (charlatan_id, buitenterras_id),
      (trio_id, toilet_id), (trio_id, viplounge_id), (trio_id, vestiaire_id),
      (decap_id, toilet_id), (decap_id, rookzone_id), (decap_id, vestiaire_id), (decap_id, viplounge_id),
      (salamander_id, gratiswater_id), (salamander_id, lounge_id),
      (yucca_id, toilet_id), (yucca_id, vestiaire_id), (yucca_id, buitenterras_id),
      (canard_id, toilet_id), (canard_id, buitenterras_id),
      (tweedekamer_id, toilet_id),
      (mirano_id, toilet_id), (mirano_id, rolstoel_id), (mirano_id, vestiaire_id), (mirano_id, viplounge_id),
      (upstairs_id, toilet_id), (upstairs_id, buitenterras_id),
      (bardofficier_id, toilet_id), (bardofficier_id, rolstoel_id),
      (stadscafe_id, toilet_id), (stadscafe_id, buitenterras_id),
      (depint_id, cashless_id),
      (deprof_id, toilet_id), (deprof_id, airco_id),
      (cafebelge_id, toilet_id), (cafebelge_id, buitenterras_id),
      (thehive_id, toilet_id), (thehive_id, airco_id),
      (exterior_id, buitenterras_id),
      (monarch_id, toilet_id),
      (playing_id, toilet_id),
      (rompomp_id, toilet_id),
      (mummie_id, toilet_id), (mummie_id, airco_id);
    
END $$;

INSERT INTO vibe_checks (venue_id, crowd_level, energy, created_at)
SELECT 
    v.id, 
    v.crowd_level,
    CASE 
        WHEN v.crowd_level = 'busy' THEN 8
        WHEN v.crowd_level = 'medium' THEN 6
        WHEN v.crowd_level = 'vibes' THEN 7
        ELSE 5
    END,
    NOW() - (random() * interval '2 hours')
FROM venues v
WHERE v.crowd_level IS NOT NULL;