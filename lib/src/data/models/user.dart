import 'package:intl/intl.dart';

/// A model class that represents a user, including personal information
/// and timestamps for creation and updates.
class User {
  /// A unique identifier for the user. This field may be null for
  /// newly created users until set by the backend.
  final String? uid;

  /// The user's first name.
  final String firstName;

  /// The user's last name.
  final String lastName;

  /// The user's email address.
  final String email;

  /// The user's phone number. This field is optional.
  final String? phoneNumber;

  /// The user's physical address. This field is optional.
  final String? address;

  /// The user's date of birth. This field is optional.
  final DateTime? dateOfBirth;

  /// The date and time when the user was created.
  /// Defaults to the current date and time if not specified.
  final DateTime createdAt;

  /// The date and time when the user was last updated.
  /// Defaults to the current date and time if not specified.
  final DateTime updatedAt;

  /// Creates a new [User] instance with the specified details.
  ///
  /// If [uid] is not provided, it will be set by the backend.
  /// [createdAt] and [updatedAt] default to the current date and time if not provided.
  User({
    this.uid,
    required this.firstName,
    required this.lastName,
    required this.email,
    this.phoneNumber,
    this.address,
    this.dateOfBirth,
    DateTime? createdAt,
    DateTime? updatedAt,
  })  : createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  /// Private constructor used to create a [User] instance from database data.
  ///
  /// [User._fromDatabase] is used within the [User.fromJson] factory
  /// to ensure that all fields are populated directly from the database.
  User._fromDatabase({
    required this.uid,
    required this.firstName,
    required this.lastName,
    required this.email,
    this.phoneNumber,
    this.address,
    this.dateOfBirth,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Creates a [User] instance from JSON data.
  ///
  /// This factory constructor is useful for deserializing a user object
  /// from backend or database JSON data. It converts date strings to [DateTime]
  /// objects as required.
  ///
  /// - [json] is a `Map<String, dynamic>` containing the user data.
  /// - `id` in the JSON map is mapped to the [uid] field.
  /// - [first_name], [last_name], [email], and other fields are mapped as expected.
  factory User.fromJson(Map<String, dynamic> json) {
    return User._fromDatabase(
      uid: json['id'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      email: json['email'],
      phoneNumber: json['phone_number'],
      address: json['address'],
      dateOfBirth: json['date_of_birth'] != null
          ? DateTime.parse(json['date_of_birth'])
          : null,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  /// Converts a [User] instance to JSON format.
  ///
  /// This method is useful for serializing a [User] object to be sent
  /// to a backend or database. The `dateOfBirth` field is formatted
  /// as 'yyyy-MM-dd' if it is not null, and timestamps are formatted
  /// in ISO 8601 format.
  Map<String, dynamic> toJson() {
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    return {
      'id': uid,
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'phone_number': phoneNumber,
      'address': address,
      'date_of_birth':
          dateOfBirth != null ? formatter.format(dateOfBirth!) : null,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  /// Creates a new [User] instance by copying the current instance
  /// and optionally modifying specified fields.
  ///
  /// This method is useful for creating a modified copy of a [User]
  /// object without altering the original instance.
  ///
  /// Example usage:
  /// ```dart
  /// final updatedUser = user.copyWith(email: 'new.email@example.com');
  /// ```
  ///
  /// Parameters:
  /// - [uid]: The unique identifier for the user. If not provided, the original [uid] is retained.
  /// - [firstName]: The user's first name. If not provided, the original [firstName] is retained.
  /// - [lastName]: The user's last name. If not provided, the original [lastName] is retained.
  /// - [email]: The user's email. If not provided, the original [email] is retained.
  /// - [phoneNumber]: The user's phone number. If not provided, the original [phoneNumber] is retained.
  /// - [address]: The user's address. If not provided, the original [address] is retained.
  /// - [dateOfBirth]: The user's date of birth. If not provided, the original [dateOfBirth] is retained.
  /// - [createdAt]: The creation date. If not provided, the original [createdAt] is retained.
  /// - [updatedAt]: The last updated date. If not provided, the original [updatedAt] is retained.
  ///
  /// Returns a new [User] instance with the updated fields.
  User copyWith({
    String? uid,
    String? firstName,
    String? lastName,
    String? email,
    String? phoneNumber,
    String? address,
    DateTime? dateOfBirth,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return User(
      uid: uid ?? this.uid,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      address: address ?? this.address,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
