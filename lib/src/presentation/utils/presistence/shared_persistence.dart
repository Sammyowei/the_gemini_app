part of 'persistence.dart';

// SharedPersistence class implementing the Persistence interface
class SharedPersistence implements Persistence {
  static SharedPersistence? _instance;
  static SharedPreferences? _prefs;

  // Private constructor
  SharedPersistence._internal();

  // Factory constructor to ensure a single instance
  factory SharedPersistence() {
    if (_instance == null) {
      _instance = SharedPersistence._internal();
      _initializePreferences();
    }
    return _instance!;
  }

  // Method to initialize SharedPreferences
  static Future<void> _initializePreferences() async {
    _prefs = await SharedPreferences.getInstance();
  }

  @override
  Future<void> save(String key, dynamic value) async {
    await _prefs?.setString(key, value);
  }

  @override
  Future<void> delete(String key) async {
    await _prefs?.remove(key);
  }

  @override
  dynamic get(String key) {
    return _prefs?.getString(key);
  }
}
