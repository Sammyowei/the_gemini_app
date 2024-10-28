import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:the_gemini_app/src/data/models/auth_model/auth_models.dart';

final authModelProvider = Provider<AuthUser>((ref) {
  return AuthUser(email: '', password: '');
});
