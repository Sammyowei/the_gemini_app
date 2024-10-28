// Define a constant variable to store the path to the images directory
const _imagePath = 'assets/images';

// Define an extension on the String class called ImageExtension
extension ImageExtension on String {
  // Define a getter named png to append '.png' to the string and return the full image path
  String get png => '$_imagePath/$this.png';
  String get jpg => '$_imagePath/$this.jpg';
}

// Define an abstract class called ImageConstants
abstract class ImageConstants {
  // Define static constant variables to represent different image paths

  /// Represents the path to the loading widget image.
  static String loadingwidget = 'loading'.png;

  /// Represents the path to the onboarding one image.
  static String onboardingOneImage = 'onboarding_one'.png;

  /// Represents the path to the onboarding two image.
  static String onboardingTwoImage = 'onboarding_two'.png;

  /// Represents the path to the onboarding three image.
  static String onboardingThreeImage = 'onboarding_three'.png;

  /// Represents the path to the onboarding three image.
  static String vectorImage = 'vector'.png;

  /// Represents the path to the sign up onboarding image.
  static String signUpOnboardingImage = 'sign_up_onbaording'.png;

  static String table = 'table'.jpg;
}
