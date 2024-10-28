import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:the_gemini_app/src/domain/config/routes/route_name_config.dart';
import 'package:the_gemini_app/src/presentation/utils/presistence/persistence.dart';
import 'package:the_gemini_app/src/presentation/views/onboarding/onboarding_screen_one.dart';
import 'package:the_gemini_app/src/presentation/views/onboarding/onboarding_screen_three.dart';
import 'package:the_gemini_app/src/presentation/views/onboarding/onboarding_screen_two.dart';
import 'package:the_gemini_app/src/presentation/widgets/gemini/gemini_app_widget.dart';
import 'package:the_gemini_app/src/presentation/widgets/supabase/supabase_inherited_widget.dart';

/// A screen widget for onboarding users.
class OnboardingScreen extends StatefulWidget {
  /// Constructs an [OnboardingScreen] widget.
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

/// The state class for the [OnboardingScreen] widget.
class _OnboardingScreenState extends State<OnboardingScreen> {
  late PageController _controller;

  int indexValue = 0;

  @override
  void initState() {
    super.initState();
    // TODO: implement initState
    _controller = PageController(initialPage: indexValue);
    // getAuthState();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies

    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            const Align(
              alignment: Alignment.topCenter,
              child: GeminiAppWidget(),
            ),
            PageView.builder(
              controller: _controller,
              itemCount: pages.length,
              onPageChanged: (value) {
                indexValue = value;
              },
              allowImplicitScrolling: false,
              itemBuilder: (context, index) {
                return pages[index];
              },
            ),
            Align(
              alignment: const Alignment(0, 0.62),
              child: SmoothPageIndicator(
                controller: _controller,
                count: 3,
                effect: WormEffect(
                  activeDotColor: theme.colorScheme.primary,
                  dotWidth: 20.w,
                  dotHeight: 6.5.h,
                  strokeWidth: 25.w,
                  dotColor: theme.colorScheme.outline,
                  type: WormType.underground,
                  paintStyle: PaintingStyle.fill,
                ),
                onDotClicked: (index) {
                  indexValue = index;
                  _controller.animateToPage(
                    indexValue,
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.linear,
                  );
                },
              ),
            ),
            Align(
              alignment: const Alignment(0, 0.77),
              child: Padding(
                padding: EdgeInsets.only(left: 20.w, right: 20.w),
                child: MaterialButton(
                  onPressed: () async {
                    // Action to perform when the button is pressed.

// TODO: Check the current index

                    print(indexValue);

                    // TODO: Check to see the page length

                    print('page length is: ${pages.length}');

                    // find the total index or pages

                    final totalIndex = pages.length - 1;

                    // Check to see if the page index is less than the total page index

                    if (indexValue < totalIndex) {
                      //  Increment the indexValue by 1

                      indexValue++;
// animate to the page at index Value

                      _controller.animateToPage(
                        indexValue,
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.linear,
                      );
                    } else {
                      final prefs = await SharedPreferences.getInstance();

                      await prefs.setBool('isViewed', true).then((value) {
                        if (context.mounted) {
                          final loadOnboarding = prefs.getBool('isViewed');

                          print(loadOnboarding);

                          context
                              .pushReplacementNamed(RouteNameConfig.authScreen);
                        }
                      });
                    }

                    //
                  },
                  color: theme.colorScheme.primary,
                  minWidth: MediaQuery.of(context).size.width,
                  height: 48.h,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'Next',
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: Colors.white,
                        ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

const pages = [
  OnboardingScreenOne(),
  OnboardingScreenTwo(),
  OnboardingScreenThree(),
];
