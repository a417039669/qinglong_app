import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

var themeProvider = ChangeNotifierProvider((ref) => ThemeViewModel());

class ThemeViewModel extends ChangeNotifier {
  ThemeData currentTheme = lightTheme;

  void changeTheme() {
    if (currentTheme == darkTheme) {
      currentTheme = lightTheme;
    } else {
      currentTheme = darkTheme;
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
