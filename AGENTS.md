# Club App - Project Overview

## Project Description

A Flutter mobile app for club/venue discovery with features for:

- Club and venue discovery with map-based navigation
- Real-time "vibe" checking (crowd level status)
- Squad Mode for sharing location with friends
- Anonymous and authenticated user modes
- Multi-language support (Dutch, English, French)
- Onboarding flow with intro screens and setup wizard

## Architecture

### State Management

- **Riverpod** for dependency injection and state management
- **ValueNotifier** for theme and locale state (defined in `main.dart`)
- Provider-based architecture: `authProvider`, `favoritesProvider`, `squadProvider`

### Navigation Flow

```
SplashScreen → OnboardingIntroScreen (4 pages) → OptionScreen
                                                           ↓
                            ┌──────────────────────────────┴──────────────────────────────┐
                            ↓                                                                ↓
                  OnboardingSetup (Nickname → Location → Complete)              MainNavigation (App)
                                                                                            ↓
                                                                               Home | Map | Activities | Settings
```

### Data Layer

- **Repositories**: Abstract data sources via interfaces
  - `ClubRepository` - places/clubs data
  - `SquadRepository` - squad management
  - `VibeRepository` - vibe checks
- **Supabase** backend (production) + mock data (development)
- Local storage via `UserProfileService`

### Key Files

| File | Purpose |
|------|---------|
| `lib/main.dart` | App entry, theme/locale notifiers, ShadApp setup |
| `lib/core/models/place.dart` | Place model with ClubStatus, LocationType enums |
| `lib/core/providers/auth_provider.dart` | Riverpod auth state (anonymous + authenticated) |
| `lib/core/widgets/animated_background.dart` | Shared animated gradient background |
| `lib/features/navigation/screens/main_navigation.dart` | Bottom nav with IndexedStack |
| `lib/features/home/screens/home_screen.dart` | Home with PageView highlights carousel |
| `lib/features/map/screens/map_screen.dart` | Full-screen FlutterMap with markers |
| `lib/features/squad/providers/squad_provider.dart` | Squad state management |
| `lib/features/onboarding/screens/splash_screen.dart` | Initial splash with startup verification |

## Key Features Implementation

### 1. Animated Background

- `AnimatedBlurBackground` widget wraps content in Stack
- 4 gradient circles (purple, blue, pink, cyan) with sinusoidal animation
- Duration: 60 seconds for seamless looping
- Applied to: Home, Activities, Settings screens via MainNavigation

### 2. Home Highlights Carousel

- Full-width PageView (no viewportFraction)
- Scale animation on scroll (Transform.scale)
- Page indicators
- Cards have semi-transparent background (0xCC dark / 0.8 light)

### 3. Onboarding Flow

- **Intro**: 4 swipeable pages (Welcome → SquadMode → ComfortSafety → VoiceMatters)
- **Option**: Anonymous vs authenticated choice
- **Setup**: 3 steps (Nickname required for anonymous, Location/Complete for all)
- Nickname generator for random anonymous names

### 4. Squad Mode

- Real-time location sharing with friends
- PIN-based join system
- Auto-disappear at 6 AM for privacy
- Pulse animation on current user avatar

### 5. Auth

- Anonymous mode with device-linked profile
- Supabase authentication for account creation
- Profile sync across devices
- Delete account functionality

## UI Components

- **ShadCN UI** for consistent design system
- Bottom sheet modals for club details
- Map markers with status colors (open/event/closed)
- Vibe check dialogs
- Settings with account/preferences/help sections

## Localization

Supported locales: `nl`, `en`, `fr`

- ARB files in `lib/l10n/`
- AppLocalizations for string access

## Dependencies (Key)

- `flutter_riverpod` - State management
- `shadcn_ui` - UI components
- `flutter_map` + `latlong2` - Maps
- `supabase_flutter` - Backend
- `geolocator` - Location services

## Environment

- Supabase URL: `https://gucwsgnxvawtfrnhnqtw.supabase.co`
- Min SDK: Android 21 / iOS 12

## 6. Vibe Points Gamification System

MVP: Alleen voor **ingelogde gebruikers** (anonieme gebruikers kunnen geen VP verdienen).

### Database (Supabase)

Nieuwe tabellen in `supabase/schema.sql`:
- `vibe_profiles` - VP, level, streak per user
- `vibe_actions` - Audit trail voor VP verdienen

### Models (`lib/core/models/`)

| File | Purpose |
|------|---------|
| `vibe_profile.dart` | VP model (userId, totalVp, currentLevel, weekendStreak, visitedPlaces) |
| `vibe_action.dart` | Action types enum (checkIn, vibeUpdate, squadInvite, earlyBird, explorer) |

### Services (`lib/core/services/`)

| File | Purpose |
|------|---------|
| `vibe_points_service.dart` | VP berekeningen, level thresholds, streak logic, early bird check |

### Repositories (`lib/core/repositories/`)

| File | Purpose |
|------|---------|
| `vibe_repository.dart` | Supabase database operaties (addVp, updateStreak, getLeaderboard, getRank) |

### Providers (`lib/core/providers/`)

| File | Purpose |
|------|---------|
| `vibe_provider.dart` | Riverpod state voor VP (vibeProvider, vpDisplayProvider, VibeDisplayData) |

### UI Widgets (`lib/core/widgets/`)

| File | Purpose |
|------|---------|
| `vp_display.dart` | Toont VP balans + streak + rank |
| `level_indicator.dart` | Level badge met progress bar + StreakIndicator widget |

### VP Verdien Mechaniek (MVP)

| Action | VP | Voorwaarde |
|--------|-----|-------------|
| Check-in | +10 | Altijd (via ClubBottomSheet) |
| Vibe Update | +20 | Bij vibe check bevestigen (via VibeCheckDialog) |
| Early Bird | +30 | Bonus: Check-in vóór 23:30 |
| Explorer | +40 | Bonus: Eerste keer op nieuwe locatie |

### Level Systeem

| Level | VP Range | Naam | Badge |
|-------|----------|------|-------|
| 1 | 0-99 | Newbie | Grijs |
| 2 | 100-499 | Club Hopper | Blauw |
| 3 | 500-1499 | Vibe Master | Paars |
| 4 | 1500+ | Legend | Goud (gloed effect) |

### Integratie

- `ClubBottomSheet` - Check-in knop (+10 VP) alleen zichtbaar voor ingelogde gebruikers
- `VibeCheckDialog` - Vibe update knop (+20 VP) met VP beloning
- `auth_provider.dart` - Auto-create vibe_profile bij eerste login

### Weekend Streak

- Streak teller in vibe_profiles
- Streak multiplier: 1.2x VP na 3+ weekends
- Visual indicator: Vlam icoon (StreakIndicator widget)

### Supabase Tabellen (in schema.sql)

```sql
-- vibe_profiles
CREATE TABLE vibe_profiles (
    id UUID PRIMARY KEY,
    user_id UUID REFERENCES auth.users(id),
    total_vp INTEGER DEFAULT 0,
    current_level INTEGER DEFAULT 1,
    weekend_streak INTEGER DEFAULT 0,
    last_check_in TIMESTAMPTZ,
    visited_places UUID[],
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- vibe_actions (audit trail)
CREATE TABLE vibe_actions (
    id UUID PRIMARY KEY,
    user_id UUID REFERENCES auth.users(id),
    action_type TEXT NOT NULL,
    place_id UUID REFERENCES places(id),
    vp_earned INTEGER NOT NULL,
    created_at TIMESTAMPTZ DEFAULT NOW()
);
```
