import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:github_client_app/models/index.dart';
import 'package:github_client_app/common/Cache.dart';
import 'package:github_client_app/common/Network.dart';

// 提供四套可选主题色
const _themes = <MaterialColor>[
  Colors.blue,
  Colors.cyan,
  Colors.teal,
  Colors.green,
  Colors.red,
];

class Global {
  static SharedPreferences _prefs;
  static Profile profile = Profile();

  //网络缓存对象
  static NetCache netCache = NetCache();

  //可选的主题列表
  static List<MaterialColor> get themes => _themes;

  //whether is release version
  static bool get isRelease => bool.fromEnvironment("dart.vm.product");

  //When app is running, it's initialized global info.
  static Future init() async {
    _prefs = await SharedPreferences.getInstance();
    var _profile = _prefs.getString("profile");
    if (_profile != null) {
      try {
        profile = Profile.fromJson(jsonDecode(_profile));
      }catch(e){
        print(e);
      }
    }

    //If not cache info, setting normal cache policy.
    profile.cache = profile.cache ?? CacheConfig()
      ..enable = true
      ..maxAge = 3600
      ..maxCount = 100;

    //Init some config about network.
    Git.init();
  }

  //storage Profile info.
  static saveProfile() =>
      _prefs.setString("profile", jsonEncode(profile.toJson()));

}