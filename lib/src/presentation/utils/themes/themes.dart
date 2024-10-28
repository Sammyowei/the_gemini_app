import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:the_gemini_app/src/presentation/palette/palette.dart';

/// A class that provides methods to define the light and dark themes for the app.
class AppTheme {
  AppTheme();

  /// Defines the light theme for the app.
  ///
  /// [context] The [BuildContext] of the widget that is requesting the theme.
  ///

  static TextTheme get textTheme => _textTheme();

  static TextTheme _textTheme() {
    const double headingOne = 32;
    const double large = 18;
    const double medium = 16;
    const double small = 14;
    const double xSmall = 12;

    return TextTheme(
      displayLarge: GoogleFonts.readexPro(
        fontWeight: FontWeight.w600,
        fontSize: headingOne,
      ),
      titleLarge: GoogleFonts.readexPro(
        fontSize: large,
      ),
      titleMedium: GoogleFonts.readexPro(
        fontSize: medium,
      ),
      bodyLarge: GoogleFonts.readexPro(
        fontSize: small,
      ),
      bodyMedium: GoogleFonts.readexPro(
        fontSize: xSmall,
      ),
      labelLarge: GoogleFonts.readexPro(
        fontWeight: FontWeight.bold,
        fontSize: small,
      ),
    );
  }

  /// Defines the dark theme for the app.
  ///
  /// [context] The [BuildContext] of the widget that is requesting the theme.
  ///
  /// Returns a [ThemeData] object representing the dark theme.
  static ThemeData darkTheme(BuildContext context) {
    // Define color scheme for the dark theme.
    const ColorScheme colorScheme = ColorScheme.light(
      // Define primary color.
      primary: Palette.darkPrimaryColor,
      // Define background color.
      background: Palette.darkBackgroundColor,
      // Define secondary color.
      secondary: Palette.darkSecondaryColor,
      // Define error color.
      error: Palette.darkRedColor,
      // Define brightness as light.
      brightness: Brightness.light,
      // Define surface color.
      surface: Palette.darkSurfaceColor,
      // Define text color.
      onSurface: Palette.darkTextColor,
      // Define the outline color
      outline: Palette.darkOutlineColor,

      secondaryContainer: Color.fromARGB(255, 111, 130, 189),
      tertiaryContainer: Palette.darkContainerColor1,
      primaryContainer: Palette.darkContainerColor3,
    );

    // Return ThemeData with defined color scheme and Material3 design.
    return ThemeData.from(
      colorScheme: colorScheme,
      useMaterial3: true,
      textTheme: textTheme,
    );
  }

  /// Returns a [ThemeData] object representing the light theme.
  static ThemeData lightTheme(BuildContext context) {
    // Define color scheme for the light theme.
    const ColorScheme colorScheme = ColorScheme.light(
      // Define primary color.
      primary: Palette.primaryColor,
      // Define background color.
      background: Palette.backgroundColor,
      // Define secondary color.
      secondary: Palette.secondaryColor,
      // Define error color.
      error: Palette.redColor,

      // Define brightness as dark.
      brightness: Brightness.dark,
      // Define surface color.
      surface: Palette.surfaceColor,
      // Define text color.
      onSurface: Palette.textColor,
      // Define the outline color
      outline: Palette.outlineColor,
      primaryContainer: Color.fromARGB(255, 247, 207, 167),
      secondaryContainer: Color.fromARGB(255, 118, 118, 209),
      tertiaryContainer: Color.fromARGB(255, 88, 113, 155),
    );

    ThemeData themeData = ThemeData.from(
      colorScheme: colorScheme,
      useMaterial3: true,
      textTheme: textTheme,
    );

    // Return ThemeData with defined color scheme and Material3 design.
    return themeData;
  }
}
