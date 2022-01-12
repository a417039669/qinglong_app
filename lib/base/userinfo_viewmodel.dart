import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qinglong_app/base/base_viewmodel.dart';
import 'package:qinglong_app/utils/sp_utils.dart';

import 'sp_const.dart';

var userInfoProvider = ChangeNotifierProvider((ref) => UserInfoViewModel());

class UserInfoViewModel extends ViewModel {
  UserInfoBean? _userInfoBean;

  UserInfoViewModel() {
    String userInfoJson = SpUtil.getString(sp_UserINfo);
    if (userInfoJson.isNotEmpty) {
      _userInfoBean = UserInfoBean.fromJson(jsonDecode(userInfoJson));
    }
  }

  void updateUserInfoBean(UserInfoBean userInfoBean) {
    _userInfoBean = userInfoBean;
    SpUtil.putString(sp_UserINfo, jsonEncode(userInfoBean));
  }

  UserInfoBean? get userInfoBean => _userInfoBean;
}

class UserInfoBean {
  String? name;
  int? age;

  UserInfoBean({this.name, this.age});

  UserInfoBean.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    age = json['age'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['age'] = this.age;
    return data;
  }
}
