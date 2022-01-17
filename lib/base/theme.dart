import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qinglong_app/base/sp_const.dart';
import 'package:qinglong_app/utils/codeeditor_theme.dart';
import 'package:qinglong_app/utils/sp_utils.dart';

var themeProvider = ChangeNotifierProvider((ref) => ThemeViewModel());
const Color _primaryColor = Color(0xFF299343);

class ThemeViewModel extends ChangeNotifier {
  ThemeData currentTheme = lightTheme;

  ThemeColors themeColor = LightThemeColors();

  ThemeViewModel() {
    var brightness = SchedulerBinding.instance!.window.platformBrightness;
    bool isDarkMode = brightness == Brightness.dark;
    changeThemeReal(isDarkMode, false);
  }

  bool isInDartMode() {
    return SpUtil.getBool(sp_Theme, defValue: false);
  }

  void changeThemeReal(bool dark, [bool notify = true]) {
    SpUtil.putBool(sp_Theme, dark);
    if (!dark) {
      currentTheme = lightTheme;
      themeColor = LightThemeColors();
    } else {
      currentTheme = darkTheme;
      themeColor = DartThemeColors();
    }
    if (notify) {
      notifyListeners();
    }
  }

  void changeTheme() {
    changeThemeReal(!SpUtil.getBool(sp_Theme, defValue: false), true);
  }
}

ThemeData darkTheme = ThemeData.dark().copyWith(
  brightness: Brightness.dark,
  primaryColor: const Color(0xffffffff),
  scaffoldBackgroundColor: Colors.black,
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.black,
    titleTextStyle: TextStyle(
      color: Colors.white,
      fontSize: 18,
    ),
  ),
  inputDecorationTheme: const InputDecorationTheme(
    labelStyle: TextStyle(color: _primaryColor),
    focusedBorder: UnderlineInputBorder(
      borderSide: BorderSide(
        color: _primaryColor,
      ),
    ),
  ),
  tabBarTheme: const TabBarTheme(
    labelStyle: TextStyle(
      fontSize: 14,
    ),
    unselectedLabelStyle: TextStyle(
      fontSize: 14,
    ),
    labelColor: Color(0xffffffff),
    unselectedLabelColor: Color(0xff999999),
  ),
  colorScheme: const ColorScheme.light(
    secondary: _primaryColor,
    primary: _primaryColor,
  ),
);
ThemeData lightTheme = ThemeData.light().copyWith(
  brightness: Brightness.light,
  primaryColor: _primaryColor,
  colorScheme: const ColorScheme.light(
    secondary: _primaryColor,
    primary: _primaryColor,
  ),
  scaffoldBackgroundColor: const Color(0xfff5f5f5),
  inputDecorationTheme: const InputDecorationTheme(
    labelStyle: TextStyle(color: _primaryColor),
    focusedBorder: UnderlineInputBorder(
      borderSide: BorderSide(
        color: _primaryColor,
      ),
    ),
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: _primaryColor,
    titleTextStyle: TextStyle(
      color: Colors.white,
      fontSize: 18,
    ),
  ),
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    selectedItemColor: _primaryColor,
  ),
  buttonTheme: const ButtonThemeData(
    buttonColor: _primaryColor,
  ),
  progressIndicatorTheme: const ProgressIndicatorThemeData(
    color: _primaryColor,
  ),
  tabBarTheme: const TabBarTheme(
    labelStyle: TextStyle(
      fontSize: 14,
    ),
    unselectedLabelStyle: TextStyle(
      fontSize: 14,
    ),
    labelColor: _primaryColor,
    unselectedLabelColor: Color(0xff999999),
    indicator: UnderlineTabIndicator(
      borderSide: BorderSide(color: _primaryColor),
    ),
  ),
);

abstract class ThemeColors {
  Color settingBgColor();

  Color taskTitleColor();

  Color descColor();

  Color pinColor();

  Color buttonBgColor();

  Map<String, TextStyle> codeEditorTheme();
}

class LightThemeColors extends ThemeColors {
  @override
  Color taskTitleColor() {
    return const Color(0xff333333);
  }

  @override
  Color pinColor() {
    return const Color(0xffF7F7F7);
  }

  @override
  Map<String, TextStyle> codeEditorTheme() {
    return qinglongLightTheme;
  }

  @override
  Color descColor() {
    return const Color(0xff999999);
  }

  @override
  Color settingBgColor() {
    return Colors.white;
  }

  @override
  Color buttonBgColor() {
    return _primaryColor;
  }
}

class DartThemeColors extends ThemeColors {
  @override
  Color taskTitleColor() {
    return Colors.white;
  }

  @override
  Color pinColor() {
    return Colors.black12;
  }

  @override
  Map<String, TextStyle> codeEditorTheme() {
    return qinglongDarkTheme;
  }

  @override
  Color descColor() {
    return const Color(0xff999999);
  }

  @override
  Color settingBgColor() {
    return Colors.black;
  }

  @override
  Color buttonBgColor() {
    return const Color(0xff333333);
  }
}
