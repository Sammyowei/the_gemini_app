import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:the_gemini_app/src/data/models/user.dart';
import 'package:the_gemini_app/src/data/models/user_model.dart';

class UserNotifier extends StateNotifier<User?> {
  UserNotifier() : super(null);

  // Function to set user data
  void setUser(User user) {
    state = user;
  }

  // Function to clear user data (e.g., logout)
  void clearUser() {
    state = null;
  }

  User? getUser() {
    return state;
  }
}

class UserModelNotifier extends StateNotifier<UserModels?> {
  UserModelNotifier() : super(null);

  void setUser(UserModels? user) {
    state = user;
  }

  UserModels? getUser() => state;
}
