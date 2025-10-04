import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';
import 'app_localizations_fa.dart';
import 'app_localizations_ru.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
    Locale('fa'),
    Locale('ru'),
    Locale('zh')
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'DIAG'**
  String get appTitle;

  /// No description provided for @navDashboard.
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get navDashboard;

  /// No description provided for @navTelemetry.
  ///
  /// In en, this message translates to:
  /// **'Telemetry'**
  String get navTelemetry;

  /// No description provided for @navLogs.
  ///
  /// In en, this message translates to:
  /// **'Logs'**
  String get navLogs;

  /// No description provided for @configHeading.
  ///
  /// In en, this message translates to:
  /// **'Connection & Session'**
  String get configHeading;

  /// No description provided for @configBaseUrlLabel.
  ///
  /// In en, this message translates to:
  /// **'Backend base URL'**
  String get configBaseUrlLabel;

  /// No description provided for @configBaseUrlApply.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get configBaseUrlApply;

  /// No description provided for @configBaseUrlApplied.
  ///
  /// In en, this message translates to:
  /// **'Backend URL updated'**
  String get configBaseUrlApplied;

  /// No description provided for @configVinLabel.
  ///
  /// In en, this message translates to:
  /// **'Vehicle VIN'**
  String get configVinLabel;

  /// No description provided for @configPortLabel.
  ///
  /// In en, this message translates to:
  /// **'Port'**
  String get configPortLabel;

  /// No description provided for @configAdapterLabel.
  ///
  /// In en, this message translates to:
  /// **'Adapter ID'**
  String get configAdapterLabel;

  /// No description provided for @configRateLabel.
  ///
  /// In en, this message translates to:
  /// **'Target rate (Hz)'**
  String get configRateLabel;

  /// No description provided for @configPidsLabel.
  ///
  /// In en, this message translates to:
  /// **'Monitored PIDs'**
  String get configPidsLabel;

  /// No description provided for @configPidsHint.
  ///
  /// In en, this message translates to:
  /// **'Comma-separated, e.g. 010C,0105,0110'**
  String get configPidsHint;

  /// No description provided for @configLogRootLabel.
  ///
  /// In en, this message translates to:
  /// **'Log directory'**
  String get configLogRootLabel;

  /// No description provided for @configSeedLabel.
  ///
  /// In en, this message translates to:
  /// **'Telemetry seed (optional)'**
  String get configSeedLabel;

  /// No description provided for @configStartButton.
  ///
  /// In en, this message translates to:
  /// **'Start session'**
  String get configStartButton;

  /// No description provided for @dashboardHeading.
  ///
  /// In en, this message translates to:
  /// **'Diagnostic Control'**
  String get dashboardHeading;

  /// No description provided for @dashboardLoadingError.
  ///
  /// In en, this message translates to:
  /// **'Failed to load session status'**
  String get dashboardLoadingError;

  /// No description provided for @dashboardNoSessionTitle.
  ///
  /// In en, this message translates to:
  /// **'No session running'**
  String get dashboardNoSessionTitle;

  /// No description provided for @dashboardNoSessionDescription.
  ///
  /// In en, this message translates to:
  /// **'Adjust the session parameters above and press Start to begin streaming telemetry.'**
  String get dashboardNoSessionDescription;

  /// No description provided for @dashboardSessionActive.
  ///
  /// In en, this message translates to:
  /// **'Session active'**
  String get dashboardSessionActive;

  /// No description provided for @dashboardStartSuccess.
  ///
  /// In en, this message translates to:
  /// **'Diagnostic session started'**
  String get dashboardStartSuccess;

  /// No description provided for @dashboardStopSuccess.
  ///
  /// In en, this message translates to:
  /// **'Diagnostic session stopped'**
  String get dashboardStopSuccess;

  /// No description provided for @dashboardRequestFailed.
  ///
  /// In en, this message translates to:
  /// **'Request failed. Check the backend URL and try again.'**
  String get dashboardRequestFailed;

  /// No description provided for @dashboardInvalidRate.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid target rate.'**
  String get dashboardInvalidRate;

  /// No description provided for @dashboardInvalidPids.
  ///
  /// In en, this message translates to:
  /// **'Provide at least one PID (comma separated).'**
  String get dashboardInvalidPids;

  /// No description provided for @infoSessionId.
  ///
  /// In en, this message translates to:
  /// **'Session ID'**
  String get infoSessionId;

  /// No description provided for @infoVin.
  ///
  /// In en, this message translates to:
  /// **'VIN'**
  String get infoVin;

  /// No description provided for @infoAdapter.
  ///
  /// In en, this message translates to:
  /// **'Adapter'**
  String get infoAdapter;

  /// No description provided for @infoTargetRate.
  ///
  /// In en, this message translates to:
  /// **'Target rate'**
  String get infoTargetRate;

  /// No description provided for @infoActualRate.
  ///
  /// In en, this message translates to:
  /// **'Actual rate'**
  String get infoActualRate;

  /// No description provided for @infoStarted.
  ///
  /// In en, this message translates to:
  /// **'Started'**
  String get infoStarted;

  /// No description provided for @infoMonitoredPids.
  ///
  /// In en, this message translates to:
  /// **'Monitored PIDs'**
  String get infoMonitoredPids;

  /// No description provided for @dashboardStopSession.
  ///
  /// In en, this message translates to:
  /// **'Stop session'**
  String get dashboardStopSession;

  /// No description provided for @dashboardRecentActivity.
  ///
  /// In en, this message translates to:
  /// **'Recent Activity'**
  String get dashboardRecentActivity;

  /// No description provided for @dashboardActivityCardTitle.
  ///
  /// In en, this message translates to:
  /// **'Activity'**
  String get dashboardActivityCardTitle;

  /// No description provided for @dashboardActivityPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Telemetry charts, DTC highlights, and session logs will appear here once a session is running.'**
  String get dashboardActivityPlaceholder;

  /// No description provided for @dashboardActivityTelemetryTitle.
  ///
  /// In en, this message translates to:
  /// **'Live telemetry streaming'**
  String get dashboardActivityTelemetryTitle;

  /// No description provided for @dashboardActivityTelemetrySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Navigate to the Telemetry tab to view charts.'**
  String get dashboardActivityTelemetrySubtitle;

  /// No description provided for @dashboardActivityLogsTitle.
  ///
  /// In en, this message translates to:
  /// **'Log pipeline active'**
  String get dashboardActivityLogsTitle;

  /// No description provided for @dashboardActivityLogsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Parquet writer is flushing data in the background.'**
  String get dashboardActivityLogsSubtitle;

  /// No description provided for @telemetryHeading.
  ///
  /// In en, this message translates to:
  /// **'Live Telemetry'**
  String get telemetryHeading;

  /// No description provided for @telemetryDescription.
  ///
  /// In en, this message translates to:
  /// **'Connect this client to the FastAPI websocket endpoint (/ws/telemetry) to stream these widgets.'**
  String get telemetryDescription;

  /// No description provided for @telemetryCardHint.
  ///
  /// In en, this message translates to:
  /// **'Data binding is live. Values below reflect the latest samples from the vehicle.'**
  String get telemetryCardHint;

  /// No description provided for @telemetryAwaitingData.
  ///
  /// In en, this message translates to:
  /// **'Waiting for telemetry...'**
  String get telemetryAwaitingData;

  /// No description provided for @telemetryNoSession.
  ///
  /// In en, this message translates to:
  /// **'Start a diagnostic session to stream telemetry.'**
  String get telemetryNoSession;

  /// No description provided for @telemetryStreamError.
  ///
  /// In en, this message translates to:
  /// **'Telemetry stream error: {error}'**
  String telemetryStreamError(Object error);

  /// No description provided for @telemetryCardRpm.
  ///
  /// In en, this message translates to:
  /// **'Engine RPM'**
  String get telemetryCardRpm;

  /// No description provided for @telemetryCardThrottle.
  ///
  /// In en, this message translates to:
  /// **'Throttle Position'**
  String get telemetryCardThrottle;

  /// No description provided for @telemetryCardCoolant.
  ///
  /// In en, this message translates to:
  /// **'Coolant Temperature'**
  String get telemetryCardCoolant;

  /// No description provided for @logsHeading.
  ///
  /// In en, this message translates to:
  /// **'Session Logs'**
  String get logsHeading;

  /// No description provided for @logsDescription.
  ///
  /// In en, this message translates to:
  /// **'Once the log API is exposed, the file list will populate below. Use this view to download, filter, and replay Parquet datasets.'**
  String get logsDescription;

  /// No description provided for @logsEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No logs to display yet'**
  String get logsEmptyTitle;

  /// No description provided for @logsEmptySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Implement the /v1/logs endpoint to fetch session history.'**
  String get logsEmptySubtitle;

  /// No description provided for @retryButton.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retryButton;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['ar', 'en', 'fa', 'ru', 'zh'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar': return AppLocalizationsAr();
    case 'en': return AppLocalizationsEn();
    case 'fa': return AppLocalizationsFa();
    case 'ru': return AppLocalizationsRu();
    case 'zh': return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
