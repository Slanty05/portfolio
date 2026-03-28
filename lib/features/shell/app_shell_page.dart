import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';

import '../../core/responsive/responsive_builder.dart';
import '../../core/router/app_routes.dart';
import 'widgets/premium_bottom_nav.dart';
import 'widgets/nav_model.dart';

class AppShellPage extends StatelessWidget {
  const AppShellPage({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  void _goBranch(int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  static final _destinations = [
    NavItemModel(
      label: 'Home',
      icon: Icons.home_outlined,
      activeIcon: Icons.home,
    ),
    NavItemModel(
      label: 'Projects',
      icon: Icons.work_outline,
      activeIcon: Icons.work,
    ),
    NavItemModel(
      label: 'Experience',
      icon: Icons.timeline_outlined,
      activeIcon: Icons.timeline,
    ),
    NavItemModel(
      label: 'Settings',
      icon: Icons.settings_outlined,
      activeIcon: Icons.settings,
    ),
  ];

  static final _routes = [
    AppRoutes.home,
    AppRoutes.projects,
    AppRoutes.experience,
    AppRoutes.settings,
  ];

  @override
  Widget build(BuildContext context) {
    final title = _destinations[navigationShell.currentIndex].label;
    final currentIndex = navigationShell.currentIndex;

    return ResponsiveBuilder(
      mobile: (context) {
        return Scaffold(
          extendBody: true,
          body: navigationShell,
          bottomNavigationBar: PremiumBottomNav(
            currentIndex: currentIndex,
            onTap: _goBranch,
            items: _destinations,
          ),
        );
      },
      tablet: (context) {
        return Scaffold(
          appBar: AppBar(title: Text(title), centerTitle: false),
          body: Row(
            children: [
              NavigationRail(
                selectedIndex: navigationShell.currentIndex,
                onDestinationSelected: _goBranch,
                labelType: NavigationRailLabelType.all,
                destinations: [
                  for (final d in _destinations)
                    NavigationRailDestination(
                      icon: Icon(d.icon),
                      selectedIcon: Icon(d.activeIcon),
                      label: Text(d.label),
                    ),
                ],
              ),
              const VerticalDivider(width: 1),
              Expanded(child: navigationShell),
            ],
          ).animate().fadeIn(duration: 260.ms),
        );
      },
      desktop: (context) {
        return Scaffold(
          appBar: AppBar(
            title: Text(title),
            centerTitle: false,
            actions: [
              _Breadcrumbs(currentRoute: _routes[navigationShell.currentIndex]),
              const SizedBox(width: 12),
            ],
          ),
          body: Row(
            children: [
              NavigationRail(
                extended: true,
                selectedIndex: navigationShell.currentIndex,
                onDestinationSelected: _goBranch,
                destinations: [
                  for (final d in _destinations)
                    NavigationRailDestination(
                      icon: Icon(d.icon),
                      selectedIcon: Icon(d.activeIcon),
                      label: Text(d.label),
                    ),
                ],
              ),
              const VerticalDivider(width: 1),
              Expanded(
                child: Align(
                  alignment: Alignment.topCenter,
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 1100),
                    child: navigationShell,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _Breadcrumbs extends StatelessWidget {
  const _Breadcrumbs({required this.currentRoute});

  final String currentRoute;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _BreadcrumbItem(label: _getRouteLabel(currentRoute), isLast: true),
        ],
      ),
    );
  }

  String _getRouteLabel(String route) {
    return switch (route) {
      AppRoutes.home => 'Home',
      AppRoutes.projects => 'Projects',
      AppRoutes.experience => 'Experience',
      AppRoutes.settings => 'Settings',
      _ => route,
    };
  }
}

class _BreadcrumbItem extends StatelessWidget {
  const _BreadcrumbItem({required this.label, required this.isLast});

  final String label;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Text(
          label,
          style: TextStyle(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
            fontSize: 14,
            fontWeight: isLast ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
      ],
    );
  }
}
