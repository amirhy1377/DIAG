import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Persian (`fa`).
class AppLocalizationsFa extends AppLocalizations {
  AppLocalizationsFa([String locale = 'fa']) : super(locale);

  @override
  String get appTitle => 'DIAG';

  @override
  String get navDashboard => 'داشبورد';

  @override
  String get navTelemetry => 'تله‌متری';

  @override
  String get navLogs => 'گزارش‌ها';

  @override
  String get configHeading => 'اتصال و نشست';

  @override
  String get configBaseUrlLabel => 'نشانی پایهٔ بک‌اند';

  @override
  String get configBaseUrlApply => 'ذخیره';

  @override
  String get configBaseUrlApplied => 'نشانی بک‌اند به‌روزرسانی شد';

  @override
  String get configVinLabel => 'VIN خودرو';

  @override
  String get configPortLabel => 'پورت';

  @override
  String get configAdapterLabel => 'شناسه مبدل';

  @override
  String get configRateLabel => 'نرخ هدف (هرتز)';

  @override
  String get configPidsLabel => 'PIDهای پایش‌شده';

  @override
  String get configPidsHint => 'با کاما جدا کنید، مثال: 010C,0105,0110';

  @override
  String get configLogRootLabel => 'مسیر ذخیرهٔ گزارش';

  @override
  String get configSeedLabel => 'بذر تله‌متری (اختیاری)';

  @override
  String get configStartButton => 'شروع نشست';

  @override
  String get dashboardHeading => 'کنترل عیب‌یابی';

  @override
  String get dashboardLoadingError => 'وضعیت نشست بارگیری نشد';

  @override
  String get dashboardNoSessionTitle => 'هیچ نشستی در حال اجرا نیست';

  @override
  String get dashboardNoSessionDescription => 'پارامترهای نشست را در بالا تنظیم کرده و برای آغاز جریان تله‌متری دکمهٔ شروع را فشار دهید.';

  @override
  String get dashboardSessionActive => 'نشست فعال است';

  @override
  String get dashboardStartSuccess => 'نشست عیب‌یابی آغاز شد';

  @override
  String get dashboardStopSuccess => 'نشست عیب‌یابی متوقف شد';

  @override
  String get dashboardRequestFailed => 'درخواست انجام نشد. نشانی بک‌اند را بررسی کرده و دوباره تلاش کنید.';

  @override
  String get dashboardInvalidRate => 'یک نرخ هدف معتبر وارد کنید.';

  @override
  String get dashboardInvalidPids => 'دست‌کم یک PID (با کاما جدا شده) وارد کنید.';

  @override
  String get infoSessionId => 'شناسه نشست';

  @override
  String get infoVin => 'VIN';

  @override
  String get infoAdapter => 'مبدل';

  @override
  String get infoTargetRate => 'نرخ هدف';

  @override
  String get infoActualRate => 'نرخ واقعی';

  @override
  String get infoStarted => 'زمان آغاز';

  @override
  String get infoMonitoredPids => 'PIDهای پایش‌شده';

  @override
  String get dashboardStopSession => 'توقف نشست';

  @override
  String get dashboardRecentActivity => 'فعالیت‌های اخیر';

  @override
  String get dashboardActivityCardTitle => 'فعالیت';

  @override
  String get dashboardActivityPlaceholder => 'با فعال شدن نشست، نمودارهای تله‌متری، رویدادهای DTC و گزارش‌ها در اینجا نمایش داده می‌شوند.';

  @override
  String get dashboardActivityTelemetryTitle => 'جریان تله‌متری زنده';

  @override
  String get dashboardActivityTelemetrySubtitle => 'برای دیدن نمودارها به برگهٔ تله‌متری بروید.';

  @override
  String get dashboardActivityLogsTitle => 'خط لولهٔ گزارش فعال است';

  @override
  String get dashboardActivityLogsSubtitle => 'نویسندهٔ Parquet در پس‌زمینه در حال ذخیره‌سازی داده است.';

  @override
  String get telemetryHeading => 'تله‌متری زنده';

  @override
  String get telemetryDescription => 'این کلاینت را به نقطهٔ پایانی وب‌سوکت FastAPI (/ws/telemetry) متصل کنید تا این ویجت‌ها داده دریافت کنند.';

  @override
  String get telemetryCardHint => 'اتصال داده فعال است. مقادیر زیر آخرین نمونه‌های دریافتی از خودرو هستند.';

  @override
  String get telemetryAwaitingData => 'در انتظار دریافت تله‌متری...';

  @override
  String get telemetryNoSession => 'برای پخش تله‌متری یک نشست عیب‌یابی را آغاز کنید.';

  @override
  String telemetryStreamError(Object error) {
    return 'خطای جریان تله‌متری: $error';
  }

  @override
  String get telemetryCardRpm => 'دور موتور';

  @override
  String get telemetryCardThrottle => 'درصد گاز';

  @override
  String get telemetryCardCoolant => 'دمای مایع خنک‌کننده';

  @override
  String get logsHeading => 'گزارش‌های نشست';

  @override
  String get logsDescription => 'پس از در دسترس بودن API گزارش، فهرست فایل‌ها در اینجا نمایش داده می‌شود. از این نما برای دانلود، فیلتر و اجرای مجدد داده‌های Parquet استفاده کنید.';

  @override
  String get logsEmptyTitle => 'هنوز گزارشی برای نمایش نیست';

  @override
  String get logsEmptySubtitle => 'برای دریافت تاریخچه نشست، نقطهٔ پایانی /v1/logs را پیاده‌سازی کنید.';

  @override
  String get retryButton => 'تلاش دوباره';
}
