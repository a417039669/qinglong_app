import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qinglong_app/utils/qinglong_theme.dart';

var themeProvider = ChangeNotifierProvider((ref) => ThemeViewModel());
const Color _primaryColor = Color(0xFF299343);

class ThemeViewModel extends ChangeNotifier {
  ThemeData currentTheme = lightTheme;

  ThemeColors themeColor = LightartThemeColors();

  void changeTheme() {
    if (currentTheme == darkTheme) {
      currentTheme = lightTheme;
      themeColor = LightartThemeColors();
    } else {
      currentTheme = darkTheme;
      themeColor = DartThemeColors();
    }
    notifyListeners();
  }
}

ThemeData darkTheme = ThemeData.dark().copyWith(
  primaryColor: const Color(0xffffffff),
);
ThemeData lightTheme = ThemeData.light().copyWith(
  primaryColor: _primaryColor,
  scaffoldBackgroundColor: Colors.white,
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
      fontSize: 16,
    ),
    unselectedLabelStyle: TextStyle(
      fontSize: 16,
    ),
    labelColor: _primaryColor,
    unselectedLabelColor:  Color(0xff999999),
    indicator: UnderlineTabIndicator(
      borderSide: BorderSide(color: _primaryColor),
    ),
  ),
);

abstract class ThemeColors {
  Color taskTitleColor();

  Color searchBarBg();

  Color pinColor();

  Map<String, TextStyle> codeEditorTheme();
}

class LightartThemeColors extends ThemeColors {
  @override
  Color taskTitleColor() {
    return Color(0xff333333);
  }

  @override
  Color searchBarBg() {
    return const Color(0xffF7F7F7);
  }

  @override
  Color pinColor() {
    return const Color(0xffF7F7F7);
  }

  @override
  Map<String, TextStyle> codeEditorTheme() {
    return qinglongLightTheme;
  }
}

class DartThemeColors extends ThemeColors {
  @override
  Color taskTitleColor() {
    return Colors.white;
  }

  @override
  Color searchBarBg() {
    return const Color(0xff2E312E);
  }

  @override
  Color pinColor() {
    return Colors.black12;
  }

  @override
  Map<String, TextStyle> codeEditorTheme() {
    return qinglongDarkTheme;
  }
}
