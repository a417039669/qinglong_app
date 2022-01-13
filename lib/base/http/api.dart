import 'package:qinglong_app/base/http/http.dart';
import 'package:qinglong_app/module/login/login_bean.dart';
import 'package:qinglong_app/module/task/task_bean.dart';

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
}
