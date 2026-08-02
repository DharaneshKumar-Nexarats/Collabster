import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/auth_session.dart';

class LocalAuthStorage {
  static const String _sessionKey = 'auth.session';
  static const String _onboardingKey = 'auth.onboarding_complete';

  Future<SharedPreferences> get _prefs async => SharedPreferences.getInstance();

  Future<AuthSession?> readSession() async {
    final prefs = await _prefs;
    final encoded = prefs.getString(_sessionKey);
    if (encoded == null || encoded.isEmpty) {
      debugPrint('LocalAuthStorage: readSession – no session found in prefs');
      return null;
    }

    try {
      final session = AuthSession.fromEncodedJson(encoded);
      debugPrint('LocalAuthStorage: readSession – email="${session.email}", password="${session.password}", role="${session.role}"');
      return session;
    } catch (e) {
      debugPrint('LocalAuthStorage: failed to decode session – $e');
      return null;
    }
  }

  Future<void> saveSession(AuthSession session) async {
    final prefs = await _prefs;
    final encoded = session.toEncodedJson();
    debugPrint('LocalAuthStorage: saveSession – email="${session.email}", password="${session.password}", role="${session.role}", activeRole="${session.activeRole}", roles=${session.roles}');
    final success = await prefs.setString(_sessionKey, encoded);
    if (!success) {
      debugPrint('LocalAuthStorage: SharedPreferences.setString returned false');
    } else {
      debugPrint('LocalAuthStorage: saveSession – SUCCESS, encoded length=${encoded.length}');
    }
  }

  Future<void> updateSession(AuthSession? Function(AuthSession? current) update) async {
    final current = await readSession();
    final next = update(current);
    if (next == null) return;

    await saveSession(next);
  }

  Future<void> clearSession() async {
    final prefs = await _prefs;
    await prefs.remove(_sessionKey);
  }

  Future<bool> isOnboardingComplete() async {
    final prefs = await _prefs;
    return prefs.getBool(_onboardingKey) ?? false;
  }

  Future<void> markOnboardingComplete() async {
    final prefs = await _prefs;
    await prefs.setBool(_onboardingKey, true);
  }
}
