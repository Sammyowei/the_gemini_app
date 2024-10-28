import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:the_gemini_app/src/providers/state_notifiers/number_state_notifier.dart';

final verificationStateNotifierProvider =
    StateNotifierProvider<VerificationNotifier, int>((ref) {
  return VerificationNotifier();
});

final bottomNavStateProvider =
    StateNotifierProvider<BottomNavNotifier, int>((ref) {
  return BottomNavNotifier();
});
