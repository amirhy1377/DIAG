import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appTitle => 'DIAG';

  @override
  String get navDashboard => 'لوحة التحكم';

  @override
  String get navTelemetry => 'القياسات';

  @override
  String get navLogs => 'السجلات';

  @override
  String get dashboardHeading => 'التحكم التشخيصي';

  @override
  String get dashboardLoadingError => 'فشل تحميل حالة الجلسة';

  @override
  String get dashboardNoSessionTitle => 'لا توجد جلسة قيد التشغيل';

  @override
  String get dashboardNoSessionDescription => 'ابدأ جلسة تشخيص لبدء بث القياسات. حدّث معلمات الطلب قبل الاستخدام في بيئة الإنتاج.';

  @override
  String get dashboardStartDemoButton => 'بدء جلسة تجريبية';

  @override
  String get dashboardSessionActive => 'جلسة نشطة';

  @override
  String get infoSessionId => 'معرّف الجلسة';

  @override
  String get infoVin => 'VIN';

  @override
  String get infoAdapter => 'المحول';

  @override
  String get infoTargetRate => 'معدل الهدف';

  @override
  String get infoActualRate => 'المعدل الفعلي';

  @override
  String get infoStarted => 'وقت البدء';

  @override
  String get infoMonitoredPids => 'PID المراقبة';

  @override
  String get dashboardStopSession => 'إيقاف الجلسة';

  @override
  String get dashboardRecentActivity => 'النشاط الأخير';

  @override
  String get dashboardActivityCardTitle => 'النشاط';

  @override
  String get dashboardActivityPlaceholder => 'ستظهر مخططات القياسات، وإشعارات DTC، وسجلات الجلسة هنا عند تشغيل جلسة.';

  @override
  String get dashboardActivityTelemetryTitle => 'بث القياسات الحية';

  @override
  String get dashboardActivityTelemetrySubtitle => 'انتقل إلى علامة تبويب القياسات لعرض المخططات.';

  @override
  String get dashboardActivityLogsTitle => 'خط معالجة السجلات نشط';

  @override
  String get dashboardActivityLogsSubtitle => 'كاتب Parquet يقوم بالتفريغ في الخلفية.';

  @override
  String get telemetryHeading => 'القياسات الحية';

  @override
  String get telemetryDescription => 'صِل هذا العميل بنقطة الويب سوكت FastAPI (/ws/telemetry) لبث هذه الودجات.';

  @override
  String get telemetryCardRpm => 'دورات المحرك';

  @override
  String get telemetryCardThrottle => 'موضع دواسة الوقود';

  @override
  String get telemetryCardCoolant => 'درجة حرارة سائل التبريد';

  @override
  String get telemetryCardHint => 'خطافات ربط البيانات جاهزة؛ مرّر القيم إلى رسام المخطط لعرض الإشارات الحية.';

  @override
  String get logsHeading => 'سجلات الجلسة';

  @override
  String get logsDescription => 'عند إتاحة واجهة السجلات ستظهر قائمة الملفات هنا. استخدم هذا العرض لتنزيل مجموعات Parquet وتصفيةها وإعادتها.';

  @override
  String get logsEmptyTitle => 'لا توجد سجلات للعرض بعد';

  @override
  String get logsEmptySubtitle => 'نفّذ نقطة النهاية /v1/logs لاسترداد سجل الجلسات.';

  @override
  String get retryButton => 'إعادة المحاولة';
}
