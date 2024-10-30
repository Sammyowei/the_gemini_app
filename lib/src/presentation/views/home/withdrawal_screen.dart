import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:the_gemini_app/src/data/models/transaction.dart';
import 'package:the_gemini_app/src/presentation/presentation.dart';
import 'package:the_gemini_app/src/presentation/views/home/wallet_page.dart';
import 'package:the_gemini_app/src/presentation/widgets/supabase/supabase_inherited_widget.dart';
import 'package:the_gemini_app/src/providers/future_providers/user_future_provider.dart';
import 'package:the_gemini_app/src/providers/state_notifier_provider/boolean_state_notifier_provider.dart';
import 'package:the_gemini_app/src/providers/state_notifier_provider/user_state_notifier_provider.dart';
import 'package:uuid/uuid.dart';

class WithdrawalScreen extends ConsumerStatefulWidget {
  const WithdrawalScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _WithdrawalScreenState();
}

class _WithdrawalScreenState extends ConsumerState<WithdrawalScreen> {
  late TextEditingController _walletAddress;
  late TextEditingController _amount;

  @override
  void initState() {
    _walletAddress = TextEditingController();
    _amount = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _walletAddress.dispose();
    _amount.dispose();
    super.dispose();
  }

  void _validateWallet(String? value) {
    if (value == null || value.isEmpty) {
      ref.read(walletFieldValidatorStateProvider.notifier).toggleOff();
    } else {
      ref.read(walletFieldValidatorStateProvider.notifier).toggleOn();

      if (value.length < 10) {
        ref.read(walletValidatorStateProvider.notifier).toggleOff();
      } else {
        ref.read(walletValidatorStateProvider.notifier).toggleOn();
      }
    }
  }

  void _validateAmount(String? value) {
    if (value == null || value.isEmpty) {
      ref.read(amountFieldValidatorStateProvider3.notifier).toggleOff();
    } else {
      ref.read(amountFieldValidatorStateProvider3.notifier).toggleOn();

      if (double.parse(value) < 5000) {
        ref.read(amountValidatorStateProvider3.notifier).toggleOff();
      } else {
        ref.read(amountValidatorStateProvider3.notifier).toggleOn();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.sizeOf(context).width,
      padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.w),
      child: Column(
        children: [
          Text(
            'Withdrawal',
            style: Theme.of(context)
                .textTheme
                .titleLarge
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
          Gap(10.h),
          Text(
            "Ready to make a withdrawal? All payments are processed in USDT via the TRX network, ensuring a fast and secure transaction. Once you submit your request, our team will process it within 24 hours. Sit back and relax—we’ll notify you once your funds are on their way!",
            style: Theme.of(context).textTheme.titleSmall,
            textAlign: TextAlign.center,
          ),
          Gap(40.h),
          Consumer(
            builder: (context, ref, child) {
              final walletAddressValidator =
                  ref.watch(walletValidatorStateProvider);

              final walletFieldValidator =
                  ref.watch(walletFieldValidatorStateProvider);
              return CustomTextField(
                controller: _walletAddress,
                hintText: 'Wallet address',
                onChanged: _validateWallet,
                keyboardType: TextInputType.text,
                prefixIcon: Icon(
                  Icons.wallet_outlined,
                  size: 18.h,
                  color: Theme.of(context).colorScheme.primary,
                ),
                sulfixIcon: walletFieldValidator
                    ? walletAddressValidator
                        ? Icon(
                            Icons.check_circle_outline,
                            size: 18.h,
                            color: Colors.green,
                          )
                        : Icon(
                            Icons.cancel_outlined,
                            size: 18.h,
                            color: Colors.red,
                          )
                    : null,
              );
            },
          ),
          Gap(20.h),
          Consumer(
            builder: (context, ref, child) {
              final walletAddressValidator =
                  ref.watch(amountValidatorStateProvider3);

              final walletFieldValidator =
                  ref.watch(amountFieldValidatorStateProvider3);

              return CustomTextField(
                controller: _amount,
                hintText: 'Amount',
                onChanged: _validateAmount,
                keyboardType: TextInputType.number,
                prefixIcon: Icon(
                  Icons.account_balance_rounded,
                  color: Theme.of(context).colorScheme.primary,
                  size: 18.h,
                ),
                sulfixIcon: walletFieldValidator
                    ? walletAddressValidator
                        ? Icon(
                            Icons.check_circle_outline,
                            size: 18.h,
                            color: Colors.green,
                          )
                        : Icon(
                            Icons.cancel_outlined,
                            size: 18.h,
                            color: Colors.red,
                          )
                    : null,
              );
            },
          ),
          Gap(10.h),
          Row(
            children: [
              Text(
                'min: ${NumberFormat.currency(
                  symbol: "\$",
                  locale: 'En_US',
                  name: 'USD',
                ).format(5000)}',
              )
            ],
          ),
          Gap(40.h),
          Consumer(
            builder: (context, ref, child) {
              final amountAddressValidator =
                  ref.watch(amountValidatorStateProvider3);

              final amountFieldValidator =
                  ref.watch(amountFieldValidatorStateProvider3);

              final walletAddressValidator =
                  ref.watch(walletValidatorStateProvider);

              final walletFieldValidator =
                  ref.watch(walletFieldValidatorStateProvider);

              final isAmountValid =
                  (amountFieldValidator && amountAddressValidator);

              final isWalletvalid =
                  (walletFieldValidator && walletAddressValidator);

              final isValid = (isWalletvalid && isAmountValid);

              final user = ref.watch(userModelsProvider);
              return CustomButton(
                onTap: () async {
                  // Check the account balance  of the logged in user and see he has the appropraite amount to withdraw.

                  final balance = getUsdWalletBalance(user);

                  final withdrawalAmount = double.parse(_amount.text.trim());
                  // Compare to know if the withdrawal is greater than the account balance

                  if (withdrawalAmount > balance) {
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (context) {
                        return const AlertDialog.adaptive(
                          title: Text(
                            'Insufficient Funds',
                          ),
                          content: Text(
                            "It appears your balance isn’t sufficient to complete this withdrawal. Please review your available funds and try again. For assistance, feel free to contact support.",
                          ),
                        );
                      },
                    );

                    Future.delayed(
                      const Duration(seconds: 3),
                      () {
                        context.pop();
                      },
                    );
                  } else {
                    showLoadingDialog(context);
                    final id = MySupabaseConfig.of(context)
                        .supabase
                        .client
                        .auth
                        .currentUser!
                        .id;

                    final transaction = Transaction(
                      id: const Uuid().v4(),
                      transactionType: 'USD Wallet Withdrawal',
                      status: 'Processing',
                      referenceID: const Uuid().v4(),
                      userID: id,
                      amount: withdrawalAmount,
                      transactionDate: DateTime.now(),
                      description:
                          'Withdrawal (amount: $withdrawalAmount, wallet Address: ${_walletAddress.text.trim()})',
                    );

                    try {
                      await MySupabaseConfig.of(context)
                          .supabase
                          .client
                          .from('transactions')
                          .insert(transaction.toJson());

                      if (context.mounted) {
                        context.pop();

                        ref
                            .read(walletFieldValidatorStateProvider.notifier)
                            .toggleOff();

                        ref
                            .read(amountFieldValidatorStateProvider3.notifier)
                            .toggleOff();

                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (context) {
                            return AlertDialog.adaptive(
                              title: const Text(
                                'Withdrawal Successful',
                              ),
                              content: Text(
                                "Your withdrawal of ${NumberFormat.currency(symbol: '\$', name: 'USD').format(double.parse(_amount.text.trim()))} is being processed! Please allow up to 24 hours for the funds to arrive. We’ll notify you as soon as the transfer is complete. Thank you for your patience!",
                              ),
                            );
                          },
                        );

                        Future.delayed(
                          const Duration(seconds: 3),
                          () {
                            context.pop();

                            ref.refresh(userFutureProvider(context));

                            _amount.clear();
                            _walletAddress.clear();
                          },
                        );
                      }
                    } on PostgrestException catch (e) {
                      context.pop();
                      print(e.message);
                    }
                  }
                },
                size: Size(MediaQuery.sizeOf(context).width, 45),
                description: 'Withdraw',
                color: isValid
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.outline,
                outlineColor: isValid
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.outline,
                textColor: isValid
                    ? Colors.white
                    : Theme.of(context).colorScheme.secondary,
              );
            },
          ),
        ],
      ),
    );
  }
}
