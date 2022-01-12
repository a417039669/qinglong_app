import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qinglong_app/base/base_viewmodel.dart';
import 'package:qinglong_app/base/http/http.dart';
import 'package:qinglong_app/base/http/url.dart';
import 'package:qinglong_app/main.dart';

import 'login_bean.dart';

var loginProvider = ChangeNotifierProvider((ref) => LoginViewModel());

class LoginViewModel extends ViewModel {
  bool loginSuccess = false;
  bool isLoading = false;
  String msg = "";

  void login(String userName, String password) async {
    isLoading = true;
    loginSuccess = false;
    msg = "";

    notifyListeners();
    HttpResponse<LoginBean> response = await Http.post<LoginBean>(
      Url.LOGIN,
      {
        "username": userName,
        "password": password,
      },
    );

    if (response.success) {
      userInfoViewModel.updateToken(response.bean?.token ?? "");
      loginSuccess = true;
      isLoading = false;
    } else {
      isLoading = false;
      loginSuccess = false;
      msg = response.message ?? "";
    }
    notifyListeners();
  }
}
