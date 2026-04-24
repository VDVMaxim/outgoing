Hier is een beknopte, maar complete technische samenvatting van de database-architectuur. Dit is de perfecte context om later aan een AI (of jezelf) te geven wanneer je de Flutter frontend gaat updaten.

📝 Database Changelog & Architectuur Samenvatting (voor Frontend)

1. Naamgeving & De "Magic View" (Cruciaal voor Flutter)

Van Clubs naar Places: Alle terminologie (venues, clubs) is hernoemd naar places.

De Frontend query't een View: Jouw Flutter app praat alleen met de view genaamd places. Deze view gedraagt zich exact als een normale tabel, inclusief geneste relaties (zoals places(opening_hours(*))).

Onder de motorkap: De data is gesplitst. osm_places bevat de originele OpenStreetMap data. place_overrides bevat aanpassingen van eigenaren. De view places voegt deze on-the-fly samen en geeft altijd de data van de override voorrang, tenzij deze leeg (NULL) is.

1. Aanpassingen Opslaan (Append-Only Pattern)

Als een eigenaar een locatie aanpast, doe je géén UPDATE. De place_overrides tabel is een append-only logboek.

Actie: Je doet altijd een nieuwe INSERT in place_overrides met de gewijzigde velden. De places view is slim genoeg om automatisch alleen de meest recente rij per locatie op te halen aan de hand van de created_at timestamp.

1. Verwijderde Velden (Nu Berekend in Frontend/Backend)
Je zult deze velden niet meer in de database vinden, de frontend moet ze nu afleiden:

status (open/closed): Berekenen op basis van de opening_hours tabel en de huidige tijd.

recent_likes & recent_dislikes: Live optellen door een .count() te doen op de vibe_checks tabel.

last_vibe_update: Is simpelweg de hoogste created_at waarde uit de vibe_checks tabel voor die locatie.

wait_time & is_flash_promo_active: Verwijderd wegens overbodig/dynamisch.

1. Tags, Faciliteiten & Verenigingen (Nieuwe Relaties)

Tags & Facilities Samengevoegd: Er is geen aparte faciliteiten-tabel meer. Alles zit in de tabel tags. Om onderscheid te maken is er een category kolom toegevoegd (bijv. waardes als 'music_genre', 'facility', 'vibe'). Koppel ze aan een locatie via place_tags.

Verenigingen (Associations): De simpele boolean is_vereniging is verwijderd. Er is nu een volwaardige associations tabel (voor de namen van studentenverenigingen/organisaties) en een koppeltabel association_places.

1. Performance Upgrade: UUIDv7

We gebruiken nu tijd-gesorteerde uuid_generate_v7() in plaats van willekeurige v4. Dit maakt de database veel sneller naarmate hij groeit. Hier hoef je in Flutter niks voor aan te passen, maar het is goed om te weten als je handmatig ID's genereert.
