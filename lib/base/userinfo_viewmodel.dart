import 'dart:convert';

import 'package:qinglong_app/utils/extension.dart';
import 'package:qinglong_app/utils/sp_utils.dart';

import '../main.dart';
import 'sp_const.dart';
import 'theme.dart';

class UserInfoViewModel {
  int _primaryColor = commonColor.value;
  String? _token;
  String? _host = "";
  String? _userName;
  String? _passWord;
  bool _useSecertLogined = false;

  List<UserInfoBean> historyAccounts = [];

  UserInfoViewModel() {
    _token = SpUtil.getString(spUserInfo);
    _userName = SpUtil.getString(spUserName);
    _passWord = SpUtil.getString(spPassWord);
    _primaryColor = SpUtil.getInt(spCustomColor, defValue: commonColor.value);

    _useSecertLogined = SpUtil.getBool(spSecretLogined, defValue: false);
    _host = SpUtil.getString(spHost, defValue: '');

    List<dynamic>? tempList =
        jsonDecode(SpUtil.getString(spLoginHistory, defValue: '[]'));

    if (tempList != null && tempList.isNotEmpty) {
      for (Map<String, dynamic> value in tempList) {
        historyAccounts.add(UserInfoBean.fromJson(value));
      }
    }
  }

  void updateToken(String token) {
    _token = token;
    SpUtil.putString(spUserInfo, token);
  }

  void updateUserName(
      String host, String userName, String password, bool secretLogin) {
    updateHost(host);
    _useSecretLogin(secretLogin);
    _userName = userName;
    _passWord = password;
    SpUtil.putString(spUserName, userName);
    SpUtil.putString(spPassWord, password);

    save2HistoryAccount();
  }

  void _useSecretLogin(bool use) {
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

  void save2HistoryAccount() {
    if (_host == null || _host!.isEmpty) return;
    if (_userName == null || _userName!.isEmpty) return;
    if (_passWord == null || _passWord!.isEmpty) return;

    //如果已经存在host，那就更新

    "login success $_host $userName $passWord".log();

    historyAccounts.removeWhere((element) => element.host == _host);

    historyAccounts.insert(
        0,
        UserInfoBean(
            userName: _userName,
            password: _passWord,
            useSecretLogined: _useSecertLogined,
            host: _host));

    SpUtil.putString(spLoginHistory, jsonEncode(historyAccounts));
  }

  void removeHistoryAccount(String? host) {
    if (host == null || host.isEmpty) return;

    historyAccounts.removeWhere((element) => element.host == host);

    SpUtil.putString(spLoginHistory, jsonEncode(historyAccounts));
  }
}

class UserInfoBean {
  String? userName;
  String? password;
  bool useSecretLogined = false;
  String? host;

  UserInfoBean(
      {this.userName, this.password, this.useSecretLogined = false, this.host});

  UserInfoBean.fromJson(Map<String, dynamic> json) {
    userName = json['userName'];
    password = json['password'];
    useSecretLogined = json['useSecretLogined'] ?? false;
    host = json['host'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userName'] = this.userName;
    data['password'] = this.password;
    data['useSecretLogined'] = this.useSecretLogined;
    data['host'] = this.host;
    return data;
  }
}
