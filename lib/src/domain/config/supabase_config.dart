import 'package:supabase_flutter/supabase_flutter.dart';

/// A class representing the configuration for Supabase.
class SupabaseConfig {
  /// The URL of the Supabase project.
  final String _projectUrl;

  /// The anonymous key for accessing Supabase.
  final String _anonKey;

  /// The initialized Supabase instance.
  late Supabase _supabase;

  bool _isinitialied = false;

  /// The Supabase client instance.

  /// Constructs a [SupabaseConfig] object with provided parameters.
  ///
  /// [projectUrl] is the URL of the Supabase project.
  /// [anonKey] is the anonymous key for accessing Supabase.
  SupabaseConfig({String? projectUrl, String? anonKey})
      : _projectUrl = projectUrl ?? "https://cbrwyycbrwycfsbpnewm.supabase.co",
        _anonKey = anonKey ??
            "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImNicnd5eWNicnd5Y2ZzYnBuZXdtIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MjczNDQ3MDksImV4cCI6MjA0MjkyMDcwOX0.f03qclGk5pXfzQYvmsGBbDs8YRjBnEI_-jbA3NKBWi0" {
    // Initializes Supabase during object construction.
    initSupabase();
  }

  /// Initializes the Supabase and Supabase client.
  Future<void> initSupabase() async {
    if (!_isinitialied) {
      _supabase =
          await Supabase.initialize(url: _projectUrl, anonKey: _anonKey);
      _isinitialied = true;

      print("Supabase Init successfully");
    } else {
      _supabase;
      print("Supabase Init already successfully");
    }
  }

  /// Getter method to retrieve the Supabase client instance.
  SupabaseClient get client => _supabase.client;

  /// Getter method to retrieve the Supabase configuration.
  Supabase get supabase => _supabase;
}
