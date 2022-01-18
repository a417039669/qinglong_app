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
  static const String routeHomePage = "/home/homepage";
  static const String routeLogin = "/login";
  static const String routeAddTask = "/task/add";
  static const String routeAddEnv = "/env/add";
  static const String routeConfigEdit = "/config/edit";

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
    }

    return null;
  }
}
