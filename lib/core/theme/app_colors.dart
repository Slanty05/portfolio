import 'package:flutter/material.dart';

/// Comprehensive color system for the portfolio app
/// Provides semantic colors that adapt to light/dark themes automatically
class AppColors {
  AppColors._();

  // ==================== BRAND COLORS ====================
  /// Primary brand color - Navy Blue
  static const Color primaryNavy = Color(0xFF0A192F);
  
  /// Secondary accent color - Emerald Green
  static const Color accentEmerald = Color(0xFF10B981);
  
  /// Additional brand colors for variety
  static const Color accentBlue = Color(0xFF3B82F6);
  static const Color accentPurple = Color(0xFF8B5CF6);
  static const Color accentOrange = Color(0xFFF97316);

  // ==================== NEUTRAL PALETTE ====================
  // Light Mode Neutrals
  static const Color lightBackground = Color(0xFFF9FAFB);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightSurfaceVariant = Color(0xFFF3F4F6);
  static const Color lightOnSurface = Color(0xFF111827);
  static const Color lightOnSurfaceVariant = Color(0xFF6B7280);
  
  // Dark Mode Neutrals (Linear-style Deep Charcoal)
  static const Color darkBackground = Color(0xFF0D1117);
  static const Color darkSurface = Color(0xFF161B22);
  static const Color darkSurfaceVariant = Color(0xFF21262D);
  static const Color darkOnSurface = Color(0xFFF0F6FC);
  static const Color darkOnSurfaceVariant = Color(0xFF8B949E);

  // ==================== SEMANTIC COLORS ====================
  // Success Colors
  static const Color successLight = Color(0xFF10B981);
  static const Color successDark = Color(0xFF34D399);
  static const Color successSurfaceLight = Color(0xFFECFDF5);
  static const Color successSurfaceDark = Color(0xFF064E3B);

  // Warning Colors
  static const Color warningLight = Color(0xFFF59E0B);
  static const Color warningDark = Color(0xFFFBBf24);
  static const Color warningSurfaceLight = Color(0xFFFEF3C7);
  static const Color warningSurfaceDark = Color(0xFF451A03);

  // Error Colors
  static const Color errorLight = Color(0xFFEF4444);
  static const Color errorDark = Color(0xFFF87171);
  static const Color errorSurfaceLight = Color(0xFFFEF2F2);
  static const Color errorSurfaceDark = Color(0xFF7F1D1D);

  // Info Colors
  static const Color infoLight = Color(0xFF3B82F6);
  static const Color infoDark = Color(0xFF60A5FA);
  static const Color infoSurfaceLight = Color(0xFFEFF6FF);
  static const Color infoSurfaceDark = Color(0xFF1E3A8A);

  // ==================== TEXT COLORS ====================
  // Light Mode Text Colors
  static const Color lightTextPrimary = Color(0xFF111827);
  static const Color lightTextSecondary = Color(0xFF6B7280);
  static const Color lightTextTertiary = Color(0xFF9CA3AF);
  static const Color lightTextDisabled = Color(0xFFD1D5DB);
  static const Color lightTextOnPrimary = Color(0xFFFFFFFF);

  // Dark Mode Text Colors
  static const Color darkTextPrimary = Color(0xFFF0F6FC);
  static const Color darkTextSecondary = Color(0xFF8B949E);
  static const Color darkTextTertiary = Color(0xFF484F58);
  static const Color darkTextDisabled = Color(0xFF30363D);
  static const Color darkTextOnPrimary = Color(0xFF0D1117);

  // ==================== BORDER & DIVIDER COLORS ====================
  static const Color lightBorder = Color(0xFFE5E7EB);
  static const Color lightBorderStrong = Color(0xFFD1D5DB);
  static const Color darkBorder = Color(0xFF30363D);
  static const Color darkBorderStrong = Color(0xFF21262D);

  // ==================== SHADOW COLORS ====================
  static const Color shadowLight = Color(0x1A000000);
  static const Color shadowMedium = Color(0x33000000);
  static const Color shadowStrong = Color(0x4D000000);

  // ==================== OVERLAY COLORS ====================
  static const Color overlayLight = Color(0x80000000);
  static const Color overlayDark = Color(0x80FFFFFF);

  // ==================== GRADIENTS ====================
  static const List<Color> primaryGradient = [primaryNavy, accentBlue];
  static const List<Color> accentGradient = [accentEmerald, accentBlue];
  static const List<Color> sunsetGradient = [accentOrange, accentPurple];
}

/// Extension on ColorScheme to easily access app colors
extension ColorSchemeExtensions on ColorScheme {
  // ==================== BRAND COLORS ====================
  Color get brandPrimary => AppColors.primaryNavy;
  Color get brandSecondary => AppColors.accentEmerald;
  Color get brandAccent => AppColors.accentBlue;
  Color get brandPurple => AppColors.accentPurple;
  Color get brandOrange => AppColors.accentOrange;

  // ==================== SURFACE COLORS ====================
  Color get surfaceBackground => brightness == Brightness.dark 
      ? AppColors.darkBackground 
      : AppColors.lightBackground;
      
  Color get surfaceCard => brightness == Brightness.dark 
      ? AppColors.darkSurface 
      : AppColors.lightSurface;
      
  Color get surfaceVariant => brightness == Brightness.dark 
      ? AppColors.darkSurfaceVariant 
      : AppColors.lightSurfaceVariant;

  // ==================== TEXT COLORS ====================
  Color get textPrimary => brightness == Brightness.dark 
      ? AppColors.darkTextPrimary 
      : AppColors.lightTextPrimary;
      
  Color get textSecondary => brightness == Brightness.dark 
      ? AppColors.darkTextSecondary 
      : AppColors.lightTextSecondary;
      
  Color get textTertiary => brightness == Brightness.dark 
      ? AppColors.darkTextTertiary 
      : AppColors.lightTextTertiary;
      
  Color get textDisabled => brightness == Brightness.dark 
      ? AppColors.darkTextDisabled 
      : AppColors.lightTextDisabled;

  // ==================== SEMANTIC COLORS ====================
  Color get success => brightness == Brightness.dark 
      ? AppColors.successDark 
      : AppColors.successLight;
      
  Color get successSurface => brightness == Brightness.dark 
      ? AppColors.successSurfaceDark 
      : AppColors.successSurfaceLight;
      
  Color get warning => brightness == Brightness.dark 
      ? AppColors.warningDark 
      : AppColors.warningLight;
      
  Color get warningSurface => brightness == Brightness.dark 
      ? AppColors.warningSurfaceDark 
      : AppColors.warningSurfaceLight;
      
  Color get error => brightness == Brightness.dark 
      ? AppColors.errorDark 
      : AppColors.errorLight;
      
  Color get errorSurface => brightness == Brightness.dark 
      ? AppColors.errorSurfaceDark 
      : AppColors.errorSurfaceLight;
      
  Color get info => brightness == Brightness.dark 
      ? AppColors.infoDark 
      : AppColors.infoLight;
      
  Color get infoSurface => brightness == Brightness.dark 
      ? AppColors.infoSurfaceDark 
      : AppColors.infoSurfaceLight;

  // ==================== BORDER COLORS ====================
  Color get border => brightness == Brightness.dark 
      ? AppColors.darkBorder 
      : AppColors.lightBorder;
      
  Color get borderStrong => brightness == Brightness.dark 
      ? AppColors.darkBorderStrong 
      : AppColors.lightBorderStrong;

  // ==================== OVERLAY COLORS ====================
  Color get overlay => brightness == Brightness.dark 
      ? AppColors.overlayDark 
      : AppColors.overlayLight;
}

/// Extension on BuildContext to easily access colors
extension BuildContextExtensions on BuildContext {
  // ==================== BRAND COLORS ====================
  Color get brandPrimary => Theme.of(this).colorScheme.brandPrimary;
  Color get brandSecondary => Theme.of(this).colorScheme.brandSecondary;
  Color get brandAccent => Theme.of(this).colorScheme.brandAccent;
  Color get brandPurple => Theme.of(this).colorScheme.brandPurple;
  Color get brandOrange => Theme.of(this).colorScheme.brandOrange;

  // ==================== SURFACE COLORS ====================
  Color get surfaceBackground => Theme.of(this).colorScheme.surfaceBackground;
  Color get surfaceCard => Theme.of(this).colorScheme.surfaceCard;
  Color get surfaceVariant => Theme.of(this).colorScheme.surfaceVariant;

  // ==================== TEXT COLORS ====================
  Color get textPrimary => Theme.of(this).colorScheme.textPrimary;
  Color get textSecondary => Theme.of(this).colorScheme.textSecondary;
  Color get textTertiary => Theme.of(this).colorScheme.textTertiary;
  Color get textDisabled => Theme.of(this).colorScheme.textDisabled;

  // ==================== SEMANTIC COLORS ====================
  Color get success => Theme.of(this).colorScheme.success;
  Color get successSurface => Theme.of(this).colorScheme.successSurface;
  Color get warning => Theme.of(this).colorScheme.warning;
  Color get warningSurface => Theme.of(this).colorScheme.warningSurface;
  Color get error => Theme.of(this).colorScheme.error;
  Color get errorSurface => Theme.of(this).colorScheme.errorSurface;
  Color get info => Theme.of(this).colorScheme.info;
  Color get infoSurface => Theme.of(this).colorScheme.infoSurface;

  // ==================== BORDER COLORS ====================
  Color get border => Theme.of(this).colorScheme.border;
  Color get borderStrong => Theme.of(this).colorScheme.borderStrong;

  // ==================== OVERLAY COLORS ====================
  Color get overlay => Theme.of(this).colorScheme.overlay;
}
