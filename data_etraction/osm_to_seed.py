import json
import uuid

def generate_seed():
    # Zorg dat je de output van Overpass Turbo opslaat als osm_data.json
    try:
        with open('osm_data.json', 'r', encoding='utf-8') as f:
            data = json.load(f)
    except FileNotFoundError:
        print("Fout: Kan osm_data.json niet vinden. Zorg dat je de Overpass export in dezelfde map hebt opgeslagen.")
        return

    sql_statements = []
    
    # We clearen de venues tabel niet, want misschien heb je al handmatige data.
    # Als je wel wil clearen, uncomment de volgende regel:
    # sql_statements.append("DELETE FROM venues;\n")

    for element in data.get('elements', []):
        tags = element.get('tags', {})
        amenity = tags.get('amenity', '')
        
        # Bepaal het type voor jouw database ENUM
        if amenity in ['nightclub', 'bar', 'pub']:
            location_type = 'club'
        elif amenity == 'fast_food':
            location_type = 'food'
        else:
            continue # Sla over als het iets anders is

        # Zoek een naam, fallback als er geen is (vaak bij frituren)
        raw_name = tags.get('name')
        if not raw_name:
            if location_type == 'food':
                cuisine = tags.get('cuisine', '')
                if 'frite' in cuisine:
                    raw_name = "Frituur"
                else:
                    raw_name = "Snack/Fast Food"
            else:
                raw_name = "Bar/Pub"
                
        name = raw_name.replace("'", "''") # SQL injectie voorkomen
        
        # Coördinaten ophalen (werkt voor zowel nodes als ways door 'out center;')
        if element['type'] == 'node':
            lat = element.get('lat')
            lon = element.get('lon')
        elif element['type'] == 'way':
            center = element.get('center', {})
            lat = center.get('lat')
            lon = center.get('lon')
        else:
            continue

        if not lat or not lon:
            continue

        # Adres opbouwen
        street = tags.get('addr:street', '')
        housenumber = tags.get('addr:housenumber', '')
        city = tags.get('addr:city', '')
        
        # Als er geen adres is, zetten we een default string. 
        # Je kunt later via reverse geocoding dit nog mooier maken.
        address_parts = [p for p in [f"{street} {housenumber}".strip(), city] if p]
        address = ", ".join(address_parts).replace("'", "''")
        if not address:
            address = 'Adres onbekend'

        venue_id = str(uuid.uuid4())
        
        # We zetten status standaard op 'closed' en crowd_level op 'Rustig' 
        # (Jouw cronjob pakt dit later wel op)
        sql = f"""INSERT INTO venues (id, name, address, latitude, longitude, location_type, status, crowd_level) 
VALUES ('{venue_id}', '{name}', '{address}', {lat}, {lon}, '{location_type}', 'closed', 'Rustig');"""
        
        sql_statements.append(sql)

    # Schrijf alles naar een nieuw SQL bestand
    with open('osm_seed_belgium.sql', 'w', encoding='utf-8') as out:
        out.write("\n".join(sql_statements))
        
    print(f"Klaar! {len(sql_statements)} locaties gegenereerd in 'osm_seed_belgium.sql'.")
    print("Plak de inhoud hiervan in je Supabase SQL editor.")

if __name__ == '__main__':
    generate_seed()