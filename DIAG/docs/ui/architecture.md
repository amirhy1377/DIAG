# Cross-Platform UI Options

This document outlines viable front-end strategies for delivering DIAG on Android, iOS, Windows, macOS, and Linux. All approaches reuse the existing FastAPI back-end and share a telemetry SDK defined in `/DIAG/app`.

## 1. Flutter (Primary Recommendation)
- **Coverage:** Android, iOS, Windows, macOS, Linux, and web (beta).
- **Language:** Dart.
- **Why:** Single UI toolkit with first-class desktop + mobile support, built-in rendering, strong charting ecosystem, hot-reload for fast iteration.
- **Integration:** Implement an SDK layer in `lib/services/diag_api.dart` that mirrors FastAPI schemas (`StartSessionRequest`, `SessionStatusResponse`, etc.). Use `json_serializable` for model generation and `riverpod` for state management.
- **Platform specifics:**
  - Android/iOS: Leverage `flutter_blue_plus` for BLE adapter discovery. Use `permission_handler` for runtime permissions.
  - Desktop: Use `serial_port_win32`, `usb_serial` (Linux), and `libserialport` wrappers for adapter communication.
- **Packaging:** `flutter build apk`, `flutter build ipa`, `flutter build windows`, `flutter build macos`, `flutter build linux`. Automate via GitHub Actions and Codemagic.
- **Proposed structure:**
  ```text
  ui/flutter/
    lib/
      main.dart
      services/diag_api.dart
      state/session_controller.dart
      widgets/
    assets/
    pubspec.yaml
  ```
- **MVP Screens:**
  1. Session Dashboard (start/stop, VIN, adapter info)
  2. Live Telemetry (charts + table)
  3. Log Browser (Parquet file list with download)
  4. Settings (adapter selection, rate tuning)

## 2. React Native + Tauri (Alternative Hybrid)
- **Mobile:** React Native for Android/iOS using TypeScript, `react-query`, and `redux-toolkit`.
- **Desktop:** Tauri application reusing the React codebase, delivering Windows/MSI, macOS/DMG, Linux/AppImage.
- **Pros:** Web technologies + smaller desktop footprint compared to Electron.
- **Cons:** Two build systems (Metro + Rust); hardware adapter access requires native modules (`react-native-ble-plx`, custom USB bindings).
- **When to pick:** Team already comfortable with React/TS and willing to maintain shared component library.

## 3. .NET MAUI (Native Stack)
- **Coverage:** Android, iOS, Windows, macOS (Catalyst); community Linux support via Gtk.
- **Language:** C#.
- **Pros:** Tight integration with Windows ecosystem, strong MVVM tooling, good for teams invested in .NET.
- **Cons:** Linux support unofficial; UI styling less flexible across platforms compared to Flutter.
- **Usage:** Create `DiagApp` solution, consume REST via `HttpClient`, use `CommunityToolkit.Maui` for MVVM helpers.

## Shared Components (Regardless of UI Stack)
- **API Contract:** Define OpenAPI spec (`/docs` already served by FastAPI). Generate clients (`openapi-generator` for Dart/TS/C#) to keep parity with backend.
- **Telemetry SDK:** Move common DTOs to `DIAG/app/schemas` and expose via REST & websocket for live streaming.
- **Auth & Config:** Implement config endpoint returning feature flags, poll intervals, branding (color palette, logos) to keep clients consistent.

## Immediate Action Items
1. Decide on the primary framework (recommend Flutter) and install toolchain.
2. Scaffold project (e.g. `flutter create diag_ui`) inside `ui/flutter`.
3. Define API client interfaces and shared JSON schemas.
4. Build Session Dashboard screen with mocked data; hook to FastAPI once stable.
5. Add CI jobs to build/test chosen client(s).

## Longer-Term Enhancements
- Offline cache of diagnostic sessions for replay.
- Real-time collaboration (share telemetry stream).
- Localization infrastructure (ARB files for Flutter, i18next for React, Resx for MAUI).
- Theming system to switch between light/dark and OEM branding.
\n## Current Status\n- [x] Flutter project scaffolded at \ui/flutter\ with Riverpod, GoRouter, and Dio preconfigured.\n- [ ] Backend API wiring (REST + websocket)\n- [ ] Production theming and design polish\n
