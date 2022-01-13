import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

var themeProvider = ChangeNotifierProvider((ref) => ThemeViewModel());

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
  primaryColor: Color(0xffffffff),
);
ThemeData lightTheme = ThemeData.light().copyWith(
  primaryColor: Color(0xFF0F77FE),
);

abstract class ThemeColors {
  Color taskTitleColor();
}

class LightartThemeColors extends ThemeColors {
  @override
  Color taskTitleColor() {
    return Color(0xff333333);
  }
}

class DartThemeColors extends ThemeColors {
  @override
  Color taskTitleColor() {
    return Colors.white;
  }
}
