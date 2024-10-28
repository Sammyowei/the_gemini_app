import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:the_gemini_app/src/data/models/user.dart';
import 'package:the_gemini_app/src/domain/config/routes/route_name_config.dart';
import 'package:the_gemini_app/src/presentation/presentation.dart';
import 'package:the_gemini_app/src/presentation/widgets/supabase/supabase_inherited_widget.dart';
import 'package:the_gemini_app/src/providers/state_notifier_provider/boolean_state_notifier_provider.dart';
import 'package:the_gemini_app/src/providers/state_notifier_provider/user_state_notifier_provider.dart';

import '../../widgets/gemini/gemini_app_widget.dart';

class OnboardUser extends ConsumerStatefulWidget {
  const OnboardUser({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _OnboardUserState();
}

class _OnboardUserState extends ConsumerState<OnboardUser> {
  late TextEditingController _firstNameController;
  late TextEditingController _lastnameController;

  @override
  void initState() {
    _firstNameController = TextEditingController();
    _lastnameController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastnameController.dispose();
    super.dispose();
  }

  void _validateFirstName(String? value) {
    if (value!.isEmpty) {
      ref.read(firstNameFieldValidatorStateProvider.notifier).toggleOff();
    } else {
      ref.read(firstNameFieldValidatorStateProvider.notifier).toggleOn();

      if (value.length < 3) {
        ref.read(firstNameValidatorStateProvider.notifier).toggleOff();
      } else {
        ref.read(firstNameValidatorStateProvider.notifier).toggleOn();
      }
    }
  }

  void _validateLastName(String? value) {
    if (value!.isEmpty) {
      ref.read(lastNameFieldValidatorStateProvider.notifier).toggleOff();
    } else {
      ref.read(lastNameFieldValidatorStateProvider.notifier).toggleOn();

      if (value.length < 3) {
        ref.read(lastNameValidatorStateProvider.notifier).toggleOff();
      } else {
        ref.read(lastNameValidatorStateProvider.notifier).toggleOn();
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
        height: MediaQuery.sizeOf(context).height,
        width: MediaQuery.sizeOf(context).width,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Let's Complete Your Profile!",
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 10.h),
              Text(
                'Great! Let’s get to know you better—fill in your details to get started!',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              Gap(30.h),
              Consumer(
                builder: (context, ref, child) {
                  final isFieldValid =
                      ref.watch(firstNameFieldValidatorStateProvider);

                  final isValid = ref.watch(firstNameValidatorStateProvider);
                  return CustomTextField(
                    hintText: 'First name',
                    onChanged: _validateFirstName,
                    controller: _firstNameController,
                    sulfixIcon: isFieldValid
                        ? isValid
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
                    prefixIcon: Icon(
                      Icons.account_circle_outlined,
                      color: Theme.of(context).colorScheme.primary,
                      size: 18.h,
                    ),
                  );
                },
              ),
              Gap(10.h),
              Consumer(
                builder: (context, ref, child) {
                  final isFieldValid =
                      ref.watch(lastNameFieldValidatorStateProvider);

                  final isValid = ref.watch(lastNameValidatorStateProvider);
                  return CustomTextField(
                    hintText: 'Last name',
                    controller: _lastnameController,
                    onChanged: _validateLastName,
                    prefixIcon: Icon(
                      Icons.account_circle_outlined,
                      color: Theme.of(context).colorScheme.primary,
                      size: 18.h,
                    ),
                    sulfixIcon: isFieldValid
                        ? isValid
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
              Gap(20.h),
              Consumer(
                builder: (context, ref, child) {
                  final firstNameValid =
                      ref.watch(firstNameValidatorStateProvider);

                  final lastNameValid =
                      ref.watch(lastNameValidatorStateProvider);

                  final isValid = (firstNameValid && lastNameValid);
                  return CustomButton(
                    onTap: () async {
                      print(_firstNameController.text.trim());
                      print(_lastnameController.text.trim());
                      final User user0 = User(
                        firstName: _firstNameController.text.trim(),
                        lastName: _lastnameController.text.trim(),
                        email: MySupabaseConfig.of(context)
                                .supabase
                                .client
                                .auth
                                .currentUser
                                ?.email ??
                            'testuser@email.com',
                      );

                      final user = ref.read(userProvider.notifier);

                      user.setUser(user0);

                      print(
                          ref.read(userProvider.notifier).getUser()?.toJson());

                      context.pushNamed(RouteNameConfig.contactDetail);
                    },
                    size: Size(MediaQuery.sizeOf(context).width, 50),
                    color: isValid
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).colorScheme.outline,
                    outlineColor: isValid
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).colorScheme.outline,
                    description: 'Continue',
                    textColor: isValid
                        ? Colors.white
                        : Theme.of(context).colorScheme.secondary,
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
