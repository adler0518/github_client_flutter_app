import 'package:flutter/material.dart';
import 'dart:collection';
import 'package:dio/dio.dart';
import 'Global.dart';


class CacheObject {
  CacheObject(this.response) : timeStamp = DateTime.now().millisecondsSinceEpoch;
  Response response;
  int timeStamp;

  @override
  bool operator ==(other) {
    return response.hashCode == other.hashCode;
  }

  @override
  int get hashCode => response.realUri.hashCode;
}

class NetCache extends Interceptor {
  var cache = LinkedHashMap<String, CacheObject>();

  @override
  onRequest(RequestOptions options) {
    print('cache request: ${Global.profile.cache.enable}');
    if (!Global.profile.cache.enable) return options;

    //It is pull refresh that refresh sign.
    bool refresh = options.extra["refresh"] == true;

    //Delete about cache when refresh sign content 'refresh' string.
    if (refresh) {
      if (options.extra["list"] == true) {
        cache.removeWhere((k,v) => k.contains(options.path));
      } else {
        delete(options.uri.toString());
      }
      return options;
    }

    //Load get data from cache or net, while first from cache.
    if (options.extra["noCache"] != true &&
        options.method.toLowerCase() == 'get') {
      String key = options.extra['cacheKey'] ?? options.uri.toString();
      var ob = cache[key];
      if (ob != null) {
        //Return cache data when is whihin the expiration date.
        if ((DateTime.now().millisecondsSinceEpoch - ob.timeStamp) / 1000 < Global.profile.cache.maxAge) {
          return cache[key].response;
        }else {
          delete(key);
        }
      }
    }

    return options;
  }

  @override
  onError(DioError err) {
    print('error: ${err}');
  }

  @override
  onResponse(Response response) {
    print('cache response');
    if (Global.profile.cache.enable) {
      _saveCache(response);
    }
  }

  _saveCache(Response object) {
    RequestOptions options = object.request;
    if (options.extra["noCache"] != true &&
        options.method.toLowerCase() == "get") {
      // First data is removed, while cache data count overtop max count.
      if (cache.length == Global.profile.cache.maxCount) {
        cache.remove(cache[cache.keys.first]);
      }
      String key = options.extra["cacheKey"] ?? options.uri.toString();
      cache[key] = CacheObject(object);
    }
  }

  void delete(String key) {
    cache.remove(key);
  }
}