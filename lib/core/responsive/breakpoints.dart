class Breakpoints {
  static const double mobileMax = 600;
  static const double tabletMax = 1024;
  /// Above this width, project grid uses 4 columns (otherwise 3 on desktop).
  static const double desktopWide = 1440;

  /// Projects grid: 1 mobile, 2 tablet, 3 desktop, 4 wide desktop.
  static int projectGridCrossAxisCount(double width) {
    if (width <= mobileMax) return 1;
    if (width <= tabletMax) return 2;
    if (width <= desktopWide) return 3;
    return 4;
  }

  /// Fixed tile height so project cards don’t overflow in the grid.
  static double projectGridMainAxisExtent(double width) {
    final cols = projectGridCrossAxisCount(width);
    return switch (cols) {
      1 => 440,
      2 => 480,
      3 => 520,
      _ => 540,
    };
  }
}

