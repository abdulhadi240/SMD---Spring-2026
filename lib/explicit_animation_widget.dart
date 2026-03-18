// ============================================================
// EXPLICIT ANIMATION — Fade-In Logo
//
// Technique:
//   • AnimationController drives the animation manually (tick-by-tick).
//   • CurvedAnimation wraps the controller to apply an easing curve.
//   • LogoFade extends AnimatedWidget so it rebuilds automatically
//     on every tick without needing setState() or AnimationBuilder.
//
// Key classes used:
//   AnimationController, CurvedAnimation, AnimatedWidget, Tween
//
// Reference:
//   https://docs.flutter.dev/ui/animations/tutorial#simplifying-with-animatedwidget
// ============================================================

import 'package:flutter/material.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Stateful host widget — owns and manages the AnimationController lifecycle.
// ─────────────────────────────────────────────────────────────────────────────

/// [FadeInLogoWidget] is the card displayed in Section 1.
/// It creates and controls an [AnimationController] and passes the
/// resulting [Animation] down to [LogoFade] for rendering.
class FadeInLogoWidget extends StatefulWidget {
  const FadeInLogoWidget({super.key});

  @override
  State<FadeInLogoWidget> createState() => _FadeInLogoWidgetState();
}

class _FadeInLogoWidgetState extends State<FadeInLogoWidget>
    with SingleTickerProviderStateMixin {
  // ── Animation objects ─────────────────────────────────────────────────────
  late final AnimationController _controller;
  late final Animation<double> _opacityAnim;
  late final Animation<Offset> _slideAnim;

  @override
  void initState() {
    super.initState();

    // AnimationController: defines duration and vsync ticker.
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    );

    // CurvedAnimation: wraps the controller with an easing curve.
    final curved = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );

    // Tween<double>: maps the 0→1 controller range to 0.0→1.0 opacity.
    _opacityAnim = Tween<double>(begin: 0.0, end: 1.0).animate(curved);

    // Tween<Offset>: slight upward slide as the logo fades in.
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.25),
      end: Offset.zero,
    ).animate(curved);

    // Start the animation automatically on widget creation.
    _controller.forward();
  }

  @override
  void dispose() {
    // Always dispose the controller to free resources.
    _controller.dispose();
    super.dispose();
  }

  /// Resets and re-runs the animation from the beginning.
  void _replay() {
    _controller
      ..reset()
      ..forward();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 24),
        child: Column(
          children: [
            // ── Explanation chip ──────────────────────────────────────
            _InfoChip(
              icon: Icons.info_outline,
              label:
                  'AnimationController ticks; AnimatedWidget rebuilds on each tick.',
              color: Colors.deepPurple.shade50,
              textColor: Colors.deepPurple.shade700,
            ),
            const SizedBox(height: 24),

            // ── The animated logo (AnimatedWidget subclass) ───────────
            LogoFade(
              opacityAnim: _opacityAnim,
              slideAnim: _slideAnim,
            ),

            const SizedBox(height: 28),

            // ── Controls ──────────────────────────────────────────────
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FilledButton.icon(
                  onPressed: _replay,
                  icon: const Icon(Icons.replay_rounded),
                  label: const Text('Replay'),
                  style: FilledButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                  ),
                ),
                const SizedBox(width: 12),
                // Live opacity readout powered by AnimatedBuilder
                AnimatedBuilder(
                  animation: _opacityAnim,
                  builder: (_, __) => Text(
                    'Opacity: ${_opacityAnim.value.toStringAsFixed(2)}',
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 13,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// AnimatedWidget subclass — rebuilds automatically on animation tick.
// ─────────────────────────────────────────────────────────────────────────────

/// [LogoFade] extends [AnimatedWidget] and listens to [opacityAnim].
/// It rebuilds its subtree on every tick without requiring setState() in the
/// parent — the canonical Flutter pattern for explicit animations.
class LogoFade extends AnimatedWidget {
  final Animation<Offset> slideAnim;

  const LogoFade({
    super.key,
    required Animation<double> opacityAnim,
    required this.slideAnim,
  }) : super(listenable: opacityAnim);

  /// Cast the listenable back to a typed Animation<double>.
  Animation<double> get _opacity => listenable as Animation<double>;

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: slideAnim,
      child: Opacity(
        opacity: _opacity.value,
        child: Column(
          children: [
            // ── Logo container ─────────────────────────────────────
            Container(
              width: 130,
              height: 130,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [
                    Colors.deepPurple.shade600,
                    Colors.blue.shade400,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color:
                        Colors.deepPurple.withOpacity(0.35 * _opacity.value),
                    blurRadius: 24,
                    spreadRadius: 4,
                  ),
                ],
              ),
              child: const Center(
                child: Icon(
                  Icons.flutter_dash,
                  size: 72,
                  color: Colors.white,
                ),
              ),
            ),

            const SizedBox(height: 16),

            // ── App title ─────────────────────────────────────────
            Text(
              'Flutter Animations',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple.shade700,
                letterSpacing: 0.5,
              ),
            ),

            const SizedBox(height: 4),

            // ── Group badge ───────────────────────────────────────
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.deepPurple.shade50,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                'Group 20k-1069  •  Abdul Hadi',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.deepPurple.shade600,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Small helper widget
// ─────────────────────────────────────────────────────────────────────────────

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final Color textColor;

  const _InfoChip({
    required this.icon,
    required this.label,
    required this.color,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(icon, size: 16, color: textColor),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              label,
              style: TextStyle(fontSize: 12, color: textColor),
            ),
          ),
        ],
      ),
    );
  }
}
