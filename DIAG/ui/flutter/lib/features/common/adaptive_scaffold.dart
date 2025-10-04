import 'package:flutter/material.dart';
import 'package:diag_ui/l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';

import '../dashboard/dashboard_screen.dart';
import '../logs/log_browser_screen.dart';
import '../telemetry/telemetry_screen.dart';

class AdaptiveScaffold extends StatelessWidget {
  const AdaptiveScaffold({
    super.key,
    required this.location,
    required this.child,
  });

  final String location;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final destinations = _buildDestinations(l10n);

    return LayoutBuilder(
      builder: (context, constraints) {
        final bool useRail = constraints.maxWidth >= 900;
        final int selectedIndex = _indexForLocation(location, destinations);

        if (useRail) {
          return Scaffold(
            body: Row(
              children: [
                NavigationRail(
                  selectedIndex: selectedIndex,
                  onDestinationSelected: (index) => context.go(destinations[index].route),
                  labelType: NavigationRailLabelType.all,
                  destinations: destinations
                      .map(
                        (destination) => NavigationRailDestination(
                          icon: Icon(destination.icon),
                          selectedIcon: Icon(destination.activeIcon),
                          label: Text(destination.label),
                        ),
                      )
                      .toList(),
                ),
                const VerticalDivider(width: 1),
                Expanded(child: child),
              ],
            ),
          );
        }

        return Scaffold(
          body: child,
          bottomNavigationBar: NavigationBar(
            selectedIndex: selectedIndex,
            destinations: destinations
                .map(
                  (destination) => NavigationDestination(
                    icon: Icon(destination.icon),
                    selectedIcon: Icon(destination.activeIcon),
                    label: destination.label,
                  ),
                )
                .toList(),
            onDestinationSelected: (index) => context.go(destinations[index].route),
          ),
        );
      },
    );
  }

  List<_Destination> _buildDestinations(AppLocalizations l10n) {
    return <_Destination>[
      _Destination(
        label: l10n.navDashboard,
        icon: Icons.dashboard_outlined,
        activeIcon: Icons.dashboard,
        route: DashboardScreen.routePath,
      ),
      _Destination(
        label: l10n.navTelemetry,
        icon: Icons.auto_graph_outlined,
        activeIcon: Icons.auto_graph,
        route: TelemetryScreen.routePath,
      ),
      _Destination(
        label: l10n.navLogs,
        icon: Icons.folder_open_outlined,
        activeIcon: Icons.folder_open,
        route: LogBrowserScreen.routePath,
      ),
    ];
  }

  int _indexForLocation(String location, List<_Destination> destinations) {
    final int index = destinations.indexWhere(
      (destination) => location == destination.route || location.startsWith('${destination.route}/'),
    );
    return index >= 0 ? index : 0;
  }
}

class _Destination {
  const _Destination({
    required this.label,
    required this.icon,
    required this.activeIcon,
    required this.route,
  });

  final String label;
  final IconData icon;
  final IconData activeIcon;
  final String route;
}
