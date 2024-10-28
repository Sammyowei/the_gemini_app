import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:the_gemini_app/src/domain/config/config.dart';
import 'package:the_gemini_app/src/presentation/presentation.dart';
import 'package:the_gemini_app/src/presentation/widgets/supabase/supabase_inherited_widget.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Supabase configuration.
  final superbaseConfig = SupabaseConfig();

  // If the platform is iOS, set the system UI mode to manual to
  //
  //
  // hide system overlays.

  if (!kIsWeb) {
    if (Platform.isIOS) {
      SystemChrome.setEnabledSystemUIMode(
        SystemUiMode.manual,
        overlays: [],
      );
    }
  }

  // Run the application.
  runApp(
    // Provide Supabase configuration to the app.
    ProviderScope(
      child: MySupabaseConfig(
        supabase: superbaseConfig,
        child: const MyApp(),
      ),
    ),
  );
}

/// The main application widget.
class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      builder: (context, child) {
        return child!;
      },
      child: MaterialApp.router(
        // Configure the router for the app.
        routerConfig: RoutingConfig.router,
        // Set the title of the app.
        title: 'Gemini Mobile',
        // Disable the debug banner.
        debugShowCheckedModeBanner: false,
        // Apply the light theme to the app.
        theme: AppTheme.lightTheme(context),
        // Apply the dark theme to the app.
        darkTheme: AppTheme.darkTheme(context),
      ),
    );
  }
}
