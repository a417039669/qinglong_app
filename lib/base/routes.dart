import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qinglong_app/module/config/config_edit_page.dart';
import 'package:qinglong_app/module/env/add_env_page.dart';
import 'package:qinglong_app/module/env/env_bean.dart';
import 'package:qinglong_app/module/home/home_page.dart';
import 'package:qinglong_app/module/login/login_page.dart';
import 'package:qinglong_app/module/task/add_task_page.dart';
import 'package:qinglong_app/module/task/task_bean.dart';

class Routes {
  static const String route_HomePage = "/home/homepage";
  static const String route_LOGIN = "/login";
  static const String route_AddTask = "/task/add";
  static const String route_AddEnv = "/env/add";
  static const String route_ConfigEdit = "/config/edit";

  static Route<dynamic>? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case route_HomePage:
        return MaterialPageRoute(builder: (context) => const HomePage());
      case route_LOGIN:
        return MaterialPageRoute(builder: (context) => const LoginPage());
      case route_AddTask:
        if (settings.arguments != null) {
          return CupertinoPageRoute(
              builder: (context) => AddTaskPage(
                    taskBean: settings.arguments as TaskBean,
                  ));
        } else {
          return CupertinoPageRoute(builder: (context) => const AddTaskPage());
        }
      case route_AddEnv:
        if (settings.arguments != null) {
          return CupertinoPageRoute(
              builder: (context) => AddEnvPage(
                    taskBean: settings.arguments as EnvBean,
                  ));
        } else {
          return CupertinoPageRoute(builder: (context) => const AddEnvPage());
        }
      case route_ConfigEdit:
        return CupertinoPageRoute(
          builder: (context) => ConfigEditPage(
            (settings.arguments as Map)["title"],
            (settings.arguments as Map)["content"],
          ),
        );
    }

    return null;
  }
}
