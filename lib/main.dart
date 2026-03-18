// ============================================================
// Flutter Animations Demo
// Group:   20k-1069
// Member:  Abdul Hadi
//
// Single page showcasing:
//   1. Explicit Animation — AnimationController + AnimatedWidget (Fade-In Logo)
//   2. Implicit Animation — AnimatedContainer (Shape Transform)
// ============================================================

import 'package:flutter/material.dart';
import 'explicit_animation_widget.dart';
import 'implicit_animation_widget.dart';

void main() {
  runApp(const FlutterAnimationsApp());
}

class FlutterAnimationsApp extends StatelessWidget {
  const FlutterAnimationsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Animations Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        cardTheme: CardTheme(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
      home: const AnimationsPage(),
    );
  }
}

/// Single page that hosts both animation widgets, one below the other.
class AnimationsPage extends StatelessWidget {
  const AnimationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F4FB),
      appBar: AppBar(
        title: const Text(
          'Flutter Animations Demo',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(32),
          child: Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Text(
              'Group 20k-1069  •  Abdul Hadi',
              style: TextStyle(
                color: Colors.white.withOpacity(0.85),
                fontSize: 13,
              ),
            ),
          ),
        ),
      ),
      body: const SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ── Section 1: Explicit Animation ──────────────────────────
            _SectionHeader(
              number: '1',
              title: 'Explicit Animation',
              subtitle:
                  'Fade-In Logo using AnimationController + AnimatedWidget',
              color: Colors.deepPurple,
            ),
            SizedBox(height: 12),
            FadeInLogoWidget(),

            SizedBox(height: 32),

            // ── Section 2: Implicit Animation ──────────────────────────
            _SectionHeader(
              number: '2',
              title: 'Implicit Animation',
              subtitle: 'Shape Transform using AnimatedContainer',
              color: Colors.teal,
            ),
            SizedBox(height: 12),
            AnimatedContainerWidget(),

            SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

/// Reusable numbered section header.
class _SectionHeader extends StatelessWidget {
  final String number;
  final String title;
  final String subtitle;
  final Color color;

  const _SectionHeader({
    required this.number,
    required this.title,
    required this.subtitle,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          radius: 16,
          backgroundColor: color,
          child: Text(
            number,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
