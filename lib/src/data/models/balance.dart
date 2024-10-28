import 'package:intl/intl.dart';

/// Represents the balance information for a user's account.
///
/// This class encapsulates all the details related to a user's balance,
/// including current balance, total deposits, withdrawals, earnings, and last update time.
class Balance {
  /// Unique identifier for the balance record.
  final String? id;

  /// ID of the user associated with this balance.
  final String userID;

  /// The current balance of the user's account.
  final num currentBalance;

  /// The total amount of deposits made to the account.
  final num totalDeposit;

  /// The total amount of withdrawals made from the account.
  final num totalWithdrawal;

  /// The total earnings accumulated in the account.
  final num totalEarning;

  /// The date and time when the balance was last updated.
  final DateTime lastUpdated;

  /// Creates a new [Balance] instance.
  ///
  /// All numeric fields default to 0 if not provided.
  Balance({
    this.id,
    required this.userID,
    this.currentBalance = 0,
    this.totalDeposit = 0,
    this.totalWithdrawal = 0,
    this.totalEarning = 0,
    required this.lastUpdated,
  });

  /// Creates a [Balance] instance from a JSON map.
  ///
  /// This factory constructor is used to deserialize JSON data into
  /// a [Balance] object. It sets default values of 0 for numeric fields
  /// if they are not present in the JSON data.
  factory Balance.fromJson(Map<String, dynamic> json) {
    return Balance(
      id: json['id'],
      userID: json['user_id'],
      currentBalance: json['current_balance'] ?? 0,
      totalDeposit: json['total_deposit'] ?? 0,
      totalWithdrawal: json['total_withdrawal'] ?? 0,
      totalEarning: json['total_earning'] ?? 0,
      lastUpdated: DateTime.parse(json['last_updated']),
    );
  }

  /// Converts the [Balance] instance to a JSON map.
  ///
  /// This method is used to serialize the [Balance] object into
  /// a format that can be easily stored or transmitted.
  Map<String, dynamic> toJson() {
    final DateFormat formatter = DateFormat('yyyy-MM-dd HH:mm:ss');
    return {
      'id': id,
      'user_id': userID,
      'current_balance': currentBalance,
      'total_deposit': totalDeposit,
      'total_withdrawal': totalWithdrawal,
      'total_earning': totalEarning,
      'last_updated': formatter.format(lastUpdated),
    };
  }

  /// Returns a string representation of the [Balance].
  @override
  String toString() {
    final currencyFormat = NumberFormat.currency(symbol: '\$');
    return 'Balance(id: $id, userID: $userID, '
        'currentBalance: ${currencyFormat.format(currentBalance)}, '
        'totalDeposit: ${currencyFormat.format(totalDeposit)}, '
        'totalWithdrawal: ${currencyFormat.format(totalWithdrawal)}, '
        'totalEarning: ${currencyFormat.format(totalEarning)}, '
        'lastUpdated: $lastUpdated';
  }
}
