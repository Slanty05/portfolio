import 'package:flutter/widgets.dart';

import 'breakpoints.dart';

typedef ResponsiveWidgetBuilder = Widget Function(BuildContext context);

class ResponsiveBuilder extends StatelessWidget {
  const ResponsiveBuilder({
    super.key,
    required this.mobile,
    required this.tablet,
    required this.desktop,
  });

  final ResponsiveWidgetBuilder mobile;
  final ResponsiveWidgetBuilder tablet;
  final ResponsiveWidgetBuilder desktop;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    if (width <= Breakpoints.mobileMax) return mobile(context);
    if (width <= Breakpoints.tabletMax) return tablet(context);
    return desktop(context);
  }
}

