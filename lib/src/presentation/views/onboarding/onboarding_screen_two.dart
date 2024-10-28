import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:the_gemini_app/src/data/constants/constants.dart';

class OnboardingScreenTwo extends StatelessWidget {
  const OnboardingScreenTwo({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        child: Stack(
          children: [
            Align(
              alignment: const Alignment(0, -0.4),
              child: Image.asset(
                ImageConstants.onboardingTwoImage,
                height: 270.96.h,
                width: 278.02.w,
              ),
            ),
            Align(
              alignment: const Alignment(-0.35, -0.6),
              child: Image.asset(
                IconConstants.bitcoinIcon,
              ),
            ),
            Align(
              alignment: const Alignment(-0.05, -0.66),
              child: Image.asset(
                IconConstants.solanaIcon,
              ),
            ),
            Align(
              alignment: const Alignment(0.25, -0.73),
              child: Image.asset(
                IconConstants.ethereumIcon,
              ),
            ),
            Align(
              alignment: const Alignment(0, 0.38),
              child: Text(
                'Smart trading tools',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.displayLarge,
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
              alignment: const Alignment(0, 0.51),
              child: Text(
                'Unlock the power of smart trading tools and take control of your financial future with ${AppConstants.appName}.',
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
