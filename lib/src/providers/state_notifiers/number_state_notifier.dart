import 'package:hooks_riverpod/hooks_riverpod.dart';

class VerificationNotifier extends StateNotifier<int> {
  VerificationNotifier() : super(1);

  void setVerificationMethod(int value) {
    state = value;
  }
}

class BottomNavNotifier extends StateNotifier<int> {
  BottomNavNotifier() : super(0);

  void setValue(int value) => state = value;
}
