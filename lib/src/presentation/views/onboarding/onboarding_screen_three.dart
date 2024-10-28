import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:the_gemini_app/src/data/constants/constants.dart';

class OnboardingScreenThree extends StatelessWidget {
  const OnboardingScreenThree({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        child: Stack(
          children: [
            Align(
              alignment: const Alignment(0, -0.99),
              child: Image.asset(
                ImageConstants.onboardingThreeImage,
                height: 450.h,
              ),
            ),
            Align(
              alignment: const Alignment(0.7, -0.6),
              child: Image.asset(
                IconConstants.bitcoinIcon,
              ),
            ),
            Align(
              alignment: const Alignment(-0.78, -0.7),
              child: Image.asset(
                IconConstants.solanaIcon,
              ),
            ),
            Align(
              alignment: const Alignment(-0.58, -0.2),
              child: Image.asset(
                IconConstants.ethereumIcon,
              ),
            ),
            Align(
              alignment: const Alignment(0, 0.7),
              child: Image.asset(
                ImageConstants.vectorImage,
                fit: BoxFit.cover,
              ),
            ),
            Align(
              alignment: const Alignment(0, 0.38),
              child: Text(
                'Invest in the future',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.displayLarge,
              ),
            ),
            Align(
              alignment: const Alignment(0, 0.51),
              child: Text(
                'Unlock the gateway to financial freedom and secure your future with ${AppConstants.appName}.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      color: Theme.of(context).colorScheme.onSurface,
                      fontWeight: FontWeight.w400,
                    ),
              ),
            ),
            Align(
              alignment: const Alignment(0, 0.7),
              child: Image.asset(
                ImageConstants.vectorImage,
                fit: BoxFit.cover,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
