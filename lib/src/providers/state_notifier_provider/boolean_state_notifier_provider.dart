import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:the_gemini_app/src/src.dart';

final emailValidatorProvider =
    StateNotifierProvider<BooleanNotifier, bool>((ref) {
  return BooleanNotifier();
});

final passwordValidatorProvider =
    StateNotifierProvider<BooleanNotifier, bool>((ref) {
  return BooleanNotifier();
});

final emailfieldValidatorProvider =
    StateNotifierProvider<BooleanNotifier, bool>((ref) {
  return BooleanNotifier();
});

final passwordfieldValidatorProvider =
    StateNotifierProvider<BooleanNotifier, bool>((ref) {
  return BooleanNotifier();
});

final obscrueTextProvider = StateNotifierProvider<BooleanNotifier, bool>((ref) {
  return BooleanNotifier(value: false);
});

final otpValidatorProvider =
    StateNotifierProvider<BooleanNotifier, bool>((ref) => BooleanNotifier());

final firstNameValidatorStateProvider =
    StateNotifierProvider<BooleanNotifier, bool>(
  (ref) => BooleanNotifier(),
);

final lastNameValidatorStateProvider =
    StateNotifierProvider<BooleanNotifier, bool>(
  (ref) => BooleanNotifier(),
);

final firstNameFieldValidatorStateProvider =
    StateNotifierProvider<BooleanNotifier, bool>(
  (ref) => BooleanNotifier(),
);

final lastNameFieldValidatorStateProvider =
    StateNotifierProvider<BooleanNotifier, bool>(
  (ref) => BooleanNotifier(),
);

final phoneNumberValidatorStateProvider =
    StateNotifierProvider<BooleanNotifier, bool>(
  (ref) => BooleanNotifier(),
);

final addressValidatorStateProvider =
    StateNotifierProvider<BooleanNotifier, bool>(
  (ref) => BooleanNotifier(),
);

final phoneNumberFieldValidatorStateProvider =
    StateNotifierProvider<BooleanNotifier, bool>(
  (ref) => BooleanNotifier(),
);

final addressFieldValidatorStateProvider =
    StateNotifierProvider<BooleanNotifier, bool>(
  (ref) => BooleanNotifier(),
);

final amountFieldValidatorStateProvider =
    StateNotifierProvider<BooleanNotifier, bool>(
  (ref) => BooleanNotifier(),
);

final amountValidatorStateProvider =
    StateNotifierProvider<BooleanNotifier, bool>(
  (ref) => BooleanNotifier(),
);

final amountFieldValidatorStateProvider2 =
    StateNotifierProvider<BooleanNotifier, bool>(
  (ref) => BooleanNotifier(),
);

final amountValidatorStateProvider2 =
    StateNotifierProvider<BooleanNotifier, bool>(
  (ref) => BooleanNotifier(),
);

final amountFieldValidatorStateProvider3 =
    StateNotifierProvider<BooleanNotifier, bool>(
  (ref) => BooleanNotifier(),
);

final amountValidatorStateProvider3 =
    StateNotifierProvider<BooleanNotifier, bool>(
  (ref) => BooleanNotifier(),
);

final walletFieldValidatorStateProvider =
    StateNotifierProvider<BooleanNotifier, bool>(
  (ref) => BooleanNotifier(),
);

final walletValidatorStateProvider =
    StateNotifierProvider<BooleanNotifier, bool>(
  (ref) => BooleanNotifier(),
);
