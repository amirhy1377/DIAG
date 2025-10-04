import 'package:diag_ui/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../services/models.dart';
import '../../state/session_controller.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  static const String routeName = 'dashboard';
  static const String routePath = '/';

  void _showSnackBar(BuildContext context, String message) {
    if (message.isEmpty) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(sessionControllerProvider);
    final l10n = AppLocalizations.of(context)!;

    ref.listen<AsyncValue<SessionStatus>>(sessionControllerProvider, (previous, next) {
      next.whenOrNull(
        error: (error, stackTrace) => _showSnackBar(context, l10n.dashboardRequestFailed),
        data: (value) {
          final wasActive = previous?.valueOrNull?.active ?? false;
          if (!wasActive && value.active) {
            _showSnackBar(context, l10n.dashboardStartSuccess);
          } else if (wasActive && !value.active) {
            _showSnackBar(context, l10n.dashboardStopSuccess);
          }
        },
      );
    });

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
  const _DashboardBody({required this.status, required this.l10n});

  final SessionStatus status;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return RefreshIndicator(
      onRefresh: () => ref.read(sessionControllerProvider.notifier).refresh(),
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(24),
        children: [
          _ConfigurationCard(status: status, l10n: l10n),
          const SizedBox(height: 24),
          Text(l10n.dashboardHeading, style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 12),
          if (status.hasSession)
            _ActiveSessionCard(session: status.session!, l10n: l10n)
          else
            _IdleSessionCard(l10n: l10n),
          const SizedBox(height: 24),
          _ActivityFeed(status: status, l10n: l10n),
        ],
      ),
    );
  }
}

class _ConfigurationCard extends ConsumerStatefulWidget {
  const _ConfigurationCard({required this.status, required this.l10n});

  final SessionStatus status;
  final AppLocalizations l10n;

  @override
  ConsumerState<_ConfigurationCard> createState() => _ConfigurationCardState();
}

class _ConfigurationCardState extends ConsumerState<_ConfigurationCard> {
  late final TextEditingController _baseUrlController;
  late final TextEditingController _vinController;
  late final TextEditingController _portController;
  late final TextEditingController _adapterController;
  late final TextEditingController _rateController;
  late final TextEditingController _pidsController;
  late final TextEditingController _logRootController;
  late final TextEditingController _seedController;

  @override
  void initState() {
    super.initState();
    _baseUrlController = TextEditingController(text: ref.read(baseUrlProvider));
    _vinController = TextEditingController(text: 'DEMO0000000000000');
    _portController = TextEditingController(text: 'COM3');
    _adapterController = TextEditingController(text: 'ELM327');
    _rateController = TextEditingController(text: '5');
    _pidsController = TextEditingController(text: '010C,0105,0110');
    _logRootController = TextEditingController(text: './logs');
    _seedController = TextEditingController();
  }

  @override
  void dispose() {
    _baseUrlController.dispose();
    _vinController.dispose();
    _portController.dispose();
    _adapterController.dispose();
    _rateController.dispose();
    _pidsController.dispose();
    _logRootController.dispose();
    _seedController.dispose();
    super.dispose();
  }

  Future<void> _applyBaseUrl(BuildContext context) async {
    final url = _baseUrlController.text.trim();
    if (url.isEmpty) {
      return;
    }
    ref.read(baseUrlProvider.notifier).state = url;
    ref.invalidate(sessionControllerProvider);
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(widget.l10n.configBaseUrlApplied)));
  }

  Future<void> _startSession(BuildContext context) async {
    final rateText = _rateController.text.trim();
    final rate = double.tryParse(rateText);
    if (rate == null || rate <= 0) {
      _showWarning(widget.l10n.dashboardInvalidRate);
      return;
    }

    final pidList = _pidsController.text
        .split(',')
        .map((value) => value.trim())
        .where((value) => value.isNotEmpty)
        .toList(growable: false);
    if (pidList.isEmpty) {
      _showWarning(widget.l10n.dashboardInvalidPids);
      return;
    }

    final seedText = _seedController.text.trim();
    final seed = seedText.isEmpty ? null : int.tryParse(seedText);

    final request = StartSessionRequest(
      vin: _vinController.text.trim().isEmpty ? 'UNKNOWN' : _vinController.text.trim(),
      port: _portController.text.trim().isEmpty ? 'AUTO' : _portController.text.trim(),
      adapterId: _adapterController.text.trim().isEmpty ? null : _adapterController.text.trim(),
      rate: rate,
      pids: pidList,
      seed: seed,
      logRoot: _logRootController.text.trim().isEmpty ? null : _logRootController.text.trim(),
    );

    final notifier = ref.read(sessionControllerProvider.notifier);
    await notifier.startSession(request);

    final state = ref.read(sessionControllerProvider);
    state.whenOrNull(
      error: (error, stackTrace) => _showWarning(widget.l10n.dashboardRequestFailed),
    );
  }

  void _showWarning(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final isActive = widget.status.active;
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.l10n.configHeading, style: theme.textTheme.titleLarge),
            const SizedBox(height: 16),
            Wrap(
              spacing: 16,
              runSpacing: 16,
              children: [
                SizedBox(
                  width: 320,
                  child: TextField(
                    controller: _baseUrlController,
                    decoration: InputDecoration(
                      labelText: widget.l10n.configBaseUrlLabel,
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.save_outlined),
                        tooltip: widget.l10n.configBaseUrlApply,
                        onPressed: () => _applyBaseUrl(context),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 220,
                  child: TextField(
                    controller: _vinController,
                    decoration: InputDecoration(labelText: widget.l10n.configVinLabel),
                  ),
                ),
                SizedBox(
                  width: 180,
                  child: TextField(
                    controller: _portController,
                    decoration: InputDecoration(labelText: widget.l10n.configPortLabel),
                  ),
                ),
                SizedBox(
                  width: 220,
                  child: TextField(
                    controller: _adapterController,
                    decoration: InputDecoration(labelText: widget.l10n.configAdapterLabel),
                  ),
                ),
                SizedBox(
                  width: 180,
                  child: TextField(
                    controller: _rateController,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    decoration: InputDecoration(labelText: widget.l10n.configRateLabel),
                  ),
                ),
                SizedBox(
                  width: 320,
                  child: TextField(
                    controller: _pidsController,
                    decoration: InputDecoration(
                      labelText: widget.l10n.configPidsLabel,
                      helperText: widget.l10n.configPidsHint,
                    ),
                  ),
                ),
                SizedBox(
                  width: 320,
                  child: TextField(
                    controller: _logRootController,
                    decoration: InputDecoration(labelText: widget.l10n.configLogRootLabel),
                  ),
                ),
                SizedBox(
                  width: 180,
                  child: TextField(
                    controller: _seedController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(labelText: widget.l10n.configSeedLabel),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.centerRight,
              child: FilledButton.icon(
                onPressed: isActive ? null : () => _startSession(context),
                icon: const Icon(Icons.play_arrow),
                label: Text(widget.l10n.configStartButton),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _IdleSessionCard extends StatelessWidget {
  const _IdleSessionCard({required this.l10n});

  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.dashboardNoSessionTitle, style: theme.textTheme.titleLarge),
            const SizedBox(height: 8),
            Text(l10n.dashboardNoSessionDescription, style: theme.textTheme.bodyMedium),
          ],
        ),
      ),
    );
  }
}

class _ActiveSessionCard extends ConsumerWidget {
  const _ActiveSessionCard({required this.session, required this.l10n});

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
  const _ActivityFeed({required this.status, required this.l10n});

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
    final theme = Theme.of(context);
    return Chip(
      label: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: theme.textTheme.labelSmall),
          Text(value, style: theme.textTheme.bodyMedium),
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
    final theme = Theme.of(context);
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(message, style: theme.textTheme.bodyLarge, textAlign: TextAlign.center),
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
