import 'package:flutter/foundation.dart';

@immutable
class SessionStatus {
  const SessionStatus({
    required this.active,
    this.session,
  });

  final bool active;
  final SessionMetadata? session;

  bool get hasSession => active && session != null;

  factory SessionStatus.fromJson(Map<String, dynamic> json) {
    return SessionStatus(
      active: json['active'] as bool? ?? false,
      session: json['session'] == null
          ? null
          : SessionMetadata.fromJson(json['session'] as Map<String, dynamic>),
    );
  }
}

@immutable
class SessionMetadata {
  const SessionMetadata({
    required this.sessionId,
    required this.vin,
    required this.adapterId,
    required this.startedAt,
    required this.pids,
    this.vehicleProfile = const <String, String>{},
    this.targetRateHz,
    this.actualRateHz,
  });

  final String sessionId;
  final String vin;
  final String adapterId;
  final DateTime startedAt;
  final List<String> pids;
  final Map<String, String> vehicleProfile;
  final double? targetRateHz;
  final double? actualRateHz;

  factory SessionMetadata.fromJson(Map<String, dynamic> json) {
    return SessionMetadata(
      sessionId: json['session_id'] as String? ?? '',
      vin: json['vin'] as String? ?? 'UNKNOWN',
      adapterId: json['adapter_id'] as String? ?? 'N/A',
      startedAt: DateTime.tryParse(json['started_at'] as String? ?? '') ?? DateTime.now(),
      pids: List<String>.from(json['pids'] as List? ?? const <String>[]),
      vehicleProfile: (json['vehicle_profile'] as Map<String, dynamic>? ?? const <String, dynamic>{})
          .map((key, value) => MapEntry(key, value?.toString() ?? '')),
      targetRateHz: (json['target_rate_hz'] as num?)?.toDouble(),
      actualRateHz: (json['actual_rate_hz'] as num?)?.toDouble(),
    );
  }
}

@immutable
class StartSessionRequest {
  const StartSessionRequest({
    required this.vin,
    required this.port,
    this.adapterId,
    this.rate = 5,
    this.pids = const <String>[],
    this.seed,
    this.logRoot,
  });

  final String vin;
  final String port;
  final String? adapterId;
  final double rate;
  final List<String> pids;
  final int? seed;
  final String? logRoot;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'vin': vin,
        'port': port,
        'adapter_id': adapterId,
        'rate': rate,
        'pids': pids,
        'seed': seed,
        'log_root': logRoot,
      }..removeWhere((_, value) => value == null);
}

@immutable
class TelemetrySample {
  const TelemetrySample({
    required this.timestamp,
    required this.values,
  });

  final DateTime timestamp;
  final Map<String, num> values;

  factory TelemetrySample.fromJson(Map<String, dynamic> json) {
    return TelemetrySample(
      timestamp: DateTime.tryParse(json['timestamp'] as String? ?? '') ?? DateTime.now(),
      values: (json['values'] as Map<String, dynamic>? ?? const <String, dynamic>{})
          .map((key, value) => MapEntry(key, (value as num?) ?? 0)),
    );
  }
}
