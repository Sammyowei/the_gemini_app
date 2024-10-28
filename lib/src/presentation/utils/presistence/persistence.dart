import 'package:shared_preferences/shared_preferences.dart';

part "local_persisence.dart";

part "shared_persistence.dart";

abstract class Persistence {
  Future<void> save(String key, dynamic value);
  dynamic get(String key);
  Future<void> delete(String key);
}
