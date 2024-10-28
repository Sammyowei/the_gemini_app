import 'package:intl/intl.dart';

/// Represents a type of investment available to users.
///
/// This class encapsulates all the details related to a specific investment type,
/// including its unique identifier, name, risk level, expected return, duration,
/// description, and creation/update timestamps.
class InvestmentType {
  /// Unique identifier for the investment type.
  final String id;

  /// Name of the investment type.
  final String name;

  /// Risk level associated with this investment type.
  final num minimumAmount;

  /// Expected return for this investment type.
  final num expectedReturn;

  /// Duration of the investment in days.
  final int durationDays;

  /// Detailed description of the investment type.
  final String? description;

  /// The date and time when this investment type was created.
  final DateTime? createdAt;

  /// The date and time when this investment type was last updated.
  final DateTime? updatedAt;

  /// Creates a new [InvestmentType] instance.
  InvestmentType({
    required this.id,
    required this.name,
    required this.minimumAmount,
    required this.expectedReturn,
    required this.durationDays,
    this.description,
    this.createdAt,
    this.updatedAt,
  });

  /// Creates an [InvestmentType] instance from a JSON map.
  ///
  /// This factory constructor is used to deserialize JSON data into
  /// an [InvestmentType] object.
  factory InvestmentType.fromJson(Map<String, dynamic> json) {
    return InvestmentType(
      id: json['id'],
      name: json['name'],
      minimumAmount: json['minimum_amount'],
      expectedReturn: json['expected_return'],
      durationDays: json['duration_days'],
      description: json['description'],
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : null,
    );
  }

  /// Converts the [InvestmentType] instance to a JSON map.
  ///
  /// This method is used to serialize the [InvestmentType] object into
  /// a format that can be easily stored or transmitted.
  Map<String, dynamic> toJson() {
    final DateFormat formatter = DateFormat('yyyy-MM-dd HH:mm:ss');
    return {
      'id': id,
      'name': name,
      'minimum_amount': minimumAmount,
      'expected_return': expectedReturn,
      'duration_days': durationDays,
      'description': description,
      'created_at': createdAt != null ? formatter.format(createdAt!) : null,
      'updated_at': updatedAt != null ? formatter.format(updatedAt!) : null,
    };
  }

  /// Returns a string representation of the [InvestmentType].
  @override
  String toString() {
    return 'InvestmentType(id: $id, name: $name, minimumAmount: $minimumAmount, '
        'expectedReturn: $expectedReturn, durationDays: $durationDays)';
  }
}
