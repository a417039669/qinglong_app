import 'package:qinglong_app/utils/sp_utils.dart';

import 'sp_const.dart';

class UserInfoViewModel {
  String? _token;
  String? _host = "";

  UserInfoViewModel() {
    String userInfoJson = SpUtil.getString(sp_UserINfo);
    _host = SpUtil.getString(sp_Host, defValue: "http://49.234.59.95:5700");
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

  bool isLogined() {
    return token != null && token!.isNotEmpty;
  }
}
