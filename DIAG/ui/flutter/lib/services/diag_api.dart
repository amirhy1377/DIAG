import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import 'models.dart';

class DiagApiClient {
  DiagApiClient({
    required this.baseUrl,
    Dio? dio,
  }) : _dio = dio ?? _defaultDio(baseUrl);

  final String baseUrl;
  final Dio _dio;

  static Dio _defaultDio(String baseUrl) {
    return Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 20),
        responseType: ResponseType.json,
        headers: const {
          'content-type': 'application/json',
        },
      ),
    );
  }

  Future<SessionStatus> fetchSessionStatus() async {
    try {
      final response = await _dio.get<Map<String, dynamic>>('/v1/session/status');
      final data = response.data ?? const <String, dynamic>{'active': false};
      return SessionStatus.fromJson(data);
    } on DioException catch (error) {
      if (error.response?.statusCode == 404) {
        return const SessionStatus(active: false);
      }
      rethrow;
    }
  }

  Future<SessionStatus> startSession(StartSessionRequest request) async {
    final response = await _dio.post<Map<String, dynamic>>(
      '/v1/session/start',
      data: jsonEncode(request.toJson()),
    );
    final data = response.data ?? const <String, dynamic>{'active': true};
    return SessionStatus.fromJson(data);
  }

  Future<void> stopSession() async {
    await _dio.post('/v1/session/stop');
  }

  Stream<TelemetrySample> subscribeTelemetry({Duration? timeout}) {
    final uri = _buildWebSocketUri();
    final channel = WebSocketChannel.connect(uri);
    final stream = channel.stream
        .where((event) => event is String)
        .cast<String>()
        .map((message) => TelemetrySample.fromJson(
              jsonDecode(message) as Map<String, dynamic>,
            ));
    return timeout == null ? stream : stream.timeout(timeout);
  }

  Uri _buildWebSocketUri() {
    final httpUri = Uri.parse(baseUrl);
    final scheme = httpUri.scheme == 'https' ? 'wss' : 'ws';
    return httpUri.replace(scheme: scheme, path: '/ws/telemetry');
  }
}
