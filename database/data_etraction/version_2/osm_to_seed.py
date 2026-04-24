import json
import uuid
import math
import re
import os
import requests

def parse_opening_hours(oh_raw, place_id):
    if not oh_raw:
        return []
    
    if oh_raw.strip() == "24/7":
        return [f"INSERT INTO opening_hours (place_id, day_of_week, open_time, close_time) VALUES ('{place_id}', {d}, '00:00:00', '23:59:59');" for d in range(7)]

    sqls = []
    days_map = {'Su': 0, 'Mo': 1, 'Tu': 2, 'We': 3, 'Th': 4, 'Fr': 5, 'Sa': 6}
    days_list = ['Su', 'Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa']

    parts = oh_raw.split(';')
    for part in parts:
        part = part.strip()
        if not part or part.lower() == 'off' or 'off' in part.lower():
            continue
        
        match = re.search(r'([MoTuWeThFrSaSu,\- ]+)\s+(\d{2}:\d{2})\s*-\s*(\d{2}:\d{2})', part)
        if match:
            # Controleer op corrupte/onmogelijke tijden (zoals 25:00)
            open_hh, open_mm = map(int, match.group(2).split(':'))
            close_hh, close_mm = map(int, match.group(3).split(':'))
            
            if open_hh > 23 or open_mm > 59 or close_hh > 23 or close_mm > 59:
                return [] # Corrupte data gedetecteerd! Abort parsing

            days_str = match.group(1).strip()
            open_t = match.group(2) + ":00"
            close_t = match.group(3) + ":00"
            
            active_days = set()
            for segment in days_str.split(','):
                segment = segment.strip()
                if '-' in segment:
                    dash_parts = [p.strip() for p in segment.split('-') if p.strip()]
                    if len(dash_parts) >= 2:
                        start_d = dash_parts[0]
                        end_d = dash_parts[-1]
                        if start_d in days_map and end_d in days_map:
                            idx = days_list.index(start_d)
                            end_idx = days_list.index(end_d)
                            while True:
                                active_days.add(days_map[days_list[idx]])
                                if idx == end_idx:
                                    break
                                idx = (idx + 1) % 7
                elif segment in days_map:
                    active_days.add(days_map[segment])
            
            for d in active_days:
                if open_t > close_t:
                    sqls.append(f"INSERT INTO opening_hours (place_id, day_of_week, open_time, close_time) VALUES ('{place_id}', {d}, '{open_t}', '23:59:59');")
                    next_d = (d + 1) % 7
                    sqls.append(f"INSERT INTO opening_hours (place_id, day_of_week, open_time, close_time) VALUES ('{place_id}', {next_d}, '00:00:00', '{close_t}');")
                else:
                    sqls.append(f"INSERT INTO opening_hours (place_id, day_of_week, open_time, close_time) VALUES ('{place_id}', {d}, '{open_t}', '{close_t}');")
    return sqls

def fetch_osm_data(query_file='overpass_osm_query.txt'):
    print("1. Query inlezen...")
    try:
        with open(query_file, 'r', encoding='utf-8') as f:
            query = f.read()
    except FileNotFoundError:
        print(f"Fout: Kan '{query_file}' niet vinden. Zorg dat dit bestand bestaat.")
        return None

    print("2. Data ophalen via Overpass API (dit kan even duren bij grote queries)...")
    overpass_url = "https://overpass-api.de/api/interpreter"
    
    # 1. Voeg een User-Agent toe zodat de server weet dat we geen kwaadaardige bot zijn.
    # (Optioneel: verander het emailadres naar je eigen adres)
    headers = {
        'User-Agent': 'FlutterPlacesApp/1.0 (jouw@email.com)',
        'Accept': 'application/json'
    }
    
    # 2. Stuur de query als direct UTF-8 geëncodeerde tekst, niet als een form-dictionary
    response = requests.post(overpass_url, data=query.encode('utf-8'), headers=headers)
    
    if response.status_code != 200:
        print(f"Fout bij ophalen API: {response.status_code}")
        print(response.text)
        return None
        
    print("✓ Data succesvol binnengehaald!")
    return response.json()

def generate_seed():
    data = fetch_osm_data()
    if not data:
        return

    print("3. SQL Queries genereren en transformeren...")
    
    # We slaan blokken op in plaats van individuele lijnen om te voorkomen 
    # dat een locatie en zijn uren over twee bestanden worden gesplitst.
    sql_blocks = []
    
    for element in data.get('elements', []):
        tags = element.get('tags', {})
        amenity = tags.get('amenity', '')
        
        # Mapping bepalen
        if amenity in ['nightclub', 'bar', 'pub']:
            location_type = 'club'
        elif amenity == 'fast_food':
            location_type = 'food'
        else:
            continue

        # Naam en fallback bepalen
        raw_name = tags.get('name')
        if not raw_name:
            if location_type == 'food':
                cuisine = tags.get('cuisine', '')
                raw_name = "Frituur" if 'frite' in cuisine else "Snack/Fast Food"
            else:
                raw_name = "Bar/Pub"
                
        name = raw_name.replace("'", "''") 
        
        # Coördinaten ophalen
        if element['type'] == 'node':
            lat = element.get('lat')
            lon = element.get('lon')
        elif element['type'] in ['way', 'relation']:
            center = element.get('center', {})
            lat = center.get('lat')
            lon = center.get('lon')
        else:
            continue

        if not lat or not lon:
            continue
            
        # Adres opbouwen (Optioneel, maar goed om te hebben als fallback)
        street = tags.get('addr:street', '')
        housenumber = tags.get('addr:housenumber', '')
        city = tags.get('addr:city', '')
        address_parts = [p for p in [f"{street} {housenumber}".strip(), city] if p]
        address = ", ".join(address_parts).replace("'", "''")
        address_sql = f"'{address}'" if address else "NULL"

        place_id = str(uuid.uuid4())
        oh_raw = tags.get('opening_hours', '')
        oh_raw_sql = f"'{oh_raw.replace(chr(39), chr(39)+chr(39))}'" if oh_raw else "NULL"
        
        # Hoofd query voor osm_places (geen 'status' meer, naam aangepast)
        main_sql = f"INSERT INTO osm_places (id, name, address, latitude, longitude, location_type, opening_hours_raw) VALUES ('{place_id}', '{name}', {address_sql}, {lat}, {lon}, '{location_type}', {oh_raw_sql});"
        
        # Opening hours queries
        oh_sqls = parse_opening_hours(oh_raw, place_id)
        
        # Groepeer de main sql met de uren
        block = [main_sql] + oh_sqls
        sql_blocks.append(block)

    if not sql_blocks:
        print("Geen bruikbare locaties gevonden in de data.")
        return

    print("4. Bestanden aanmaken en wegschrijven...")
    
    # Mappenstructuur aanmaken
    os.makedirs('output/split', exist_ok=True)
    
    # Eén groot bestand maken
    all_sqls = [sql for block in sql_blocks for sql in block]
    with open('output/osm_seed.sql', 'w', encoding='utf-8') as out_full:
        out_full.write("\n".join(all_sqls))
    print(f"✓ Hoofdbestand 'output/osm_seed.sql' aangemaakt ({len(all_sqls)} lijnen).")

    # Smart Split Logica (Houd blokken bij elkaar)
    max_lines_per_file = 2000
    current_chunk = []
    chunk_index = 1
    
    for block in sql_blocks:
        block_size = len(block)
        
        # Check of dit blok het bestand over de limiet zou duwen
        if len(current_chunk) + block_size > max_lines_per_file and len(current_chunk) > 0:
            # Schrijf de huidige chunk weg
            file_name = f'output/split/osm_seed_part_{chunk_index}.sql'
            with open(file_name, 'w', encoding='utf-8') as out_part:
                out_part.write("\n".join(current_chunk))
            print(f"  - Bestand '{file_name}' aangemaakt met {len(current_chunk)} lijnen.")
            
            # Reset voor de volgende chunk
            chunk_index += 1
            current_chunk = []
            
        # Voeg het blok toe aan de (nieuwe of bestaande) chunk
        current_chunk.extend(block)
        
    # Schrijf het allerlaatste restje weg
    if current_chunk:
        file_name = f'output/split/osm_seed_part_{chunk_index}.sql'
        with open(file_name, 'w', encoding='utf-8') as out_part:
            out_part.write("\n".join(current_chunk))
        print(f"  - Bestand '{file_name}' aangemaakt met {len(current_chunk)} lijnen.")

    print("\n🎉 Klaar! Je data is automatisch opgehaald, getransformeerd en netjes (smart-split) opgedeeld.")

if __name__ == '__main__':
    generate_seed()