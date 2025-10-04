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
  String get configHeading => 'Connection & Session';

  @override
  String get configBaseUrlLabel => 'Backend base URL';

  @override
  String get configBaseUrlApply => 'Save';

  @override
  String get configBaseUrlApplied => 'Backend URL updated';

  @override
  String get configVinLabel => 'Vehicle VIN';

  @override
  String get configPortLabel => 'Port';

  @override
  String get configAdapterLabel => 'Adapter ID';

  @override
  String get configRateLabel => 'Target rate (Hz)';

  @override
  String get configPidsLabel => 'Monitored PIDs';

  @override
  String get configPidsHint => 'Comma-separated, e.g. 010C,0105,0110';

  @override
  String get configLogRootLabel => 'Log directory';

  @override
  String get configSeedLabel => 'Telemetry seed (optional)';

  @override
  String get configStartButton => 'Start session';

  @override
  String get dashboardHeading => 'Diagnostic Control';

  @override
  String get dashboardLoadingError => 'Failed to load session status';

  @override
  String get dashboardNoSessionTitle => 'No session running';

  @override
  String get dashboardNoSessionDescription => 'Adjust the session parameters above and press Start to begin streaming telemetry.';

  @override
  String get dashboardSessionActive => 'Session active';

  @override
  String get dashboardStartSuccess => 'Diagnostic session started';

  @override
  String get dashboardStopSuccess => 'Diagnostic session stopped';

  @override
  String get dashboardRequestFailed => 'Request failed. Check the backend URL and try again.';

  @override
  String get dashboardInvalidRate => 'Enter a valid target rate.';

  @override
  String get dashboardInvalidPids => 'Provide at least one PID (comma separated).';

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
  String get telemetryCardHint => 'Data binding is live. Values below reflect the latest samples from the vehicle.';

  @override
  String get telemetryAwaitingData => 'Waiting for telemetry...';

  @override
  String get telemetryNoSession => 'Start a diagnostic session to stream telemetry.';

  @override
  String telemetryStreamError(Object error) {
    return 'Telemetry stream error: $error';
  }

  @override
  String get telemetryCardRpm => 'Engine RPM';

  @override
  String get telemetryCardThrottle => 'Throttle Position';

  @override
  String get telemetryCardCoolant => 'Coolant Temperature';

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
