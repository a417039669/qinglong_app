import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qinglong_app/module/home/home_page.dart';
import 'package:qinglong_app/module/task/add_task_page.dart';
import 'package:qinglong_app/module/task/task_bean.dart';

class Routes {
  static const String route_HomePage = "/home/homepage";
  static const String route_AddTask = "/task/add";

  static Route<dynamic>? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case route_HomePage:
        return MaterialPageRoute(builder: (context) => const HomePage());
      case route_AddTask:
        if (settings.arguments != null) {
          return CupertinoPageRoute(
              builder: (context) => AddTaskPage(
                    taskBean: settings.arguments as TaskBean,
                  ));
        } else {
          return CupertinoPageRoute(builder: (context) => AddTaskPage());
        }
    }

    return null;
  }
}
