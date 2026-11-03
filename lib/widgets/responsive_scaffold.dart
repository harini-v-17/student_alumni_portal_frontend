import 'package:flutter/material.dart';
import '../utils/responsive.dart';
import '../utils/constants.dart';

// ─── Nav destination data ─────────────────────────────────────────────────────
class AppNavDestination {
  final IconData icon;
  final IconData selectedIcon;
  final String label;

  const AppNavDestination({
    required this.icon,
    required this.selectedIcon,
    required this.label,
  });
}

// ─── ResponsiveScaffold ───────────────────────────────────────────────────────
/// A scaffold that shows:
///  • Desktop (≥ 900 px)  → permanent sidebar NavigationDrawer
///  • Tablet  (600–900 px) → NavigationRail
///  • Mobile  (< 600 px)  → BottomNavigationBar / NavigationBar
///
/// Preserves the [AppBar] on all breakpoints (it's hidden only when
/// [hideAppBarOnDesktop] is true).
class ResponsiveScaffold extends StatelessWidget {
  final String title;
  final Color appBarColor;
  final List<AppNavDestination> destinations;
  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;
  final Widget body;
  final List<Widget>? appBarActions;
  final bool hideAppBarOnDesktop;
  final Widget? floatingActionButton;

  const ResponsiveScaffold({
    super.key,
    required this.title,
    required this.destinations,
    required this.selectedIndex,
    required this.onDestinationSelected,
    required this.body,
    this.appBarColor = AppColors.primary,
    this.appBarActions,
    this.hideAppBarOnDesktop = false,
    this.floatingActionButton,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final r = Responsive(constraints.maxWidth);

        if (r.isDesktop) {
          return _DesktopLayout(
            title: title,
            appBarColor: appBarColor,
            destinations: destinations,
            selectedIndex: selectedIndex,
            onDestinationSelected: onDestinationSelected,
            body: body,
            appBarActions: appBarActions,
            hideAppBar: hideAppBarOnDesktop,
            floatingActionButton: floatingActionButton,
          );
        }

        if (r.isTablet) {
          return _TabletLayout(
            title: title,
            appBarColor: appBarColor,
            destinations: destinations,
            selectedIndex: selectedIndex,
            onDestinationSelected: onDestinationSelected,
            body: body,
            appBarActions: appBarActions,
            floatingActionButton: floatingActionButton,
          );
        }

        // Mobile
        return _MobileLayout(
          title: title,
          appBarColor: appBarColor,
          destinations: destinations,
          selectedIndex: selectedIndex,
          onDestinationSelected: onDestinationSelected,
          body: body,
          appBarActions: appBarActions,
          floatingActionButton: floatingActionButton,
        );
      },
    );
  }
}

// ─── Desktop layout ───────────────────────────────────────────────────────────
class _DesktopLayout extends StatelessWidget {
  final String title;
  final Color appBarColor;
  final List<AppNavDestination> destinations;
  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;
  final Widget body;
  final List<Widget>? appBarActions;
  final bool hideAppBar;
  final Widget? floatingActionButton;

  const _DesktopLayout({
    required this.title,
    required this.appBarColor,
    required this.destinations,
    required this.selectedIndex,
    required this.onDestinationSelected,
    required this.body,
    this.appBarActions,
    this.hideAppBar = false,
    this.floatingActionButton,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: hideAppBar
          ? null
          : AppBar(
              backgroundColor: appBarColor,
              foregroundColor: Colors.white,
              elevation: 0,
              automaticallyImplyLeading: false,
              title: Text(
                title,
                style: const TextStyle(
                    fontWeight: FontWeight.w700, fontSize: 17),
              ),
              actions: appBarActions,
            ),
      body: Row(
        children: [
          // ── Permanent sidebar ──────────────────────────────────────────
          _Sidebar(
            appBarColor: appBarColor,
            destinations: destinations,
            selectedIndex: selectedIndex,
            onDestinationSelected: onDestinationSelected,
          ),
          // ── Content area ───────────────────────────────────────────────
          Expanded(child: body),
        ],
      ),
      floatingActionButton: floatingActionButton,
    );
  }
}

// ─── Tablet layout ────────────────────────────────────────────────────────────
class _TabletLayout extends StatelessWidget {
  final String title;
  final Color appBarColor;
  final List<AppNavDestination> destinations;
  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;
  final Widget body;
  final List<Widget>? appBarActions;
  final Widget? floatingActionButton;

  const _TabletLayout({
    required this.title,
    required this.appBarColor,
    required this.destinations,
    required this.selectedIndex,
    required this.onDestinationSelected,
    required this.body,
    this.appBarActions,
    this.floatingActionButton,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: appBarColor,
        foregroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Text(
          title,
          style:
              const TextStyle(fontWeight: FontWeight.w700, fontSize: 17),
        ),
        actions: appBarActions,
      ),
      body: Row(
        children: [
          // ── NavigationRail ─────────────────────────────────────────────
          NavigationRail(
            backgroundColor: appBarColor,
            selectedIndex: selectedIndex,
            onDestinationSelected: onDestinationSelected,
            labelType: NavigationRailLabelType.all,
            selectedIconTheme:
                const IconThemeData(color: Colors.white, size: 22),
            unselectedIconTheme: IconThemeData(
                color: Colors.white.withOpacity(0.55), size: 22),
            selectedLabelTextStyle: const TextStyle(
                color: Colors.white,
                fontSize: 11,
                fontWeight: FontWeight.w700),
            unselectedLabelTextStyle: TextStyle(
                color: Colors.white.withOpacity(0.55), fontSize: 11),
            indicatorColor: Colors.white.withOpacity(0.15),
            destinations: destinations
                .map(
                  (d) => NavigationRailDestination(
                    icon: Icon(d.icon),
                    selectedIcon: Icon(d.selectedIcon),
                    label: Text(d.label),
                  ),
                )
                .toList(),
          ),
          const VerticalDivider(width: 1, thickness: 1),
          // ── Content area ───────────────────────────────────────────────
          Expanded(child: body),
        ],
      ),
      floatingActionButton: floatingActionButton,
    );
  }
}

// ─── Mobile layout ────────────────────────────────────────────────────────────
class _MobileLayout extends StatelessWidget {
  final String title;
  final Color appBarColor;
  final List<AppNavDestination> destinations;
  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;
  final Widget body;
  final List<Widget>? appBarActions;
  final Widget? floatingActionButton;

  const _MobileLayout({
    required this.title,
    required this.appBarColor,
    required this.destinations,
    required this.selectedIndex,
    required this.onDestinationSelected,
    required this.body,
    this.appBarActions,
    this.floatingActionButton,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: appBarColor,
        foregroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Text(
          title,
          style:
              const TextStyle(fontWeight: FontWeight.w700, fontSize: 17),
        ),
        actions: appBarActions,
      ),
      body: body,
      bottomNavigationBar: destinations.length > 1
          ? NavigationBar(
              backgroundColor: Colors.white,
              indicatorColor: appBarColor.withOpacity(0.12),
              selectedIndex: selectedIndex,
              onDestinationSelected: onDestinationSelected,
              labelBehavior:
                  NavigationDestinationLabelBehavior.alwaysShow,
              destinations: destinations
                  .map(
                    (d) => NavigationDestination(
                      icon: Icon(d.icon, color: AppColors.textSecondary),
                      selectedIcon:
                          Icon(d.selectedIcon, color: appBarColor),
                      label: d.label,
                    ),
                  )
                  .toList(),
            )
          : null,
      floatingActionButton: floatingActionButton,
    );
  }
}

// ─── Permanent sidebar ────────────────────────────────────────────────────────
class _Sidebar extends StatelessWidget {
  final Color appBarColor;
  final List<AppNavDestination> destinations;
  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;

  const _Sidebar({
    required this.appBarColor,
    required this.destinations,
    required this.selectedIndex,
    required this.onDestinationSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 220,
      color: appBarColor,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            ...destinations.asMap().entries.map((entry) {
              final i = entry.key;
              final d = entry.value;
              final isSelected = i == selectedIndex;
              return _SidebarItem(
                icon: isSelected ? d.selectedIcon : d.icon,
                label: d.label,
                isSelected: isSelected,
                accentColor: appBarColor,
                onTap: () => onDestinationSelected(i),
              );
            }),
          ],
        ),
      ),
    );
  }
}

class _SidebarItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final Color accentColor;
  final VoidCallback onTap;

  const _SidebarItem({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.accentColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
        padding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? Colors.white.withOpacity(0.18)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Icon(icon,
                size: 20,
                color: isSelected
                    ? Colors.white
                    : Colors.white.withOpacity(0.6)),
            const SizedBox(width: 12),
            Text(
              label,
              style: TextStyle(
                color: isSelected
                    ? Colors.white
                    : Colors.white.withOpacity(0.6),
                fontSize: 13.5,
                fontWeight: isSelected
                    ? FontWeight.w700
                    : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

