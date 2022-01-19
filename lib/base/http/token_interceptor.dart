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

    options.headers["User-Agent"] =
        "Mozilla/5.0 (iPhone; CPU iPhone OS 13_2_3 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/13.0.3 Mobile/15E148 Safari/604.1";
    options.headers["Content-Type"] = "application/json;charset=UTF-8";
    if (options.path != Url.loginByClientId) {
      options.queryParameters["t"] =
          (DateTime.now().millisecondsSinceEpoch ~/ 1000).toString();
    }
    return handler.next(options);
  }
}
