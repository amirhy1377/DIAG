import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get appTitle => 'DIAG';

  @override
  String get navDashboard => 'Панель управления';

  @override
  String get navTelemetry => 'Телеметрия';

  @override
  String get navLogs => 'Журналы';

  @override
  String get dashboardHeading => 'Управление диагностикой';

  @override
  String get dashboardLoadingError => 'Не удалось загрузить состояние сессии';

  @override
  String get dashboardNoSessionTitle => 'Сеанс не запущен';

  @override
  String get dashboardNoSessionDescription => 'Запустите диагностический сеанс, чтобы начать поток телеметрии. Перед эксплуатацией обновите параметры запроса.';

  @override
  String get dashboardStartDemoButton => 'Запустить демо-сеанс';

  @override
  String get dashboardSessionActive => 'Сеанс активен';

  @override
  String get infoSessionId => 'Идентификатор сеанса';

  @override
  String get infoVin => 'VIN';

  @override
  String get infoAdapter => 'Адаптер';

  @override
  String get infoTargetRate => 'Целевая частота';

  @override
  String get infoActualRate => 'Фактическая частота';

  @override
  String get infoStarted => 'Время запуска';

  @override
  String get infoMonitoredPids => 'Отслеживаемые PID';

  @override
  String get dashboardStopSession => 'Остановить сеанс';

  @override
  String get dashboardRecentActivity => 'Последние действия';

  @override
  String get dashboardActivityCardTitle => 'Активность';

  @override
  String get dashboardActivityPlaceholder => 'Когда сеанс активен, здесь появятся графики телеметрии, уведомления DTC и журналы.';

  @override
  String get dashboardActivityTelemetryTitle => 'Потоковая телеметрия';

  @override
  String get dashboardActivityTelemetrySubtitle => 'Перейдите на вкладку \"Телеметрия\", чтобы посмотреть графики.';

  @override
  String get dashboardActivityLogsTitle => 'Конвейер журналов активен';

  @override
  String get dashboardActivityLogsSubtitle => 'Процесс записи Parquet выполняет сброс в фоновом режиме.';

  @override
  String get telemetryHeading => 'Онлайн‑телеметрия';

  @override
  String get telemetryDescription => 'Подключите этот клиент к websocket FastAPI (/ws/telemetry), чтобы транслировать эти виджеты.';

  @override
  String get telemetryCardRpm => 'Обороты двигателя';

  @override
  String get telemetryCardThrottle => 'Положение дросселя';

  @override
  String get telemetryCardCoolant => 'Температура охлаждающей жидкости';

  @override
  String get telemetryCardHint => 'Привязки данных готовы: передайте значения рисовальщику графиков, чтобы увидеть живые сигналы.';

  @override
  String get logsHeading => 'Журналы сеанса';

  @override
  String get logsDescription => 'Как только API журналов станет доступен, список файлов появится ниже. Используйте это представление для загрузки, фильтрации и воспроизведения наборов Parquet.';

  @override
  String get logsEmptyTitle => 'Журналы пока отсутствуют';

  @override
  String get logsEmptySubtitle => 'Реализуйте конечную точку /v1/logs для получения истории сеансов.';

  @override
  String get retryButton => 'Повторить';
}
