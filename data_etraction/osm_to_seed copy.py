import json
import uuid
import math

def generate_seed():
    # Zorg dat je de output van Overpass Turbo opslaat als osm_data.json
    try:
        with open('osm_data.json', 'r', encoding='utf-8') as f:
            data = json.load(f)
    except FileNotFoundError:
        print("Fout: Kan osm_data.json niet vinden. Zorg dat je de Overpass export in dezelfde map hebt opgeslagen.")
        return

    sql_statements = []
    
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

        # Zoek een naam, fallback als er geen is
        raw_name = tags.get('name')
        if not raw_name:
            if location_type == 'food':
                cuisine = tags.get('cuisine', '')
                raw_name = "Frituur" if 'frite' in cuisine else "Snack/Fast Food"
            else:
                raw_name = "Bar/Pub"
                
        name = raw_name.replace("'", "''") # SQL injectie voorkomen
        
        # Coördinaten ophalen
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
        
        address_parts = [p for p in [f"{street} {housenumber}".strip(), city] if p]
        address = ", ".join(address_parts).replace("'", "''")
        if not address:
            address = 'Adres onbekend'

        venue_id = str(uuid.uuid4())
        
        sql = f"INSERT INTO venues (id, name, address, latitude, longitude, location_type, status, crowd_level) VALUES ('{venue_id}', '{name}', '{address}', {lat}, {lon}, '{location_type}', 'closed', 'Rustig');"
        sql_statements.append(sql)

    # --- SPLIT LOGICA NAAR 4 BESTANDEN ---
    total_items = len(sql_statements)
    if total_items == 0:
        print("Geen data gevonden om te exporteren.")
        return

    # Bereken hoeveel items er per bestand moeten (naar boven afgerond)
    chunk_size = math.ceil(total_items / 4)

    for i in range(4):
        start_index = i * chunk_size
        end_index = start_index + chunk_size
        
        # Pak het deel van de lijst
        subset = sql_statements[start_index:end_index]
        
        if subset:
            file_name = f'osm_seed_part_{i+1}.sql'
            with open(file_name, 'w', encoding='utf-8') as out:
                out.write("\n".join(subset))
            print(f"Bestand '{file_name}' aangemaakt met {len(subset)} locaties.")

    print("\nKlaar! De data is verdeeld over 4 bestanden.")
    print("Upload deze één voor één in je Supabase SQL editor.")

if __name__ == '__main__':
    generate_seed()