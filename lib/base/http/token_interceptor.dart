import 'package:dio/dio.dart';
import 'package:qinglong_app/main.dart';

import '../userinfo_viewmodel.dart';

class TokenInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (getIt<UserInfoViewModel>().token != null) {
      options.headers["Authorization"] = "Bearer " + getIt<UserInfoViewModel>().token!;
    }
    options.queryParameters["t"] = (DateTime.now().millisecondsSinceEpoch~/1000).toString();
    return handler.next(options);
  }
}
