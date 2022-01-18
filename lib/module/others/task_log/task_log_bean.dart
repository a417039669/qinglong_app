import 'package:json_conversion_annotation/json_conversion_annotation.dart';

/// @author NewTab
@JsonConversion()
class TaskLogBean {
  String? name;
  bool? isDir;
  List<String>? files;

  TaskLogBean({this.name, this.isDir, this.files});

  TaskLogBean.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    isDir = json['isDir'];
    files = json['files'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['isDir'] = this.isDir;
    data['files'] = this.files;
    return data;
  }

  static TaskLogBean jsonConversion(Map<String, dynamic> json) {
    return TaskLogBean.fromJson(json);
  }
}
