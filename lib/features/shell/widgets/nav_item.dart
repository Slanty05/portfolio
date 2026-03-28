import 'package:flutter/material.dart';
import 'package:portfolio/features/shell/widgets/nav_model.dart';

class PremiumNavItem extends StatelessWidget {
  const PremiumNavItem({
    super.key,
    required this.item,
    required this.isSelected,
    required this.onTap,
  });

  final NavItemModel item;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0, end: isSelected ? 1 : 0),
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeOutCubic,
        builder: (context, value, child) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Transform.translate(
                offset: Offset(0, -6 * value),
                child: Transform.scale(
                  scale: 1 + (0.15 * value),
                  child: Icon(
                    isSelected ? item.activeIcon : item.icon,
                    color: Color.lerp(
                      theme.colorScheme.onSurfaceVariant,
                      theme.colorScheme.primary,
                      value,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 2),

              ClipRect(
                child: Align(
                  heightFactor: value,
                  child: Opacity(
                    opacity: value,
                    child: Text(
                      item.label,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
