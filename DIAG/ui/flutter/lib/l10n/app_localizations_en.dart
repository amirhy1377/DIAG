import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'DIAG';

  @override
  String get navDashboard => 'Dashboard';

  @override
  String get navTelemetry => 'Telemetry';

  @override
  String get navLogs => 'Logs';

  @override
  String get dashboardHeading => 'Diagnostic Control';

  @override
  String get dashboardLoadingError => 'Failed to load session status';

  @override
  String get dashboardNoSessionTitle => 'No session running';

  @override
  String get dashboardNoSessionDescription => 'Launch a diagnostic session to begin streaming telemetry. Update the request parameters before production use.';

  @override
  String get dashboardStartDemoButton => 'Start demo session';

  @override
  String get dashboardSessionActive => 'Session active';

  @override
  String get infoSessionId => 'Session ID';

  @override
  String get infoVin => 'VIN';

  @override
  String get infoAdapter => 'Adapter';

  @override
  String get infoTargetRate => 'Target rate';

  @override
  String get infoActualRate => 'Actual rate';

  @override
  String get infoStarted => 'Started';

  @override
  String get infoMonitoredPids => 'Monitored PIDs';

  @override
  String get dashboardStopSession => 'Stop session';

  @override
  String get dashboardRecentActivity => 'Recent Activity';

  @override
  String get dashboardActivityCardTitle => 'Activity';

  @override
  String get dashboardActivityPlaceholder => 'Telemetry charts, DTC highlights, and session logs will appear here once a session is running.';

  @override
  String get dashboardActivityTelemetryTitle => 'Live telemetry streaming';

  @override
  String get dashboardActivityTelemetrySubtitle => 'Navigate to the Telemetry tab to view charts.';

  @override
  String get dashboardActivityLogsTitle => 'Log pipeline active';

  @override
  String get dashboardActivityLogsSubtitle => 'Parquet writer is flushing data in the background.';

  @override
  String get telemetryHeading => 'Live Telemetry';

  @override
  String get telemetryDescription => 'Connect this client to the FastAPI websocket endpoint (/ws/telemetry) to stream these widgets.';

  @override
  String get telemetryCardRpm => 'Engine RPM';

  @override
  String get telemetryCardThrottle => 'Throttle Position';

  @override
  String get telemetryCardCoolant => 'Coolant Temperature';

  @override
  String get telemetryCardHint => 'Data binding hooks are ready: feed values into the chart painter to visualise live signals.';

  @override
  String get logsHeading => 'Session Logs';

  @override
  String get logsDescription => 'Once the log API is exposed, the file list will populate below. Use this view to download, filter, and replay Parquet datasets.';

  @override
  String get logsEmptyTitle => 'No logs to display yet';

  @override
  String get logsEmptySubtitle => 'Implement the /v1/logs endpoint to fetch session history.';

  @override
  String get retryButton => 'Retry';
}
