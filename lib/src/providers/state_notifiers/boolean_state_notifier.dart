import 'package:hooks_riverpod/hooks_riverpod.dart';

class BooleanNotifier extends StateNotifier<bool> {
  BooleanNotifier({bool? value}) : super(value ?? false);

  bool get getState => state;

  void toggleOn() {
    state = true;
  }

  void toggleOff() {
    state = false;
  }

  void toggle() {
    state = !state;
  }

  void setState(bool newState) {
    state = newState;
  }
}
