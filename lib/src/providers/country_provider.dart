import 'package:country_picker/country_picker.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final CountryProvider = Provider<Country>((ref) {
  return Country.worldWide;
});
