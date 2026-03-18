# Flutter Animations Demo

**Group:** 20k-1069
**Member:** Abdul Hadi

---

## Overview

A single-page Flutter application that demonstrates **two types of Flutter animations** side-by-side:

| # | Type | Widget Used | Description |
|---|------|-------------|-------------|
| 1 | **Explicit** | `AnimationController` + `AnimatedWidget` | Fade-in logo with slide-up effect |
| 2 | **Implicit** | `AnimatedContainer` + `AnimatedDefaultTextStyle` | Tap-to-expand shape transform |

---

## Project Structure

```
flutter_animations_demo/
├── lib/
│   ├── main.dart                      # App entry point & single-page layout
│   ├── explicit_animation_widget.dart # Section 1 — Explicit animation
│   └── implicit_animation_widget.dart # Section 2 — Implicit animation
├── pubspec.yaml
└── README.md
```

---

## Section 1 — Explicit Animation (Fade-In Logo)

**File:** `lib/explicit_animation_widget.dart`

### How it works

Explicit animations require you to **manually manage** the animation lifecycle using an `AnimationController`.

```
AnimationController  ──drives──►  CurvedAnimation  ──drives──►  Tween  ──produces──►  Animation<T>
        │                                                                                     │
        └── forward() / reset()                                              LogoFade listens ┘
```

### Key classes

| Class | Role |
|-------|------|
| `AnimationController` | Drives the animation, produces values 0.0 → 1.0 over a duration |
| `CurvedAnimation` | Wraps the controller to apply `Curves.easeInOut` |
| `Tween<double>` | Maps the 0–1 range to a meaningful opacity value |
| `Tween<Offset>` | Maps the 0–1 range to a slide offset for a slide-up effect |
| `AnimatedWidget` | Base class for `LogoFade`; auto-rebuilds on each animation tick |
| `SingleTickerProviderStateMixin` | Provides the vsync ticker to the controller |

### Code highlights

```dart
// 1. Create the controller
_controller = AnimationController(
  vsync: this,
  duration: const Duration(milliseconds: 1800),
);

// 2. Apply an easing curve
final curved = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);

// 3. Create typed animations via Tweens
_opacityAnim = Tween<double>(begin: 0.0, end: 1.0).animate(curved);
_slideAnim   = Tween<Offset>(begin: Offset(0, 0.25), end: Offset.zero).animate(curved);

// 4. Start the animation
_controller.forward();

// 5. LogoFade (AnimatedWidget) rebuilds automatically on every tick
class LogoFade extends AnimatedWidget {
  @override
  Widget build(BuildContext context) {
    final opacity = (listenable as Animation<double>).value;
    return Opacity(opacity: opacity, child: ...);
  }
}
```

> **Key insight:** By extending `AnimatedWidget`, `LogoFade` calls `build()` on every animation tick without any `setState()` in the parent — clean, decoupled, and efficient.

---

## Section 2 — Implicit Animation (AnimatedContainer)

**File:** `lib/implicit_animation_widget.dart`

### How it works

Implicit animations are the **simplest animation approach** in Flutter. You only need to:

1. Use an `Animated*` widget (e.g. `AnimatedContainer`).
2. Call `setState()` to change a property.
3. Flutter **automatically interpolates** between old and new values.

No `AnimationController` needed.

### Key classes

| Class | Role |
|-------|------|
| `AnimatedContainer` | Tweens `width`, `height`, `color`, `borderRadius`, `boxShadow` automatically |
| `AnimatedDefaultTextStyle` | Tweens `fontSize` and `fontWeight` automatically |

### Code highlights

```dart
// All you do is change state — Flutter handles the rest.
void _toggle() => setState(() => _expanded = !_expanded);

AnimatedContainer(
  duration: Duration(milliseconds: 550),
  curve: Curves.easeInOutCubic,

  // These all animate automatically when _expanded changes:
  width: _expanded ? 200.0 : 110.0,
  height: _expanded ? 200.0 : 110.0,
  decoration: BoxDecoration(
    color: _expanded ? Colors.orange.shade400 : Colors.teal.shade500,
    borderRadius: BorderRadius.circular(_expanded ? 60.0 : 12.0),
  ),
  child: ...,
)
```

> **Key insight:** `AnimatedContainer` compares its current and previous decoration values and generates intermediate frames for free — no animation plumbing required.

---

## Explicit vs Implicit — Quick Comparison

| | Explicit | Implicit |
|---|---|---|
| **Controller needed?** | ✅ Yes | ❌ No |
| **Fine-grained control?** | ✅ Yes (pause, reverse, speed) | ❌ Limited |
| **Boilerplate** | More | Less |
| **Best for** | Complex, sequenced, or looping animations | Simple property transitions |
| **Flutter classes** | `AnimationController`, `AnimatedWidget`, `Tween` | `AnimatedContainer`, `AnimatedOpacity`, etc. |

---

## How to Run

```bash
# Get dependencies
flutter pub get

# Run on a connected device or emulator
flutter run
```

**Minimum Flutter SDK:** 3.0.0
**Dart SDK:** ≥ 3.0.0

---

## References

- [Flutter Animations Tutorial — simplifying with AnimatedWidget](https://docs.flutter.dev/ui/animations/tutorial#simplifying-with-animatedwidget)
- [Advanced Flutter Animations Codelab](https://codelabs.developers.google.com/advanced-flutter-animations)
