import 'package:flutter/widgets.dart';
import 'package:the_gemini_app/src/domain/config/supabase_config.dart';

/// A widget that provides access to a Supabase configuration throughout the widget tree.
class MySupabaseConfig extends InheritedWidget {
  /// The Supabase configuration to be provided to descendant widgets.
  final SupabaseConfig supabase;

  /// Constructs a [MySupabaseConfig] widget.
  ///
  /// [key] is the key to identify this widget.
  /// [child] is the widget below this widget in the widget tree.
  /// [supabase] is the Supabase configuration to be provided.
  const MySupabaseConfig({
    Key? key,
    required Widget child,
    required this.supabase,
  }) : super(child: child, key: key);

  /// Retrieves the [MySupabaseConfig] instance from the widget tree.
  ///
  /// [context] is the build context.
  static MySupabaseConfig of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<MySupabaseConfig>()!;
  }

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    // Returns true if the Supabase configuration has changed.
    return supabase != (oldWidget as MySupabaseConfig).supabase;
  }
}
