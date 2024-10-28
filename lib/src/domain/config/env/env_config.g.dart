// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'env_config.dart';

// **************************************************************************
// EnviedGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
final class _Env {
  static const String projectUrl = 'https://cbrwyycbrwycfsbpnewm.supabase.co';

  static const String projectAnonKey =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImNicnd5eWNicnd5Y2ZzYnBuZXdtIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MjczNDQ3MDksImV4cCI6MjA0MjkyMDcwOX0.f03qclGk5pXfzQYvmsGBbDs8YRjBnEI_-jbA3NKBWi0';

  static const List<int> _enviedkeyprojectDatabasePassword = <int>[
    266880211,
    1581210796,
    4103480655,
    271987258,
    449736147,
    60843962,
    2750470409,
    3536746371,
    2539631684,
    1536453804,
    417265054,
    495895211,
    3573255702,
    367491173,
    4015678627,
    972767249,
  ];

  static const List<int> _envieddataprojectDatabasePassword = <int>[
    266880145,
    1581210868,
    4103480601,
    271987314,
    449736167,
    60844024,
    2750470527,
    3536746485,
    2539631644,
    1536453854,
    417265138,
    495895260,
    3573255744,
    367491093,
    4015678673,
    972767327,
  ];

  static final String projectDatabasePassword = String.fromCharCodes(
      List<int>.generate(
    _envieddataprojectDatabasePassword.length,
    (int i) => i,
    growable: false,
  ).map((int i) =>
          _envieddataprojectDatabasePassword[i] ^
          _enviedkeyprojectDatabasePassword[i]));
}
