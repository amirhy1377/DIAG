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
  String get dashboardHeading => 'کنترل عیب‌یابی';

  @override
  String get dashboardLoadingError => 'وضعیت نشست بارگیری نشد';

  @override
  String get dashboardNoSessionTitle => 'هیچ نشستی در حال اجرا نیست';

  @override
  String get dashboardNoSessionDescription => 'برای شروع جریان تله‌متری یک نشست عیب‌یابی را اجرا کنید. پیش از استفاده در محیط عملیاتی پارامترهای درخواست را به‌روزرسانی کنید.';

  @override
  String get dashboardStartDemoButton => 'شروع نشست آزمایشی';

  @override
  String get dashboardSessionActive => 'نشست فعال است';

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
  String get infoMonitoredPids => 'PID های پایش‌شده';

  @override
  String get dashboardStopSession => 'توقف نشست';

  @override
  String get dashboardRecentActivity => 'فعالیت‌های اخیر';

  @override
  String get dashboardActivityCardTitle => 'فعالیت';

  @override
  String get dashboardActivityPlaceholder => 'وقتی نشست فعال باشد نمودارهای تله‌متری، نکات DTC و گزارش‌ها در اینجا نمایش داده می‌شوند.';

  @override
  String get dashboardActivityTelemetryTitle => 'جریان تله‌متری زنده';

  @override
  String get dashboardActivityTelemetrySubtitle => 'برای دیدن نمودارها به برگه تله‌متری بروید.';

  @override
  String get dashboardActivityLogsTitle => 'خط لوله گزارش فعال است';

  @override
  String get dashboardActivityLogsSubtitle => 'نویسنده Parquet در پس‌زمینه در حال ذخیره‌سازی داده است.';

  @override
  String get telemetryHeading => 'تله‌متری زنده';

  @override
  String get telemetryDescription => 'برای نمایش این ویجت‌ها، این کلاینت را به انتهای وب‌سوکت FastAPI (/ws/telemetry) متصل کنید.';

  @override
  String get telemetryCardRpm => 'دور موتور';

  @override
  String get telemetryCardThrottle => 'درصد گاز';

  @override
  String get telemetryCardCoolant => 'دمای مایع خنک‌کننده';

  @override
  String get telemetryCardHint => 'قلاب‌های اتصال داده آماده‌اند؛ مقادیر را به رسم‌گر نمودار بدهید تا سیگنال‌های زنده نمایش داده شوند.';

  @override
  String get logsHeading => 'گزارش‌های نشست';

  @override
  String get logsDescription => 'پس از در دسترس بودن API گزارش، فهرست فایل‌ها در اینجا نمایش داده می‌شود. از این نما برای دانلود، فیلتر و اجرای مجدد داده‌های Parquet استفاده کنید.';

  @override
  String get logsEmptyTitle => 'هنوز گزارشی برای نمایش نیست';

  @override
  String get logsEmptySubtitle => 'برای دریافت تاریخچه نشست، انتهای /v1/logs را پیاده‌سازی کنید.';

  @override
  String get retryButton => 'تلاش دوباره';
}
