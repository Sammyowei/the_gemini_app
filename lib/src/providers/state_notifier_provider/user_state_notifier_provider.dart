import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:the_gemini_app/src/data/models/user.dart';
import 'package:the_gemini_app/src/data/models/user_model.dart';
import 'package:the_gemini_app/src/providers/state_notifiers/user_state_notifier.dart';

final userProvider =
    StateNotifierProvider<UserNotifier, User?>((ref) => UserNotifier());

final userModelsProvider =
    StateNotifierProvider<UserModelNotifier, UserModels?>((ref) {
  return UserModelNotifier();
});
