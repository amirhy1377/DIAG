import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:diag_ui/l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';

import 'core/theme/app_theme.dart';
import 'features/common/adaptive_scaffold.dart';
import 'features/dashboard/dashboard_screen.dart';
import 'features/logs/log_browser_screen.dart';
import 'features/telemetry/telemetry_screen.dart';

final _routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: DashboardScreen.routePath,
    routes: [
      ShellRoute(
        builder: (context, state, child) => AdaptiveScaffold(
          location: state.matchedLocation,
          child: child,
        ),
        routes: [
          GoRoute(
            path: DashboardScreen.routePath,
            name: DashboardScreen.routeName,
            builder: (context, state) => const DashboardScreen(),
          ),
          GoRoute(
            path: TelemetryScreen.routePath,
            name: TelemetryScreen.routeName,
            builder: (context, state) => const TelemetryScreen(),
          ),
          GoRoute(
            path: LogBrowserScreen.routePath,
            name: LogBrowserScreen.routeName,
            builder: (context, state) => const LogBrowserScreen(),
          ),
        ],
      ),
    ],
  );
});

class DiagApp extends ConsumerWidget {
  const DiagApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(_routerProvider);
    return MaterialApp.router(
      onGenerateTitle: (context) => AppLocalizations.of(context)!.appTitle,
      theme: buildLightTheme(),
      darkTheme: buildDarkTheme(),
      themeMode: ThemeMode.system,
      routerConfig: router,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
    );
  }
}
