import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:the_gemini_app/src/data/constants/constants.dart';
import 'package:the_gemini_app/src/data/data.dart';
import 'package:the_gemini_app/src/domain/config/routes/route_name_config.dart';
import 'package:the_gemini_app/src/presentation/presentation.dart';
import 'package:the_gemini_app/src/presentation/widgets/gemini/gemini_app_widget.dart';
import 'package:the_gemini_app/src/presentation/widgets/supabase/supabase_inherited_widget.dart';

import 'package:the_gemini_app/src/providers/state_notifier_provider/boolean_state_notifier_provider.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  late TextEditingController _emailController;

  late TextEditingController _passwordController;

  @override
  void initState() {
    _emailController = TextEditingController();
    _passwordController = TextEditingController();

    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();

    super.dispose();
  }

  bool _isEmailValid(String email) {
    final RegExp emailRegex = RegExp(
      r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
      caseSensitive: false,
      multiLine: false,
    );

    return emailRegex.hasMatch(email);
  }

  void _validateEmail(String? value) {
    final container = ProviderScope.containerOf(context);

    if (value!.isEmpty) {
      container.read(emailfieldValidatorProvider.notifier).toggleOff();
    } else {
      container.read(emailfieldValidatorProvider.notifier).toggleOn();
      if (!_isEmailValid(value)) {
        container.read(emailValidatorProvider.notifier).toggleOff();
      } else {
        container.read(emailValidatorProvider.notifier).toggleOn();
      }
    }
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
        automaticallyImplyLeading: true,
      ),
      body: SizedBox(
        width: MediaQuery.sizeOf(context).width,
        child: Column(
          children: [
            Gap(10.h),
            Padding(
              padding: const EdgeInsets.only(
                left: 30,
                right: 30,
              ),
              child: Text(
                'Login to your Account',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.displayLarge,
              ),
            ),
            Gap(30.h),
            Padding(
                padding: const EdgeInsets.only(left: 15, right: 15).w,
                child: Consumer(
                  builder: (context, ref, child) {
                    final emailFieldValidator =
                        ref.watch(emailfieldValidatorProvider);

                    final emailValidator = ref.watch(emailValidatorProvider);
                    return CustomTextField(
                      hintText: 'Email address',
                      controller: _emailController,
                      onChanged: _validateEmail,
                      sulfixIcon: emailFieldValidator
                          ? emailValidator
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
                )),
            Gap(10.h),
            Padding(
              padding: const EdgeInsets.only(left: 15, right: 15).w,
              child: Consumer(
                builder: (context, ref, child) {
                  final passwordFiedValidator =
                      ref.watch(passwordfieldValidatorProvider);

                  final passwordValidator =
                      ref.watch(passwordValidatorProvider);

                  final obscureText = ref.watch(obscrueTextProvider);
                  return CustomTextField(
                    controller: _passwordController,
                    onChanged: _validatePassword,
                    obscureText: obscureText,
                    sulfixIcon: passwordFiedValidator
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
                    hintText: 'Password',
                    prefixIcon: Icon(
                      Icons.lock_outline,
                      size: 18.h,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  );
                },
              ),
            ),
            Gap(10.h),
            Padding(
                padding: const EdgeInsets.only(left: 20, right: 15),
                child: Consumer(
                  builder: (context, ref, child) {
                    final obscureText = ref.watch(obscrueTextProvider);
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          'Hide password',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        Checkbox.adaptive(
                          value: obscureText,
                          onChanged: (value) {
                            ref
                                .read(obscrueTextProvider.notifier)
                                .setState(value!);
                          },
                          activeColor: Theme.of(context).colorScheme.primary,
                          semanticLabel: 'Show password',
                        )
                      ],
                    );
                  },
                )),
            Gap(20.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Forgot your passowrd?',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                Gap(5.w),
                Text(
                  'Click here',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
            Gap(20.h),
            // SizedBox(
            //   height: 40.h,
            //   child: Padding(
            //     padding: const EdgeInsets.only(left: 25, right: 25).w,
            //     child: Row(
            //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //       children: [
            //         Text(
            //           'Unlock with touch ID?',
            //           style: Theme.of(context).textTheme.bodyLarge,
            //         ),
            //         Switch.adaptive(
            //           value: true,
            //           onChanged: (value) {},
            //           activeColor: Theme.of(context).colorScheme.primary,
            //           materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            //           applyCupertinoTheme: true,
            //         ),
            //       ],
            //     ),
            //   ),
            // ),
            Gap(20.h),
            Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: Consumer(
                  builder: (context, ref, child) {
                    final isEmailValid = ref.watch(emailValidatorProvider);

                    final isPasswordValid =
                        ref.watch(passwordValidatorProvider);

                    var isValid = (isEmailValid && isPasswordValid);
                    return CustomButton(
                      size: Size(
                        MediaQuery.sizeOf(context).width,
                        50,
                      ),
                      onTap: !isValid
                          ? null
                          : () async {
                              try {
                                showDialog(
                                  barrierDismissible: false,
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog.adaptive(
                                      backgroundColor: Theme.of(context)
                                          .colorScheme
                                          .background,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(15.r),
                                      ),
                                      content: const Center(
                                        child: CircularProgressIndicator
                                            .adaptive(),
                                      ),
                                    );
                                  },
                                );

                                await MySupabaseConfig.of(context)
                                    .supabase
                                    .client
                                    .auth
                                    .signInWithPassword(
                                      email: _emailController.text.trim(),
                                      password: _passwordController.text.trim(),
                                    );

                                if (context.mounted) {
                                  context.pop();
                                  context.goNamed(RouteNameConfig.home_page);
                                }
                              } on AuthException catch (e) {
                                print(e.message);

                                if (context.mounted) {
                                  context.pop();

                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      behavior: SnackBarBehavior.fixed,
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
                      description: 'Sign in',
                    );
                  },
                )),
            Gap(100.h),
            // Row(
            //   children: [
            //     Expanded(
            //       child: Divider(
            //         color: Theme.of(context).colorScheme.outline,
            //       ),
            //     ),
            //     SizedBox(
            //       width: 130,
            //       child: Center(
            //         child: Text(
            //           'or continue with',
            //           style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            //                 color: Theme.of(context).colorScheme.onSurface,
            //               ),
            //         ),
            //       ),
            //     ),
            //     Expanded(
            //       child: Divider(
            //         color: Theme.of(context).colorScheme.outline,
            //       ),
            //     ),
            //   ],
            // ),
            // Gap(30.h),
            // Padding(
            //   padding: const EdgeInsets.only(
            //     left: 40,
            //     right: 40,
            //   ),
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            //     children: [
            //       // Facebook Login
            //       AuthButton(
            //         radius: 10,
            //         imagePath: IconConstants.facebookIconPng,
            //         size: const Size(55, 55),
            //       ),
            //       // Google Login
            //       AuthButton(
            //         radius: 10,
            //         size: const Size(55, 55),
            //         imagePath: IconConstants.googleIconPng,
            //       ),
            //       // AppleLogin
            //     ],
            //   ),
            // )
          ],
        ),
      ),
    );
  }
}
