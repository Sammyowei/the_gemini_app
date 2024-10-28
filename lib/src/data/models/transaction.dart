import 'package:intl/intl.dart';

class Transaction {
  final String? id;
  final String transactionType, status, referenceID, userID;
  final String? relativeInvestmentID, description;
  final num amount;
  final DateTime transactionDate;

  Transaction({
    this.id,
    required this.transactionType,
    required this.status,
    required this.referenceID,
    required this.userID,
    this.relativeInvestmentID,
    this.description,
    required this.amount,
    required this.transactionDate,
  });

  // Constructor for creating a Transaction instance from database data
  Transaction._fromDatabase({
    required this.id,
    required this.transactionType,
    required this.status,
    required this.referenceID,
    required this.userID,
    this.relativeInvestmentID,
    this.description,
    required this.amount,
    required this.transactionDate,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction._fromDatabase(
      id: json['id'],
      transactionType: json['transaction_type'],
      status: json['status'],
      referenceID: json['reference_id'],
      userID: json['user_id'],
      relativeInvestmentID: json['relative_investment_id'],
      description: json['description'],
      amount: json['amount'],
      transactionDate: DateTime.parse(json['transaction_date']),
    );
  }

  Map<String, dynamic> toJson() {
    final DateFormat formatter = DateFormat('yyyy-MM-dd HH:mm:ss');
    return {
      'id': id,
      'transaction_type': transactionType,
      'status': status,
      'reference_id': referenceID,
      'user_id': userID,
      'relative_investment_id': relativeInvestmentID,
      'description': description,
      'amount': amount,
      'transaction_date': formatter.format(transactionDate),
    };
  }
}
