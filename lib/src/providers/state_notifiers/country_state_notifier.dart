import 'package:country_picker/country_picker.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class CountryNotifier extends StateNotifier<Country?> {
  CountryNotifier() : super(null);

  void chooseCountry(Country country) {
    state = country;
  }

  Country? getCountry() => state;
}
