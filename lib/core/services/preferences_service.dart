import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class PreferencesService {
  PreferencesService(this._sharedPreferences);

  final SharedPreferences _sharedPreferences;

  bool getBool(String key, {bool fallback = false}) {
    return _sharedPreferences.getBool(key) ?? fallback;
  }

  bool readBool(String key, {bool fallback = false}) {
    return getBool(key, fallback: fallback);
  }

  Future<bool> setBool(String key, bool value) {
    return _sharedPreferences.setBool(key, value);
  }

  Future<bool> writeBool(String key, bool value) {
    return setBool(key, value);
  }

  int? getInt(String key) {
    return _sharedPreferences.getInt(key);
  }

  int? readInt(String key) {
    return getInt(key);
  }

  Future<bool> setInt(String key, int value) {
    return _sharedPreferences.setInt(key, value);
  }

  Future<bool> writeInt(String key, int value) {
    return setInt(key, value);
  }

  String? getString(String key) {
    return _sharedPreferences.getString(key);
  }

  String? readString(String key) {
    return getString(key);
  }

  Future<bool> setString(String key, String value) {
    return _sharedPreferences.setString(key, value);
  }

  Future<bool> writeString(String key, String value) {
    return setString(key, value);
  }

  List<String> getStringList(String key) {
    return _sharedPreferences.getStringList(key) ?? const <String>[];
  }

  Future<bool> setStringList(String key, List<String> value) {
    return _sharedPreferences.setStringList(key, value);
  }

  Future<bool> remove(String key) {
    return _sharedPreferences.remove(key);
  }

  Future<bool> setJson(String key, Map<String, dynamic> value) {
    return setString(key, jsonEncode(value));
  }

  Map<String, dynamic>? getJson(String key) {
    final raw = getString(key);
    if (raw == null || raw.isEmpty) {
      return null;
    }

    return jsonDecode(raw) as Map<String, dynamic>;
  }
}
