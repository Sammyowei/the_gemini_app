part of 'persistence.dart';

class LocalPersistence implements Persistence {
  final Map<String, String> _memoryStore = {};

  @override
  Future<void> delete(String key) async {
    _memoryStore.remove(key);
  }

  @override
  Future<void> save(String key, dynamic value) async {
    _memoryStore[key] = value;
  }

  @override
  dynamic get(String key) {
    return _memoryStore[key];
  }
}
