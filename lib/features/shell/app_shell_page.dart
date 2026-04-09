import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';

import '../../core/responsive/responsive_builder.dart';
import '../../core/router/app_routes.dart';

const _kShellNavAnimDuration = Duration(milliseconds: 320);

class AppShellPage extends StatelessWidget {
  const AppShellPage({
    super.key,
    required this.navigationShell,
  });

  final StatefulNavigationShell navigationShell;

  void _goBranch(int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  static const _destinations = <_NavDestination>[
    _NavDestination(
      label: 'Home',
      icon: Icons.home_outlined,
      selectedIcon: Icons.home,
      route: AppRoutes.home,
    ),
    _NavDestination(
      label: 'Projects',
      icon: Icons.work_outline,
      selectedIcon: Icons.work,
      route: AppRoutes.projects,
    ),
    _NavDestination(
      label: 'Experience',
      icon: Icons.timeline_outlined,
      selectedIcon: Icons.timeline,
      route: AppRoutes.experience,
    ),
    _NavDestination(
      label: 'Settings',
      icon: Icons.settings_outlined,
      selectedIcon: Icons.settings,
      route: AppRoutes.settings,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final title = _destinations[navigationShell.currentIndex].label;
    final currentIndex = navigationShell.currentIndex;

    return ResponsiveBuilder(
      mobile: (context) {
        return Scaffold(
          extendBody: true,
          body: _TabChangePageTransition(
            axis: _TabTransitionAxis.horizontal,
            index: currentIndex,
            navigationShell: navigationShell,
          ),
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.fromLTRB(22, 0, 22, 20),
            child: Transform.translate(
              offset: const Offset(0, -8),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Container(
                  height: 66,
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Row(
                    children: [
                      for (var i = 0; i < _destinations.length; i++)
                        Expanded(
                          child: _MobileNavItem(
                            destination: _destinations[i],
                            selected: i == currentIndex,
                            onTap: () => _goBranch(i),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
      tablet: (context) {
        final scheme = Theme.of(context).colorScheme;
        return Scaffold(
          appBar: AppBar(
            title: _AnimatedAppBarTitle(
              index: currentIndex,
              text: title,
            ),
            centerTitle: false,
            elevation: 0,
            scrolledUnderElevation: 0,
            surfaceTintColor: Colors.transparent,
            backgroundColor: scheme.surface,
          ),
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
                      selectedIcon: Icon(d.selectedIcon),
                      label: Text(d.label),
                    ),
                ],
              ),
              const VerticalDivider(width: 1),
              Expanded(
                child: _TabChangePageTransition(
                  axis: _TabTransitionAxis.vertical,
                  index: currentIndex,
                  navigationShell: navigationShell,
                ),
              ),
            ],
          ),
        );
      },
      desktop: (context) {
        final scheme = Theme.of(context).colorScheme;
        return Scaffold(
          appBar: AppBar(
            title: _AnimatedAppBarTitle(
              index: currentIndex,
              text: title,
            ),
            centerTitle: false,
            elevation: 0,
            scrolledUnderElevation: 0,
            surfaceTintColor: Colors.transparent,
            backgroundColor: scheme.surface,
            actions: [
              _AnimatedAppBarTrailing(
                index: currentIndex,
                child: _Breadcrumbs(
                  currentRoute: _destinations[navigationShell.currentIndex].route,
                ),
              ),
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
                      selectedIcon: Icon(d.selectedIcon),
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
                    child: _TabChangePageTransition(
                      axis: _TabTransitionAxis.vertical,
                      index: currentIndex,
                      navigationShell: navigationShell,
                    ),
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

enum _TabTransitionAxis { horizontal, vertical }

/// Animates the shell body on tab change without duplicating [navigationShell]
/// (avoids GlobalKey collisions). Mobile: horizontal slide; tablet/desktop: vertical.
class _TabChangePageTransition extends StatefulWidget {
  const _TabChangePageTransition({
    required this.navigationShell,
    required this.index,
    required this.axis,
  });

  final StatefulNavigationShell navigationShell;
  final int index;
  final _TabTransitionAxis axis;

  @override
  State<_TabChangePageTransition> createState() => _TabChangePageTransitionState();
}

class _TabChangePageTransitionState extends State<_TabChangePageTransition>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  var _forward = true;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: _kShellNavAnimDuration,
    )..value = 1;
  }

  @override
  void didUpdateWidget(covariant _TabChangePageTransition oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.index != widget.index) {
      _forward = widget.index > oldWidget.index;
      _controller.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final slideH = math.min(56.0, size.width * 0.12);
    final slideV = math.min(48.0, size.height * 0.08);

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final t = Curves.easeOutCubic.transform(_controller.value);
        final inv = 1.0 - t;
        final Offset offset;
        if (widget.axis == _TabTransitionAxis.horizontal) {
          offset = Offset(_forward ? slideH * inv : -slideH * inv, 0);
        } else {
          offset = Offset(0, _forward ? slideV * inv : -slideV * inv);
        }
        final opacity = (0.86 + 0.14 * t).clamp(0.0, 1.0);
        return Opacity(
          opacity: opacity,
          child: Transform.translate(
            offset: offset,
            child: child,
          ),
        );
      },
      child: widget.navigationShell,
    );
  }
}

/// Smooth title change when switching tabs (tablet / desktop).
class _AnimatedAppBarTitle extends StatelessWidget {
  const _AnimatedAppBarTitle({
    required this.index,
    required this.text,
  });

  final int index;
  final String text;

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme.titleLarge;
    return AnimatedSwitcher(
      duration: _kShellNavAnimDuration,
      switchInCurve: Curves.easeOutCubic,
      switchOutCurve: Curves.easeInCubic,
      layoutBuilder: (currentChild, previousChildren) {
        return Stack(
          alignment: Alignment.centerLeft,
          clipBehavior: Clip.none,
          children: [
            ...previousChildren,
            ?currentChild,
          ],
        );
      },
      transitionBuilder: (child, animation) {
        final curved = CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutCubic,
          reverseCurve: Curves.easeInCubic,
        );
        return FadeTransition(
          opacity: curved,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0.06, 0),
              end: Offset.zero,
            ).animate(curved),
            child: child,
          ),
        );
      },
      child: Text(
        text,
        key: ValueKey<int>(index),
        style: style,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}

/// Smooth trailing (breadcrumbs) change on desktop when switching tabs.
class _AnimatedAppBarTrailing extends StatelessWidget {
  const _AnimatedAppBarTrailing({
    required this.index,
    required this.child,
  });

  final int index;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: _kShellNavAnimDuration,
      switchInCurve: Curves.easeOutCubic,
      switchOutCurve: Curves.easeInCubic,
      layoutBuilder: (currentChild, previousChildren) {
        return Stack(
          alignment: Alignment.centerRight,
          clipBehavior: Clip.none,
          children: [
            ...previousChildren,
            ?currentChild,
          ],
        );
      },
      transitionBuilder: (child, animation) {
        final curved = CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutCubic,
          reverseCurve: Curves.easeInCubic,
        );
        return FadeTransition(
          opacity: curved,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0.1, 0),
              end: Offset.zero,
            ).animate(curved),
            child: child,
          ),
        );
      },
      child: KeyedSubtree(
        key: ValueKey<int>(index),
        child: child,
      ),
    );
  }
}

class _Breadcrumbs extends StatelessWidget {
  const _Breadcrumbs({required this.currentRoute});

  final String currentRoute;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final crumbs = <String>['Portfolio', _labelFor(currentRoute)];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (var i = 0; i < crumbs.length; i++) ...[
            Text(
              crumbs[i],
              style: theme.textTheme.labelLarge?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            if (i != crumbs.length - 1)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                child: Icon(
                  Icons.chevron_right,
                  size: 18,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
          ],
        ],
      ),
    );
  }

  String _labelFor(String route) {
    return switch (route) {
      AppRoutes.home => 'Home',
      AppRoutes.projects => 'Projects',
      AppRoutes.experience => 'Experience',
      AppRoutes.settings => 'Settings',
      _ => route,
    };
  }
}

class _NavDestination {
  const _NavDestination({
    required this.label,
    required this.icon,
    required this.selectedIcon,
    required this.route,
  });

  final String label;
  final IconData icon;
  final IconData selectedIcon;
  final String route;
}

class _MobileNavItem extends StatelessWidget {
  const _MobileNavItem({
    required this.destination,
    required this.selected,
    required this.onTap,
  });

  final _NavDestination destination;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: onTap,
          child: AnimatedContainer(
            duration: 280.ms,
            curve: Curves.easeOutCubic,
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: selected
                  ? LinearGradient(
                      colors: [
                        scheme.primary.withValues(alpha: 0.28),
                        scheme.tertiary.withValues(alpha: 0.22),
                      ],
                    )
                  : null,
              border: selected
                  ? Border.all(
                      width: 1.4,
                      color: Colors.transparent,
                    )
                  : Border.all(
                      width: 0.6,
                      color: scheme.outlineVariant.withValues(alpha: 0.25),
                    ),
              boxShadow: selected
                  ? [
                      BoxShadow(
                        color: scheme.primary.withValues(alpha: 0.32),
                        blurRadius: 16,
                        spreadRadius: 1,
                        offset: const Offset(0, 0),
                      ),
                    ]
                  : null,
            ),
            child: DecoratedBox(
              decoration: selected
                  ? BoxDecoration(
                      borderRadius: BorderRadius.circular(18),
                      gradient: LinearGradient(
                        colors: [
                          scheme.primary.withValues(alpha: 0.18),
                          scheme.tertiary.withValues(alpha: 0.1),
                        ],
                      ),
                    )
                  : const BoxDecoration(),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TweenAnimationBuilder<double>(
                    tween: Tween<double>(begin: 1, end: selected ? 1.18 : 1),
                    duration: 280.ms,
                    curve: Curves.elasticOut,
                    builder: (context, value, child) {
                      return Transform.scale(scale: value, child: child);
                    },
                    child: Icon(
                      selected ? destination.selectedIcon : destination.icon,
                      size: 22,
                      color: selected
                          ? scheme.primary
                          : scheme.onSurfaceVariant.withValues(alpha: 0.9),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    destination.label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                      color: selected
                          ? scheme.primary
                          : scheme.onSurfaceVariant.withValues(alpha: 0.9),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

