import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:the_gemini_app/src/providers/state_notifiers/string_state_notifier.dart';

final urlstateProvider = StateNotifierProvider<StringNotifier, String>((ref) {
  return StringNotifier();
});
