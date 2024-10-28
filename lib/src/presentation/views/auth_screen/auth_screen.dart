import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import 'package:the_gemini_app/src/domain/config/routes/route_name_config.dart';

import 'package:the_gemini_app/src/presentation/widgets/gemini/gemini_app_widget.dart';
import 'package:the_gemini_app/src/presentation/widgets/widgets.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 15, right: 15).w,
          child: Column(
            children: [
              const GeminiAppWidget(),
              Gap(50.h),
              Text(
                'Hello! Start your crypto investment today',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.displayLarge,
              ),
              Gap(15.h),
              // AuthButton(
              //   onTap: () async {
              //     if (!kIsWeb) {
              //       await AuthProviderRepository().nativeGoogleSignIn(context);
              //       return;
              //     }
              //     await AuthProviderRepository().googleSignIn(context);

              //     // await AuthProviderRepository().nativeGoogleSignIn(context);
              //   },
              //   description: 'Continue with Google',
              //   radius: 10,
              //   size: Size(
              //     MediaQuery.sizeOf(context).width,
              //     50,
              //   ),
              //   imagePath: IconConstants.googleIconPng,
              // ),
              Gap(15.h),
              Gap(20.h),
              CustomButton(
                size: Size(
                  MediaQuery.sizeOf(context).width,
                  50,
                ),
                onTap: () =>
                    context.pushNamed(RouteNameConfig.signUpOnboarding),
                color: Theme.of(context).colorScheme.primary,
                outlineColor: Theme.of(context).colorScheme.primary,
                description: 'Sign up with email',
                textColor: Colors.white,
              ),
              Gap(150.h),
              Row(
                children: [
                  Expanded(
                    child: Divider(
                      color: Theme.of(context).colorScheme.outline,
                    ),
                  ),
                  Gap(10.w),
                  Text(
                    'Already have an account?',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurface),
                  ),
                  Gap(10.w),
                  Expanded(
                    child: Divider(
                      color: Theme.of(context).colorScheme.outline,
                    ),
                  ),
                ],
              ),
              Gap(30.h),
              CustomButton(
                onTap: () => context.pushNamed(RouteNameConfig.signIn),
                size: Size(
                  MediaQuery.sizeOf(context).width,
                  50,
                ),
                outlineColor: Theme.of(context).colorScheme.primary,
                textColor: Theme.of(context).colorScheme.primary,
                description: 'Sign in',
              )
            ],
          ),
        ),
      ),
    );
  }
}
