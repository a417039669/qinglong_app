import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

class Utils {
  static void hideKeyBoard(BuildContext context) {
    FocusScope.of(context).requestFocus(FocusNode());
  }

  static String formatMessageTime(int time) {
    DateTime current = DateTime.now();
    DateTime chatTime;
    if (time.toString().length == 10) {
      chatTime = DateTime.fromMillisecondsSinceEpoch(time * 1000);
    } else {
      chatTime = DateTime.fromMillisecondsSinceEpoch(time);
    }

    if (current.year == chatTime.year) {
      if (current.day == chatTime.day) {
        if (chatTime.hour <= 12) {
          return DateFormat("上午 H:mm").format(chatTime);
        } else {
          return DateFormat("下午 H:mm").format(chatTime);
        }
      } else if (chatTime.day == current.day - 1) {
        return DateFormat("昨天 H:mm").format(chatTime);
      } else {
        return DateFormat("M/d H:mm").format(chatTime);
      }
    } else {
      return DateFormat("yyyy/M/d HH:mm").format(chatTime);
    }
  }
}
