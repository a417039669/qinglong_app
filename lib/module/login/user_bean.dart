import 'package:json_conversion_annotation/json_conversion_annotation.dart';

/// @author NewTab
@JsonConversion()
class UserBean {
  String? username;
  bool? twoFactorActivated;

  UserBean({this.username, this.twoFactorActivated});

  UserBean.fromJson(Map<String, dynamic> json) {
    username = json['username'];
    twoFactorActivated = json['twoFactorActivated'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['username'] = this.username;
    data['twoFactorActivated'] = this.twoFactorActivated;
    return data;
  }
  static UserBean jsonConversion(Map<String, dynamic> json) {
    return UserBean.fromJson(json);
  }
}
