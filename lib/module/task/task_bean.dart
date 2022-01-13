import 'dart:convert';

import 'package:json_conversion_annotation/json_conversion_annotation.dart';

@JsonConversion()
class TaskBean {
  String? name;
  String? command;
  String? schedule;
  bool? saved;
  String? sId;
  num? created;
  int? status;
  String? timestamp;
  int? isSystem;
  int? isDisabled;
  String? logPath;
  int? isPinned;
  int? lastExecutionTime;
  int? lastRunningTime;
  String? pid;

  TaskBean(
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
      this.isPinned,
      this.lastExecutionTime,
      this.lastRunningTime,
      this.pid});

  TaskBean.fromJson(Map<String, dynamic> json) {
    try {
      name = json['name'].toString();
      command = json['command'].toString();
      schedule = json['schedule'].toString();
      saved = json['saved'];
      sId = json['_id'].toString();
      created = json['created'];
      status = json['status'];
      timestamp = json['timestamp'].toString();
      isSystem = json['isSystem'];
      isDisabled = json['isDisabled'];
      logPath = json['log_path'].toString();
      isPinned = json['isPinned'];
      lastExecutionTime = json['last_execution_time'];
      lastRunningTime = json['last_running_time'];
      pid = json['pid'].toString();
    } catch (e) {
      print(jsonEncode(json));
      print(e);
    }
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
    data['last_execution_time'] = this.lastExecutionTime;
    data['last_running_time'] = this.lastRunningTime;
    data['pid'] = this.pid;
    return data;
  }

  static TaskBean jsonConversion(Map<String, dynamic> json) {
    return TaskBean.fromJson(json);
  }
}
