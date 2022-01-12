import 'package:qinglong_app/utils/sp_utils.dart';

import 'sp_const.dart';

class UserInfoViewModel {
  String? _token;
  String? _host = "";

  static UserInfoViewModel? _userInfoViewModel;

  static UserInfoViewModel getInstance() {
    _userInfoViewModel ??= UserInfoViewModel._();
    return _userInfoViewModel!;
  }

  UserInfoViewModel._() {
    String userInfoJson = SpUtil.getString(sp_UserINfo);
    _host = SpUtil.getString(sp_Host);
    if (userInfoJson.isNotEmpty) {
      _token = userInfoJson;
    }
  }

  void updateToken(String token) {
    _token = token;
    SpUtil.putString(sp_UserINfo, token);
  }

  void updateHost(String host) {
    _host = host;
    SpUtil.putString(sp_Host, host);
  }

  String? get token => _token;

  String? get host => _host;
}
