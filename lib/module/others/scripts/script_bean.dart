import 'package:json_conversion_annotation/json_conversion_annotation.dart';

/// @author NewTab
@JsonConversion()
class ScriptBean {
  String? title;
  String? value;
  String? key;
  double? mtime;
  bool? disabled;
  List<ScriptChildren>? children;

  ScriptBean(
      {this.title,
        this.value,
        this.key,
        this.mtime,
        this.disabled,
        this.children});

  ScriptBean.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    value = json['value'];
    key = json['key'];
    mtime = json['mtime'];
    disabled = json['disabled'];
    if (json['children'] != null) {
      children = <ScriptChildren>[];
      json['children'].forEach((v) {
        children!.add(new ScriptChildren.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['value'] = this.value;
    data['key'] = this.key;
    data['mtime'] = this.mtime;
    data['disabled'] = this.disabled;
    if (this.children != null) {
      data['children'] = this.children!.map((v) => v.toJson()).toList();
    }
    return data;
  }
  static ScriptBean jsonConversion(Map<String, dynamic> json) {
    return ScriptBean.fromJson(json);
  }

}

class ScriptChildren {
  String? title;
  String? value;
  String? key;
  double? mtime;
  String? parent;

  ScriptChildren({this.title, this.value, this.key, this.mtime, this.parent});

  ScriptChildren.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    value = json['value'];
    key = json['key'];
    mtime = json['mtime'];
    parent = json['parent'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['value'] = this.value;
    data['key'] = this.key;
    data['mtime'] = this.mtime;
    data['parent'] = this.parent;
    return data;
  }
}
