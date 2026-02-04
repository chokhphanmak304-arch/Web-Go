import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart';

class BrandingService {
  static const String _keyAppName = 'branding_app_name';
  static const String _keyColor = 'branding_color';
  static const String _keyLogoPath = 'branding_logo_path';

  static const String defaultAppName = 'Web Go';
  static const int defaultColorValue = 0xFFE91E63;
  static const String defaultLogoAsset = 'assets/logo_odoo.png';

  // Preset colors
  static const List<BrandingColor> presetColors = [
    BrandingColor('Deep Pink', 0xFFE91E63),
    BrandingColor('Blue', 0xFF2196F3),
    BrandingColor('Purple', 0xFF9C27B0),
    BrandingColor('Teal', 0xFF009688),
    BrandingColor('Orange', 0xFFFF9800),
    BrandingColor('Red', 0xFFF44336),
    BrandingColor('Indigo', 0xFF3F51B5),
    BrandingColor('Green', 0xFF4CAF50),
    BrandingColor('Navy', 0xFF1E3A5F),
    BrandingColor('Brown', 0xFF795548),
  ];

  // Cached values
  static String _appName = defaultAppName;
  static int _colorValue = defaultColorValue;
  static String? _logoPath;
  static bool _loaded = false;

  static String get appName => _appName;
  static Color get primaryColor => Color(_colorValue);
  static int get colorValue => _colorValue;
  static String? get logoPath => _logoPath;
  static bool get hasCustomLogo => _logoPath != null && File(_logoPath!).existsSync();

  static Future<void> load() async {
    if (_loaded) return;
    final prefs = await SharedPreferences.getInstance();
    _appName = prefs.getString(_keyAppName) ?? defaultAppName;
    _colorValue = prefs.getInt(_keyColor) ?? defaultColorValue;
    _logoPath = prefs.getString(_keyLogoPath);
    _loaded = true;
  }

  static Future<void> forceReload() async {
    _loaded = false;
    await load();
  }

  static Future<void> saveAppName(String name) async {
    final prefs = await SharedPreferences.getInstance();
    _appName = name.trim().isEmpty ? defaultAppName : name.trim();
    await prefs.setString(_keyAppName, _appName);
  }

  static Future<void> saveColor(int colorValue) async {
    final prefs = await SharedPreferences.getInstance();
    _colorValue = colorValue;
    await prefs.setInt(_keyColor, colorValue);
  }

  static Future<String> saveLogo(File sourceFile) async {
    final dir = await getApplicationDocumentsDirectory();
    final logoFile = File('${dir.path}/custom_logo.png');
    await sourceFile.copy(logoFile.path);
    _logoPath = logoFile.path;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyLogoPath, logoFile.path);
    return logoFile.path;
  }

  static Future<void> clearLogo() async {
    if (_logoPath != null) {
      final file = File(_logoPath!);
      if (await file.exists()) await file.delete();
    }
    _logoPath = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyLogoPath);
  }

  static Future<void> resetToDefault() async {
    final prefs = await SharedPreferences.getInstance();
    await clearLogo();
    _appName = defaultAppName;
    _colorValue = defaultColorValue;
    await prefs.remove(_keyAppName);
    await prefs.remove(_keyColor);
  }

  // Helper widget to show logo
  static Widget buildLogo({double? width, double? height, BoxFit fit = BoxFit.contain}) {
    if (hasCustomLogo) {
      return Image.file(File(_logoPath!), width: width, height: height, fit: fit, errorBuilder: (_, __, ___) {
        return Image.asset(defaultLogoAsset, width: width, height: height, fit: fit);
      });
    }
    return Image.asset(defaultLogoAsset, width: width, height: height, fit: fit);
  }
}

class BrandingColor {
  final String name;
  final int value;
  const BrandingColor(this.name, this.value);
  Color get color => Color(value);
}
