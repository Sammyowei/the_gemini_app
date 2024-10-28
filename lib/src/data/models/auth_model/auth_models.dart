import 'dart:convert';

class AuthUser {
  final String email;
  final String password;

  AuthUser({required this.email, required this.password});

  // Convert a User instance into a Map
  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'password': password,
    };
  }

  // Create a User instance from a Map
  factory AuthUser.fromMap(Map<String, dynamic> map) {
    return AuthUser(
      email: map['email'],
      password: map['password'],
    );
  }

  // Convert a User instance to a JSON string
  String toJson() => jsonEncode(toMap());

  // Create a User instance from a JSON string
  factory AuthUser.fromJson(String source) =>
      AuthUser.fromMap(jsonDecode(source));

  // Copy method
  AuthUser copyWith({String? email, String? password}) {
    return AuthUser(
      email: email ?? this.email,
      password: password ?? this.password,
    );
  }
}
