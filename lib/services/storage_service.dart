import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';
import '../models/user.dart';

class StorageService {
  static final StorageService _instance = StorageService._internal();
  factory StorageService() => _instance;
  
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  SharedPreferences? _prefs;
  
  StorageService._internal();
  
  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }
  
  // Token Management
  Future<void> saveToken(String token) async {
    await _secureStorage.write(key: 'auth_token', value: token);
  }
  
  Future<String?> getToken() async {
    return await _secureStorage.read(key: 'auth_token');
  }
  
  Future<void> clearToken() async {
    await _secureStorage.delete(key: 'auth_token');
  }
  
  // User Data Management
  Future<void> saveUser(User user) async {
    final userJson = jsonEncode(user.toJson());
    await _prefs?.setString('user_data', userJson);
  }
  
  Future<User?> getUser() async {
    final userJson = _prefs?.getString('user_data');
    if (userJson != null) {
      return User.fromJson(jsonDecode(userJson));
    }
    return null;
  }
  
  Future<void> clearUser() async {
    await _prefs?.remove('user_data');
  }
  
  // Generic Storage
  Future<void> saveString(String key, String value) async {
    await _prefs?.setString(key, value);
  }
  
  String? getString(String key) {
    return _prefs?.getString(key);
  }
  
  Future<void> saveBool(String key, bool value) async {
    await _prefs?.setBool(key, value);
  }
  
  bool? getBool(String key) {
    return _prefs?.getBool(key);
  }
  
  Future<void> saveInt(String key, int value) async {
    await _prefs?.setInt(key, value);
  }
  
  int? getInt(String key) {
    return _prefs?.getInt(key);
  }
  
  Future<void> remove(String key) async {
    await _prefs?.remove(key);
  }
  
  Future<void> clear() async {
    await _prefs?.clear();
    await _secureStorage.deleteAll();
  }
  
  // Recent Searches Management
  Future<void> saveRecentSearches(List<Map<String, String>> searches) async {
    final searchesJson = jsonEncode(searches);
    await _prefs?.setString('recent_searches', searchesJson);
  }
  
  List<Map<String, String>> getRecentSearches() {
    final searchesJson = _prefs?.getString('recent_searches');
    if (searchesJson != null) {
      final List<dynamic> decoded = jsonDecode(searchesJson);
      return decoded.map((e) => Map<String, String>.from(e)).toList();
    }
    return [];
  }
  
  Future<void> addRecentSearch(String from, String to) async {
    List<Map<String, String>> searches = getRecentSearches();
    
    // Supprimer si la recherche existe déjà
    searches.removeWhere((s) => s['from'] == from && s['to'] == to);
    
    // Ajouter au début
    searches.insert(0, {'from': from, 'to': to});
    
    // Limiter à 5 recherches
    if (searches.length > 5) {
      searches = searches.sublist(0, 5);
    }
    
    await saveRecentSearches(searches);
  }
  
  // Theme Mode Management
  Future<void> saveThemeMode(String mode) async {
    await _prefs?.setString('theme_mode', mode);
  }
  
  Future<String?> getThemeMode() async {
    return _prefs?.getString('theme_mode');
  }
  
  // Locale Management
  Future<void> saveLocale(String locale) async {
    await _prefs?.setString('locale', locale);
  }
  
  Future<String?> getLocale() async {
    return _prefs?.getString('locale');
  }
}
