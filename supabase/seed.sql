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