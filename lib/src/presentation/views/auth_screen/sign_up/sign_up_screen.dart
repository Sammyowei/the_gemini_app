import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:the_gemini_app/src/data/constants/app_constants.dart';
import 'package:the_gemini_app/src/domain/config/routes/route_name_config.dart';
import 'package:the_gemini_app/src/presentation/presentation.dart';
import 'package:the_gemini_app/src/presentation/widgets/gemini/gemini_app_widget.dart';
import 'package:the_gemini_app/src/providers/providers.dart';
import 'package:the_gemini_app/src/providers/state_notifier_provider/boolean_state_notifier_provider.dart';

import '../../../utils/presistence/persistence.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  late TextEditingController _emailController;

  @override
  void initState() {
    _emailController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
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

  @override
  Widget build(BuildContext context) {
    final sharedPersistence = SharedPersistence();
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
                "What's your email?",
                style: Theme.of(context).textTheme.displayLarge,
                textAlign: TextAlign.center,
              ),
              Gap(5.h),
              Text(
                'Enter the email address you want to use to register with ${AppConstants.appName}.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              Gap(20.h),
              Consumer(
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
              ),
              const Gap(20),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Have an account?"),
                  TextButton(
                    onPressed: () {
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
                  final isEmailValid = ref.watch(emailValidatorProvider);

                  var isValid = (isEmailValid);
                  return CustomButton(
                    size: Size(
                      MediaQuery.sizeOf(context).width,
                      50,
                    ),
                    onTap: !isValid
                        ? null
                        : () async {
                            await sharedPersistence
                                .save('_email', _emailController.text.trim())
                                .then((value) {
                              print(sharedPersistence.get("_email"));
                              if (context.mounted) {
                                context.pushNamed(RouteNameConfig.password);
                              }
                            });
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
                    description: 'Continue',
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
