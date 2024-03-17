import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LocalStorageService {

  LocalStorageService._();
  static final LocalStorageService storage = LocalStorageService._();
  static const _secureStorage = FlutterSecureStorage();

  Future<void> writeSecureData(String key, String data) async {
    await _secureStorage.write(
        key: key, value: data, aOptions: _getAndroidOptions());
  }

  Future<String?> readSecureData(String key) async {
    var readData = await _secureStorage.read(key: key, aOptions: _getAndroidOptions());
    return readData;
  }

  Future<void> updateSecureData(String key, String value) async {
    await deleteSecureData(key).whenComplete(() async{
      await writeSecureData(key, value);
    });
  }

  Future<List<String>> readAllSecureData() async {
    var allData = await _secureStorage.readAll(aOptions: _getAndroidOptions());
    List<String> list = allData.entries.map((e) => "${e.key}:${e.value}").toList();
    return list;
  }

  Future<void> deleteSecureData(String key) async {
    await _secureStorage.delete(key: key, aOptions: _getAndroidOptions());
  }

  Future<bool> containsKeyInSecureData(String key) async {
    var containsKey = await _secureStorage.containsKey(key: key, aOptions: _getAndroidOptions());
    return containsKey;
  }

  Future<void> deleteAllSecureData() async {
    await _secureStorage.deleteAll(aOptions: _getAndroidOptions());
  }

  AndroidOptions _getAndroidOptions() => const AndroidOptions(
    encryptedSharedPreferences: true,
  );
}