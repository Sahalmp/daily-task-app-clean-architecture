import 'package:flutter/material.dart';

enum Priority { high, medium, low }

class AppColors {
  static const Color high = Color(0xFFD32F2F);
  static const Color medium = Color(0xFFF9A825);
  static const Color low = Color(0xFF2E7D32);
}

class AppTheme {
  static ThemeData get lightTheme {
    final base = ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF4F46E5)),
    );
    return base.copyWith(
      textTheme: base.textTheme,
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: base.colorScheme.primary,
          foregroundColor: base.colorScheme.onPrimary,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: base.colorScheme.primary,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
      inputDecorationTheme: const InputDecorationTheme(
        border: OutlineInputBorder(),
      ),
    );
  }

  static ThemeData get darkTheme {
    const background = Color(0xFF0B0B0F);
    const surface = Color(0xFF121216);
    const white = Color(0xFFFFFFFF);
    const black = Color(0xFF000000);
    const outline = Color(0xFF2A2A32);

    const colorScheme = ColorScheme(
      brightness: Brightness.dark,
      primary: white,
      onPrimary: black,
      secondary: Color(0xFFE5E7EB),
      onSecondary: black,
      surface: surface,
      onSurface: white,
      error: Color(0xFFEF4444),
      onError: black,
      tertiary: Color(0xFF9CA3AF),
      onTertiary: black,
      primaryContainer: surface,
      onPrimaryContainer: white,
      secondaryContainer: surface,
      onSecondaryContainer: white,
      tertiaryContainer: surface,
      onTertiaryContainer: white,
      errorContainer: Color(0xFF7F1D1D),
      onErrorContainer: white,
      surfaceTint: Colors.transparent,
      inverseSurface: Color(0xFFE5E7EB),
      onInverseSurface: black,
      inversePrimary: black,
      shadow: black,
      outline: outline,
      scrim: black,
    );

    final base = ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: background,
    );

    return base.copyWith(
      appBarTheme: const AppBarTheme(
        backgroundColor: background,
        foregroundColor: white,
        elevation: 0,
        centerTitle: false,
      ),
      cardColor: surface,
      dividerColor: outline,
      textTheme: base.textTheme.apply(
        bodyColor: white,
        displayColor: white,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: white,
          foregroundColor: black,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: white,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
      inputDecorationTheme: const InputDecorationTheme(
        filled: true,
        fillColor: surface,
        border: OutlineInputBorder(borderSide: BorderSide(color: outline)),
        enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: outline)),
        focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Color(0xFFE5E7EB))),
        hintStyle: TextStyle(color: Color(0xFF9CA3AF)),
        labelStyle: TextStyle(color: white),
      ),
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) => states.contains(WidgetState.selected) ? white : outline),
        checkColor: const WidgetStatePropertyAll<Color>(black),
        side: const BorderSide(color: outline),
      ),
      listTileTheme: const ListTileThemeData(
        iconColor: white,
        textColor: white,
      ),
      iconTheme: const IconThemeData(color: white),
    );
  }
}

extension PriorityX on Priority {
  String get label => switch (this) {
        Priority.high => 'High',
        Priority.medium => 'Medium',
        Priority.low => 'Low',
      };

  Color get color => switch (this) {
        Priority.high => AppColors.high,
        Priority.medium => AppColors.medium,
        Priority.low => AppColors.low,
      };
}