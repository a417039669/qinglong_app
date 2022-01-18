import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qinglong_app/module/config/config_edit_page.dart';
import 'package:qinglong_app/module/env/add_env_page.dart';
import 'package:qinglong_app/module/env/env_bean.dart';
import 'package:qinglong_app/module/home/home_page.dart';
import 'package:qinglong_app/module/login/login_page.dart';
import 'package:qinglong_app/module/others/login_log/login_log_page.dart';
import 'package:qinglong_app/module/others/scripts/script_detail_page.dart';
import 'package:qinglong_app/module/others/scripts/script_page.dart';
import 'package:qinglong_app/module/others/task_log/task_log_detail_page.dart';
import 'package:qinglong_app/module/others/task_log/task_log_page.dart';
import 'package:qinglong_app/module/task/add_task_page.dart';
import 'package:qinglong_app/module/task/task_bean.dart';

class Routes {
  static const String routeHomePage = "/home/homepage";
  static const String routeLogin = "/login";
  static const String routeAddTask = "/task/add";
  static const String routeAddEnv = "/env/add";
  static const String routeConfigEdit = "/config/edit";
  static const String routeLoginLog = "/log/login";
  static const String routeTaskLog = "/log/task";
  static const String routeTaskLogDetail = "/log/taskDetail";
  static const String routeScript = "/script";
  static const String routeScriptDetail = "/script/detail";

  static Route<dynamic>? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case routeHomePage:
        return MaterialPageRoute(builder: (context) => const HomePage());
      case routeLogin:
        return MaterialPageRoute(builder: (context) => const LoginPage());
      case routeAddTask:
        if (settings.arguments != null) {
          return CupertinoPageRoute(
              builder: (context) => AddTaskPage(
                    taskBean: settings.arguments as TaskBean,
                  ));
        } else {
          return CupertinoPageRoute(builder: (context) => const AddTaskPage());
        }
      case routeAddEnv:
        if (settings.arguments != null) {
          return CupertinoPageRoute(
              builder: (context) => AddEnvPage(
                    taskBean: settings.arguments as EnvBean,
                  ));
        } else {
          return CupertinoPageRoute(builder: (context) => const AddEnvPage());
        }
      case routeConfigEdit:
        return CupertinoPageRoute(
          builder: (context) => ConfigEditPage(
            (settings.arguments as Map)["title"],
            (settings.arguments as Map)["content"],
          ),
        );
      case routeLoginLog:
        return CupertinoPageRoute(
          builder: (context) => const LoginLogPage(),
        );
      case routeTaskLog:
        return CupertinoPageRoute(
          builder: (context) => const TaskLogPage(),
        );
      case routeScript:
        return CupertinoPageRoute(
          builder: (context) => const ScriptPage(),
        );
      case routeTaskLogDetail:
        return CupertinoPageRoute(
          builder: (context) => TaskLogDetailPage(
            title: settings.arguments as String,
          ),
        );
      case routeScriptDetail:
        return CupertinoPageRoute(
          builder: (context) => ScriptDetailPage(
            title: (settings.arguments as Map)["title"],
            path: (settings.arguments as Map)["path"],
          ),
        );
    }

    return null;
  }
}
