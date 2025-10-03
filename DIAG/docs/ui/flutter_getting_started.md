# Flutter Client – Getting Started

The Flutter UI lives in `ui/flutter` and targets Android, iOS, Windows, macOS, Linux, and web from a single codebase.

## Prerequisites
- Flutter SDK 3.24.x (`C:\src\flutter`) is already installed on this workstation.
- Android/iOS/desktop tooling as required by each platform (Xcode for iOS builds, Visual Studio workloads for Windows, etc.).
- Backend API reachable at `http://localhost:8000` by default. Override by updating `baseUrlProvider` or providing a runtime configuration service.

## Useful Commands
```bash
# change into the project directory
dart pub global deactivate flutter_plugin_tools # optional example
cd ui/flutter

# fetch packages (mirrors already configured)
flutter pub get

# run the app on a connected device or desktop host
flutter run -d windows       # Windows desktop
flutter run -d linux         # Linux (from Linux host)
flutter run -d macos         # macOS (from macOS host)
flutter run -d chrome        # Web
flutter run -d emulator-5554 # Android (replace with your device ID)

# analyze and test
flutter analyze
flutter test

# build artifacts
flutter build windows
flutter build apk --split-per-abi
flutter build macos
flutter build linux
flutter build web
```

## Project Layout
- `lib/app.dart` – top-level router and theming.
- `lib/core/theme` – Material 3 light/dark themes.
- `lib/state/session_controller.dart` – Riverpod providers for session lifecycle.
- `lib/services/` – HTTP and websocket clients + data models mirroring FastAPI schemas.
- `lib/features/` – feature-oriented UI (dashboard, telemetry, logs, shared scaffolding).

## Next Steps
1. Wire `DiagApiClient` to the live FastAPI instance and flesh out the telemetry stream provider.
2. Replace the dashboard demo request with a form-driven workflow.
3. Integrate charts (e.g., `syncfusion_flutter_charts`) for real-time telemetry.
4. Hook log browser to the Parquet listing endpoint once exposed.
