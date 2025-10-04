import 'dart:math' as math;

import 'package:diag_ui/l10n/app_localizations.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../services/models.dart';
import '../../state/session_controller.dart';

class TelemetryScreen extends ConsumerWidget {
  const TelemetryScreen({super.key});

  static const String routeName = 'telemetry';
  static const String routePath = '/telemetry';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final sessionAsync = ref.watch(sessionControllerProvider);
    final session = sessionAsync.valueOrNull;
    final telemetry = ref.watch(telemetryStreamProvider);

    Widget content;

    if (sessionAsync.isLoading) {
      content = const Center(child: CircularProgressIndicator());
    } else if (session == null || !session.active) {
      content = _StatusNotice(
        icon: Icons.play_circle_outline,
        message: l10n.telemetryNoSession,
      );
    } else {
      content = telemetry.when(
        data: (samples) {
          if (samples.isEmpty) {
            return _StatusNotice(
              icon: Icons.sensors,
              message: l10n.telemetryAwaitingData,
            );
          }
          return _TelemetryGrid(samples: samples, l10n: l10n);
        },
        loading: () => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(height: 16),
              Text(l10n.telemetryAwaitingData),
            ],
          ),
        ),
        error: (error, stackTrace) => _StatusNotice(
          icon: Icons.error_outline,
          message: l10n.telemetryStreamError(error.toString()),
        ),
      );
    }

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.telemetryHeading,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 12),
            Text(
              l10n.telemetryDescription,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 24),
            Expanded(child: content),
          ],
        ),
      ),
    );
  }
}

class _TelemetryGrid extends StatelessWidget {
  const _TelemetryGrid({required this.samples, required this.l10n});

  final List<TelemetrySample> samples;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final latest = samples.last;
    final entries = latest.values.entries.toList()
      ..sort((a, b) => a.key.compareTo(b.key));
    final width = MediaQuery.of(context).size.width;
    final crossAxisCount = width > 1200
        ? 3
        : width > 900
            ? 2
            : 1;

    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1.5,
      ),
      itemCount: entries.length,
      itemBuilder: (context, index) {
        final entry = entries[index];
        final history = _historyFor(samples, entry.key);
        final label = _resolveLabel(l10n, entry.key);
        return _TelemetryMetricCard(
          pid: entry.key,
          label: label,
          value: entry.value,
          history: history,
          timestamp: samples.last.timestamp.toLocal(),
        );
      },
    );
  }

  List<double> _historyFor(List<TelemetrySample> samples, String key) {
    return samples
        .map((sample) => sample.values[key])
        .whereType<num>()
        .map((value) => value.toDouble())
        .toList(growable: false);
  }

  String _resolveLabel(AppLocalizations l10n, String key) {
    final normalised = key.toLowerCase();
    switch (normalised) {
      case '010c':
      case 'rpm':
        return l10n.telemetryCardRpm;
      case '0111':
      case 'throttle':
        return l10n.telemetryCardThrottle;
      case '0105':
      case 'coolant':
        return l10n.telemetryCardCoolant;
      default:
        return key;
    }
  }
}

class _TelemetryMetricCard extends StatelessWidget {
  const _TelemetryMetricCard({
    required this.pid,
    required this.label,
    required this.value,
    required this.history,
    required this.timestamp,
  });

  final String pid;
  final String label;
  final num value;
  final List<double> history;
  final DateTime timestamp;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final formattedTime = MaterialLocalizations.of(context).formatTimeOfDay(
      TimeOfDay.fromDateTime(timestamp),
    );

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: theme.textTheme.titleMedium),
            Text(pid, style: theme.textTheme.bodySmall),
            const SizedBox(height: 12),
            Expanded(
              child: _TelemetrySparkline(
                history: history,
                color: theme.colorScheme.primary,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              _formatValue(value),
              style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w600),
            ),
            Text(
              formattedTime,
              style: theme.textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }

  String _formatValue(num value) {
    if (value is int) {
      return value.toString();
    }
    final absValue = value.abs();
    if (absValue >= 100) {
      return value.toStringAsFixed(0);
    }
    if (absValue >= 10) {
      return value.toStringAsFixed(1);
    }
    return value.toStringAsFixed(2);
  }
}

class _TelemetrySparkline extends StatelessWidget {
  const _TelemetrySparkline({required this.history, required this.color});

  final List<double> history;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: CustomPaint(
        key: ValueKey<int>(history.length),
        painter: _SparklinePainter(history: history, color: color),
      ),
    );
  }
}

class _SparklinePainter extends CustomPainter {
  _SparklinePainter({required this.history, required this.color});

  final List<double> history;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    if (history.isEmpty) {
      return;
    }

    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..isAntiAlias = true;

    final minValue = history.reduce(math.min);
    final maxValue = history.reduce(math.max);
    final range = (maxValue - minValue).abs() < 1e-6 ? 1.0 : (maxValue - minValue);

    final path = Path();
    for (var i = 0; i < history.length; i++) {
      final x = history.length == 1
          ? size.width
          : i / (history.length - 1) * size.width;
      final normalised = (history[i] - minValue) / range;
      final y = size.height - (normalised * size.height);
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _SparklinePainter oldDelegate) {
    return oldDelegate.color != color || !listEquals(oldDelegate.history, history);
  }
}

class _StatusNotice extends StatelessWidget {
  const _StatusNotice({required this.icon, required this.message});

  final IconData icon;
  final String message;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 48, color: theme.colorScheme.primary),
          const SizedBox(height: 12),
          Text(message, style: theme.textTheme.bodyLarge, textAlign: TextAlign.center),
        ],
      ),
    );
  }
}
