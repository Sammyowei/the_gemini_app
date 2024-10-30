import 'package:hooks_riverpod/hooks_riverpod.dart';

class StringNotifier extends StateNotifier<String> {
  StringNotifier() : super('');

  void setValue(String value) {
    state = value;
  }

  String get value => state;
}
