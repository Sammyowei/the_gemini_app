import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:math' show pi;
import 'package:the_gemini_app/src/data/data.dart';
import 'package:the_gemini_app/src/domain/config/routes/route_name_config.dart';
import 'package:the_gemini_app/src/presentation/palette/palette.dart';
import 'package:the_gemini_app/src/presentation/utils/presistence/persistence.dart';
import 'package:the_gemini_app/src/presentation/widgets/gemini/gemini_app_widget.dart';
import 'package:the_gemini_app/src/presentation/widgets/supabase/supabase_inherited_widget.dart';

/// A screen widget displayed during the initial app launch.
class SplashScreen extends StatefulWidget {
  /// Constructs a [SplashScreen] widget.
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

/// The state class for the [SplashScreen] widget.
class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  // Animation controller for logo rotation animation.
  late AnimationController _logoAnimationController;
  // Animation for logo rotation.
  late Animation<double> _logoAnimation;

  // Animation controller for screen transition animation.
  late AnimationController _screenTransitionAnimationController;
  // Animation for fading transition.
  late Animation<double> _fadeAnimation;

  // Flag indicating whether the screen has loaded.
  bool isLoaded = false;

  @override
  void initState() {
    super.initState();

    // Initializing logo rotation animation controller.
    _logoAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )
      ..repeat()
      ..addListener(() {
        // Reversing the animation when rotation completes half-circle.
        if (_logoAnimation.value >= (pi)) {
          _logoAnimationController.reverse();
        }
      })
      // Starting screen transition when animation completes.
      ..addStatusListener((status) {
        if (status == AnimationStatus.dismissed) {
          _startScreenTransition();
        }
      });

    // Tween animation for logo rotation.
    _logoAnimation = Tween<double>(begin: 0.0, end: 2 * pi).animate(
      _logoAnimationController,
    );

    // Initializing screen transition animation controller.
    _screenTransitionAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 0),
    );

    // Tween animation for screen fading transition.
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _screenTransitionAnimationController,
      curve: Curves.easeInOut,
    ));

    // Starting logo rotation animation.
    _logoAnimationController.forward();
  }

  // Method to start screen transition animation.
  void _startScreenTransition() {
    setState(() {
      isLoaded = true;
    });
    // Starting screen transition animation and navigating to next screen.
    _screenTransitionAnimationController.forward().then((_) {
      context.pushReplacementNamed(RouteNameConfig.initialSecond);
    });
  }

  @override
  void dispose() {
    // Disposing animation controllers to free up resources.
    _logoAnimationController.dispose();
    _screenTransitionAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Logo animation with rotation.
          Align(
            child: AnimatedBuilder(
              animation: _logoAnimation,
              builder: (context, child) {
                return Transform.rotate(
                  angle: _logoAnimation.value,
                  child: Hero(
                    tag: 'logo',
                    child: Image.asset(
                      IconConstants.appIcons,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                );
              },
            ),
          ),
          // Fading transition animation for screen.
          Positioned.fill(
            child: AnimatedBuilder(
              animation: _screenTransitionAnimationController,
              builder: (context, child) {
                return FadeTransition(
                  opacity: _fadeAnimation,
                  child: Container(
                    color: Colors.transparent,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

/// A screen widget displayed after the initial app launch.
class SecondScreen extends StatefulWidget {
  /// Constructs a [SecondScreen] widget.
  const SecondScreen({super.key});

  @override
  State<SecondScreen> createState() => _SecondScreenState();
}

/// The state class for the [SecondScreen] widget.
class _SecondScreenState extends State<SecondScreen> {
  @override
  void initState() {
    // Delaying screen transition to simulate loading.
    Future.delayed(
      const Duration(seconds: 2),
      () {
        // Checking current brightness mode.
        Brightness currentBrightness =
            MediaQuery.of(context).platformBrightness;
        // Determining if dark mode is enabled.
        bool isDarkMode = currentBrightness == Brightness.dark;
        // Navigating to onboarding screen after delay.

        getAuthState();

        // Setting manual system UI mode with necessary overlays.
        SystemChrome.setEnabledSystemUIMode(
          SystemUiMode.manual,
          overlays: [
            SystemUiOverlay.bottom,
            SystemUiOverlay.top,
          ],
        );
        // Setting system UI overlay style based on dark mode.
        if (!isDarkMode) {
          SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
        } else {
          SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
        }
      },
    );

    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  void getAuthState() {
    final auth = MySupabaseConfig.of(context)
        .supabase
        .client
        .auth
        .onAuthStateChange
        .listen((event) async {
      final authEvent = event.event;

      final session = event.session;

      print(authEvent);

      if (session == null) {
        final prefs = await SharedPreferences.getInstance();
        final loadOnboarding = prefs.getBool('isViewed');

        print(
            'yes i should load this up. cause onbaording hasn\' loaded before $loadOnboarding ');

        if (loadOnboarding == null || loadOnboarding == false) {
          if (context.mounted) {
            if (kIsWeb) {
              context.pushReplacementNamed(RouteNameConfig.authScreen);
              return;
            }
            context.pushReplacementNamed(RouteNameConfig.onboarding);
          }
        } else {
          context.pushReplacementNamed(RouteNameConfig.authScreen);
          return;
        }
      } else {
        context.pushReplacementNamed(RouteNameConfig.home_page);
        return;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: Stack(
        children: [
          // Gemini widget for second screen.
          const Align(
            child: GeminiAppWidget(),
          ),
          // Version text displayed at the bottom.
          Align(
            alignment: const Alignment(0, 0.9),
            child: Hero(
              tag: 'version',
              child: Text(
                AppConstants.appVersion,
                style: GoogleFonts.readexPro(
                  fontSize: 12.sp,
                  color: theme.colorScheme.outline,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
