import 'package:json_conversion_annotation/json_conversion_annotation.dart';

@JsonConversion()
class TaskDetailBean {
  String? name;
  String? command;
  String? schedule;
  bool? saved;
  String? sId;
  int? created;
  int? status;
  String? timestamp;
  int? isSystem;
  int? isDisabled;
  String? logPath;
  int? isPinned;

  TaskDetailBean(
      {this.name,
        this.command,
        this.schedule,
        this.saved,
        this.sId,
        this.created,
        this.status,
        this.timestamp,
        this.isSystem,
        this.isDisabled,
        this.logPath,
        this.isPinned});

  TaskDetailBean.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    command = json['command'];
    schedule = json['schedule'];
    saved = json['saved'];
    sId = json['_id'];
    created = json['created'];
    status = json['status'];
    timestamp = json['timestamp'];
    isSystem = json['isSystem'];
    isDisabled = json['isDisabled'];
    logPath = json['log_path'];
    isPinned = json['isPinned'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['command'] = this.command;
    data['schedule'] = this.schedule;
    data['saved'] = this.saved;
    data['_id'] = this.sId;
    data['created'] = this.created;
    data['status'] = this.status;
    data['timestamp'] = this.timestamp;
    data['isSystem'] = this.isSystem;
    data['isDisabled'] = this.isDisabled;
    data['log_path'] = this.logPath;
    data['isPinned'] = this.isPinned;
    return data;
  }
}
