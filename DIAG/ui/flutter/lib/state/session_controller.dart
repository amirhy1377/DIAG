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
