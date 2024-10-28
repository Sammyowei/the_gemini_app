import 'package:intl/intl.dart';

/// Represents an investment made by a user.
///
/// This class encapsulates all the details related to a single investment,
/// including its unique identifier, associated user, investment type,
/// status, amount, and various important dates.
class Investment {
  /// Unique identifier for the investment.
  final String? id;

  /// ID of the user who made the investment.
  final String userId;

  /// ID of the investment type.
  final String investmentTypeId;

  /// Current status of the investment (e.g., "active", "matured", "cancelled").
  final String status;

  /// The amount invested.
  final num amount;

  /// The date when the investment was made.
  final DateTime investmentDate;

  /// The date when the investment record was created in the system.
  final DateTime createdAt;

  /// The date when the investment record was last updated.
  final DateTime updatedAt;

  /// The date when the investment is set to mature.
  final DateTime maturityDate;

  /// Creates a new [Investment] instance.
  ///
  /// The [id] parameter is optional and can be null for new investments
  /// that haven't been assigned an ID yet.
  Investment({
    this.id,
    required this.userId,
    required this.investmentTypeId,
    required this.status,
    required this.amount,
    required this.investmentDate,
    required this.createdAt,
    required this.updatedAt,
    required this.maturityDate,
  });

  /// Creates an [Investment] instance from a JSON map.
  ///
  /// This factory constructor is used to deserialize JSON data into
  /// an [Investment] object.
  factory Investment.fromJson(Map<String, dynamic> json) {
    return Investment(
      id: json['id'],
      userId: json['user_id'],
      investmentTypeId: json['investment_type_id'],
      status: json['status'],
      amount: json['amount'],
      investmentDate: DateTime.parse(json['investment_date']),
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      maturityDate: DateTime.parse(json['maturity_date']),
    );
  }

  /// Converts the [Investment] instance to a JSON map.
  ///
  /// This method is used to serialize the [Investment] object into
  /// a format that can be easily stored or transmitted.
  Map<String, dynamic> toJson() {
    final DateFormat formatter = DateFormat('yyyy-MM-dd HH:mm:ss');
    return {
      'id': id,
      'user_id': userId,
      'investment_type_id': investmentTypeId,
      'status': status,
      'amount': amount,
      'investment_date': formatter.format(investmentDate),
      'created_at': formatter.format(createdAt),
      'updated_at': formatter.format(updatedAt),
      'maturity_date': formatter.format(maturityDate),
    };
  }
}
