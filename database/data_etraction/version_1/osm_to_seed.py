import json
import uuid
import math
import re

def parse_opening_hours(oh_raw, venue_id):
    if not oh_raw:
        return []
    
    if oh_raw.strip() == "24/7":
        return [f"INSERT INTO opening_hours (venue_id, day_of_week, open_time, close_time) VALUES ('{venue_id}', {d}, '00:00:00', '23:59:59');" for d in range(7)]

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
                return [] # Corrupte data gedetecteerd! Abort parsing, val terug op raw_string.

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
                    sqls.append(f"INSERT INTO opening_hours (venue_id, day_of_week, open_time, close_time) VALUES ('{venue_id}', {d}, '{open_t}', '23:59:59');")
                    next_d = (d + 1) % 7
                    sqls.append(f"INSERT INTO opening_hours (venue_id, day_of_week, open_time, close_time) VALUES ('{venue_id}', {next_d}, '00:00:00', '{close_t}');")
                else:
                    sqls.append(f"INSERT INTO opening_hours (venue_id, day_of_week, open_time, close_time) VALUES ('{venue_id}', {d}, '{open_t}', '{close_t}');")
    return sqls

def generate_seed():
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
        
        if amenity in ['nightclub', 'bar', 'pub']:
            location_type = 'club'
        elif amenity == 'fast_food':
            location_type = 'food'
        else:
            continue

        raw_name = tags.get('name')
        if not raw_name:
            if location_type == 'food':
                cuisine = tags.get('cuisine', '')
                raw_name = "Frituur" if 'frite' in cuisine else "Snack/Fast Food"
            else:
                raw_name = "Bar/Pub"
                
        name = raw_name.replace("'", "''") 
        
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

        venue_id = str(uuid.uuid4())
        oh_raw = tags.get('opening_hours', '')
        oh_raw_sql = f"'{oh_raw.replace(chr(39), chr(39)+chr(39))}'" if oh_raw else "NULL"
        
        sql = f"INSERT INTO venues (id, name, address, latitude, longitude, location_type, status, opening_hours_raw) VALUES ('{venue_id}', '{name}', NULL, {lat}, {lon}, '{location_type}', 'closed', {oh_raw_sql});"
        sql_statements.append(sql)
        
        oh_sqls = parse_opening_hours(oh_raw, venue_id)
        sql_statements.extend(oh_sqls)

    total_items = len(sql_statements)
    if total_items == 0:
        print("Geen data gevonden om te exporteren.")
        return

    max_lines_per_file = 2000
    total_files = math.ceil(total_items / max_lines_per_file)

    for i in range(total_files):
        start_index = i * max_lines_per_file
        end_index = start_index + max_lines_per_file
        subset = sql_statements[start_index:end_index]
        
        if subset:
            file_name = f'osm_seed_part_{i+1}.sql'
            with open(file_name, 'w', encoding='utf-8') as out:
                out.write("\n".join(subset))
            print(f"Bestand '{file_name}' aangemaakt met {len(subset)} locaties.")

    print(f"\nKlaar! De data is verdeeld over {total_files} bestanden met maximaal {max_lines_per_file} regels per bestand.")

if __name__ == '__main__':
    generate_seed()