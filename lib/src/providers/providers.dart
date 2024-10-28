import 'package:hooks_riverpod/hooks_riverpod.dart';

export 'state_notifiers/state_notifiers.dart';
export 'state_notifier_provider/state_notifier_provider.dart';
export 'auth_model_provider.dart';

final urlProvider = Provider<String>((ref) {
  return '';
});
