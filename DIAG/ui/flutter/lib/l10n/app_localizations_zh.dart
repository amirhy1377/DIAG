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
  String get configHeading => '连接与会话';

  @override
  String get configBaseUrlLabel => '后端基础地址';

  @override
  String get configBaseUrlApply => '保存';

  @override
  String get configBaseUrlApplied => '后端地址已更新';

  @override
  String get configVinLabel => '车辆 VIN';

  @override
  String get configPortLabel => '端口';

  @override
  String get configAdapterLabel => '适配器 ID';

  @override
  String get configRateLabel => '目标频率 (Hz)';

  @override
  String get configPidsLabel => '监控的 PID';

  @override
  String get configPidsHint => '使用逗号分隔，例如 010C,0105,0110';

  @override
  String get configLogRootLabel => '日志目录';

  @override
  String get configSeedLabel => '遥测随机种子（可选）';

  @override
  String get configStartButton => '开始会话';

  @override
  String get dashboardHeading => '诊断控制';

  @override
  String get dashboardLoadingError => '无法加载会话状态';

  @override
  String get dashboardNoSessionTitle => '当前没有正在运行的会话';

  @override
  String get dashboardNoSessionDescription => '请先在上方配置会话参数，然后点击“开始”以开始传输遥测数据。';

  @override
  String get dashboardSessionActive => '会话已激活';

  @override
  String get dashboardStartSuccess => '诊断会话已启动';

  @override
  String get dashboardStopSuccess => '诊断会话已停止';

  @override
  String get dashboardRequestFailed => '请求失败，请检查后端地址后重试。';

  @override
  String get dashboardInvalidRate => '请输入有效的目标频率。';

  @override
  String get dashboardInvalidPids => '请至少输入一个 PID（使用逗号分隔）。';

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
  String get telemetryCardHint => '数据绑定已启用，下面的数值反映车辆最新的采样数据。';

  @override
  String get telemetryAwaitingData => '正在等待遥测数据...';

  @override
  String get telemetryNoSession => '请先启动诊断会话以接收遥测数据。';

  @override
  String telemetryStreamError(Object error) {
    return '遥测流错误：$error';
  }

  @override
  String get telemetryCardRpm => '发动机转速';

  @override
  String get telemetryCardThrottle => '节气门位置';

  @override
  String get telemetryCardCoolant => '冷却液温度';

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
