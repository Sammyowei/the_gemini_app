import 'package:the_gemini_app/src/data/models/balance.dart';
import 'package:the_gemini_app/src/data/models/investment.dart';
import 'package:the_gemini_app/src/data/models/investment_type.dart';
import 'package:the_gemini_app/src/data/models/notification.dart';
import 'package:the_gemini_app/src/data/models/transaction.dart';
import 'package:the_gemini_app/src/data/models/user.dart';

class UserModels {
  final User? user;
  final List<Transaction>? transaction;

  final List<Notification>? notification;

  final List<Investment>? investment;

  final List<InvestmentType>? investmentType;

  UserModels({
    this.investment,
    this.investmentType,
    this.notification,
    this.transaction,
    this.user,
  });
}
