import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:quanly/core/utils/app_constants.dart';

class LocaleService {
  LocaleService._();

  static const _supported = <Locale>[
    Locale('vi', 'VN'),
    Locale('en', 'US'),
  ];

  static List<Locale> get supportedLocales => List.unmodifiable(_supported);

  static Future<Locale?> getSavedLocale() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final value = prefs.getString(AppConstants.language);
      if (value == null || value.isEmpty) return null;

      // Stored as "vi_VN" / "en_US"
      final parts = value.split('_');
      if (parts.length != 2) return null;

      final locale = Locale(parts[0], parts[1]);
      return _supported.any((l) => l.languageCode == locale.languageCode && l.countryCode == locale.countryCode)
          ? locale
          : null;
    } catch (_) {
      return null;
    }
  }

  static Future<void> saveLocale(Locale locale) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      AppConstants.language,
      '${locale.languageCode}_${locale.countryCode ?? ''}',
    );
  }

  static Future<void> setLocale(Locale locale) async {
    await saveLocale(locale);
    Get.updateLocale(locale);
  }
}


