import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:the_gemini_app/src/data/constants/constants.dart';

/// A widget that displays the Gemini Mobile app logo and name.
class GeminiAppWidget extends StatelessWidget {
  const GeminiAppWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 130.w,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Display the app logo using a Hero animation.
          Hero(
            tag: 'logo',
            transitionOnUserGestures: true,
            child: Image.asset(
              IconConstants.appIcons,
              height: 20.h,
              // Set the color of the app logo.
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          Gap(5.w),
          // Display the app name.
          Text(
            AppConstants.appName,
            // Apply Google Fonts to the app name text.
            style: GoogleFonts.readexPro(
              fontSize: 18.sp,
              fontWeight: FontWeight.w800,
              // Set the color of the app name text.
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }
}
