import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:navasys/shared/models/user.dart';

class TokenStorage {

  static const _kAccess = 'access_token';
  static const _kRefresh = 'refresh_token';
  TokenStorage._();
  static final TokenStorage instance = TokenStorage._();
  factory TokenStorage() => instance;


  final FlutterSecureStorage _storage = const FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
  );

  String? _accessToken;
  String? _refreshToken;
  User? _cachedUser;

  /// Carga ambos tokens en paralelo y arma el usuario. Llamar una vez en main().
  Future<void> init() async {
    final values = await Future.wait([
      _storage.read(key: _kAccess),
      _storage.read(key: _kRefresh),
    ]);
    _accessToken = values[0];
    _refreshToken = values[1];
    _cachedUser = _userFromToken(_accessToken);
  }

  Future<void> save({required String accessToken, required String refreshToken}) async {
    _accessToken = accessToken;
    _refreshToken = refreshToken;
    _cachedUser = _userFromToken(accessToken); // se actualiza al hacer login o refresh
    await Future.wait([
      _storage.write(key: _kAccess, value: accessToken),
      _storage.write(key: _kRefresh, value: refreshToken),
    ]);
  }

  Future<String?> get accessToken async =>
      _accessToken ??= await _storage.read(key: _kAccess);

  Future<String?> get refreshToken async =>
      _refreshToken ??= await _storage.read(key: _kRefresh);

  Future<bool> hasSession() async => (await refreshToken) != null;

  Future<void> clear() async {
    _accessToken = null;
    _refreshToken = null;
    _cachedUser = null;
    await _storage.deleteAll();
  }

  // ---------- Claims ----------

  Map<String, dynamic>? _decode(String? token) {
    if (token == null) return null;
    try {
      final payload = base64Url.normalize(token.split('.')[1]);
      return jsonDecode(utf8.decode(base64Url.decode(payload))) as Map<String, dynamic>;
    } catch (_) {
      return null;
    }
  }

  Future<Map<String, dynamic>?> get claims async => _decode(await accessToken);

  String extractValue(Map<String, dynamic>? c, String label) =>
      (c?[label]?.toString() ?? '').trim();

  Future<String> get primerNombre async =>
      extractValue(await claims, 'firstName').toLowerCase();

  Future<bool> get isAccessTokenExpired async {
    final exp = (await claims)?['exp'] as int?;
    if (exp == null) return true;
    final expiry = DateTime.fromMillisecondsSinceEpoch(exp * 1000);
    return DateTime.now().isAfter(expiry.subtract(const Duration(seconds: 30)));
  }

  // ---------- Usuario ----------

  User? _userFromToken(String? token) {
    final c = _decode(token);
    if (c == null) return null;
    return User(
      id: int.tryParse(extractValue(c, 'code')) ?? 0,
      document: extractValue(c, 'sub'),
      type: extractValue(c, 'type'),
      firstName: extractValue(c, 'firstName'),
      lastName: extractValue(c, 'lastName'),
    );
  }

  User? get currentUser => _cachedUser;

  Future<User?> get userLogged async =>
      _cachedUser ??= _userFromToken(await accessToken);
}