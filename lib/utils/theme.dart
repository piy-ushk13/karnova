// Augment: TripOnBuddy Website → Flutter App
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppTheme {
  // Material 3 colors as specified in new theme palette
  static const Color primaryColor = Color(0xFF4E79FF); // Light Blue
  static const Color primaryColorLight = Color(
    0xFF81A9FF,
  ); // Lighter shade of primary
  static const Color primaryColorDark = Color(
    0xFF3A5CBF,
  ); // Darker shade of primary
  static const Color secondaryColor = Color(0xFFFF5A5F); // Accent/Action color
  static const Color scaffoldBackgroundColor = Color(
    0xFFF8FAFC,
  ); // Lighter background for better contrast
  static const Color surfaceColor = Color(0xFFFFFFFF);
  static const Color dividerColor = Color(0xFFE5E7EB);

  // Gradient colors
  static const Color gradientStart = Color(
    0xFFE6EFFF,
  ); // Light blue gradient start
  static const Color gradientEnd = Color(
    0xFFF0E6FF,
  ); // Light lavender gradient end

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
  static ColorScheme lightColorScheme = ColorScheme.light(
    primary: primaryColor,
    secondary: secondaryColor,
    surface: surfaceColor,
    error: Colors.red,
    onPrimary: Colors.white,
    onSecondary: Colors.white,
    onSurface: Colors.black,
    onError: Colors.white,
    surfaceTint: primaryColor,
    outline: dividerColor,
    // Use withAlpha instead of withOpacity
    outlineVariant: dividerColor.withAlpha(128),
    shadow: Colors.black,
    scrim: Colors.black.withAlpha(102),
    inverseSurface: Colors.black,
    onInverseSurface: Colors.white,
    inversePrimary: Colors.white,
    surfaceContainerHighest: scaffoldBackgroundColor,
    onSurfaceVariant: Colors.black87,
    primaryContainer: primaryColor.withAlpha(204),
    onPrimaryContainer: Colors.white,
    secondaryContainer: secondaryColor.withAlpha(204),
    onSecondaryContainer: Colors.white,
    tertiary: Color(0xFF4CAF50),
    onTertiary: Colors.white,
    tertiaryContainer: Color(0xFF4CAF50).withAlpha(204),
    onTertiaryContainer: Colors.white,
    errorContainer: Colors.red.shade200,
    onErrorContainer: Colors.white,
  );

  // Text themes using system fonts for reliability
  // Updated to use system fonts to ensure text always appears
  static TextTheme _buildTextTheme(TextTheme base) {
    return base.copyWith(
      // H1/Hero: Serif font for headings, bold, 32-40px
      displayLarge: TextStyle(
        fontFamily: 'serif',
        fontSize: 40.sp,
        fontWeight: FontWeight.bold,
        color: Colors.black,
        letterSpacing: -0.5,
      ),
      displayMedium: TextStyle(
        fontFamily: 'serif',
        fontSize: 36.sp,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
      displaySmall: TextStyle(
        fontFamily: 'serif',
        fontSize: 32.sp,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
      headlineLarge: TextStyle(
        fontFamily: 'serif',
        fontSize: 28.sp,
        fontWeight: FontWeight.w600,
        color: Colors.black,
      ),
      headlineMedium: TextStyle(
        fontFamily: 'serif',
        fontSize: 24.sp,
        fontWeight: FontWeight.w600,
        color: Colors.black,
      ),
      // Section titles: Serif font, 20-24px
      headlineSmall: TextStyle(
        fontFamily: 'serif',
        fontSize: 20.sp,
        fontWeight: FontWeight.w600,
        color: Colors.black,
      ),
      titleLarge: TextStyle(
        fontFamily: 'sans-serif',
        fontSize: 18.sp,
        fontWeight: FontWeight.w500,
        color: Colors.black,
      ),
      titleMedium: TextStyle(
        fontFamily: 'sans-serif',
        fontSize: 16.sp,
        fontWeight: FontWeight.w500,
        color: Colors.black,
      ),
      titleSmall: TextStyle(
        fontFamily: 'sans-serif',
        fontSize: 14.sp,
        fontWeight: FontWeight.w500,
        color: Colors.black,
      ),
      // bodyText1: Sans-serif, 16px
      bodyLarge: TextStyle(
        fontFamily: 'sans-serif',
        fontSize: 16.sp,
        fontWeight: FontWeight.normal,
        color: Colors.black,
      ),
      bodyMedium: TextStyle(
        fontFamily: 'sans-serif',
        fontSize: 14.sp,
        fontWeight: FontWeight.normal,
        color: Colors.black,
      ),
      // caption: Sans-serif, 12px
      bodySmall: TextStyle(
        fontFamily: 'sans-serif',
        fontSize: 12.sp,
        fontWeight: FontWeight.normal,
        color: Colors.black87,
      ),
      labelLarge: TextStyle(
        fontFamily: 'sans-serif',
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
    // Ensure text is always visible
    textSelectionTheme: TextSelectionThemeData(
      cursorColor: primaryColor,
      selectionColor: primaryColor.withAlpha(77),
      selectionHandleColor: primaryColor,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: surfaceColor,
      foregroundColor: Colors.black,
      titleTextStyle: TextStyle(
        color: Colors.black,
        fontSize: 20.sp,
        fontWeight: FontWeight.w600,
        fontFamily: 'serif',
      ),
      iconTheme: IconThemeData(color: Colors.black),
      actionsIconTheme: IconThemeData(color: Colors.black),
      elevation: 0,
      systemOverlayStyle: SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
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
      // Ensure text is visible in input fields
      hintStyle: TextStyle(color: Colors.grey[600]),
      labelStyle: TextStyle(color: Colors.black87),
      floatingLabelStyle: TextStyle(color: primaryColor),
      helperStyle: TextStyle(color: Colors.black87),
      errorStyle: TextStyle(color: Colors.red),
      // Border styles
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
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(standardBorderRadius),
        borderSide: BorderSide(color: Colors.red),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(standardBorderRadius),
        borderSide: BorderSide(color: Colors.red, width: 2),
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
      // Ensure text is visible in chips
      labelStyle: TextStyle(
        color: textPrimaryColor,
        fontWeight: FontWeight.normal,
        fontSize: 14.sp,
      ),
      secondaryLabelStyle: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontSize: 14.sp,
      ),
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
      // Ensure text is visible in bottom navigation bar
      selectedLabelStyle: TextStyle(
        color: secondaryColor,
        fontSize: 12.sp,
        fontWeight: FontWeight.w500,
      ),
      unselectedLabelStyle: TextStyle(
        color: Colors.black,
        fontSize: 12.sp,
        fontWeight: FontWeight.normal,
      ),
      // Make sure icons are visible
      selectedIconTheme: IconThemeData(color: secondaryColor, size: 24.sp),
      unselectedIconTheme: IconThemeData(color: Colors.black, size: 22.sp),
      type: BottomNavigationBarType.fixed,
      landscapeLayout: BottomNavigationBarLandscapeLayout.centered,
      showSelectedLabels: true,
      showUnselectedLabels: true,
    ),
  );

  // Dark theme - using same light theme for consistency
  static ThemeData darkTheme = lightTheme;
}
