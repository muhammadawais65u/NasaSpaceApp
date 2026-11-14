# Junior Astronaut Mission Trainer - Flutter app

Flutter front end for the game. It talks only to the FastAPI backend in `../backend`
(which holds the game rules and the NASA data) and to Supabase Auth for sign-in.

Checked with Flutter 3.47.9: `flutter analyze` is clean, `flutter test` passes and the web
build was played in Chrome against the real backend.

## First-time setup

Flutter is installed at `C:/src/flutter` (add `C:/src/flutter/bin` to PATH). The `web/` and
`android/` folders are already generated.

```bash
cd frontend
flutter pub get
flutter test
```

## Run

1. Start the backend (from `backend/`):
   `.venv\Scripts\python -m uvicorn app.main:app --host 0.0.0.0 --port 8000`
2. Web (the port matters, the backend allows `http://localhost:3000`):
   `flutter run -d chrome --web-port 3000`
3. Android phone on the same Wi-Fi (use your PC's IP address):
   `flutter run --dart-define=API_BASE=http://192.168.x.x:8000`

For Android, plain `http://` needs two lines in `android/app/src/main/AndroidManifest.xml`:
`<uses-permission android:name="android.permission.INTERNET"/>` above `<application`, and
`android:usesCleartextTraffic="true"` inside the `<application ...>` tag.
The Android emulator reaches the PC at `http://10.0.2.2:8000`.

## Sign-in

Flow: main menu -> Start Mission -> type a first name -> Select Your Astronaut.
There is no email or password. The app asks Supabase for an anonymous session; if
anonymous sign-ins are off in Supabase (they are right now) it asks the backend instead
(`POST /api/v1/auth/guest`), which creates a throwaway account with a random address.
The name is kept only on the device.

## Settings you can change

`lib/config.dart`, or at build time with `--dart-define`:
`API_BASE`, `SUPABASE_URL`, `SUPABASE_ANON_KEY` (public key only, never the service key).

## Structure

```
lib/
  main.dart                  app start, picks the first screen
  config.dart                backend and Supabase addresses
  models.dart                data shapes from the backend
  services/
    auth_service.dart        guest session, kept on the device and refreshed
    api_client.dart          every backend call
    game_controller.dart     app state shared by all screens
  widgets/ui.dart            background, panels, buttons, resource chips/bars, 3D tilt
  screens/
    home_screen.dart         main menu, How to Play, Select Astronaut, Mission Briefing
    hub_screen.dart          Choose Your Mission: resources, NASA alert, 3D carousel
    mission_screen.dart      mission briefing, choices, result, Game Over / Congratulations
    learning_screen.dart     facts, live NASA DONKI space weather, NASA OSDR studies
    settings_screen.dart     astronaut, player, data sources
    name_screen.dart         "What is your name?" - the only sign-in step
assets/images/               pictures cut from the design mock-ups
```

## What is and is not "3D"

The mission carousel and the picture cards use real perspective transforms (they turn and
tilt in 3D as you swipe or move the pointer). The game screen (lib/screens/game_screen.dart) is a drawn 3D-style Moon walk with a
joystick. The objectives of the day's mission come one at a time: a glowing pad shows where
to build the next one and every finished building stays. After the last objective the final
decision is built at the colony core, the resources change by its cost and the next mission
starts.
The other characters and scenes are 2D pictures cut from the mock-ups.

## Not built from the mock-ups

Music/sound toggles, graphics quality and language settings.
