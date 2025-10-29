import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Tema do aplicativo ChefIA
class AppTheme {
  // Cores principais
  static const Color _primary = Color(0xFF6C63FF);
  static const Color _primaryDark = Color(0xFF5A4FCF);
  static const Color _secondary = Color(0xFFFF6B6B);
  static const Color _accent = Color(0xFF4ECDC4);
  
  // Cores neutras
  static const Color _background = Color(0xFFFAFAFA);
  static const Color _surface = Colors.white;
  static const Color _error = Color(0xFFFF5252);
  
  // Cores de texto
  static const Color _textPrimary = Color(0xFF2D3748);
  static const Color _textSecondary = Color(0xFF718096);
  static const Color _textHint = Color(0xFFA0AEC0);
  
  // Dark theme colors
  static const Color _backgroundDark = Color(0xFF1A1D29);
  static const Color _surfaceDark = Color(0xFF252836);
  static const Color _textPrimaryDark = Color(0xFFF7FAFC);
  static const Color _textSecondaryDark = Color(0xFFE2E8F0);

  /// Tema claro
  static ThemeData get light {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      
      // Color Scheme
      colorScheme: const ColorScheme.light(
        primary: _primary,
        secondary: _secondary,
        tertiary: _accent,
        background: _background,
        surface: _surface,
        error: _error,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onTertiary: Colors.white,
        onBackground: _textPrimary,
        onSurface: _textPrimary,
        onError: Colors.white,
      ),
      
      // Typography
      textTheme: _buildTextTheme(Brightness.light),
      
      // AppBar
      appBarTheme: AppBarTheme(
        backgroundColor: _surface,
        foregroundColor: _textPrimary,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.poppins(
          color: _textPrimary,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
      
      // Cards
      cardTheme: CardThemeData(
        color: _surface,
        elevation: 2,
        shadowColor: Colors.black.withOpacity(0.1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      
      // Buttons
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: _primary,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: _primary,
          side: const BorderSide(color: _primary, width: 1.5),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      
      // Floating Action Button
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: _secondary,
        foregroundColor: Colors.white,
        elevation: 4,
        shape: CircleBorder(),
      ),
      
      // Input Decoration
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: _surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: _primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: _error, width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        hintStyle: GoogleFonts.poppins(
          color: _textHint,
          fontSize: 16,
        ),
      ),
      
      // Chip
      chipTheme: ChipThemeData(
        backgroundColor: _accent.withOpacity(0.1),
        selectedColor: _accent,
        secondarySelectedColor: _accent,
        labelStyle: GoogleFonts.poppins(
          color: _accent,
          fontWeight: FontWeight.w500,
        ),
        secondaryLabelStyle: GoogleFonts.poppins(
          color: Colors.white,
          fontWeight: FontWeight.w500,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        showCheckmark: false,
      ),
    );
  }

  /// Tema escuro
  static ThemeData get dark {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      
      // Color Scheme
      colorScheme: const ColorScheme.dark(
        primary: _primary,
        secondary: _secondary,
        tertiary: _accent,
        background: _backgroundDark,
        surface: _surfaceDark,
        error: _error,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onTertiary: Colors.white,
        onBackground: _textPrimaryDark,
        onSurface: _textPrimaryDark,
        onError: Colors.white,
      ),
      
      // Typography
      textTheme: _buildTextTheme(Brightness.dark),
      
      // AppBar
      appBarTheme: AppBarTheme(
        backgroundColor: _surfaceDark,
        foregroundColor: _textPrimaryDark,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.poppins(
          color: _textPrimaryDark,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
      
      // Cards
      cardTheme: CardThemeData(
        color: _surfaceDark,
        elevation: 2,
        shadowColor: Colors.black.withOpacity(0.3),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }

  /// Constrói o tema de texto
  static TextTheme _buildTextTheme(Brightness brightness) {
    final color = brightness == Brightness.light ? _textPrimary : _textPrimaryDark;
    final secondaryColor = brightness == Brightness.light ? _textSecondary : _textSecondaryDark;
    
    return GoogleFonts.poppinsTextTheme().copyWith(
      displayLarge: GoogleFonts.poppins(
        color: color,
        fontSize: 32,
        fontWeight: FontWeight.w700,
      ),
      displayMedium: GoogleFonts.poppins(
        color: color,
        fontSize: 28,
        fontWeight: FontWeight.w600,
      ),
      displaySmall: GoogleFonts.poppins(
        color: color,
        fontSize: 24,
        fontWeight: FontWeight.w600,
      ),
      headlineMedium: GoogleFonts.poppins(
        color: color,
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
      headlineSmall: GoogleFonts.poppins(
        color: color,
        fontSize: 18,
        fontWeight: FontWeight.w600,
      ),
      titleLarge: GoogleFonts.poppins(
        color: color,
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),
      titleMedium: GoogleFonts.poppins(
        color: color,
        fontSize: 14,
        fontWeight: FontWeight.w600,
      ),
      titleSmall: GoogleFonts.poppins(
        color: secondaryColor,
        fontSize: 12,
        fontWeight: FontWeight.w500,
      ),
      bodyLarge: GoogleFonts.poppins(
        color: color,
        fontSize: 16,
        fontWeight: FontWeight.w400,
      ),
      bodyMedium: GoogleFonts.poppins(
        color: color,
        fontSize: 14,
        fontWeight: FontWeight.w400,
      ),
      bodySmall: GoogleFonts.poppins(
        color: secondaryColor,
        fontSize: 12,
        fontWeight: FontWeight.w400,
      ),
      labelLarge: GoogleFonts.poppins(
        color: color,
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}

/// Extensões para cores customizadas
extension AppColors on ColorScheme {
  Color get success => const Color(0xFF4CAF50);
  Color get warning => const Color(0xFFFF9800);
  Color get info => const Color(0xFF2196F3);
  
  Color get gradient1 => const Color(0xFF6C63FF);
  Color get gradient2 => const Color(0xFF4ECDC4);
}