import 'package:json_conversion_annotation/json_conversion_annotation.dart';

@JsonConversion()
class EnvBean {
  String? value;
  String? sId;
  int? created;
  int? status;
  String? timestamp;
  String? name;
  String? remarks;

  EnvBean({this.value, this.sId, this.created, this.status, this.timestamp, this.name, this.remarks});

  EnvBean.fromJson(Map<String, dynamic> json) {
    value = json['value'];
    sId = json.containsKey('_id') ? json['_id'].toString() : (json.containsKey('id') ? json['id'].toString() : "");
    created = int.tryParse(json['created'].toString());
    status = json['status'];
    timestamp = json['timestamp'];
    name = json['name'];
    remarks = json['remarks'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['value'] = this.value;
    data['_id'] = this.sId;
    data['created'] = this.created;
    data['status'] = this.status;
    data['timestamp'] = this.timestamp;
    data['name'] = this.name;
    data['remarks'] = this.remarks;
    return data;
  }

  static EnvBean jsonConversion(Map<String, dynamic> json) {
    return EnvBean.fromJson(json);
  }
}
