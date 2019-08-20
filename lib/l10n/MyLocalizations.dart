import 'dart:async';

import 'package:intl/intl.dart';
import 'package:flutter/widgets.dart';

import 'package:github_client_app/l10n/messages_all.dart';

class MyLocalizations {
  MyLocalizations(this.locale);

  final Locale locale;

  static Future<MyLocalizations> load(Locale locale) {
    return initializeMessages(locale.toString())
        .then((void _) {
      return MyLocalizations(locale);
    });
  }

  static MyLocalizations of(BuildContext context) {
    return Localizations.of<MyLocalizations>(context, MyLocalizations);
  }

  String title() => Intl.message('<title>', name: 'title', locale: locale.toString());
  String home(name) => Intl.message('D $name', name: 'home', args: [name], desc: 'one desc message', locale: locale.toString());
  String login() => Intl.message('<login>', name: 'login', desc: 'login button title', locale: locale.toString());

// ... more Intl.message() methods like title()

  String theme = "换肤";
  String language = "语言";
  String logout = "登出";
  String logoutTip = "确定要登出？";
  String cancel = "取消";
  String yes = "确定";
  String userName() => "用户名";
  String userNameOrEmail() => "请输入用户名或邮箱";
  String userNameRequired() => "用户名不能为空";
  String password() => "密码";
  String passwordRequired() => "密码不能为空";
  String userNameOrPasswordWrong() => "用户名或密码错误";
}

