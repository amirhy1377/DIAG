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
  String get configHeading => 'Подключение и сеанс';

  @override
  String get configBaseUrlLabel => 'Базовый URL сервера';

  @override
  String get configBaseUrlApply => 'Сохранить';

  @override
  String get configBaseUrlApplied => 'Адрес сервера обновлён';

  @override
  String get configVinLabel => 'VIN автомобиля';

  @override
  String get configPortLabel => 'Порт';

  @override
  String get configAdapterLabel => 'Идентификатор адаптера';

  @override
  String get configRateLabel => 'Целевая частота (Гц)';

  @override
  String get configPidsLabel => 'Отслеживаемые PID';

  @override
  String get configPidsHint => 'Перечислите через запятую, например 010C,0105,0110';

  @override
  String get configLogRootLabel => 'Каталог журналов';

  @override
  String get configSeedLabel => 'Seed телеметрии (необязательно)';

  @override
  String get configStartButton => 'Запустить сеанс';

  @override
  String get dashboardHeading => 'Управление диагностикой';

  @override
  String get dashboardLoadingError => 'Не удалось загрузить состояние сеанса';

  @override
  String get dashboardNoSessionTitle => 'Сеанс не запущен';

  @override
  String get dashboardNoSessionDescription => 'Настройте параметры сеанса выше и нажмите \"Запустить\", чтобы начать поток телеметрии.';

  @override
  String get dashboardSessionActive => 'Сеанс активен';

  @override
  String get dashboardStartSuccess => 'Диагностический сеанс запущен';

  @override
  String get dashboardStopSuccess => 'Диагностический сеанс остановлен';

  @override
  String get dashboardRequestFailed => 'Запрос не выполнен. Проверьте адрес сервера и повторите попытку.';

  @override
  String get dashboardInvalidRate => 'Введите корректную целевую частоту.';

  @override
  String get dashboardInvalidPids => 'Укажите как минимум один PID (через запятую).';

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
  String get dashboardActivityLogsSubtitle => 'Процесс записи Parquet выполняет сброс в фоне.';

  @override
  String get telemetryHeading => 'Онлайн‑телеметрия';

  @override
  String get telemetryDescription => 'Подключите этот клиент к websocket FastAPI (/ws/telemetry), чтобы транслировать эти виджеты.';

  @override
  String get telemetryCardHint => 'Связь с данными активна. Значения ниже отражают последние образцы с автомобиля.';

  @override
  String get telemetryAwaitingData => 'Ожидание телеметрии...';

  @override
  String get telemetryNoSession => 'Запустите диагностический сеанс, чтобы получить телеметрию.';

  @override
  String telemetryStreamError(Object error) {
    return 'Ошибка потока телеметрии: $error';
  }

  @override
  String get telemetryCardRpm => 'Обороты двигателя';

  @override
  String get telemetryCardThrottle => 'Положение дросселя';

  @override
  String get telemetryCardCoolant => 'Температура охлаждающей жидкости';

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
