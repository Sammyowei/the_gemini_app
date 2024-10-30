// Import necessary packages and files for routing configuration and view definitions.
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:the_gemini_app/src/domain/config/routes/route_name_config.dart';
import 'package:the_gemini_app/src/domain/config/routes/route_path_config.dart';
import 'package:the_gemini_app/src/domain/config/routes/transition_route_config.dart';
import 'package:the_gemini_app/src/presentation/utils/presistence/persistence.dart';
import 'package:the_gemini_app/src/presentation/views/auth_screen/sign_up/password_screen.dart';
import 'package:the_gemini_app/src/presentation/views/auth_screen/sign_up/sign_up_onboarding_screen.dart';
import 'package:the_gemini_app/src/presentation/views/home/deposit_screen.dart';
import 'package:the_gemini_app/src/presentation/views/home/home_screen.dart';
import 'package:the_gemini_app/src/presentation/views/home/investment_page_screen.dart';
import 'package:the_gemini_app/src/presentation/views/home/notification_screen.dart';
import 'package:the_gemini_app/src/presentation/views/home/wallet_page.dart';
import 'package:the_gemini_app/src/presentation/views/onboard_user/contact_detail.dart';
import 'package:the_gemini_app/src/presentation/views/onboard_user/onboard_user.dart';
import 'package:the_gemini_app/src/presentation/views/views.dart';
import 'package:the_gemini_app/src/presentation/widgets/supabase/supabase_inherited_widget.dart';
import 'package:the_gemini_app/src/providers/state_notifier_provider/string_state_notifier_provider.dart';

// Define an abstract class for routing configuration.
abstract class RoutingConfig {
  // Static member to hold the router configuration.
  static GoRouter router = GoRouter(
    redirect: (context, state) {
      MySupabaseConfig.of(context)
          .supabase
          .client
          .auth
          .onAuthStateChange
          .listen((event) {
        final session = event.session;

        if (session == null) {
          context.goNamed(
            RouteNameConfig.authScreen,
          );
        }
      });
      return null;
    },
    routes: [
      // Define the initial route.
      GoRoute(
        // Path for the initial route.
        path: RoutePathConfig.initial,
        // Name for the initial route.
        name: RouteNameConfig.initial,
        // Builder function for the initial route, returns SplashScreen widget.
        builder: (context, state) {
          return const SplashScreen();
        },
        // Define nested routes for the initial route.
        routes: [
          // Transition route for the initial nested route.
          transitionGoRoute(
            // Path for the initial nested route.
            path: RoutePathConfig.initialSecond,
            // Name for the initial nested route.
            name: RouteNameConfig.initialSecond,
            // Page builder function for the initial nested route, returns SecondScreen widget.
            pageBuilder: (context, state) => const SecondScreen(),
          ),
        ],
      ),
      // Define the onboarding route.
      GoRoute(
        // Path for the onboarding route.
        path: RoutePathConfig.onboarding,
        // Name for the onboarding route.
        name: RouteNameConfig.onboarding,
        // Builder function for the onboarding route, returns OnboardingScreen widget.
        builder: (context, state) {
          return const OnboardingScreen();
        },
      ),

      // Defines the onboarding route.
      GoRoute(
        path: RoutePathConfig.authScreen,
        name: RouteNameConfig.authScreen,
        builder: (context, state) {
          return const AuthScreen();
        },
      ),

      GoRoute(
        path: RoutePathConfig.signIn,
        name: RouteNameConfig.signIn,
        builder: (context, state) {
          return const SignInScreen();
        },
      ),
      GoRoute(
        path: RoutePathConfig.signUpOnboarding,
        name: RouteNameConfig.signUpOnboarding,
        builder: (context, state) {
          return const SignUpOnboarding();
        },
      ),

      GoRoute(
        path: RoutePathConfig.signUpScreen,
        name: RouteNameConfig.signUpScreen,
        builder: (context, state) {
          return const SignUpScreen();
        },
      ),

      GoRoute(
        path: RoutePathConfig.authOtp,
        name: RouteNameConfig.authOtp,
        builder: (context, state) {
          final email = SharedPersistence().get('_email');
          return OTPScreen(
            email: email ?? "testusers@gmail.com",
          );
        },
      ),
      GoRoute(
        path: RoutePathConfig.password,
        name: RouteNameConfig.password,
        builder: (context, state) {
          return const SPasswordScreen();
        },
      ),

      GoRoute(
        path: RoutePathConfig.onboard_user,
        name: RouteNameConfig.onboard_user,
        builder: (context, state) {
          return const OnboardUser();
        },
      ),
      GoRoute(
        path: RoutePathConfig.contactDetail,
        name: RouteNameConfig.contactDetail,
        builder: (context, state) {
          return const ContactDetailScreen();
        },
      ),
      GoRoute(
        path: RoutePathConfig.home_page,
        name: RouteNameConfig.home_page,
        builder: (context, state) {
          return const HomeScreen();
        },
      ),

      GoRoute(
        path: RoutePathConfig.wallet_page_section,
        name: RouteNameConfig.wallet_page_section,
        builder: (context, state) {
          return const WalletPage();
        },
      ),

      GoRoute(
        path: RoutePathConfig.deposit_screen,
        name: RouteNameConfig.deposit_screen,
        builder: (context, state) {
          final url = ProviderScope.containerOf(context).read(urlstateProvider);
          return DepositScreenPage(
            url: url,
          );
        },
      ),
      GoRoute(
        path: RoutePathConfig.investment_page,
        name: RouteNameConfig.investment_page,
        builder: (context, state) {
          final investmentType = state.uri.queryParameters['id'];
          String id = 'id';
          if (investmentType == null) {
            id = 'crypto';
          } else {
            id = investmentType;
          }

          return InvestmentScreen(
            investmentType: id,
          );
        },
      ),
      GoRoute(
        path: RoutePathConfig.notification_screen,
        name: RouteNameConfig.notification_screen,
        builder: (context, state) {
          return const NotificationScreen();
        },
      )
    ],
  );
}
