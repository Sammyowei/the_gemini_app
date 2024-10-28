import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:the_gemini_app/src/domain/config/routes/route_name_config.dart';
import '../../../../src.dart';

class SignUpOnboarding extends StatelessWidget {
  const SignUpOnboarding({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.background,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Get Started in 3 easy steps',
              style: Theme.of(context).textTheme.displayLarge,
              textAlign: TextAlign.center,
            ),
          ),
          Image.asset(
            ImageConstants.signUpOnboardingImage,
            width: 322.w,
            height: 284.h,
          ),
          SizedBox(
            height: 160.h,
            width: MediaQuery.sizeOf(context).width,
            child: Stack(
              children: [
                const Align(
                  alignment: Alignment(-0.419, -0.5),
                  child: LineDrawer(),
                ),
                Align(
                  alignment: const Alignment(0.3, -0.5),
                  child: SizedBox(
                    height: 130.h,
                    width: MediaQuery.sizeOf(context).width * 0.6,
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        DescContainer(
                          value: '1',
                          desc: 'Create your account',
                        ),
                        DescContainer(
                          value: '2',
                          desc: 'Submit documents',
                        ),
                        DescContainer(
                          value: '3',
                          desc: 'Selfie verification',
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
          Gap(30.h),
          Padding(
            padding: const EdgeInsets.only(left: 15, right: 15),
            child: CustomButton(
              onTap: () {
                context.pushNamed(RouteNameConfig.signUpScreen);
              },
              size: Size(MediaQuery.sizeOf(context).width, 50),
              color: Theme.of(context).colorScheme.primary,
              outlineColor: Theme.of(context).colorScheme.primary,
              textColor: Colors.white,
              description: 'Continue',
            ),
          ),
        ],
      ),
    );
  }
}

class DescContainer extends StatelessWidget {
  final String value;

  final String desc;
  const DescContainer(
      {super.key, this.desc = 'Create your account', this.value = '1'});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Row(
        children: [
          Container(
            height: 25.h,
            width: 25.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Theme.of(context).colorScheme.primary,
            ),
            child: Center(
              child: Text(
                value,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
          ),
          Gap(10.w),
          Text(
            desc,
            style: Theme.of(context).textTheme.bodyLarge,
          )
        ],
      ),
    );
  }
}

class LineDrawer extends StatelessWidget {
  const LineDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 130.h,
      width: 2.w,
      color: Theme.of(context).colorScheme.primary,
    );
  }
}
