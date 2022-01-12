import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qinglong_app/base/base_viewmodel.dart';

var loginProvider = ChangeNotifierProvider((ref) => LoginViewModel());

class LoginViewModel extends ViewModel {
  bool loginSuccess = false;
  bool isLoading = false;

  void login(String userName, String password) {
    isLoading = true;
    notifyListeners();
    Future.delayed(Duration(seconds: 2), () {
      isLoading = false;
      loginSuccess = true;
      notifyListeners();
    });
  }
}
