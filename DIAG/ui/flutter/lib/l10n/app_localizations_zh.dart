import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appTitle => 'DIAG';

  @override
  String get navDashboard => '仪表盘';

  @override
  String get navTelemetry => '遥测';

  @override
  String get navLogs => '日志';

  @override
  String get dashboardHeading => '诊断控制';

  @override
  String get dashboardLoadingError => '无法加载会话状态';

  @override
  String get dashboardNoSessionTitle => '当前没有正在运行的会话';

  @override
  String get dashboardNoSessionDescription => '启动一次诊断会话以开始传输遥测数据。在生产环境使用前请更新请求参数。';

  @override
  String get dashboardStartDemoButton => '启动演示会话';

  @override
  String get dashboardSessionActive => '会话已激活';

  @override
  String get infoSessionId => '会话 ID';

  @override
  String get infoVin => '车辆识别码';

  @override
  String get infoAdapter => '适配器';

  @override
  String get infoTargetRate => '目标频率';

  @override
  String get infoActualRate => '实际频率';

  @override
  String get infoStarted => '开始时间';

  @override
  String get infoMonitoredPids => '监控的 PID';

  @override
  String get dashboardStopSession => '停止会话';

  @override
  String get dashboardRecentActivity => '最近活动';

  @override
  String get dashboardActivityCardTitle => '活动';

  @override
  String get dashboardActivityPlaceholder => '当会话运行时，这里会显示遥测图表、DTC 提示以及会话日志。';

  @override
  String get dashboardActivityTelemetryTitle => '实时遥测流';

  @override
  String get dashboardActivityTelemetrySubtitle => '切换到“遥测”选项卡查看图表。';

  @override
  String get dashboardActivityLogsTitle => '日志管道已启用';

  @override
  String get dashboardActivityLogsSubtitle => 'Parquet 写入器正在后台刷新数据。';

  @override
  String get telemetryHeading => '实时遥测';

  @override
  String get telemetryDescription => '将此客户端连接到 FastAPI WebSocket 端点 (/ws/telemetry)，即可开始传输这些组件。';

  @override
  String get telemetryCardRpm => '发动机转速';

  @override
  String get telemetryCardThrottle => '节气门位置';

  @override
  String get telemetryCardCoolant => '冷却液温度';

  @override
  String get telemetryCardHint => '数据绑定钩子已就绪，将数据传递给图表绘制器即可展示实时信号。';

  @override
  String get logsHeading => '会话日志';

  @override
  String get logsDescription => '当日志接口可用时，文件列表会显示在下方。使用该界面下载、筛选并回放 Parquet 数据集。';

  @override
  String get logsEmptyTitle => '暂无日志可显示';

  @override
  String get logsEmptySubtitle => '实现 /v1/logs 端点以获取会话历史。';

  @override
  String get retryButton => '重试';
}
