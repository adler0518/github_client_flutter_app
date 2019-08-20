import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'Global.dart';
import 'Cache.dart';
import '../models/index.dart';


class Git {
  Git([this.context]) {
    _options = Options(extra: {"context": context});
  }

  BuildContext context;
  Options _options;
  static Dio dio = new Dio(BaseOptions(
    baseUrl: 'https://api.github.com/',
//    baseUrl: 'https://www.mocky.io/',
    headers: {
      HttpHeaders.acceptHeader: "application/vnd.github.squirrel-girl-preview,"
          "application/vnd.github.symmetra-preview+json",
    },
  ));

  static void init() {
    //Add cache plugin
    dio.interceptors.add(Global.netCache);

    //User token (null means logout)
    dio.options.headers[HttpHeaders.authorizationHeader] = Global.profile.token;

    if (!Global.isRelease) {
      (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
          (client) {
//        client.findProxy = (uri) {
//          return "PROXY 10.1.10.250:8888";
//        };

        //Disabled certificate verify.
        client.badCertificateCallback =
            (X509Certificate cert, String host, int port) => true;
      };
    }
  }

  //Login method
  Future<User> login(String login, String pwd) async {
    String basic = 'Basic ' + base64.encode(utf8.encode('$login:$pwd'));
    //Update public header (authorization）
    dio.options.headers[HttpHeaders.authorizationHeader] = basic;

    var r = await dio.get(
      "/users/$login",
      options: _options.merge(headers: {
        HttpHeaders.authorizationHeader: basic
      }, extra: {
        "noCache": true, //本接口禁用缓存
      }),
    );

    print('login response: $r.data');


    //Clear all cache
    Global.netCache.cache.clear();

    //Update token info that in profile.
    Global.profile.token = basic;
    return User.fromJson(r.data);
  }

  //Get repo list method
  Future<List<Repo>> getRepos(
      {Map<String, dynamic> queryParameters, //query param, paging
      refresh = false}) async
  {
    if (refresh) {
      //Delete cache data when pull refresh.（Adapter use this info.）
      _options.extra.addAll({"refresh": true, "list": true});
    }
    
    print('request repo params:${queryParameters}');

    var r = await dio.get<List>(
      "user/repos",
      queryParameters: queryParameters,
      options: _options,
    );

    print('network response: ${r.data}');

    return r.data.map((e) => Repo.fromJson(e)).toList();
  }

  void getDemoNet() async {
    var dio1 = Dio();
    (dio1.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (client) {
//      client.findProxy = (uri) {
//        return "PROXY 59.188.134.170";
//      };
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
    };
//    Response response = await dio1.get("https://www.mocky.io/v2/5185415ba171ea3a00704eed");
    dio1.options.headers[HttpHeaders.authorizationHeader] = "Basic YWRsZXIwNTE4OmFkbGVyMDUwMg==";
    Response response = await dio1.get("https://api.github.com/users/adler0518");



//    var dio2 = Dio(BaseOptions(
//      baseUrl: "https://www.mocky.io/",
//      connectTimeout: 5000,
//      receiveTimeout: 5000,
//      headers: {HttpHeaders.userAgentHeader: 'dio', 'common-header': 'xx'},
//    ));
//    Response response = await dio2.get('v2/5185415ba171ea3a00704eed');


//    Response response = await dio.get('v2/5185415ba171ea3a00704eed');
    print(response.data);

  }

}