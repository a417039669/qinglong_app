import 'package:qinglong_app/base/http/api.dart';
import 'package:qinglong_app/base/http/http.dart';
import 'package:qinglong_app/base/userinfo_viewmodel.dart';
import 'package:qinglong_app/module/login/login_bean.dart';
import 'package:qinglong_app/utils/extension.dart';

import '../main.dart';

class LoginHelper {
  static int success = 0;
  static int failed = 1;
  static int twiceLogin = 2;
  bool useSecretLogin = false;

  final String host;
  final String userName;
  final String password;
  final bool rememberPassword;

  LoginHelper(this.useSecretLogin, this.host, this.userName, this.password,
      this.rememberPassword);

  Future<int> login() async {
    Http.clear();
    getIt<UserInfoViewModel>().updateHost(host);
    HttpResponse<LoginBean> response;

    if (loginByUserName()) {
      response = await Api.login(userName, password);
    } else {
      response = await Api.loginByClientId(userName, password);
    }
    if (response.success) {
      loginSuccess(response, userName, password);
      return success;
    } else if (loginByUserName() && response.code == 401) {
      //可能用户使用的是老版本qinglong
      HttpResponse<LoginBean> oldResponse =
          await Api.loginOld(userName, password);
      if (oldResponse.success) {
        loginSuccess(oldResponse, userName, password);
        return success;
      } else {
        (oldResponse.message ?? "请检查网络情况").toast();
        if (oldResponse.code == 420) {
          return twiceLogin;
        } else {
          return failed;
        }
      }
    } else {
      (response.message ?? "请检查网络情况").toast();
      //420代表需要2步验证
      if (response.code == 420) {
        return twiceLogin;
      } else {
        return failed;
      }
    }
  }

  Future<int> loginTwice(String code) async {
    HttpResponse<LoginBean> response =
        await Api.loginTwo(userName, password, code);
    if (response.success) {
      loginSuccess(response, userName, password);
      return success;
    } else {
      (response.message ?? "请检查网络情况").toast();
      return failed;
    }
  }

  void loginSuccess(
      HttpResponse<LoginBean> response, String userName, String password) {
    getIt<UserInfoViewModel>().updateToken(response.bean?.token ?? "");
    if (rememberPassword) {
      getIt<UserInfoViewModel>()
          .updateUserName(host, userName, password, !loginByUserName());
    } else {
      getIt<UserInfoViewModel>()
          .updateUserName(host, "", "", !loginByUserName());
    }
  }

  bool loginByUserName() {
    return !useSecretLogin;
  }
}
