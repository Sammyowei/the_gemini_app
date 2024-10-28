import 'package:country_picker/country_picker.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:the_gemini_app/src/providers/state_notifiers/country_state_notifier.dart';

final countryStateNotifierProvider =
    StateNotifierProvider<CountryNotifier, Country?>((ref) {
  return CountryNotifier();
});
