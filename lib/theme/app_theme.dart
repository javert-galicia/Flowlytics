import 'package:flutter/material.dart';

class AppTheme {
  // Colores principales profesionales
  static const Color primaryBlue = Color(0xFF2563EB); // Azul vibrante
  static const Color primaryDark = Color(0xFF1E40AF);
  static const Color primaryLight = Color(0xFF60A5FA);
  
  // Colores secundarios dinámicos
  static const Color accentOrange = Color(0xFFEA580C); // Naranja energético
  static const Color accentGreen = Color(0xFF059669); // Verde exitoso
  static const Color accentPurple = Color(0xFF7C3AED); // Púrpura creativo
  static const Color accentRose = Color(0xFFE11D48); // Rosa vibrante
  
  // Colores de fondo y superficie
  static const Color backgroundLight = Color(0xFFF8FAFC);
  static const Color backgroundDark = Color(0xFF0F172A);
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color surfaceDark = Color(0xFF1E293B);
  
  // Grises profesionales
  static const Color gray50 = Color(0xFFF8FAFC);
  static const Color gray100 = Color(0xFFF1F5F9);
  static const Color gray200 = Color(0xFFE2E8F0);
  static const Color gray300 = Color(0xFFCBD5E1);
  static const Color gray400 = Color(0xFF94A3B8);
  static const Color gray500 = Color(0xFF64748B);
  static const Color gray600 = Color(0xFF475569);
  static const Color gray700 = Color(0xFF334155);
  static const Color gray800 = Color(0xFF1E293B);
  static const Color gray900 = Color(0xFF0F172A);

  // Gradientes dinámicos
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primaryBlue, primaryDark],
  );

  static const LinearGradient accentGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [accentOrange, accentRose],
  );

  static const LinearGradient successGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [accentGreen, Color(0xFF10B981)],
  );

  static const LinearGradient creativeGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [accentPurple, Color(0xFF8B5CF6)],
  );

  // Tema claro
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: ColorScheme.fromSeed(
      seedColor: primaryBlue,
      brightness: Brightness.light,
      primary: primaryBlue,
      secondary: accentOrange,
      tertiary: accentPurple,
      surface: surfaceLight,
      background: backgroundLight,
    ),
    fontFamily: 'Roboto',
    textTheme: const TextTheme(
      displayLarge: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.w800,
        fontFamily: 'Lato',
        color: gray900,
        letterSpacing: -0.5,
      ),
      displayMedium: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.w700,
        fontFamily: 'Lato',
        color: gray900,
        letterSpacing: -0.25,
      ),
      displaySmall: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        fontFamily: 'Lato',
        color: gray800,
      ),
      headlineLarge: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        fontFamily: 'Roboto',
        color: gray800,
      ),
      headlineMedium: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        fontFamily: 'Roboto',
        color: gray700,
      ),
      headlineSmall: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        fontFamily: 'Roboto',
        color: gray700,
      ),
      titleLarge: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        fontFamily: 'Roboto',
        color: gray800,
      ),
      titleMedium: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        fontFamily: 'Roboto',
        color: gray700,
      ),
      bodyLarge: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        fontFamily: 'Roboto',
        color: gray700,
        height: 1.5,
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        fontFamily: 'Roboto',
        color: gray600,
        height: 1.4,
      ),
      bodySmall: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        fontFamily: 'Roboto',
        color: gray500,
        height: 1.3,
      ),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: surfaceLight,
      foregroundColor: gray900,
      elevation: 0,
      scrolledUnderElevation: 1,
      titleTextStyle: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w700,
        fontFamily: 'Lato',
        color: gray900,
      ),
      iconTheme: IconThemeData(color: gray700),
    ),
    cardTheme: CardThemeData(
      elevation: 2,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        elevation: 2,
        shadowColor: primaryBlue.withOpacity(0.3),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        textStyle: const TextStyle(
          fontFamily: 'Roboto',
          fontWeight: FontWeight.w600,
          fontSize: 16,
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: gray50,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: gray200),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: gray200),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: primaryBlue, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: accentRose, width: 2),
      ),
      contentPadding: const EdgeInsets.all(16),
      labelStyle: const TextStyle(
        fontFamily: 'Roboto',
        color: gray600,
      ),
      hintStyle: const TextStyle(
        fontFamily: 'Roboto',
        color: gray400,
      ),
    ),
    drawerTheme: const DrawerThemeData(
      backgroundColor: surfaceLight,
      elevation: 8,
      shadowColor: gray300,
    ),
  );

  // Colores específicos para cada canvas
  static const Map<String, List<Color>> canvasColors = {
    'home': [primaryBlue, primaryLight],
    'business': [Color(0xFF059669), Color(0xFF10B981)], // Verde empresarial
    'foda': [Color(0xFFEA580C), Color(0xFFF97316)], // Naranja analítico
    'value': [Color(0xFF7C3AED), Color(0xFF8B5CF6)], // Púrpura valor
    'team': [Color(0xFFE11D48), Color(0xFFF43F5E)], // Rosa colaborativo
    'idea': [Color(0xFF0891B2), Color(0xFF06B6D4)], // Cyan creativo
  };

  // Método para obtener gradiente por tipo de canvas
  static LinearGradient getCanvasGradient(String canvasType) {
    final colors = canvasColors[canvasType] ?? [primaryBlue, primaryLight];
    return LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: colors,
    );
  }

  // Animaciones y efectos
  static const Duration defaultAnimationDuration = Duration(milliseconds: 300);
  static const Curve defaultAnimationCurve = Curves.easeInOutCubic;
}