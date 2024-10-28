import 'package:flutter/material.dart';

/// A class to hold the color palette for the app.
///
/// This class contains the colors used throughout the app,
/// including the primary color, the background color, surface color,
/// outline color, text color, secondary color, and other custom colors.
class Palette {
  /// The primary color used throughout the app.
  static const Color primaryColor = Color(0xff2F66F6);

  /// The background color used throughout the app.
  static const Color backgroundColor = Color(0xffF8F9FC);

  /// The surface color used throughout the app.
  static const Color surfaceColor = Color(0xFfFFFFFF);

  /// The outline color used throughout the app.
  static const Color outlineColor = Color(0xffD7D9E4);

  /// The text color used throughout the app.
  static const Color textColor = Color(0xff11183C);

  /// The secondary color used throughout the app.
  static const Color secondaryColor = Color(0xff696F8C);

  /// A custom green color used throughout the app.
  static const Color greenColor = Color(0xff098C26);

  /// A custom orange color used throughout the app.
  static const Color orangeColor = Color(0xffF7931A);

  /// A custom red color used throughout the app.
  static const Color redColor = Color(0xffCD0000);

  /// The dark background color used throughout the app.
  static const Color darkBackgroundColor = Color(0xff121212);

  /// The dark surface color used throughout the app.
  static const Color darkSurfaceColor = Color(0xff22283A);

  /// The dark outline color used throughout the app.
  static const Color darkOutlineColor = Color(0xff3D455C);

  /// The dark secondary color used throughout the app.
  static const Color darkSecondaryColor = Color(0xff9096A2);

  /// The dark text color used throughout the app.
  static const Color darkTextColor = Color(0xffFFFFFF);

  /// The dark primary color used throughout the app.
  static const Color darkPrimaryColor = Color(0xff436FE2);

  /// The dark green color used throughout the app.
  static const Color darkGreenColor = Color(0xff31C451);

  /// The dark orange color used throughout the app.
  static const Color darkOrangeColor = Color(0xffF7931A);

  /// The dark red color used throughout the app.
  static const Color darkRedColor = Color(0xffCD0000);

  /// A blue gradient used throughout the app.
  static LinearGradient blueGradient = LinearGradient(
    colors: [const Color(0xff2F66F6), const Color(0xff2F66F6).withOpacity(0)],
    stops: const [0, 100],
  );

  /// A dark blue gradient used throughout the app.
  static LinearGradient darkBlueGradient = LinearGradient(
    colors: [const Color(0xff436FE2), const Color(0xff2F66F6).withOpacity(0)],
    stops: const [0, 100],
  );

  /// An orange gradient used throughout the app.
  static LinearGradient orangeGradient = LinearGradient(
    colors: [const Color(0xffF7931A), const Color(0xffF7931A).withOpacity(0)],
    stops: const [0, 100],
  );

  // Suggested container colors for light mode.
  static const Color containerColor1 = Color(0xffE8F0FE); // Light purple-blue
  static const Color containerColor2 = Color(0xffF4F4F6); // Light neutral
  static const Color containerColor3 = Color(0xffFFEEDD); // Light orange-beige

  // Suggested container colors for dark mode.
  static const Color darkContainerColor1 =
      Color(0xff3C4A70); // Dark purple-blue
  static const Color darkContainerColor2 = Color(0xff2A2F40); // Dark neutral
  static const Color darkContainerColor3 =
      Color(0xff503D36); // Dark orange-brown
}
