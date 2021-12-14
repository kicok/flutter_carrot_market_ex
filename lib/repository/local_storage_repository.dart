import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LocalStorageRepository {
// Create storage
  final storage = const FlutterSecureStorage();

  // Read value
  Future<String?> getStroredValue(String key) async {
    try {
      return await storage.read(key: key);
    } catch (error) {
      rethrow;
    }
  }

  // write value
  Future<void> stroreValue(String key, String value) async {
    try {
      await storage.write(key: key, value: value);
    } catch (e) {
      rethrow;
    }
  }
}
