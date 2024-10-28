import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:the_gemini_app/src/data/models/transaction.dart';
import 'package:the_gemini_app/src/data/models/user_model.dart';
import 'package:the_gemini_app/src/presentation/presentation.dart';
import 'package:the_gemini_app/src/presentation/views/home/deposit_screen.dart';

import 'package:the_gemini_app/src/providers/state_notifier_provider/user_state_notifier_provider.dart';

class WalletPage extends ConsumerStatefulWidget {
  final String walletName;

  const WalletPage({
    super.key,
    this.walletName = 'USD Wallet',
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _WalletPageState();
}

class _WalletPageState extends ConsumerState<WalletPage> {
  UserModels? users;
  @override
  void didChangeDependencies() {
    users = ref.watch(userModelsProvider);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.background,
        title: Text(widget.walletName),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              margin: EdgeInsets.symmetric(horizontal: 10.w),
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.w),
              height: MediaQuery.sizeOf(context).height * .25,
              width: MediaQuery.sizeOf(context).width,
              child: Column(
                children: [
                  Consumer(
                    builder: (context, ref, child) {
                      final amount = getUsdWalletBalance(users);
                      final currencyFormatter = NumberFormat.currency(
                          name: 'USD', locale: 'En_US', symbol: '\$');

                      final walletBalance = currencyFormatter.format(amount);
                      return Text(
                        walletBalance,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              fontSize: 35.sp,
                              fontWeight: FontWeight.bold,
                              color: (amount == 0)
                                  ? Theme.of(context)
                                      .colorScheme
                                      .secondary
                                      .withOpacity(.3)
                                  : null,
                            ),
                      );
                    },
                  ),
                  Gap(20.h),
                  SizedBox(
                    height: 90,
                    width: MediaQuery.sizeOf(context).width,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          children: [
                            CustomButton(
                              size: const Size(50, 50),
                              color: Theme.of(context)
                                  .colorScheme
                                  .primary
                                  .withOpacity(.2),
                              outlineColor: Theme.of(context)
                                  .colorScheme
                                  .primary
                                  .withOpacity(.2),
                              onTap: () {
                                depositButton(context);
                              },
                              widget: Icon(
                                Icons.add,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                            Text(
                              'Deposit',
                              style: Theme.of(context).textTheme.bodyLarge,
                            )
                          ],
                        ),
                        Column(
                          children: [
                            CustomButton(
                              size: const Size(50, 50),
                              color: Theme.of(context)
                                  .colorScheme
                                  .primary
                                  .withOpacity(.2),
                              outlineColor: Theme.of(context)
                                  .colorScheme
                                  .primary
                                  .withOpacity(.2),
                              onTap: () {},
                              widget: Icon(
                                Icons.remove,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                            Text(
                              'Withdraw',
                              style: Theme.of(context).textTheme.bodyLarge,
                            )
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            Consumer(
              builder: (context, ref, child) {
                final transaction = ref.watch(userModelsProvider);
                final users = ref.watch(userModelsProvider);
                final walletTransactions = <Transaction>[];

                users?.transaction?.forEach((element) {
                  walletTransactions.add(element);
                });

                return Expanded(
                  child: (transaction?.transaction?.isEmpty ?? true)
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Gap(20.h),
                            Text(
                              'Transactions',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge
                                  ?.copyWith(
                                    fontSize: 20.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            Expanded(
                                child: Center(
                              child: Text(
                                "You do not have any transactions",
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                            ))
                          ],
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Gap(20.h),
                            Text(
                              'Transactions',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge
                                  ?.copyWith(
                                    fontSize: 20.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            Gap(10.h),
                            Expanded(
                              child: ListView.builder(
                                itemCount: walletTransactions.length,
                                itemBuilder: (context, index) {
                                  final reversedList = walletTransactions
                                    ..sort(
                                      (a, b) => b.transactionDate
                                          .compareTo(a.transactionDate),
                                    );

                                  final element = reversedList[index];

                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 8.0),
                                    child: SizedBox(
                                      height: 50.h,
                                      width: 50.h,
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          // Custom Container to the left of the ListTile
                                          Container(
                                            width:
                                                45.0.w, // Customize the width
                                            height:
                                                45.0.h, // Customize the height
                                            margin: const EdgeInsets.only(
                                              right: 16.0,
                                            ),
                                            decoration: BoxDecoration(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .secondary
                                                  .withOpacity(
                                                      .1), // Customize color
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                            ),
                                            child: Center(
                                              child:
                                                  Builder(builder: (context) {
                                                final isDeposit = element
                                                        .transactionType
                                                        .toLowerCase()
                                                        .contains('deposit') ||
                                                    element.transactionType
                                                        .toLowerCase()
                                                        .contains('payout');
                                                return !isDeposit
                                                    ? Icon(
                                                        Icons
                                                            .arrow_outward_rounded,
                                                        color: Colors.red,
                                                        size: 25.h,
                                                      )
                                                    : Transform.rotate(
                                                        angle: 3,
                                                        alignment:
                                                            Alignment.center,
                                                        child: Icon(
                                                          Icons
                                                              .arrow_outward_rounded,
                                                          color: Colors.green,
                                                          size: 25.h,
                                                        ),
                                                      );
                                              }),
                                            ),
                                          ),

                                          // Expanded ListTile to take the remaining width
                                          Expanded(
                                            child: ListTile(
                                              contentPadding: EdgeInsets.zero,
                                              // Remove internal padding for alignment

                                              title: Text(
                                                element.transactionType,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyLarge
                                                    ?.copyWith(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                              ),
                                              subtitle: Text(
                                                DateFormat('MMMM dd yyyy')
                                                    .format(element
                                                        .transactionDate),
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyLarge
                                                    ?.copyWith(
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .secondary,
                                                      fontWeight:
                                                          FontWeight.w200,
                                                    ),
                                              ),
                                              trailing:
                                                  Builder(builder: (context) {
                                                final isDeposit = element
                                                        .transactionType
                                                        .toLowerCase()
                                                        .contains('deposit') ||
                                                    element.transactionType
                                                        .toLowerCase()
                                                        .contains('payout');

                                                final currencyFormatter =
                                                    NumberFormat.currency(
                                                  name: 'USD',
                                                  locale: 'En_US',
                                                  symbol: '\$',
                                                );
                                                return Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.end,
                                                  children: [
                                                    Text(
                                                      '${isDeposit ? '+' : '-'}${currencyFormatter.format(element.amount)}',
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodyLarge
                                                          ?.copyWith(
                                                            fontWeight:
                                                                FontWeight.w100,
                                                          ),
                                                    ),
                                                    Text(
                                                      element.status
                                                          .toLowerCase(),
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodySmall
                                                          ?.copyWith(
                                                              color: !(element
                                                                          .status
                                                                          .toLowerCase() ==
                                                                      'failed')
                                                                  ? Colors.green
                                                                  : Colors.red),
                                                    )
                                                  ],
                                                );
                                              }),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            )
                          ],
                        ),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}

num getUsdWalletBalance(UserModels? users) {
  final transactions = users?.transaction;
  if (users == null || transactions == null || transactions.isEmpty) {
    return 0;
  }

  final walletTransactions = <Transaction>[];
  const walletName = 'usd';

  for (var element in transactions) {
    if (element.transactionType.toLowerCase().contains(walletName)) {
      walletTransactions.add(element);
    }
  }

  num amount = 0;

  for (var element in walletTransactions) {
    final isDeposit = element.transactionType.toLowerCase().contains('deposit');
    final isSuccessful = element.status.toLowerCase() == 'successful';

    if (isSuccessful) {
      if (isDeposit) {
        amount += element.amount;
      } else {
        amount -= element.amount;
      }
    }
  }

  final investmentTransaction = <Transaction>[];
  const investmentKeyword = 'investment';

  for (var element in transactions) {
    final isInvestment =
        element.transactionType.toLowerCase().contains(investmentKeyword);

    if (isInvestment) {
      investmentTransaction.add(element);
    }
  }

  for (var element in investmentTransaction) {
    final isInvested = element.transactionType.toLowerCase().contains('buy-in');

    if (isInvested) {
      amount -= element.amount;
    } else {
      amount += element.amount;
    }
  }

  return amount;
}

void depositButton(BuildContext context) {
  showModalBottomSheet(
    context: context,
    showDragHandle: true,
    builder: (context) {
      return const DepositScreen();
    },
  );
}

num getInvestmentsBalance(UserModels? users, [String keyword = 'crypto']) {
  final transactions = users?.transaction;
  if (users == null || transactions == null || transactions.isEmpty) {
    return 0;
  }

  print('Here');
  const depositKeyword = 'buy-in';
  const withdrawalKeyword = 'payout';

  // Now let's collect only the transactions with the keywords and store them in a separate collection.

  final investmentTransactions = <Transaction>[];

  for (var transaction in transactions) {
    // print(transaction.transactionType);
    if (transaction.transactionType.toLowerCase().startsWith(keyword)) {
      print(transaction.transactionType);
      investmentTransactions.add(transaction);
      print('Here 1');
    }
  }

  print(investmentTransactions.length);
  // Check if the transaction is collection is empty to avoid conflict then move foward

  if (investmentTransactions.isEmpty) {
    print('Here 2');
    return 0;
  }

// also  check if its just a single transaction present and check if that transaction is a buy in

  if (investmentTransactions.length == 1) {
    print('Here 3');
    return investmentTransactions.first.amount;
  }

//  Get the total number of buy-in transaction and payout transaction

  final buyInTransactions = <Transaction>[];

  final payoutTransactions = <Transaction>[];

  for (var investmentTransaction in investmentTransactions) {
    if (investmentTransaction.transactionType
        .toLowerCase()
        .endsWith(depositKeyword)) {
      buyInTransactions.add(investmentTransaction);
      print('Here 4');
    } else if (investmentTransaction.transactionType
        .toLowerCase()
        .endsWith(withdrawalKeyword)) {
      payoutTransactions.add(investmentTransaction);
      print('Here 5');
    }
  }

  if (buyInTransactions.length == payoutTransactions.length) {
    print('Here 6');
    return 0;
  }
  // check to see if the number of buy in are greater than the number of payout

  num amount = 0;

  if (buyInTransactions.length > payoutTransactions.length) {
    // get the remaining length of buy in trancaction

// sort the transaction by date to get the most recent date.

    buyInTransactions.sort(
      (a, b) {
        return b.transactionDate.compareTo(a.transactionDate);
      },
    );

    print('Here 7');
    final remainingBuyInTransaction =
        payoutTransactions.length % buyInTransactions.length;

    print(remainingBuyInTransaction);

    for (var i = 0; i < remainingBuyInTransaction; i++) {
      amount += buyInTransactions[i].amount;
      print('Here 8');

      print(amount);
    }
  }

//  not run the sum of all payout and buy-in if its payout you subtract if its buy in you add

  print('colplete');
  return amount;
}
