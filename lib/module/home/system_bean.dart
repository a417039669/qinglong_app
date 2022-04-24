
import 'package:json_conversion_annotation/json_conversion_annotation.dart';

@JsonConversion()
class SystemBean {
  String? version;

  SystemBean({this.version});

  SystemBean.fromJson(Map<String, dynamic> json) {
    version = json['version'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['version'] = this.version;
    return data;
  }

  static SystemBean jsonConversion(Map<String, dynamic> json) {
    return SystemBean.fromJson(json);
  }
}