// ============================================================
// IMPLICIT ANIMATION — AnimatedContainer
//
// Technique:
//   • AnimatedContainer detects property changes in setState() and
//     automatically interpolates (tweens) between old and new values.
//   • No AnimationController is needed — Flutter handles everything.
//   • AnimatedDefaultTextStyle is used alongside it to also tween
//     the text style, demonstrating that multiple Animated* widgets
//     can work together without extra setup.
//
// Key classes used:
//   AnimatedContainer, AnimatedDefaultTextStyle, AnimatedSwitcher
//
// Reference:
//   https://codelabs.developers.google.com/advanced-flutter-animations
// ============================================================

import 'package:flutter/material.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Main widget
// ─────────────────────────────────────────────────────────────────────────────

/// [AnimatedContainerWidget] is the card displayed in Section 2.
/// Tapping the central box toggles [_expanded], and Flutter
/// smoothly interpolates every listed property automatically.
class AnimatedContainerWidget extends StatefulWidget {
  const AnimatedContainerWidget({super.key});

  @override
  State<AnimatedContainerWidget> createState() =>
      _AnimatedContainerWidgetState();
}

class _AnimatedContainerWidgetState extends State<AnimatedContainerWidget> {
  // ── State that drives the animation ──────────────────────────────────────
  bool _expanded = false;
  int _tapCount = 0;

  // ── Computed animated properties (derived from _expanded) ────────────────
  double get _size => _expanded ? 200.0 : 110.0;
  Color get _color =>
      _expanded ? Colors.orange.shade400 : Colors.teal.shade500;
  double get _borderRadius => _expanded ? 60.0 : 12.0;
  double get _elevation => _expanded ? 16.0 : 4.0;
  double get _fontSize => _expanded ? 15.0 : 11.0;
  Color get _shadowColor =>
      _expanded ? Colors.orange.shade300 : Colors.teal.shade300;

  void _toggle() {
    setState(() {
      _expanded = !_expanded;
      _tapCount++;
    });
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
              icon: Icons.auto_awesome_outlined,
              label:
                  'setState() changes properties → AnimatedContainer tweens them automatically.',
              color: Colors.teal.shade50,
              textColor: Colors.teal.shade700,
            ),
            const SizedBox(height: 28),

            // ── Animated box ──────────────────────────────────────────
            GestureDetector(
              onTap: _toggle,
              child: AnimatedContainer(
                // Duration & curve — the only required animation config.
                duration: const Duration(milliseconds: 550),
                curve: Curves.easeInOutCubic,

                // Properties that animate automatically:
                width: _size,
                height: _size,
                decoration: BoxDecoration(
                  color: _color,
                  borderRadius: BorderRadius.circular(_borderRadius),
                  boxShadow: [
                    BoxShadow(
                      color: _shadowColor.withOpacity(0.55),
                      blurRadius: _elevation * 2,
                      spreadRadius: _elevation / 2,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),

                child: Center(
                  // AnimatedDefaultTextStyle tweens text size and weight.
                  child: AnimatedDefaultTextStyle(
                    duration: const Duration(milliseconds: 550),
                    curve: Curves.easeInOutCubic,
                    style: TextStyle(
                      fontSize: _fontSize,
                      color: Colors.white,
                      fontWeight: _expanded
                          ? FontWeight.bold
                          : FontWeight.w500,
                      letterSpacing: 0.4,
                    ),
                    child: Text(
                      _expanded ? 'Tap to\nCollapse' : 'Tap me!',
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // ── State readout row ─────────────────────────────────────
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _StatePill(
                  label: _expanded ? 'Expanded' : 'Collapsed',
                  color: _color,
                ),
                const SizedBox(width: 12),
                _StatePill(
                  label: 'Taps: $_tapCount',
                  color: Colors.blueGrey.shade400,
                ),
              ],
            ),

            const SizedBox(height: 12),

            // ── Property table ────────────────────────────────────────
            _PropertyTable(
              rows: [
                ('Size', '${_size.toInt()} × ${_size.toInt()} px'),
                ('Border radius', '${_borderRadius.toInt()} px'),
                ('Color', _expanded ? 'Orange 400' : 'Teal 500'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Helper widgets
// ─────────────────────────────────────────────────────────────────────────────

class _StatePill extends StatelessWidget {
  final String label;
  final Color color;

  const _StatePill({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 400),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.5)),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.w600,
          fontSize: 13,
        ),
      ),
    );
  }
}

class _PropertyTable extends StatelessWidget {
  final List<(String, String)> rows;

  const _PropertyTable({required this.rows});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: rows.map((row) {
          final (key, value) = row;
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 3),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  key,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}

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
