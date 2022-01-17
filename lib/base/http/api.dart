import 'dart:ffi';

import 'package:qinglong_app/base/http/http.dart';
import 'package:qinglong_app/module/config/config_bean.dart';
import 'package:qinglong_app/module/env/env_bean.dart';
import 'package:qinglong_app/module/login/login_bean.dart';
import 'package:qinglong_app/module/task/task_bean.dart';
import 'package:qinglong_app/module/task/task_detail/task_detail_bean.dart';

import 'url.dart';

class Api {
  static Future<HttpResponse<LoginBean>> login(String userName, String passWord) async {
    return await Http.post<LoginBean>(
      Url.LOGIN,
      {
        "username": userName,
        "password": passWord,
      },
    );
  }

  static Future<HttpResponse<List<TaskBean>>> crons() async {
    return await Http.get<List<TaskBean>>(Url.TASKS, {"searchValue": ""});
  }

  static Future<HttpResponse<NullResponse>> startTasks(List<String> crons) async {
    return await Http.put<NullResponse>(Url.RUN_TASKS, crons);
  }

  static Future<HttpResponse<NullResponse>> stopTasks(List<String> crons) async {
    return await Http.put<NullResponse>(Url.RUN_TASKS, crons);
  }

  static Future<HttpResponse<String>> inTimeLog(String cron) async {
    return await Http.get<String>(Url.INTIME_LOG(cron), null);
  }

  static Future<HttpResponse<TaskDetailBean>> taskDetail(String cron) async {
    return await Http.get<TaskDetailBean>(Url.TASK_DETAIL + cron, null);
  }

  static Future<HttpResponse<TaskDetailBean>> addTask(String name, String command, String cron, {String? id}) async {
    var data = {"name": name, "command": command, "schedule": cron};

    if (id != null) {
      data["_id"] = id;
      return await Http.put<TaskDetailBean>(Url.ADD_TASK, data);
    }
    return await Http.post<TaskDetailBean>(Url.ADD_TASK, data);
  }

  static Future<HttpResponse<NullResponse>> delTask(String cron) async {
    return await Http.delete<NullResponse>(Url.ADD_TASK, [cron]);
  }

  static Future<HttpResponse<NullResponse>> pinTask(String cron) async {
    return await Http.put<NullResponse>(Url.PIN_TASK, [cron]);
  }

  static Future<HttpResponse<NullResponse>> unpinTask(String cron) async {
    return await Http.put<NullResponse>(Url.UNPIN_TASK, [cron]);
  }

  static Future<HttpResponse<NullResponse>> enableTask(String cron) async {
    return await Http.put<NullResponse>(Url.ENABLE_TASK, [cron]);
  }

  static Future<HttpResponse<NullResponse>> disableTask(String cron) async {
    return await Http.put<NullResponse>(Url.DISABLE_TASK, [cron]);
  }

  static Future<HttpResponse<List<ConfigBean>>> files() async {
    return await Http.get<List<ConfigBean>>(Url.FILES, null);
  }

  static Future<HttpResponse<String>> content(String name) async {
    return await Http.get<String>(Url.CONFIG_CONTENT + name, null);
  }

  static Future<HttpResponse<NullResponse>> saveFile(String name, String content) async {
    return await Http.post<NullResponse>(Url.SAVE_FILE, {"content": content, "name": name});
  }

  static Future<HttpResponse<List<EnvBean>>> envs(String search) async {
    return await Http.get<List<EnvBean>>(Url.ENVS, {"searchValue": search});
  }

  static Future<HttpResponse<NullResponse>> enableEnv(String id) async {
    return await Http.put<NullResponse>(Url.ENABLE_ENVS, [id]);
  }

  static Future<HttpResponse<NullResponse>> disableEnv(String id) async {
    return await Http.put<NullResponse>(Url.DISABLE_ENVS, [id]);
  }

  static Future<HttpResponse<NullResponse>> delEnv(String id) async {
    return await Http.delete<NullResponse>(Url.DEL_ENV, [id]);
  }

  static Future<HttpResponse<NullResponse>> addEnv(String name, String value, String remarks, {String? id}) async {
    var data = {"value": value, "remarks": remarks, "name": name};

    if (id != null) {
      data["_id"] = id;
      return await Http.put<NullResponse>(Url.ADD_ENV, data);
    }
    return await Http.post<NullResponse>(Url.ADD_ENV, [data]);
  }
}
