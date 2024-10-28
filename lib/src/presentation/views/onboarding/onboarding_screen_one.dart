import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:the_gemini_app/src/data/constants/constants.dart';

class OnboardingScreenOne extends StatelessWidget {
  const OnboardingScreenOne({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Stack(
        children: [
          Align(
            alignment: const Alignment(0, -0.5),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset(
                ImageConstants.onboardingOneImage,
                height: 270.96.h,
                width: 278.02.w,
              ),
            ),
          ),
          Align(
            alignment: const Alignment(-1, -0.5),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset(
                IconConstants.bitcoinIcon,
              ),
            ),
          ),
          Align(
            alignment: const Alignment(1, -0.5),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset(
                IconConstants.solanaIcon,
              ),
            ),
          ),
          Align(
            alignment: const Alignment(0, -0.8),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset(
                IconConstants.ethereumIcon,
              ),
            ),
          ),
          Align(
            alignment: const Alignment(0, 0.35),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Take hold of your finances',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.displayLarge,
              ),
            ),
          ),
          Align(
            alignment: const Alignment(0, 0.6),
            child: Image.asset(
              ImageConstants.vectorImage,
              fit: BoxFit.cover,
            ),
          ),
          Align(
            alignment: const Alignment(0, 0.53),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Take control of your financial future and unlock a world of financial freedom with ${AppConstants.appName}',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
              ),
            ),
          ),
          Align(
            alignment: const Alignment(0, 0.6),
            child: Image.asset(
              ImageConstants.vectorImage,
              fit: BoxFit.fill,
            ),
          ),
        ],
      ),
    );
  }
}
