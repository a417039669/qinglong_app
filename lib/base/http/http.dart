import 'package:dio/dio.dart';
import 'package:dio_log/dio_log.dart';
import 'package:flutter/foundation.dart';
import 'package:qinglong_app/base/http/token_interceptor.dart';
import 'package:qinglong_app/base/userinfo_viewmodel.dart';
import 'package:qinglong_app/main.dart';

import '../../json.jc.dart';

class Http {
  static const int NOT_LOGIN = 1000;
  static Dio? _dio;

  static void initDioConfig(
    String host,
  ) {
    _dio = Dio(
      BaseOptions(
        baseUrl: host,
        connectTimeout: 5000,
        receiveTimeout: 5000,
        sendTimeout: 5000,
        contentType: "application/json",
      ),
    );
    _dio?.interceptors.add(DioLogInterceptor());
    _dio?.interceptors.add(TokenInterceptor());
  }

  static Future<HttpResponse<T>> post<T>(String uri, Map<String, dynamic> json, {bool compute = true}) async {
    if (userInfoViewModel.host == null || userInfoViewModel.host!.isEmpty) {
      return HttpResponse(success: false, code: NOT_LOGIN, message: "未登录");
    }

    if (_dio == null) {
      initDioConfig(UserInfoViewModel.getInstance().host!);
    }

    var response = await _dio!.post(uri, data: json);

    return decodeResponse<T>(response, compute);
  }

  static HttpResponse<T> decodeResponse<T>(
    Response<dynamic> response,
    bool compute,
  ) {
    late HttpResponse<T> result;

    int code = 0;

    if (response.statusCode == 200) {
      if (compute) {
        try {
          if (response.data["code"] == 200) {
            dynamic data = response.data["data"];
            T bean = DeserializeAction.invokeJson(DeserializeAction<T>(data));
            result = HttpResponse<T>(success: true, code: 200, bean: bean);
          } else {
            result = HttpResponse<T>(success: false, code: -1000, message: "服务器返回数据异常");
          }
        } catch (e) {
          result = HttpResponse<T>(success: false, code: -1000, message: "json解析失败");
        }
      }
    } else {
      code = response.statusCode ?? 0;
      result = HttpResponse(success: false, code: code, message: response.statusMessage);
    }

    return result;
  }
}

class HttpResponse<T> {
  late bool success;
  String? message;
  late int code;
  T? bean;

  HttpResponse({required this.success, this.message, required this.code, this.bean});
}

class DeserializeAction<T> {
  final dynamic json;

  DeserializeAction(this.json);

  T invoke() {
    return JsonConversion$Json.fromJson<T>(json);
  }

  static dynamic invokeJson(DeserializeAction a) => a.invoke();
}

mixin BaseBean<T> {
  T fromJson(Map<String, dynamic> json);
}

class CronBean with BaseBean<CronBean> {
  @override
  CronBean fromJson(Map<String, dynamic> json) {
    return CronBean();
  }
}

void decode<T>() async {
  compute(DeserializeAction.invokeJson, DeserializeAction<T>({}));
}
