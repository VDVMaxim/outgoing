-- Zorg ervoor dat pg_cron is ingeschakeld in je Supabase Dashboard 
-- (Database -> Extensions -> zoek op 'pg_cron' en zet deze aan).
CREATE EXTENSION IF NOT EXISTS pg_cron;

-- 1. De functie die de vibe berekent voor alle venues
CREATE OR REPLACE FUNCTION calculate_and_update_vibes()
RETURNS void
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
    v_venue RECORD;
    v_time_score FLOAT;
    v_checkin_score FLOAT;
    v_squad_score FLOAT;
    v_total_score FLOAT;
    v_new_crowd_level TEXT;
    v_current_hour INT;
BEGIN
    -- Haal het huidige uur op in lokale tijd (pas de timezone aan indien nodig, bijv 'Europe/Brussels')
    v_current_hour := EXTRACT(HOUR FROM (NOW() AT TIME ZONE 'Europe/Brussels'));

    FOR v_venue IN SELECT * FROM venues LOOP
        
        -- A. TIME SCORE (Gewicht: 40%)
        -- Piekuren tussen 23:00 en 04:00 scoren het hoogst
        IF v_current_hour >= 23 OR v_current_hour < 4 THEN
            v_time_score := 10.0;
        ELSIF v_current_hour >= 21 THEN
            v_time_score := 6.0;
        ELSIF v_current_hour >= 18 THEN
            v_time_score := 3.0;
        ELSE
            v_time_score := 1.0;
        END IF;

        -- B. CHECK-IN SCORE (Gewicht: 30%)
        -- Aantal check-ins in de afgelopen 2 uur in deze venue. Maximaal 10 punten. (Bijv. 5 checkins = 10 punten)
        SELECT LEAST((COUNT(*) * 2.0), 10.0) INTO v_checkin_score
        FROM vibe_actions
        WHERE venue_id = v_venue.id
          AND action_type = 'check_in'
          AND created_at >= NOW() - INTERVAL '2 hours';

        -- C. SQUAD SCORE (Gewicht: 30%)
        -- Gebruik PostGIS om unieke squad members binnen een straal van 50m te tellen
        IF v_venue.location IS NOT NULL THEN
            SELECT LEAST((COUNT(DISTINCT user_id) * 3.0), 10.0) INTO v_squad_score
            FROM squad_members
            WHERE ST_DWithin(
                ST_SetSRID(ST_MakePoint(longitude, latitude), 4326)::geography,
                v_venue.location,
                50 -- afstand in meters
            )
            AND updated_at >= NOW() - INTERVAL '30 minutes'; -- Alleen actieve leden in het afgelopen halfuur
        ELSE
            v_squad_score := 0;
        END IF;

        -- Bereken de definitieve score (max 10)
        v_total_score := (v_time_score * 0.4) + (v_checkin_score * 0.3) + (v_squad_score * 0.3);

        -- Map de score naar de crowd_level strings die de app gebruikt
        IF v_total_score >= 8.0 THEN
            v_new_crowd_level := 'Bomvol';
        ELSIF v_total_score >= 6.0 THEN
            v_new_crowd_level := 'Druk';
        ELSIF v_total_score >= 4.0 THEN
            v_new_crowd_level := 'Sfeervol';
        ELSIF v_total_score >= 2.0 THEN
            v_new_crowd_level := 'Gezellig';
        ELSE
            v_new_crowd_level := 'Rustig';
        END IF;

        -- Update de venue, trigger zorgt automatisch voor updated_at
        UPDATE venues
        SET crowd_level = v_new_crowd_level,
            last_vibe_update = NOW()
        WHERE id = v_venue.id;
        
    END LOOP;
END;
$$;

-- 2. Maak de Cronjob aan (voert de functie elke 5 minuten uit)
-- Let op: Als dit een error geeft over permissies in de SQL Editor, 
-- maak dan een nieuwe cron job aan via het Supabase Dashboard:
-- Dashboard -> Integrations -> Cron -> Add Cron Job (Schema: public, Function: calculate_and_update_vibes, Schedule: */5 * * * *)
SELECT cron.schedule(
    'update-venue-vibes-every-5-mins',
    '*/5 * * * *',
    $$SELECT calculate_and_update_vibes();$$
);