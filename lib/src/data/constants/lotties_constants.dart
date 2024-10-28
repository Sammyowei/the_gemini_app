const _lottiePath = 'assets/lotties';

extension LottieExtention on String {
  String get lottie => '$_lottiePath/$this.json';
}

abstract class LottieConstants {
  static String lodingAnimation = 'spiral_rotation'.lottie;
}
