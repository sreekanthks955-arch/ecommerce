import 'package:flutter/material.dart';

class AppTheme {
  // Brand colors
  static const Color blue = Color(0xFF3B50DF);
  static const Color purple = Color(0xFF6366F1);
  static const Color ink = Color(0xFF0F172A);
  static const Color muted = Color(0xFF64748B);
  static const Color canvas = Color(0xFFF8FAFC);
  static const Color border = Color(0xFFE2E8F0);

  // Accent highlights
  static const Color amber = Color(0xFFF59E0B);
  static const Color emerald = Color(0xFF10B981);
  static const Color rose = Color(0xFFF43F5E);

  // Dark palette
  static const Color darkCanvas = Color(0xFF0B0F17);
  static const Color darkCard = Color(0xFF131A26);
  static const Color darkBorder = Color(0xFF1E293B);
  static const Color darkInk = Color(0xFFF8FAFC);
  static const Color darkMuted = Color(0xFF94A3B8);

  static bool isDark(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark;

  static Color surfaceColor(BuildContext context) =>
      isDark(context) ? darkCard : Colors.white;

  static Color scaffoldColor(BuildContext context) =>
      isDark(context) ? darkCanvas : canvas;

  static Color textColor(BuildContext context) =>
      isDark(context) ? darkInk : ink;

  static Color subtleColor(BuildContext context) =>
      isDark(context) ? darkMuted : muted;

  static Color borderColor(BuildContext context) =>
      isDark(context) ? darkBorder : border;

  static ThemeData get light => ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        scaffoldBackgroundColor: canvas,
        colorScheme: ColorScheme.fromSeed(
          seedColor: blue,
          brightness: Brightness.light,
          primary: blue,
          secondary: purple,
          surface: Colors.white,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: canvas,
          foregroundColor: ink,
          elevation: 0,
          scrolledUnderElevation: 0,
          centerTitle: false,
          titleTextStyle: TextStyle(
            color: ink,
            fontSize: 18,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.3,
          ),
        ),
        cardTheme: CardThemeData(
          color: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: const BorderSide(color: border, width: 1),
          ),
        ),
        navigationBarTheme: NavigationBarThemeData(
          height: 68,
          backgroundColor: Colors.white,
          elevation: 4,
          shadowColor: const Color(0x0C000000),
          indicatorColor: const Color(0xFFEEF2FF),
          labelTextStyle: WidgetStateProperty.resolveWith(
            (states) => TextStyle(
              fontSize: 11,
              fontWeight: states.contains(WidgetState.selected)
                  ? FontWeight.w700
                  : FontWeight.w500,
              color: states.contains(WidgetState.selected) ? blue : muted,
            ),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: border, width: 1),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: border, width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: blue, width: 1.6),
          ),
        ),
        textTheme: const TextTheme(
          headlineMedium: TextStyle(
              color: ink, fontWeight: FontWeight.w800, letterSpacing: -0.5),
          titleLarge: TextStyle(
              color: ink, fontWeight: FontWeight.w700, letterSpacing: -0.3),
          titleMedium: TextStyle(
              color: ink, fontWeight: FontWeight.w600, letterSpacing: -0.2),
          bodyMedium: TextStyle(color: ink, height: 1.4),
          bodySmall: TextStyle(color: muted, height: 1.3),
        ),
      );

  static ThemeData get dark => ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: darkCanvas,
        colorScheme: ColorScheme.fromSeed(
          seedColor: blue,
          brightness: Brightness.dark,
          primary: const Color(0xFF596BFF),
          secondary: purple,
          surface: darkCard,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: darkCanvas,
          foregroundColor: darkInk,
          elevation: 0,
          scrolledUnderElevation: 0,
          centerTitle: false,
          titleTextStyle: TextStyle(
            color: darkInk,
            fontSize: 18,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.3,
          ),
        ),
        cardTheme: CardThemeData(
          color: darkCard,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: const BorderSide(color: darkBorder, width: 1),
          ),
        ),
        navigationBarTheme: NavigationBarThemeData(
          height: 68,
          backgroundColor: darkCard,
          elevation: 4,
          indicatorColor: const Color(0xFF1E284A),
          labelTextStyle: WidgetStateProperty.resolveWith(
            (states) => TextStyle(
              fontSize: 11,
              fontWeight: states.contains(WidgetState.selected)
                  ? FontWeight.w700
                  : FontWeight.w500,
              color: states.contains(WidgetState.selected)
                  ? const Color(0xFF7585FF)
                  : darkMuted,
            ),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: darkCard,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: darkBorder, width: 1),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: darkBorder, width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: Color(0xFF7585FF), width: 1.6),
          ),
        ),
        textTheme: const TextTheme(
          headlineMedium: TextStyle(
              color: darkInk, fontWeight: FontWeight.w800, letterSpacing: -0.5),
          titleLarge: TextStyle(
              color: darkInk, fontWeight: FontWeight.w700, letterSpacing: -0.3),
          titleMedium: TextStyle(
              color: darkInk, fontWeight: FontWeight.w600, letterSpacing: -0.2),
          bodyMedium: TextStyle(color: darkInk, height: 1.4),
          bodySmall: TextStyle(color: darkMuted, height: 1.3),
        ),
      );
}
