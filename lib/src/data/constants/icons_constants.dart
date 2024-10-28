part of 'constants.dart';

// This file is a part of 'constants.dart' and contains code related to defining constants for icons.

// This private constant variable '_iconPath' holds the path to the directory where the icon files are located.
const _iconPath = 'assets/icons';

// This extension 'IconExtension' extends the functionality of the String class to provide convenient methods for accessing icon paths.
extension IconExtension on String {
  // This getter 'png' returns the path to the PNG file with the name specified by the string followed by the '.png' extension.
  String get png => '$_iconPath/$this.png';
  // This getter 'jpg' returns the path to the JPG file with the name specified by the string followed by the '.jpg' extension.
  String get jpg => '$_iconPath/$this.jpg';
  // This getter 'jpeg' returns the path to the JPEG file with the name specified by the string followed by the '.jpeg' extension.
  String get jpeg => '$_iconPath/$this.jpeg';
  // This getter 'svg' returns the path to the SVG file with the name specified by the string followed by the '.svg' extension.
  String get svg => '$_iconPath/$this.svg';
}

// This abstract class 'IconConstants' contains static constant variables that hold paths to specific icons.
abstract class IconConstants {
  // This static constant variable 'appIcons' holds the path to the PNG file for the app icon named 'coinmoney_logo'.
  static String appIcons = 'coinmoney_logo'.png;
  // This static constant variable 'bitcoinIcons' holds the path to the PNG file for the app icon named 'bitcoin'.
  static String bitcoinIcon = 'bitcoin'.png;
  // This static constant variable 'solanaIcons' holds the path to the PNG file for the app icon named 'solana'.
  static String solanaIcon = 'solana'.png;
  // This static constant variable 'ethereumIcons' holds the path to the PNG file for the app icon named 'ethereum'.
  static String ethereumIcon = 'ethereum'.png;

  // This static constant variable 'bitcoinSVGIcons' holds the path to the SVG file for the app icon named 'bitcoin'.
  static String bitcoinSVGIcon = 'bitcoin'.svg;
  // This static constant variable 'solanaSVGIcons' holds the path to the SVG file for the app icon named 'solana'.
  static String solanaSVGIcon = 'solana'.svg;
  // This static constant variable 'ethereumVGIcons' holds the path to the SVG file for the app icon named 'ethereum'.
  static String ethereumSVGIcon = 'ethereum'.svg;
  // This static constant variable 'googleIconPng' holds the path to the PNG file for the app icon named 'google'.
  static String googleIconPng = 'google'.png;
  // This static constant variable 'facebookIconPng' holds the path to the PNG file for the app icon named 'facebook'.
  static String facebookIconPng = 'facebook'.png;
// This static constant variable 'solanaSVGIcons' holds the path to the SVG file for the app icon named 'mail'.
  static String mailIconSvg = 'mail'.svg;
}
