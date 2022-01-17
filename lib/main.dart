import 'dart:io';

import 'package:dio_log/overlay_draggable_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:qinglong_app/base/theme.dart';
import 'package:qinglong_app/module/login/login_page.dart';
import 'package:qinglong_app/utils/QlNavigatorObserver.dart';
import 'package:qinglong_app/utils/sp_utils.dart';

import 'base/routes.dart';
import 'base/userinfo_viewmodel.dart';
import 'module/home/home_page.dart';

final getIt = GetIt.instance;
var navigatorState = GlobalKey<NavigatorState>();

var logger = Logger();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SpUtil.getInstance();
  getIt.registerSingleton<UserInfoViewModel>(UserInfoViewModel());
  getIt.registerSingleton<QlNavigatorObserver>(QlNavigatorObserver());

  runApp(
    ProviderScope(
      overrides: [
        themeProvider,
      ],
      child: const MyApp(),
    ),
  );
  if (Platform.isAndroid) {
    SystemUiOverlayStyle style = const SystemUiOverlayStyle(statusBarColor: Colors.transparent);
    SystemChrome.setSystemUIOverlayStyle(style);
  }
}

class MyApp extends ConsumerWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: MaterialApp(
        navigatorObservers: [getIt<QlNavigatorObserver>()],
        navigatorKey: navigatorState,
        theme: ref.watch<ThemeViewModel>(themeProvider).currentTheme,
        onGenerateRoute: (setting) {
          return Routes.generateRoute(setting);
        },
        home: Builder(
          builder: (context) {
            showDebugBtn(context, btnColor: Colors.blue);
            return getIt<UserInfoViewModel>().isLogined() ? const HomePage() : LoginPage();
          },
        ),
        // home: LoginPage(),
      ),
    );
  }
}
