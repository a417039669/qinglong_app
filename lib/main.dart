import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qinglong_app/base/theme.dart';
import 'package:qinglong_app/module/login/login_page.dart';

import 'base/routes.dart';
import 'base/userinfo_viewmodel.dart';
import 'module/home/home_page.dart';

void main() {
  runApp(
    ProviderScope(
      overrides: [
        themeProvider,
        userInfoProvider,
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
      onTap: (){
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: MaterialApp(
        theme: ref.watch<ThemeViewModel>(themeProvider).currentTheme,
        onGenerateRoute: (setting) {
          return Routes.generateRoute(setting);
        },
        home: ref.read<UserInfoViewModel>(userInfoProvider).userInfoBean != null ? const HomePage() : LoginPage(),
      ),
    );
  }
}
