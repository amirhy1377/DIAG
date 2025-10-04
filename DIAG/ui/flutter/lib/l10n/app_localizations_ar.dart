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
  String get configHeading => 'الاتصال والجلسة';

  @override
  String get configBaseUrlLabel => 'عنوان الخادم الأساسي';

  @override
  String get configBaseUrlApply => 'حفظ';

  @override
  String get configBaseUrlApplied => 'تم تحديث عنوان الخادم';

  @override
  String get configVinLabel => 'رقم الهيكل (VIN)';

  @override
  String get configPortLabel => 'المنفذ';

  @override
  String get configAdapterLabel => 'معرف المحوّل';

  @override
  String get configRateLabel => 'المعدل المستهدف (هرتز)';

  @override
  String get configPidsLabel => 'معرّفات PID المراقبة';

  @override
  String get configPidsHint => 'افصل القيم بفاصلة، مثال: 010C,0105,0110';

  @override
  String get configLogRootLabel => 'مسار السجلات';

  @override
  String get configSeedLabel => 'بذرة القياسات (اختياري)';

  @override
  String get configStartButton => 'بدء الجلسة';

  @override
  String get dashboardHeading => 'التحكم التشخيصي';

  @override
  String get dashboardLoadingError => 'فشل تحميل حالة الجلسة';

  @override
  String get dashboardNoSessionTitle => 'لا توجد جلسة قيد التشغيل';

  @override
  String get dashboardNoSessionDescription => 'اضبط معلمات الجلسة أعلاه واضغط بدء لبدء بث القياسات.';

  @override
  String get dashboardSessionActive => 'جلسة نشطة';

  @override
  String get dashboardStartSuccess => 'تم بدء جلسة التشخيص';

  @override
  String get dashboardStopSuccess => 'تم إيقاف جلسة التشخيص';

  @override
  String get dashboardRequestFailed => 'فشل الطلب. تحقق من عنوان الخادم ثم أعد المحاولة.';

  @override
  String get dashboardInvalidRate => 'أدخل معدل هدف صالحاً.';

  @override
  String get dashboardInvalidPids => 'أدخل PID واحداً على الأقل (مفصولاً بفواصل).';

  @override
  String get infoSessionId => 'معرّف الجلسة';

  @override
  String get infoVin => 'VIN';

  @override
  String get infoAdapter => 'المحوّل';

  @override
  String get infoTargetRate => 'المعدل المستهدف';

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
  String get dashboardActivityPlaceholder => 'ستظهر مخططات القياسات وإشعارات DTC والسجلات هنا عند تشغيل الجلسة.';

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
  String get telemetryCardHint => 'الربط بالبيانات فعّال. القيم أدناه تعكس أحدث العينات من المركبة.';

  @override
  String get telemetryAwaitingData => 'جارٍ انتظار بيانات القياسات...';

  @override
  String get telemetryNoSession => 'ابدأ جلسة تشخيص لبث القياسات.';

  @override
  String telemetryStreamError(Object error) {
    return 'خطأ في تدفق القياسات: $error';
  }

  @override
  String get telemetryCardRpm => 'دورات المحرك';

  @override
  String get telemetryCardThrottle => 'موضع دواسة الوقود';

  @override
  String get telemetryCardCoolant => 'درجة حرارة سائل التبريد';

  @override
  String get logsHeading => 'سجلات الجلسة';

  @override
  String get logsDescription => 'عند إتاحة واجهة السجلات ستظهر قائمة الملفات هنا. استخدم هذا العرض لتنزيل مجموعات Parquet وتصفيةها وإعادتها.';

  @override
  String get logsEmptyTitle => 'لا توجد سجلات للعرض بعد';

  @override
  String get logsEmptySubtitle => 'نفّذ نقطة النهاية /v1/logs لاسترداد تاريخ الجلسات.';

  @override
  String get retryButton => 'إعادة المحاولة';
}
