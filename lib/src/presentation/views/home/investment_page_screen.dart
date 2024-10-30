import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:the_gemini_app/main.dart';
import 'package:the_gemini_app/src/data/models/investment_type.dart';
import 'package:the_gemini_app/src/data/models/user_model.dart';
import 'package:the_gemini_app/src/presentation/views/home/investment_detail_page.dart';
import 'package:the_gemini_app/src/presentation/widgets/supabase/supabase_inherited_widget.dart';
import 'package:the_gemini_app/src/providers/future_providers/user_future_provider.dart';
import 'package:the_gemini_app/src/providers/state_notifier_provider/boolean_state_notifier_provider.dart';
import 'package:the_gemini_app/src/providers/state_notifier_provider/string_state_notifier_provider.dart';
import 'package:the_gemini_app/src/providers/state_notifier_provider/user_state_notifier_provider.dart';
import 'package:uuid/uuid.dart';

import '../../../data/models/investment.dart';
import '../../../data/models/transaction.dart';
import '../../presentation.dart';
import 'wallet_page.dart';

class InvestmentScreen extends ConsumerStatefulWidget {
  final String investmentType;
  const InvestmentScreen({super.key, this.investmentType = 'crypto'});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _InvestmentScreenState();
}

class _InvestmentScreenState extends ConsumerState<InvestmentScreen> {
  @override
  Widget build(BuildContext context) {
    String name = widget.investmentType;

    if (name == 'ai/tesla') {
      name = "Smart AI";
    } else if (name == 'crypto') {
      name = 'Crypto';
    } else if (name == 'capital') {
      name = 'Capital Venture';
    }
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: Text("$name Investments"),
      ),
      body: Consumer(
        builder: (context, ref, child) {
          final users = ref.watch(userModelsProvider);

          final walletTransactions = <Transaction>[];

          final queryTransactions = users?.transaction;

          if (queryTransactions == null) {
            walletTransactions;
          } else {
            for (var element in queryTransactions) {
              if (element.transactionType
                  .toLowerCase()
                  .startsWith(widget.investmentType)) {
                walletTransactions.add(element);
              }
            }
          }

          final amount = getInvestmentsBalance(users, widget.investmentType);
          final currencyFormatter =
              NumberFormat.currency(name: 'USD', locale: 'En_US', symbol: '\$');

          final walletBalance = currencyFormatter.format(amount);

          return SizedBox(
            width: MediaQuery.sizeOf(context).width,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                children: [
                  Text(
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
                  ),
                  Gap(20.h),
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomButton(
                            size:
                                Size(MediaQuery.sizeOf(context).width * .4, 50),
                            color: Theme.of(context)
                                .colorScheme
                                .primary
                                .withOpacity(.2),
                            outlineColor: Theme.of(context)
                                .colorScheme
                                .primary
                                .withOpacity(.2),
                            onTap: () {
                              addInvestment(context, widget.investmentType);
                            },
                            widget: Text(
                              'Add Investment',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge
                                  ?.copyWith(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                  ),
                            )),
                      ],
                    ),
                  ),
                  Gap(30.h),
                  Row(
                    children: [
                      Text(
                        'Transactions',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              fontSize: 20.sp,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ],
                  ),
                  Expanded(
                    child: (walletTransactions.isEmpty)
                        ? Center(
                            child: Text(
                              "You do not have any investments",
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                          )
                        : ListView.builder(
                            itemCount: walletTransactions.length,
                            itemBuilder: (context, index) {
                              final reversedList = walletTransactions
                                ..sort(
                                  (a, b) => b.transactionDate
                                      .compareTo(a.transactionDate),
                                );

                              final element = reversedList[index];

                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8.0),
                                child: SizedBox(
                                  height: 50.h,
                                  width: 50.h,
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      // Custom Container to the left of the ListTile
                                      Container(
                                        width: 45.0.w, // Customize the width
                                        height: 45.0.h, // Customize the height
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
                                          child: Builder(builder: (context) {
                                            final isDeposit = element
                                                    .transactionType
                                                    .toLowerCase()
                                                    .contains('deposit') ||
                                                element.transactionType
                                                    .toLowerCase()
                                                    .contains('payout');
                                            return isDeposit
                                                ? Icon(
                                                    Icons.arrow_outward_rounded,
                                                    color: Colors.red,
                                                    size: 25.h,
                                                  )
                                                : Transform.rotate(
                                                    angle: 3,
                                                    alignment: Alignment.center,
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
                                          onTap: () {
                                            print("Index + $index");
                                            print(element.relativeInvestmentID);
                                            showInvestmentDetail(
                                                context,
                                                element.relativeInvestmentID ==
                                                        null
                                                    ? ''
                                                    : element
                                                        .relativeInvestmentID!);
                                          },
                                          contentPadding: EdgeInsets.zero,
                                          title: Text(
                                            element.transactionType,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyLarge
                                                ?.copyWith(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                          ),
                                          subtitle: Text(
                                            DateFormat('MMMM dd yyyy').format(
                                                element.transactionDate),
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyLarge
                                                ?.copyWith(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .secondary,
                                                  fontWeight: FontWeight.w200,
                                                ),
                                          ),
                                          trailing: Builder(builder: (context) {
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
                                                  '${!isDeposit ? '+' : '-'}${currencyFormatter.format(element.amount)}',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyLarge
                                                      ?.copyWith(
                                                        fontWeight:
                                                            FontWeight.w100,
                                                      ),
                                                ),
                                                Text(
                                                  element.status.toLowerCase(),
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
            ),
          );
        },
      ),
    );
  }
}

void addInvestment(BuildContext context, String investmentCat) {
  showModalBottomSheet(
    elevation: 3,
    enableDrag: true,
    context: context,
    isScrollControlled: true,
    builder: (context) {
      return FractionallySizedBox(
        heightFactor: 0.95,
        child: AddInvestment(
          category: investmentCat,
        ),
      );
    },
  );
}

void showInvestmentDetail(BuildContext context, [String id = '']) {
  showModalBottomSheet(
    elevation: 3,
    enableDrag: true,
    context: context,
    isScrollControlled: true,
    builder: (context) {
      return FractionallySizedBox(
          heightFactor: 0.95,
          child: INvestmentDetailPage(
            investmentID: id,
          ));
    },
  );
}

class AddInvestment extends ConsumerStatefulWidget {
  final String category;
  const AddInvestment({super.key, this.category = 'crypto'});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AddInvestmentState();
}

class _AddInvestmentState extends ConsumerState<AddInvestment> {
  String? selectedValue;

  String investCategory = '';

  late TextEditingController _amountcontroller;

  @override
  void initState() {
    // TODO: implement initState

    _amountcontroller = TextEditingController();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    Future.delayed(
      const Duration(milliseconds: 100),
      () {
        ref.read(investmentPickerProvider.notifier).setValue('');

        ref.read(amountFieldValidatorStateProvider2.notifier).toggleOff();
        ref.read(amountValidatorStateProvider2.notifier).toggleOff();
      },
    );
    super.didChangeDependencies();
  }

  void _onChanged(String? value, [num minimumInvest = 0]) {
    if (value == null || value.isEmpty) {
      ref.read(amountFieldValidatorStateProvider2.notifier).toggleOff();
    } else {
      ref.read(amountFieldValidatorStateProvider2.notifier).toggleOn();
      if (double.parse(value) < minimumInvest) {
        ref.read(amountValidatorStateProvider2.notifier).toggleOff();
      } else {
        ref.read(amountValidatorStateProvider2.notifier).toggleOn();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final users = ref.watch(userModelsProvider);

        if (widget.category == 'capital') {
          investCategory = 'capital venture';
        } else {
          investCategory = widget.category;
        }

        final investmentPlans = <InvestmentType>[];
        final investmentTypes = users?.investmentType;

        if (investmentTypes != null && investmentTypes.isNotEmpty) {
          for (var investment in investmentTypes) {
            if (investment.category.trim().toLowerCase() == investCategory) {
              investmentPlans.add(investment);
            }
          }
        }

        final investmentPlan = ref.watch(investmentPickerProvider);

        return Container(
          padding: EdgeInsets.symmetric(vertical: 20.w),
          height: MediaQuery.sizeOf(context).height * .95,
          width: MediaQuery.sizeOf(context).width,
          decoration: ShapeDecoration(
            color: Theme.of(context).colorScheme.surface,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(20.r),
              ),
            ),
          ),
          child: SingleChildScrollView(
            // Wrap in a scrollable widget
            child: SizedBox(
              width: MediaQuery.sizeOf(context).width,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Pick an Investment Plan',
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                    Gap(20.h),
                    Padding(
                      padding: const EdgeInsets.all(0),
                      child: DropdownMenu(
                        menuStyle: const MenuStyle(),
                        controller: TextEditingController(text: investmentPlan),
                        onSelected: (value) {
                          print(value);
                          if (value == null) {
                          } else {
                            ref
                                .read(investmentPickerProvider.notifier)
                                .setValue(value);
                          }
                        },
                        width: (MediaQuery.sizeOf(context).width * .93),
                        dropdownMenuEntries: investmentPlans.map((e) {
                          return DropdownMenuEntry(
                              value: e.name, label: e.name);
                        }).toList(),
                      ),
                    ),
                    Gap(20.h),
                    Consumer(
                      builder: (context, ref, child) {
                        final invst = ref.watch(investmentPickerProvider);
                        if (invst.isEmpty) {
                          return Container();
                        } else {
                          late InvestmentType investment;

                          investment = investmentPlans
                              .where((element) => invst == element.name)
                              .first;

                          final amount = NumberFormat.currency(
                                  symbol: '\$', name: 'USD', locale: 'En_US')
                              .format(investment.minimumAmount);

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Text('${investment.toJson()}'),

                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Investment Detail',
                                    style:
                                        Theme.of(context).textTheme.titleLarge,
                                  )
                                ],
                              ),
                              Gap(20.h),
                              Text(
                                'Name: ${investment.name}',
                                style: Theme.of(context).textTheme.titleMedium,
                              ),

                              Gap(10.h),
                              Text(
                                'Description:\n\n${investment.description}',
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),

                              Gap(30.h),

                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Column(
                                    children: [
                                      Text(
                                        'Min amount',
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium,
                                      ),
                                      Text(
                                        amount,
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium,
                                      ),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      Text(
                                        'Duration',
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium,
                                      ),
                                      Text(
                                        '${investment.durationDays} Days',
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium,
                                      ),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      Text(
                                        'Return',
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium,
                                      ),
                                      Text(
                                        '${investment.expectedReturn}%',
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium,
                                      ),
                                    ],
                                  ),
                                ],
                              ),

                              Gap(40.h),

                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'How much do you want to invest?',
                                    style:
                                        Theme.of(context).textTheme.titleMedium,
                                  ),
                                ],
                              ),

                              Gap(20.h),

                              Consumer(
                                builder: (context, ref, child) {
                                  final fieldValidator = ref.watch(
                                      amountFieldValidatorStateProvider2);

                                  final amountValidator =
                                      ref.watch(amountValidatorStateProvider2);
                                  return CustomTextField(
                                    controller: _amountcontroller,
                                    onChanged: (value) {
                                      _onChanged(
                                          value, investment.minimumAmount);
                                    },
                                    hintText: 'Amount',
                                    keyboardType: TextInputType.number,
                                    prefixIcon: Icon(
                                      Icons.wallet_rounded,
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                      size: 18.h,
                                    ),
                                    sulfixIcon: !fieldValidator
                                        ? null
                                        : amountValidator
                                            ? Icon(
                                                Icons
                                                    .check_circle_outline_rounded,
                                                color: Colors.green,
                                                size: 18.h,
                                              )
                                            : Icon(
                                                Icons.cancel_outlined,
                                                color: Colors.red,
                                                size: 18.h,
                                              ),
                                  );
                                },
                              ),

                              Gap(10.h),

                              Row(
                                children: [
                                  Text("Minimum: $amount"),
                                ],
                              ),

                              Gap(25.h),

                              Consumer(
                                builder: (context, ref, child) {
                                  final isFieldValid = ref.watch(
                                      amountFieldValidatorStateProvider2);

                                  final isAmountValid =
                                      ref.watch(amountValidatorStateProvider2);

                                  final isValid =
                                      (isFieldValid && isAmountValid);
                                  return CustomButton(
                                    onTap: !isValid
                                        ? null
                                        : () async {
// TODO: Inplement the logic to make better investments.

                                            showLoadingDialog(context);

                                            print("here");

                                            final id =
                                                MySupabaseConfig.of(context)
                                                    .supabase
                                                    .client
                                                    .auth
                                                    .currentUser
                                                    ?.id;

                                            print(id);
                                            if (id == null) {
                                              // TODO: Log user Out
                                              context.pop();
                                            } else {
                                              final usdBalance =
                                                  getUsdWalletBalance(users);

                                              if (double.parse(
                                                      _amountcontroller.text) >
                                                  usdBalance) {
                                                print(
                                                    "Should have worked Here?");

                                                context.pop();
                                                showDialog(
                                                  context: context,
                                                  barrierDismissible: false,
                                                  builder: (context) {
                                                    return AlertDialog.adaptive(
                                                      title: const Text(
                                                          'Insufficient Balance'),
                                                      content: Text(
                                                          'The minimum investment amount is $amount, '
                                                          'but your current balance is only ${NumberFormat.currency(symbol: '\$', name: 'USD', locale: "En_US").format(usdBalance)}. '
                                                          'Please deposit additional funds to proceed.'),
                                                    );
                                                  },
                                                );

                                                Future.delayed(
                                                  const Duration(seconds: 3),
                                                  () => context.pop(),
                                                );
                                              } else {
                                                // Get The Investment Type Details.

                                                print(investment.toString());

                                                final newInvestment =
                                                    Investment(
                                                  id: const Uuid().v4(),
                                                  amount: double.parse(
                                                    _amountcontroller.text
                                                        .trim(),
                                                  ),
                                                  userId: id,
                                                  investmentDate:
                                                      DateTime.now(),
                                                  investmentTypeId:
                                                      investment.id,
                                                  maturityDate: getFutureDate(
                                                      investment.durationDays),
                                                  status: 'Successful',
                                                  createdAt: DateTime.now(),
                                                  updatedAt: DateTime.now(),
                                                );
                                                print(newInvestment.toJson());

// Make new Transaction to add to the Transaction DB;

                                                final newTransaction =
                                                    Transaction(
                                                        id: const Uuid().v4(),
                                                        relativeInvestmentID:
                                                            newInvestment.id,
                                                        transactionType:
                                                            '${widget.category} Investment Buy-In',
                                                        status: 'Successful',
                                                        referenceID:
                                                            const Uuid().v4(),
                                                        userID: id,
                                                        amount: double.parse(
                                                          _amountcontroller.text
                                                              .trim(),
                                                        ),
                                                        transactionDate:
                                                            DateTime.now(),
                                                        description: investment
                                                            .description);

                                                print(newTransaction.toJson());

                                                // Start to send data to the db.

                                                try {
                                                  await MySupabaseConfig.of(
                                                          context)
                                                      .supabase
                                                      .client
                                                      .from('investments')
                                                      .insert(newInvestment
                                                          .toJson());

                                                  await MySupabaseConfig.of(
                                                          context)
                                                      .supabase
                                                      .client
                                                      .from('transactions')
                                                      .insert(newTransaction
                                                          .toJson());

                                                  context.pop();

                                                  showDialog(
                                                    context: context,
                                                    builder:
                                                        (BuildContext context) {
                                                      return AlertDialog
                                                          .adaptive(
                                                        title: Text(
                                                          'Investment Successful',
                                                          style:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .titleLarge,
                                                        ),
                                                        content: Text(
                                                          'Congratulations! You have successfully invested \$${NumberFormat.currency(symbol: '\$', name: 'USD', locale: 'En_US').format(newInvestment.amount)} '
                                                          'in the ${investment.name} plan. We wish you great returns on your investment!',
                                                          style:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .titleSmall
                                                                  ?.copyWith(),
                                                        ),
                                                        actions: <Widget>[
                                                          TextButton(
                                                            child: const Text(
                                                                'OK'),
                                                            onPressed: () {
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                            },
                                                          ),
                                                        ],
                                                      );
                                                    },
                                                  );

                                                  ref.refresh(
                                                      userFutureProvider(
                                                              context)
                                                          .future);
                                                } on PostgrestException catch (e) {
                                                  print(e.message);
                                                  showDialog(
                                                    context: context,
                                                    barrierDismissible: false,
                                                    builder: (context) {
                                                      return AlertDialog
                                                          .adaptive(
                                                        title:
                                                            const Text('Error'),
                                                        content: Text(
                                                            "Error details: ${e.details} \nError message: ${e.message}"),
                                                      );
                                                    },
                                                  );

                                                  Future.delayed(
                                                    const Duration(seconds: 3),
                                                    () => context.pop(),
                                                  );
                                                }
                                              }
                                            }
                                          },
                                    size: Size(
                                        MediaQuery.sizeOf(context).width, 40),
                                    color: isValid
                                        ? Theme.of(context).colorScheme.primary
                                        : Theme.of(context).colorScheme.outline,
                                    outlineColor: isValid
                                        ? Theme.of(context).colorScheme.primary
                                        : Theme.of(context).colorScheme.outline,
                                    textColor: isValid
                                        ? Colors.white
                                        : Theme.of(context)
                                            .colorScheme
                                            .secondary,
                                    description: 'Invest Now',
                                  );
                                },
                              ),
                            ],
                          );
                        }
                      },
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

DateTime getFutureDate([int days = 4]) {
  final currentDate = DateTime.now();

  return currentDate.add(Duration(days: days));
}
