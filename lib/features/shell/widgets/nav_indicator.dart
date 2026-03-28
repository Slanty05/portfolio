import 'package:flutter/material.dart';

class NavIndicator extends StatelessWidget {
  const NavIndicator({
    super.key,
    required this.currentIndex,
    required this.itemCount,
    this.height = 48,
    this.width = 48,
    this.duration = const Duration(milliseconds: 400),
  });

  final int currentIndex;
  final int itemCount;
  final double height;
  final double width;
  final Duration duration;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        final itemWidth = constraints.maxWidth / itemCount;

        return AnimatedPositioned(
          duration: duration,
          curve: Curves.easeOutCubic,
          left: itemWidth * currentIndex + (itemWidth - width) / 2,
          top: (constraints.maxHeight - height) / 2,
          child: _IndicatorPill(
            width: width,
            height: height,
            color: theme.colorScheme.primary,
          ),
        );
      },
    );
  }
}

class _IndicatorPill extends StatelessWidget {
  const _IndicatorPill({
    required this.width,
    required this.height,
    required this.color,
  });

  final double width;
  final double height;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.9, end: 1.0),
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
      builder: (context, scale, child) {
        return Transform.scale(
          scale: scale,
          child: Container(
            width: width,
            height: height,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: LinearGradient(
                colors: [
                  color.withValues(alpha: 0.15),
                  color.withValues(alpha: 0.08),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: color.withValues(alpha: 0.2),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}