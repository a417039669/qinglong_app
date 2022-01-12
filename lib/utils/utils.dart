import 'package:flutter/cupertino.dart';

class Utils {
  static void hideKeyBoard(BuildContext context) {
    FocusScope.of(context).requestFocus(FocusNode());
  }
}
