import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:the_gemini_app/src/domain/config/supabase_config.dart';

class AuthRepository {
  Future<AuthResponse> signUp({String email = '', String password = ''}) async {
    final res = await SupabaseConfig().client.auth.signUp(
          password: password,
          email: email,
        );

    return res;
  }

  Future<AuthResponse> signIn({String email = '', String password = ""}) async {
    final res = await SupabaseConfig().client.auth.signInWithPassword(
          password: password,
          email: email,
        );

    return res;
  }
}
