import 'package:qinglong_app/utils/sp_utils.dart';

import 'sp_const.dart';
import 'theme.dart';

class UserInfoViewModel {
  String? _token;
  String? _host = "";
  String? _userName;
  String? _passWord;
  bool _useSecertLogined = false;
  int _primaryColor = commonColor.value;

  UserInfoViewModel() {
    String userInfoJson = SpUtil.getString(spUserInfo);
    _userName = SpUtil.getString(spUserName);
    _passWord = SpUtil.getString(spPassWord);
    _primaryColor = SpUtil.getInt(spCustomColor, defValue: commonColor.value);

    _useSecertLogined = SpUtil.getBool(spSecretLogined, defValue: false);
    _host = SpUtil.getString(spHost, defValue: '');

    if (userInfoJson.isNotEmpty) {
      _token = userInfoJson;
    }
  }

  void updateToken(String token) {
    _token = token;
    SpUtil.putString(spUserInfo, token);
  }

  void updateUserName(String userName, String password) {
    _userName = userName;
    _passWord = password;
    SpUtil.putString(spUserName, userName);
    SpUtil.putString(spPassWord, password);
  }

  void useSecretLogin(bool use) {
    _useSecertLogined = use;
    SpUtil.putBool(spSecretLogined, _useSecertLogined);
  }

  void updateCustomColor(int color) {
    _primaryColor = color;
    SpUtil.putInt(spCustomColor, color);
  }

  void updateHost(String host) {
    _host = host;
    SpUtil.putString(spHost, host);
  }

  String? get token => _token;

  String? get host => _host;

  String? get userName => _userName;

  String? get passWord => _passWord;

  bool get useSecretLogined => _useSecertLogined;

  int get primaryColor => _primaryColor;

  bool isLogined() {
    return token != null && token!.isNotEmpty;
  }
}
