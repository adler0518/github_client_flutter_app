import 'dart:async';

import 'package:flutter/widgets.dart';
import 'MyLocalizations.dart';


class MyLocalizationsDelegate extends LocalizationsDelegate<MyLocalizations> {
  @override
  Future<MyLocalizations> load(Locale locale) => MyLocalizations.load(locale);

  @override
  bool isSupported(Locale locale) =>
      ['zh', 'en'].contains(locale.languageCode); // 支持的类型要包含App中注册的类型

  @override
  bool shouldReload(MyLocalizationsDelegate old) => false;
}