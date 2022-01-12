import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qinglong_app/module/home/home_page.dart';

class Routes {
  static const String route_HomePage = "/home/homepage";

  static Route<dynamic>? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case route_HomePage:
        return CupertinoPageRoute(builder: (context) => const HomePage());
    }

    return null;
  }
}
