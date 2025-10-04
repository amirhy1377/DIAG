import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/diag_api.dart';
import '../services/models.dart';

final baseUrlProvider = StateProvider<String>((ref) => 'http://localhost:8000');

final diagApiProvider = Provider<DiagApiClient>(
  (ref) => DiagApiClient(baseUrl: ref.watch(baseUrlProvider)),
);

final sessionControllerProvider = AutoDisposeAsyncNotifierProvider<SessionController, SessionStatus>(
  SessionController.new,
);

final telemetryStreamProvider = StreamProvider.autoDispose<List<TelemetrySample>>((ref) {
  final sessionAsync = ref.watch(sessionControllerProvider);
  final session = sessionAsync.valueOrNull;
  if (session == null || !session.active) {
    return const Stream<List<TelemetrySample>>.empty();
  }

  final api = ref.watch(diagApiProvider);
  final controller = StreamController<List<TelemetrySample>>();
  final samples = <TelemetrySample>[];

  final subscription = api
      .subscribeTelemetry(timeout: const Duration(seconds: 30))
      .listen((sample) {
    samples.add(sample);
    if (samples.length > 200) {
      samples.removeAt(0);
    }
    controller.add(List.unmodifiable(samples));
  }, onError: controller.addError);

  ref.onDispose(() {
    subscription.cancel();
    controller.close();
  });

  return controller.stream;
});

class SessionController extends AutoDisposeAsyncNotifier<SessionStatus> {
  late final DiagApiClient _api;

  @override
  Future<SessionStatus> build() async {
    _api = ref.watch(diagApiProvider);
    return _api.fetchSessionStatus();
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(_api.fetchSessionStatus);
  }

  Future<void> startSession(StartSessionRequest request) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await _api.startSession(request);
      return _api.fetchSessionStatus();
    });
  }

  Future<void> stopSession() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await _api.stopSession();
      return _api.fetchSessionStatus();
    });
  }
}
