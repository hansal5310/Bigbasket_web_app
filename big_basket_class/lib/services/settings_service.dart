import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsService extends ChangeNotifier {
  static const String _keyNotifications = 'settings_notifications_enabled';
  static const String _keyThemeMode = 'settings_theme_mode';

  bool _notificationsEnabled = true;
  ThemeMode _themeMode = ThemeMode.light;
  bool _loaded = false;

  bool get notificationsEnabled => _notificationsEnabled;
  ThemeMode get themeMode => _themeMode;
  bool get isLoaded => _loaded;

  SettingsService() {
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    _notificationsEnabled = prefs.getBool(_keyNotifications) ?? true;
    final modeIndex = prefs.getInt(_keyThemeMode);
    _themeMode = ThemeMode.values.elementAt(modeIndex ?? ThemeMode.light.index);
    _loaded = true;
    notifyListeners();
  }

  Future<void> setNotificationsEnabled(bool enabled) async {
    _notificationsEnabled = enabled;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyNotifications, enabled);
  }

  Future<void> toggleNotifications() async {
    await setNotificationsEnabled(!notificationsEnabled);
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    _themeMode = mode;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_keyThemeMode, mode.index);
  }

  Future<void> toggleThemeMode() async {
    await setThemeMode(_themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light);
  }
}


