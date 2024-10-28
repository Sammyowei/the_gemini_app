import 'package:flutter/material.dart' hide Notification;
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide User;
import 'package:the_gemini_app/src/data/models/balance.dart';
import 'package:the_gemini_app/src/data/models/investment.dart';
import 'package:the_gemini_app/src/data/models/investment_type.dart';
import 'package:the_gemini_app/src/data/models/notification.dart';
import 'package:the_gemini_app/src/data/models/transaction.dart';
import 'package:the_gemini_app/src/data/models/user.dart';
import 'package:the_gemini_app/src/data/models/user_model.dart';
import 'package:the_gemini_app/src/providers/state_notifier_provider/user_state_notifier_provider.dart';
import 'package:uuid/uuid.dart';

import '../../presentation/widgets/supabase/supabase_inherited_widget.dart';

final userFutureProvider = FutureProvider.autoDispose
    .family<UserModels?, BuildContext>((ref, context) async {
  // get BuildContext from ref

  final user = await getUserData(context);

  ref.read(userModelsProvider.notifier).setUser(user);
  return user;
});

Future<UserModels?> getUserData(BuildContext context) async {
  try {
    //  STEP 1: Check if User Exist or not if user exist proceed to step 2;

    final id =
        MySupabaseConfig.of(context).supabase.client.auth.currentUser?.id;

    print(id);
    final users = await MySupabaseConfig.of(context)
        .supabase
        .client
        .from('users_table')
        .select()
        .match({'id': id!});

    if (users.isEmpty) {
      //  Return User to user onboarding;
      print("Ran into an error here");
      return null;
    }

    print("Got it");
    final user = User.fromJson(users.first);

    // STEP 2: querry user transaction records
    final transactions = await MySupabaseConfig.of(context)
        .supabase
        .client
        .from('transactions')
        .select()
        .match({'user_id': id});

    List<Transaction> transactions0 = [];
    if (transactions.isEmpty) {
      // Return empty transactions body when theres no record of any transaction found in the system.
      print('Transactions are empty.');
      transactions0 = [];
    } else {
      for (var transaction in transactions) {
        print('Transacions are not empty');
        transactions0.add(Transaction.fromJson(transaction));
      }
    }

    // STEP 3: Get all notifications.
    final notifications = await MySupabaseConfig.of(context)
        .supabase
        .client
        .from('notifications')
        .select()
        .match({'user_id': id});

    List<Notification> notifications0 = [];
    if (notifications.isEmpty) {
      // Return empty transactions body when theres no record of any transaction found in the system.
      print('Notifications are empty.');
      notifications0 = [];
    } else {
      for (var notification in notifications) {
        print('Notifications are not empty.');
        // print(notification);
        notifications0.add(Notification.fromJson(notification));
      }
    }

    // STEP 4: Get all investments

    final investments = await MySupabaseConfig.of(context)
        .supabase
        .client
        .from('investments')
        .select()
        .match({'user_id': id});

    List<Investment> investments0 = [];

    if (investments.isEmpty) {
      // Return empty list of Investment data
      print('investments are empty.');
      investments0 = [];
    } else {
      for (var investment in investments) {
        print('investments are not empty.');
        // print(investment);
        investments0.add(
          Investment.fromJson(investment),
        );
      }
    }

    // STEP 5: Get the record of INvestment Types

    final investmentTypes = await MySupabaseConfig.of(context)
        .supabase
        .client
        .from('investment_types')
        .select();

    List<InvestmentType> investmentTypes0 = [];

    if (investmentTypes.isEmpty) {
      // Return empty list of Investment data
      print('investment types  are empty.');
      investmentTypes0 = [];
    } else {
      for (var investmentype in investmentTypes) {
        print('investment types  are  not empty.');

        // print(investmentype);
        investmentTypes0.add(
          InvestmentType.fromJson(investmentype),
        );
      }
    }

    // STEP 6: Get user Balance

    // STEP 7: Instanciate the user model

    final userData = UserModels(
        investment: investments0,
        investmentType: investmentTypes0,
        notification: notifications0,
        transaction: transactions0,
        user: user);

    return userData;
  } on PostgrestException catch (e) {
    print(e.message);
    return null;
  }
}
