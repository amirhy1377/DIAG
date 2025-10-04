import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:diag_ui/l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TelemetryScreen extends ConsumerStatefulWidget {
  const TelemetryScreen({super.key});

  static const String routeName = 'telemetry';
  static const String routePath = '/telemetry';

  @override
  ConsumerState<TelemetryScreen> createState() => _TelemetryScreenState();
}

class _TelemetryScreenState extends ConsumerState<TelemetryScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final crossAxisCount = width > 1200
        ? 3
        : width > 900
            ? 2
            : 1;
    final l10n = AppLocalizations.of(context)!;

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
            Expanded(
              child: GridView.count(
                crossAxisCount: crossAxisCount,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1.6,
                children: [
                  _TelemetryPlaceholder(
                    title: l10n.telemetryCardRpm,
                    hint: l10n.telemetryCardHint,
                    animation: _controller,
                  ),
                  _TelemetryPlaceholder(
                    title: l10n.telemetryCardThrottle,
                    hint: l10n.telemetryCardHint,
                    animation: _controller,
                  ),
                  _TelemetryPlaceholder(
                    title: l10n.telemetryCardCoolant,
                    hint: l10n.telemetryCardHint,
                    animation: _controller,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TelemetryPlaceholder extends StatelessWidget {
  const _TelemetryPlaceholder({
    required this.title,
    required this.hint,
    required this.animation,
  });

  final String title;
  final String hint;
  final Animation<double> animation;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            Expanded(child: _AnimatedWave(animation: animation)),
            const SizedBox(height: 12),
            Text(
              hint,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}

class _AnimatedWave extends StatelessWidget {
  const _AnimatedWave({required this.animation});

  final Animation<double> animation;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return CustomPaint(
          painter: _WavePainter(
            progress: animation.value,
            color: Theme.of(context).colorScheme.primary,
          ),
        );
      },
    );
  }
}

class _WavePainter extends CustomPainter {
  const _WavePainter({required this.progress, required this.color});

  final double progress;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withOpacity(0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5;
    final path = Path();
    final amplitude = size.height * 0.35;
    final omega = 2 * math.pi / size.width;

    for (double x = 0; x <= size.width; x += 1) {
      final y = size.height / 2 + math.sin((x * omega) + (progress * 2 * math.pi)) * amplitude;
      if (x == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _WavePainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.color != color;
  }
}
