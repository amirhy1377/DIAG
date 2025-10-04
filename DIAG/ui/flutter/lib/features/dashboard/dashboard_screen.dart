import 'package:flutter/material.dart';
import 'package:diag_ui/l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../services/models.dart';
import '../../state/session_controller.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  static const String routeName = 'dashboard';
  static const String routePath = '/';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(sessionControllerProvider);
    final l10n = AppLocalizations.of(context)!;

    return SafeArea(
      child: session.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => _ErrorView(
          message: l10n.dashboardLoadingError,
          actionLabel: l10n.retryButton,
          onRetry: () => ref.read(sessionControllerProvider.notifier).refresh(),
        ),
        data: (status) => _DashboardBody(status: status, l10n: l10n),
      ),
    );
  }
}

class _DashboardBody extends ConsumerWidget {
  const _DashboardBody({
    required this.status,
    required this.l10n,
  });

  final SessionStatus status;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return RefreshIndicator(
      onRefresh: () => ref.read(sessionControllerProvider.notifier).refresh(),
      child: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Text(
            l10n.dashboardHeading,
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 12),
          if (status.hasSession)
            _ActiveSessionCard(session: status.session!, l10n: l10n)
          else
            _InactiveSessionCard(
              l10n: l10n,
              onStart: () async {
                final notifier = ref.read(sessionControllerProvider.notifier);
                await notifier.startSession(
                  const StartSessionRequest(
                    vin: 'DEMO0000000000000',
                    port: 'COM3',
                    adapterId: 'ELM327',
                    rate: 5,
                    pids: <String>['010C', '0105', '0110'],
                  ),
                );
              },
            ),
          const SizedBox(height: 32),
          Text(
            l10n.dashboardRecentActivity,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 12),
          _ActivityFeed(status: status, l10n: l10n),
        ],
      ),
    );
  }
}

class _InactiveSessionCard extends StatelessWidget {
  const _InactiveSessionCard({
    required this.l10n,
    required this.onStart,
  });

  final AppLocalizations l10n;
  final Future<void> Function() onStart;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.dashboardNoSessionTitle,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              l10n.dashboardNoSessionDescription,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: onStart,
              icon: const Icon(Icons.play_arrow),
              label: Text(l10n.dashboardStartDemoButton),
            ),
          ],
        ),
      ),
    );
  }
}

class _ActiveSessionCard extends ConsumerWidget {
  const _ActiveSessionCard({
    required this.session,
    required this.l10n,
  });

  final SessionMetadata session;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.dashboardSessionActive, style: textTheme.titleLarge),
            const SizedBox(height: 12),
            Wrap(
              spacing: 16,
              runSpacing: 8,
              children: [
                _InfoChip(label: l10n.infoSessionId, value: session.sessionId),
                _InfoChip(label: l10n.infoVin, value: session.vin),
                _InfoChip(label: l10n.infoAdapter, value: session.adapterId),
                _InfoChip(
                  label: l10n.infoTargetRate,
                  value: session.targetRateHz != null
                      ? '${session.targetRateHz!.toStringAsFixed(2)} Hz'
                      : '—',
                ),
                _InfoChip(
                  label: l10n.infoActualRate,
                  value: session.actualRateHz != null
                      ? '${session.actualRateHz!.toStringAsFixed(2)} Hz'
                      : '—',
                ),
                _InfoChip(
                  label: l10n.infoStarted,
                  value: session.startedAt.toLocal().toString(),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(l10n.infoMonitoredPids, style: textTheme.titleMedium),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 4,
              children: session.pids
                  .map((pid) => Chip(label: Text(pid)))
                  .toList(growable: false),
            ),
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.centerRight,
              child: OutlinedButton.icon(
                onPressed: () => ref.read(sessionControllerProvider.notifier).stopSession(),
                icon: const Icon(Icons.stop_circle_outlined),
                label: Text(l10n.dashboardStopSession),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ActivityFeed extends StatelessWidget {
  const _ActivityFeed({
    required this.status,
    required this.l10n,
  });

  final SessionStatus status;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    if (!status.hasSession) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(
            l10n.dashboardActivityPlaceholder,
            style: theme.textTheme.bodyMedium,
          ),
        ),
      );
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.dashboardActivityCardTitle, style: theme.textTheme.titleMedium),
            const SizedBox(height: 12),
            ListTile(
              leading: const Icon(Icons.assessment_outlined),
              title: Text(l10n.dashboardActivityTelemetryTitle),
              subtitle: Text(l10n.dashboardActivityTelemetrySubtitle),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.sensors),
              title: Text(l10n.dashboardActivityLogsTitle),
              subtitle: Text(l10n.dashboardActivityLogsSubtitle),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  const _InfoChip({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: Theme.of(context).textTheme.labelSmall),
          Text(value, style: Theme.of(context).textTheme.bodyMedium),
        ],
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({
    required this.message,
    required this.actionLabel,
    required this.onRetry,
  });

  final String message;
  final String actionLabel;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            message,
            style: Theme.of(context).textTheme.bodyLarge,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          FilledButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh),
            label: Text(actionLabel),
          ),
        ],
      ),
    );
  }
}
