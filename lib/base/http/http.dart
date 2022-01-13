import 'dart:convert';
import 'dart:core';

import 'package:dio/dio.dart';
import 'package:dio_log/dio_log.dart';
import 'package:flutter/foundation.dart';
import 'package:qinglong_app/base/http/token_interceptor.dart';
import 'package:qinglong_app/base/userinfo_viewmodel.dart';

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

  static void _init() {
    if (_dio == null) {
      initDioConfig(UserInfoViewModel.getInstance().host!);
    }
  }

  static Future<HttpResponse<T>> get<T>(String uri, Map<String, String>? json, {bool compute = true}) async {
    _init();
    var response = await _dio!.get(uri, queryParameters: json);

    return decodeResponse<T>(response, compute);
  }

  static Future<HttpResponse<T>> post<T>(String uri, dynamic json, {bool compute = true}) async {
    _init();
    var response = await _dio!.post(uri, data: json);

    return decodeResponse<T>(response, compute);
  }

  static Future<HttpResponse<T>> delete<T>(String uri, dynamic json, {bool compute = true}) async {
    _init();
    var response = await _dio!.delete(uri, data: json);

    return decodeResponse<T>(response, compute);
  }

  static Future<HttpResponse<T>> put<T>(String uri, dynamic json, {bool compute = true}) async {
    _init();
    var response = await _dio!.put(uri, data: json);

    return decodeResponse<T>(response, compute);
  }

  static HttpResponse<T> decodeResponse<T>(
    Response<dynamic> response,
    bool compute,
  ) {
    int code = 0;

    if (response.statusCode == 200) {
      try {
        if (response.data["code"] == 200) {
          if (response.data["data"] != null) {
            if (T == NullResponse) {
              return HttpResponse<T>(
                success: true,
                code: 200,
              );
            }

            dynamic data = response.data["data"];
            T t;
            if (T == String) {
              if (data is String) {
                t = data as T;
              } else {
                t = jsonEncode(data) as T;
              }
              return HttpResponse<T>(
                success: true,
                code: 200,
                bean: t,
              );
            } else {
              T bean;
              if (compute) {
                bean = DeserializeAction.invokeJson(DeserializeAction<T>(data));
              } else {
                bean = JsonConversion$Json.fromJson<T>(data);
              }
              return HttpResponse<T>(
                success: true,
                code: 200,
                bean: bean,
              );
            }
          } else {
            return HttpResponse<T>(
              success: true,
              code: 200,
            );
          }
        } else {
          return HttpResponse<T>(
            success: false,
            code: -1000,
            message: "服务器返回数据异常",
          );
        }
      } catch (e) {
        return HttpResponse<T>(
          success: false,
          code: -1000,
          message: "json解析失败",
        );
      }
    } else {
      code = response.statusCode ?? 0;
      return HttpResponse(
        success: false,
        code: code,
        message: response.statusMessage,
      );
    }
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

class NullResponse{}