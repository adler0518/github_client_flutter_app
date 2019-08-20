import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:github_client_app/models/index.dart';
import 'Global.dart';


class ProfileChangeNotifier extends ChangeNotifier {
  // Internal, private state of the profile.
  Profile get _profile => Global.profile;

  @override
  void notifyListeners() {
    //Save profile info when has changed.
    Global.saveProfile();

    ///This call tells the widgets that are listening to this model to rebuild.
    super.notifyListeners();
  }
}

///User state
class UserModel extends ProfileChangeNotifier {
  User get user => _profile.user;

  //Check whether to login or not.
  bool get isLogin => user != null;

  set user(User user) {
    if (user?.login != _profile.user?.login) {
      _profile.lastLogin = _profile.user?.login;
      _profile.user = user;
      notifyListeners();
    }
  }
}

///App theme
class ThemeModel extends ProfileChangeNotifier {
  //Get current theme (Theme color is blue when not set).
  ColorSwatch get theme => Global.themes.firstWhere((e) => e.value == _profile.theme, orElse: () => Colors.blue);

  set theme(ColorSwatch color) {
    if (color != theme) {
      _profile.theme = color[500].value;
      notifyListeners();
    }
  }
}

///App Language
class LocaleModel extends ProfileChangeNotifier {
  //Normal use system language.
  Locale getLocale() {
    if(_profile.locale == null) return null;
    var t = _profile.locale.split('_');
    return Locale(t[0], t[1]);
  }

  String get locale => _profile.locale;

  set locale(String locale) {
    if (locale != _profile.locale) {
      _profile.locale = locale;
      notifyListeners();
    }
  }
}