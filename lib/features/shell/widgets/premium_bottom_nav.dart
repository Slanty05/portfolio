import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:portfolio/features/shell/widgets/nav_item.dart';
import 'package:portfolio/features/shell/widgets/nav_model.dart';

class PremiumBottomNav extends StatelessWidget {
  const PremiumBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.items,
  });

  final int currentIndex;
  final Function(int) onTap;
  final List<NavItemModel> items;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Container(
          height: 70,
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(32),
            boxShadow: [
              BoxShadow(
                blurRadius: 20,
                offset: const Offset(0, 10),
                color: Colors.black.withOpacity(0.08),
              ),
            ],
          ),
          child: Stack(
            children: [
              /// 🔥 Sliding Indicator (God-level feel)
              AnimatedAlign(
                duration: const Duration(milliseconds: 400),
                curve: Curves.easeOutCubic,
                alignment: Alignment(
                  -1 + (2 * currentIndex / (items.length - 1)),
                  0,
                ),
                child: FractionallySizedBox(
                  widthFactor: 1 / items.length,
                  child: Center(
                    child: Container(
                      width: 60,
                      height: 54,
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary.withValues(
                          alpha: 0.12,
                        ),
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),
                ),
              ),

              /// Items
              Row(
                children: List.generate(
                  items.length,
                  (index) => Expanded(
                    child: PremiumNavItem(
                      item: items[index],
                      isSelected: index == currentIndex,
                      onTap: () {
                        HapticFeedback.lightImpact();
                        onTap(index);
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
