// Augment: TripOnBuddy Website → Flutter App
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppTheme {
  // Material 3 colors as specified in new theme palette
  static const Color primaryColor = Color(0xFF4E79FF); // Light Blue
  static const Color secondaryColor = Color(0xFFFF5A5F); // Accent/Action color
  static const Color scaffoldBackgroundColor = Color(0xFFF0F6F4);
  static const Color surfaceColor = Color(0xFFFFFFFF);
  static const Color dividerColor = Color(0xFFE5E7EB);

  // Text colors
  static const Color textPrimaryColor = Colors.black;
  static const Color textSecondaryColor = Colors.black87;

  // Standard spacing
  static const double standardPadding = 16.0;
  static const double standardBorderRadius = 12.0;

  // Responsive breakpoints
  static double get smallScreenBreakpoint => 600.w;
  static double get largeScreenBreakpoint => 1000.w;

  // Material 3 color scheme with updated palette
  static ColorScheme lightColorScheme = ColorScheme(
    primary: primaryColor,
    secondary: secondaryColor,
    surface: surfaceColor,
    surfaceContainerHighest: scaffoldBackgroundColor,
    error: Colors.red,
    onPrimary: Colors.white,
    onSecondary: Colors.white,
    onSurface: Colors.black,
    onError: Colors.white,
    brightness: Brightness.light,
  );

  // Text themes using Roboto for body and Playfair Display for headlines
  // Updated according to new theme specifications with black text for visibility
  static TextTheme _buildTextTheme(TextTheme base) {
    return base.copyWith(
      // H1/Hero: Playfair Display, bold, 32-40px
      displayLarge: GoogleFonts.playfairDisplay(
        fontSize: 40.sp,
        fontWeight: FontWeight.bold,
        color: Colors.black,
        letterSpacing: -0.5,
      ),
      displayMedium: GoogleFonts.playfairDisplay(
        fontSize: 36.sp,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
      displaySmall: GoogleFonts.playfairDisplay(
        fontSize: 32.sp,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
      headlineLarge: GoogleFonts.playfairDisplay(
        fontSize: 28.sp,
        fontWeight: FontWeight.w600,
        color: Colors.black,
      ),
      headlineMedium: GoogleFonts.playfairDisplay(
        fontSize: 24.sp,
        fontWeight: FontWeight.w600,
        color: Colors.black,
      ),
      // Section titles: Playfair Display, 20-24px
      headlineSmall: GoogleFonts.playfairDisplay(
        fontSize: 20.sp,
        fontWeight: FontWeight.w600,
        color: Colors.black,
      ),
      titleLarge: GoogleFonts.roboto(
        fontSize: 18.sp,
        fontWeight: FontWeight.w500,
        color: Colors.black,
      ),
      titleMedium: GoogleFonts.roboto(
        fontSize: 16.sp,
        fontWeight: FontWeight.w500,
        color: Colors.black,
      ),
      titleSmall: GoogleFonts.roboto(
        fontSize: 14.sp,
        fontWeight: FontWeight.w500,
        color: Colors.black,
      ),
      // bodyText1: Roboto, 16px
      bodyLarge: GoogleFonts.roboto(
        fontSize: 16.sp,
        fontWeight: FontWeight.normal,
        color: Colors.black,
      ),
      bodyMedium: GoogleFonts.roboto(
        fontSize: 14.sp,
        fontWeight: FontWeight.normal,
        color: Colors.black,
      ),
      // caption: Roboto, 12px
      bodySmall: GoogleFonts.roboto(
        fontSize: 12.sp,
        fontWeight: FontWeight.normal,
        color: Colors.black87,
      ),
      labelLarge: GoogleFonts.roboto(
        fontSize: 14.sp,
        fontWeight: FontWeight.w500,
        color: Colors.black,
      ),
    );
  }

  // Light theme - updated according to new theme specifications
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    colorScheme: lightColorScheme,
    scaffoldBackgroundColor: scaffoldBackgroundColor,
    textTheme: _buildTextTheme(ThemeData.light().textTheme),
    dividerColor: dividerColor,
    primaryColor: primaryColor,
    primaryColorLight: Color(0xFF81A9FF), // Lighter shade of primary
    primaryColorDark: Color(0xFF3A5CBF), // Darker shade of primary
    canvasColor: surfaceColor,
    appBarTheme: AppBarTheme(
      backgroundColor: surfaceColor,
      foregroundColor: Colors.black,
      titleTextStyle: TextStyle(
        color: Colors.black,
        fontSize: 20.sp,
        fontWeight: FontWeight.w600,
        fontFamily: GoogleFonts.playfairDisplay().fontFamily,
      ),
      iconTheme: IconThemeData(color: Colors.black),
      actionsIconTheme: IconThemeData(color: Colors.black),
      elevation: 0,
    ),
    // CardTheme: background #FFFFFF, elevation 4, borderRadius 12px
    cardTheme: CardTheme(
      elevation: 4,
      color: surfaceColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(standardBorderRadius),
      ),
    ),
    // Primary ElevatedButton: bg #FF5A5F, white text
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: secondaryColor,
        foregroundColor: Colors.white,
        elevation: 2,
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(standardBorderRadius),
        ),
      ),
    ),
    // Secondary/link TextButton: text #4E79FF
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: primaryColor,
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(standardBorderRadius),
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: primaryColor,
        side: BorderSide(color: primaryColor),
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(standardBorderRadius),
        ),
      ),
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: secondaryColor,
      foregroundColor: Colors.white,
      elevation: 4,
    ),
    // InputDecorationTheme: filled white fields, border OutlineInputBorder radius 12px, color #E5E7EB
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: surfaceColor,
      prefixIconColor: textSecondaryColor,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(standardBorderRadius),
        borderSide: BorderSide(color: dividerColor),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(standardBorderRadius),
        borderSide: BorderSide(color: dividerColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(standardBorderRadius),
        borderSide: BorderSide(color: primaryColor, width: 2),
      ),
      contentPadding: EdgeInsets.symmetric(
        horizontal: standardPadding,
        vertical: standardPadding,
      ),
    ),
    // ChoiceChips: selected bg #FF5A5F, unselected border #E5E7EB
    chipTheme: ChipThemeData(
      backgroundColor: surfaceColor,
      selectedColor: secondaryColor,
      disabledColor: surfaceColor,
      labelStyle: TextStyle(color: textPrimaryColor),
      secondaryLabelStyle: TextStyle(color: Colors.white),
      side: BorderSide(color: dividerColor),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(standardBorderRadius),
      ),
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
    ),
    // BottomNavigationBarTheme: background #FFFFFF pill-shaped bar with shadow
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: surfaceColor,
      elevation: 8,
      selectedItemColor: secondaryColor,
      unselectedItemColor: Colors.black,
      selectedLabelStyle: TextStyle(
        color: secondaryColor,
        fontSize: 12.sp,
        fontWeight: FontWeight.w500,
      ),
      unselectedLabelStyle: TextStyle(color: Colors.black, fontSize: 12.sp),
      type: BottomNavigationBarType.fixed,
      landscapeLayout: BottomNavigationBarLandscapeLayout.centered,
      showSelectedLabels: true,
      showUnselectedLabels: true,
    ),
  );

  // Dark theme - using same light theme for consistency
  static ThemeData darkTheme = lightTheme;
}
