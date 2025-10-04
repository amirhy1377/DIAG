import 'dart:ui';

import 'package:diag_ui/l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:diag_ui/app.dart';
import 'package:diag_ui/services/models.dart';
import 'package:diag_ui/state/session_controller.dart';

void main() {
  testWidgets('Dashboard renders title', (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          sessionControllerProvider.overrideWith(_FakeSessionController.new),
        ],
        child: const DiagApp(),
      ),
    );

    await tester.pumpAndSettle();

    final l10n = await AppLocalizations.delegate.load(const Locale('en'));
    expect(find.textContaining(l10n.dashboardHeading), findsOneWidget);
  });
}

class _FakeSessionController extends SessionController {
  @override
  Future<SessionStatus> build() async {
    ref.keepAlive();
    return const SessionStatus(active: false);
  }
}
