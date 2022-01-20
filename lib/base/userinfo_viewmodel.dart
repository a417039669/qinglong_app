import 'package:qinglong_app/utils/sp_utils.dart';

import 'sp_const.dart';

class UserInfoViewModel {
  String? _token;
  String? _host = "";
  String? _userName;
  String? _passWord;
  bool _useSecertLogined = false;

  UserInfoViewModel() {
    String userInfoJson = SpUtil.getString(spUserInfo);
    _userName = SpUtil.getString(spUserName);
    _passWord = SpUtil.getString(spPassWord);

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

  void updateHost(String host) {
    _host = host;
    SpUtil.putString(spHost, host);
  }

  String? get token => _token;

  String? get host => _host;

  String? get userName => _userName;

  String? get passWord => _passWord;

  bool get useSecretLogined => _useSecertLogined;

  bool isLogined() {
    return token != null && token!.isNotEmpty;
  }
}
