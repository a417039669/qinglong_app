import 'package:flutter/cupertino.dart';
import 'package:qinglong_app/base/routes.dart';

class QlNavigatorObserver extends NavigatorObserver {
  bool isInLoginPage = false;

  @override
  void didPush(Route route, Route? previousRoute) {
    super.didPush(route, previousRoute);
    if (Routes.route_LOGIN == route.settings.name) {
      isInLoginPage = true;
    } else {
      isInLoginPage = false;
    }
  }
}
