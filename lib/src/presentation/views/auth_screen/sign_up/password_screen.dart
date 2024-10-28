import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_circular_progress_indicator/flutter_circular_progress_indicator.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:the_gemini_app/src/domain/config/routes/route_name_config.dart';
import 'package:the_gemini_app/src/presentation/utils/presistence/persistence.dart';
import 'package:the_gemini_app/src/presentation/widgets/supabase/supabase_inherited_widget.dart';

import '../../../../providers/state_notifier_provider/boolean_state_notifier_provider.dart';
import '../../../../src.dart';
import '../../../widgets/gemini/gemini_app_widget.dart';

class SPasswordScreen extends StatefulWidget {
  const SPasswordScreen({super.key});

  @override
  State<SPasswordScreen> createState() => _SPasswordScreenState();
}

class _SPasswordScreenState extends State<SPasswordScreen> {
  late TextEditingController _passwordController;

  @override
  void initState() {
    _passwordController = TextEditingController();

    super.initState();
  }

  late ProviderContainer container;

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  void _validatePassword(String? value) {
    final container = ProviderScope.containerOf(context);

    if (value!.isEmpty) {
      container.read(passwordfieldValidatorProvider.notifier).toggleOff();
    } else {
      container.read(passwordfieldValidatorProvider.notifier).toggleOn();
      if (value.length < 8) {
        container.read(passwordValidatorProvider.notifier).toggleOff();
      } else {
        container.read(passwordValidatorProvider.notifier).toggleOn();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.background,
        title: const GeminiAppWidget(),
        centerTitle: true,
      ),
      body: SizedBox(
        width: MediaQuery.sizeOf(context).width,
        child: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "What's your password?",
                style: Theme.of(context).textTheme.displayLarge,
                textAlign: TextAlign.center,
              ),
              Gap(5.h),
              Text(
                'Enter the password you want to use to register with ${AppConstants.appName}.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              Gap(20.h),
              Consumer(
                builder: (context, ref, child) {
                  final passwordFieldValidator =
                      ref.watch(passwordfieldValidatorProvider);

                  final passwordValidator =
                      ref.watch(passwordValidatorProvider);
                  return CustomTextField(
                    hintText: 'Password',
                    prefixIcon: Icon(
                      Icons.lock_outline_rounded,
                      size: 18.h,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    controller: _passwordController,
                    onChanged: _validatePassword,
                    sulfixIcon: passwordFieldValidator
                        ? passwordValidator
                            ? Icon(
                                Icons.check_circle_outline,
                                color: Palette.greenColor,
                                size: 18.h,
                              )
                            : Icon(
                                Icons.cancel_outlined,
                                color: Palette.redColor,
                                size: 18.h,
                              )
                        : null,
                  );
                },
              ),
              const Gap(20),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Have an account?"),
                  TextButton(
                    onPressed: () async {
                      context.pushNamed(RouteNameConfig.signIn);
                    },
                    child: Text(
                      "Login in here",
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.w400,
                          ),
                    ),
                  )
                ],
              ),
              Consumer(
                builder: (context, ref, child) {
                  final isEmailValid = ref.watch(passwordValidatorProvider);

                  var isValid = (isEmailValid);
                  return CustomButton(
                    size: Size(
                      MediaQuery.sizeOf(context).width,
                      50,
                    ),
                    onTap: !isValid
                        ? null
                        : () async {
                            final sharedPersistence = SharedPersistence();

                            final supabase =
                                MySupabaseConfig.of(context).supabase;
                            final email = sharedPersistence.get('_email');

                            showDialog(
                              barrierDismissible: false,
                              context: context,
                              builder: (context) {
                                return AlertDialog.adaptive(
                                  backgroundColor:
                                      Theme.of(context).colorScheme.background,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15.r),
                                  ),
                                  content: const Center(
                                    child: CircularProgressIndicator.adaptive(),
                                  ),
                                );
                              },
                            );
                            try {
                              final res =
                                  await supabase.supabase.client.auth.signUp(
                                email: email,
                                password: _passwordController.text.trim(),
                              );

                              print(res.user?.toJson());
                              if (context.mounted) {
                                context.pop();
                                context.pushNamed(RouteNameConfig.authOtp);
                              }
                            } on AuthException catch (e) {
                              if (context.mounted) {
                                context.pop();

                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    backgroundColor: Colors.red,
                                    content: Text(
                                      e.message,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(
                                            color: Colors.white,
                                          ),
                                    ),
                                  ),
                                );
                              }
                            }
                          },
                    color: isValid
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).colorScheme.outline,
                    outlineColor: isValid
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).colorScheme.outline,
                    textColor: isValid
                        ? Colors.white
                        : Theme.of(context).colorScheme.secondary,
                    description: 'Sign up',
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
