import 'package:flutter/material.dart';

class AppThemeConstants {
  AppThemeConstants._(); // Private constructor

  // ==================== SPACING ====================
  static const double spacingXxs = 4.0;
  static const double spacingXs = 8.0;
  static const double spacingSm = 12.0;
  static const double spacingMd = 16.0;
  static const double spacingLg = 24.0;
  static const double spacingXl = 32.0;
  static const double spacingXxl = 48.0;
  static const double spacingXxxl = 64.0;

  // ==================== BORDER RADIUS ====================
  static const double radiusXs = 4.0;
  static const double radiusSm = 6.0;
  static const double radiusMd = 8.0;
  static const double radiusLg = 12.0;
  static const double radiusXl = 16.0;
  static const double radiusXxl = 20.0;
  static const double radiusXxxl = 24.0;
  static const double radiusFull = 999.0;

  // ==================== ELEVATION ====================
  static const double elevationXs = 1.0;
  static const double elevationSm = 2.0;
  static const double elevationMd = 4.0;
  static const double elevationLg = 8.0;
  static const double elevationXl = 12.0;
  static const double elevationXxl = 16.0;

  // ==================== ICON SIZES ====================
  static const double iconXs = 16.0;
  static const double iconSm = 20.0;
  static const double iconMd = 24.0;
  static const double iconLg = 32.0;
  static const double iconXl = 40.0;
  static const double iconXxl = 48.0;

  // ==================== STROKE WIDTH ====================
  static const double strokeThin = 1.0;
  static const double strokeNormal = 2.0;
  static const double strokeThick = 3.0;
  static const double strokeXThick = 4.0;

  // ==================== OPACITY ====================
  static const double opacityDisabled = 0.38;
  static const double opacityHover = 0.08;
  static const double opacityPressed = 0.12;
  static const double opacityFocus = 0.12;
  static const double opacitySelected = 0.16;

  // ==================== ANIMATION DURATION ====================
  static const Duration durationFast = Duration(milliseconds: 150);
  static const Duration durationNormal = Duration(milliseconds: 250);
  static const Duration durationSlow = Duration(milliseconds: 350);
  static const Duration durationSlower = Duration(milliseconds: 500);

  // ==================== TYPOGRAPHY SCALE ====================
  static const double textScaleXs = 0.75;
  static const double textScaleSm = 0.875;
  static const double textScaleMd = 1.0;
  static const double textScaleLg = 1.125;
  static const double textScaleXl = 1.25;
  static const double textScaleXxl = 1.5;
  static const double textScaleXxxl = 1.875;
  static const double textScaleXxxxl = 2.25;

  // ==================== LETTER SPACING ====================
  static const double letterSpacingTight = -0.5;
  static const double letterSpacingNormal = 0.0;
  static const double letterSpacingWide = 0.25;
  static const double letterSpacingWider = 0.5;
  static const double letterSpacingWidest = 1.0;

  // ==================== LINE HEIGHT ====================
  static const double lineHeightTight = 1.25;
  static const double lineHeightNormal = 1.5;
  static const double lineHeightRelaxed = 1.75;
  static const double lineHeightLoose = 2.0;

  // ==================== BREAKPOINTS ====================
  static const double breakpointSm = 640.0;
  static const double breakpointMd = 768.0;
  static const double breakpointLg = 1024.0;
  static const double breakpointXl = 1280.0;
  static const double breakpointXxl = 1536.0;

  // ==================== COMPONENT SIZES ====================
  static const double buttonHeightSm = 32.0;
  static const double buttonHeightMd = 40.0;
  static const double buttonHeightLg = 48.0;
  static const double buttonHeightXl = 56.0;

  static const double inputHeightSm = 32.0;
  static const double inputHeightMd = 40.0;
  static const double inputHeightLg = 48.0;

  static const double appBarHeight = 56.0;
  static const double bottomNavHeight = 64.0;
  static const double fabSize = 56.0;
  static const double avatarSizeSm = 32.0;
  static const double avatarSizeMd = 40.0;
  static const double avatarSizeLg = 48.0;
  static const double avatarSizeXl = 64.0;

  // ==================== SHADOWS ====================
  static const List<BoxShadow> shadowXs = [
    BoxShadow(
      color: Color(0x0A000000),
      offset: Offset(0, 1),
      blurRadius: 2,
      spreadRadius: 0,
    ),
  ];

  static const List<BoxShadow> shadowSm = [
    BoxShadow(
      color: Color(0x0F000000),
      offset: Offset(0, 1),
      blurRadius: 3,
      spreadRadius: 0,
    ),
  ];

  static const List<BoxShadow> shadowMd = [
    BoxShadow(
      color: Color(0x1A000000),
      offset: Offset(0, 4),
      blurRadius: 6,
      spreadRadius: -1,
    ),
  ];

  static const List<BoxShadow> shadowLg = [
    BoxShadow(
      color: Color(0x1A000000),
      offset: Offset(0, 10),
      blurRadius: 15,
      spreadRadius: -3,
    ),
  ];

  static const List<BoxShadow> shadowXl = [
    BoxShadow(
      color: Color(0x1F000000),
      offset: Offset(0, 20),
      blurRadius: 25,
      spreadRadius: -5,
    ),
  ];

  // ==================== GRADIENTS ====================
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF0A192F), Color(0xFF3B82F6)],
  );

  static const LinearGradient accentGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF10B981), Color(0xFF3B82F6)],
  );

  static const LinearGradient sunsetGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFF97316), Color(0xFF8B5CF6)],
  );
}
