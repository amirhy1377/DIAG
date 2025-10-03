# UI Implementation Plan

## Milestone 0 – Tooling Bring-Up (1-2 days)
- Install chosen framework SDK (Flutter/Dart, React Native CLI + Node, or .NET workloads).
- Verify platform builds via sample Hello World artifacts for Android, iOS, Windows, Linux, macOS.
- Set up CI pipeline skeleton (`.github/workflows/ui-build.yml`).

## Milestone 1 – Core Infrastructure (3-5 days)
- Create `ui/flutter` project (or equivalent) following the architecture in `architecture.md`.
- Add shared package for API client:
  - Generate models from FastAPI OpenAPI spec (`scripts/generate_ui_client.sh`).
  - Implement websocket client for telemetry stream.
- Establish global state management (Riverpod/Bloc for Flutter, Redux/RTK Query for React, MVVM for MAUI).

## Milestone 2 – Session Management (5-7 days)
- Build Session Dashboard screen with start/stop controls, adapter selection, and status banner.
- Implement optimistic updates when starting sessions; handle 409 conflict errors from backend.
- Add authentication placeholder if future auth is planned.

## Milestone 3 – Telemetry Visualisation (7-10 days)
- Real-time charts (line chart for RPM, temperature) and tabular PID list.
- Buffer management: keep last N datapoints per PID, throttle UI updates to 10 Hz.
- Provide export/share button to trigger log download.

## Milestone 4 – Logs and History (5 days)
- Log browser that lists Parquet datasets from `/logs` endpoint.
- Allow filtering by VIN/session/date; provide download/share.
- Implement offline caching and re-run playback view (optional stretch).

## Milestone 5 – Platform Polishing (variable)
- Mobile: implement dark mode, notch-safe layouts, background permissions.
- Desktop: responsive layouts with minimum widths, keyboard shortcuts, HiDPI.
- Package signing: Android keystore, iOS provisioning profile, Windows/Mac notarisation.

## Optional Parallel Tracks
- **Design System:** Build component library using Figma tokens; export to Flutter `ThemeData`.
- **Accessibility:** color contrast validation, screen reader support.
- **Telemetry Simulation:** integrate existing Python simulator via gRPC/Websocket for on-device demos.

## Deliverables per Milestone
1. CI builds per platform.
2. Documentation updates (`docs/ui/changelog.md`).
3. Demos (screen recordings) stored in `/docs/ui/demos`.

## Resource Recommendations
- Flutter packages: `dio`, `riverpod`, `flutter_riverpod`, `syncfusion_flutter_charts`, `go_router`.
- React Native packages: `expo`, `react-navigation`, `victory-native`, `react-native-ble-plx`.
- .NET MAUI packages: `CommunityToolkit.Maui`, `LiveCharts2`, `Refit` for REST.

## Risk Mitigation
- Validate hardware adapter access early on each platform.
- Keep UI and business logic decoupled to allow swapping frameworks if needed.
- Continue running `pre-commit` on generated Dart/TS/C# via dedicated hook sets.
