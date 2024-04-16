import 'package:flutter/material.dart';

import '../../utility/database/local/cache_helper.dart';

class LanguageService {
  LanguageService._privateConstructor() {
    language = CacheHelper.getDataString(key: 'Language') ?? '';

    locale = getLanuage();
  }

  static final LanguageService _instance =
      LanguageService._privateConstructor();

  factory LanguageService() {
    return _instance;
  }

  late Locale locale;
  late String language;

  Locale getLanuage() {
    if (language != '') {
      if (language == '🇺🇸 English') {
        return const Locale('en');
      } else {
        return const Locale('ar');
      }
    } else {
      return const Locale('en');
    }
  }
}
