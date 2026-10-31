
import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenStorage {
  static const _KAccees = 'access_token';
  static const _KRefresh = 'refresh_token';

  final FlutterSecureStorage _storage = const FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
  );

  String? _accessToken;
  String? _refreshToken;

  Future<void> save({required String accessToken, required String refreshToken}) async {
    _accessToken = accessToken;
    _refreshToken = refreshToken;
    await _storage.write(key: _KAccees, value: accessToken);
    await _storage.write(key: _KRefresh, value: refreshToken);
  }

  Future<String?> get accessToken async =>
      _accessToken ??= await _storage.read(key: _KAccees);

  Future<String?> get refreshToken async =>
      _refreshToken ??= await _storage.read(key: _KRefresh);

  Future<bool> hasSession() async => (await refreshToken) != null;

  Future<void> clear() async {
    _accessToken = null;
    _refreshToken = null;
    await _storage.deleteAll();
  }

  Future<Map<String, dynamic>?> get claims async {
    final token = await accessToken;
    if (token == null) return null;

    try {
      final payload = base64Url.normalize(token.split('.')[1]);
      return jsonDecode(utf8.decode(base64Url.decode(payload))) as Map<String, dynamic>;
    } catch (_) {
      return null;
    }
  }

  Future<String> get primerNombe async {
    final c = await claims;
    final first = (c?['firstName'] as String? ?? '').trim();
    return first.toLowerCase();
  }

  Future<bool> get isAccessTokenExpired async {
    final c = await claims;
    final exp = c?['exp'] as int?;
    if (exp == null) return true;
    final expiry = DateTime.fromMillisecondsSinceEpoch(exp * 1000);
    return DateTime.now().isAfter(expiry.subtract(const Duration(seconds: 30)));
  }
}