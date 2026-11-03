import 'package:flutter/material.dart';

// ─── Breakpoints ──────────────────────────────────────────────────────────────
// Mobile   : width < 600
// Tablet   : 600 <= width < 900
// Desktop  : width >= 900

class Breakpoints {
  static const double mobile = 600;
  static const double tablet = 900;
  static const double desktop = 1200;

  // Content max-width for large screens.
  static const double maxContentWidth = 1100;
  // Form / card max-width on desktop.
  static const double maxFormWidth = 520;
}

// ─── Responsive helper ────────────────────────────────────────────────────────
class Responsive {
  final double width;

  const Responsive(this.width);

  factory Responsive.of(BuildContext context) =>
      Responsive(MediaQuery.of(context).size.width);

  bool get isMobile => width < Breakpoints.mobile;
  bool get isTablet => width >= Breakpoints.mobile && width < Breakpoints.tablet;
  bool get isDesktop => width >= Breakpoints.tablet;
  bool get isLargeDesktop => width >= Breakpoints.desktop;

  // Convenience selector — returns one of three values depending on screen class.
  T select<T>({required T mobile, required T tablet, required T desktop}) {
    if (isDesktop) return desktop;
    if (isTablet) return tablet;
    return mobile;
  }

  // Grid cross-axis count for alumni cards.
  int get alumniGridCount => select(mobile: 1, tablet: 2, desktop: 3);

  // Grid cross-axis count for domain cards.
  int get domainGridCount => select(mobile: 2, tablet: 3, desktop: 4);

  // Horizontal padding for main content areas.
  double get horizontalPadding => select(mobile: 16, tablet: 24, desktop: 32);

  // Whether to show a persistent sidebar / NavigationRail.
  bool get showSidebar => isDesktop;
  bool get showRail => isTablet;
  bool get showBottomNav => isMobile;
}

// ─── Centred, max-width content wrapper ──────────────────────────────────────
class ContentWrapper extends StatelessWidget {
  final Widget child;
  final double maxWidth;
  final EdgeInsetsGeometry? padding;

  const ContentWrapper({
    super.key,
    required this.child,
    this.maxWidth = Breakpoints.maxContentWidth,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final r = Responsive.of(context);
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: Padding(
          padding: padding ??
              EdgeInsets.symmetric(horizontal: r.horizontalPadding),
          child: child,
        ),
      ),
    );
  }
}

// ─── Form card wrapper (login / auth screens) ─────────────────────────────────
class FormWrapper extends StatelessWidget {
  final Widget child;

  const FormWrapper({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final r = Responsive.of(context);
    if (r.isMobile) return child;
    return Center(
      child: ConstrainedBox(
        constraints:
            const BoxConstraints(maxWidth: Breakpoints.maxFormWidth),
        child: child,
      ),
    );
  }
}

