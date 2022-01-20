import 'package:dio/dio.dart';
import 'package:qinglong_app/base/http/url.dart';
import 'package:qinglong_app/main.dart';

import '../userinfo_viewmodel.dart';

class TokenInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (getIt<UserInfoViewModel>().token != null &&
        getIt<UserInfoViewModel>().token!.isNotEmpty) {
      options.headers["Authorization"] =
          "Bearer " + getIt<UserInfoViewModel>().token!;
    }

    options.headers["User-Agent"] = "Dart/2.15.1(dart:io)";

    options.headers["Content-Type"] = "application/json;charset=UTF-8";
    if (options.path != Url.loginByClientId) {
      options.queryParameters["t"] =
          (DateTime.now().millisecondsSinceEpoch ~/ 1000).toString();
    }
    return handler.next(options);
  }
}
