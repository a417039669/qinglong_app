import 'package:dio/dio.dart';
import 'package:qinglong_app/main.dart';

class TokenInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (userInfoViewModel.token != null) {
      options.headers["Authorization"] = "Bearer " + userInfoViewModel.token!;
    }
    options.queryParameters["t"] = (DateTime.now().millisecondsSinceEpoch~/1000).toString();
    return handler.next(options);
  }
}
