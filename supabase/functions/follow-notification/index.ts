// Setup type definitions for built-in Supabase Runtime APIs
import "jsr:@supabase/functions-js/edge-runtime.d.ts";
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2'

console.info('Follow-notification edge function started');

Deno.serve(async (req: Request) => {
  try {
    // 1. Haal de veilige API keys (secrets) op uit Supabase
    const ONESIGNAL_APP_ID = Deno.env.get('ONESIGNAL_APP_ID');
    const ONESIGNAL_REST_API_KEY = Deno.env.get('ONESIGNAL_REST_API_KEY');
    const SUPABASE_URL = Deno.env.get('SUPABASE_URL');
    const SUPABASE_SERVICE_ROLE_KEY = Deno.env.get('SUPABASE_SERVICE_ROLE_KEY');

    if (!ONESIGNAL_APP_ID || !ONESIGNAL_REST_API_KEY || !SUPABASE_URL || !SUPABASE_SERVICE_ROLE_KEY) {
      throw new Error("Missing environment variables in Supabase Secrets.");
    }

    // 2. Lees de data (payload) die Supabase doorstuurt wanneer de database verandert
    const payload = await req.json();
    
    // 3. Controleer of de actie een "INSERT" (nieuwe rij) is op de "user_followers" tabel
    if (payload.type === 'INSERT' && payload.table === 'user_followers') {
      
      const followerId = payload.record.follower_id;   // Degene die op 'Volgen' klikte
      const followingId = payload.record.following_id; // Degene die de notificatie moet krijgen

      // 4. Maak een Supabase admin-client aan om de naam van de volger op te zoeken
      const supabase = createClient(SUPABASE_URL, SUPABASE_SERVICE_ROLE_KEY);

      const { data: profile, error } = await supabase
        .from('profiles')
        .select('nickname')
        .eq('user_id', followerId)
        .single();

      if (error) {
        console.error("Fout bij het ophalen van het profiel:", error);
      }

      const nickname = profile?.nickname ?? 'Iemand';

      // 5. Stuur het verzoek naar OneSignal om de pushmelding af te leveren
      const response = await fetch('https://api.onesignal.com/notifications', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json; charset=utf-8',
          'Authorization': `Basic ${ONESIGNAL_REST_API_KEY}`,
        },
        body: JSON.stringify({
          app_id: ONESIGNAL_APP_ID,
          target_channel: "push",
          include_aliases: {
            "external_id": [followingId] // Dit is de user_id van degene die gevolgd wordt (werkt perfect samen met OneSignal.login in Flutter!)
          },
          headings: { "en": "Nieuwe volger!", "nl": "Nieuwe volger!" },
          contents: { 
            "en": `${nickname} started following you.`, 
            "nl": `${nickname} is je gaan volgen.` 
          },
        }),
      });

      const result = await response.json();
      
      // Geef een succes-bericht terug aan Supabase
      return new Response(
        JSON.stringify({ success: true, onesignal_response: result }), 
        { headers: { 'Content-Type': 'application/json' }, status: 200 }
      );
    }

    // Als de trigger afging voor iets anders dan een insert, negeren we het netjes
    return new Response(
      JSON.stringify({ message: 'Geen actie vereist (geen insert of verkeerde tabel)' }), 
      { headers: { 'Content-Type': 'application/json' }, status: 200 }
    );

  } catch (err) {
    console.error("Fatale fout in edge function:", err);
    return new Response(
      JSON.stringify({ error: String(err) }), 
      { headers: { 'Content-Type': 'application/json' }, status: 500 }
    );
  }
});