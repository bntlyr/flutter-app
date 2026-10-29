import 'package:flutter/material.dart';

/// Centralized raw and semantic color tokens for the application.
class AppColors {
  AppColors._();

  // Core Brand Palette
  static const Color primary = Color(0xFF55AAAA);
  static const Color primaryDark = Color(0xFF3B7B7B);
  static const Color primaryLight = Color(0xFFE2F4F4);

  // Neutral & Surface Grays
  static const Color gray = Color(0xFF303030);
  static const Color grayLight = Color(0xFF757575);
  static const Color grayBorder = Color(0xFFE0E0E0);
  static const Color surfaceLight = Color(0xFFFAFAFA);

  // Black / High Emphasis Text (87% alpha)
  static const Color mainBlack = Color(0xDE000000);
  static const Color secondaryBlack = Color(0x99000000);

  // Accent & Functional Colors
  static const Color white = Color(0xFFFFFFFF);
  static const Color error = Color(0xFFD32F2F);
  static const Color success = Color(0xFF2E7D32);
}

/// ThemeExtension providing custom semantic tokens accessible directly
/// through `Theme.of(context).extension<AppCustomColors>()`.
@immutable
class AppCustomColors extends ThemeExtension<AppCustomColors> {
  const AppCustomColors({
    required this.brandPrimary,
    required this.brandGray,
    required this.mainBlack,
    required this.cardBackground,
  });

  final Color brandPrimary;
  final Color brandGray;
  final Color mainBlack;
  final Color cardBackground;

  static const light = AppCustomColors(
    brandPrimary: AppColors.primary,
    brandGray: AppColors.gray,
    mainBlack: AppColors.mainBlack,
    cardBackground: AppColors.white,
  );

  static const dark = AppCustomColors(
    brandPrimary: AppColors.primary,
    brandGray: AppColors.gray,
    mainBlack: AppColors.white,
    cardBackground: AppColors.gray,
  );

  @override
  AppCustomColors copyWith({
    Color? brandPrimary,
    Color? brandGray,
    Color? mainBlack,
    Color? cardBackground,
  }) {
    return AppCustomColors(
      brandPrimary: brandPrimary ?? this.brandPrimary,
      brandGray: brandGray ?? this.brandGray,
      mainBlack: mainBlack ?? this.mainBlack,
      cardBackground: cardBackground ?? this.cardBackground,
    );
  }

  @override
  AppCustomColors lerp(ThemeExtension<AppCustomColors>? other, double t) {
    if (other is! AppCustomColors) {
      return this;
    }
    return AppCustomColors(
      brandPrimary: Color.lerp(brandPrimary, other.brandPrimary, t)!,
      brandGray: Color.lerp(brandGray, other.brandGray, t)!,
      mainBlack: Color.lerp(mainBlack, other.mainBlack, t)!,
      cardBackground: Color.lerp(cardBackground, other.cardBackground, t)!,
    );
  }
}

/// Convenience extension on [BuildContext] for concise theme color lookup.
extension AppThemeContextExtension on BuildContext {
  AppCustomColors get customColors =>
      Theme.of(this).extension<AppCustomColors>() ?? AppCustomColors.light;
}
