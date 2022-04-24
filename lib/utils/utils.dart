import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

import '../module/home/system_bean.dart';

class Utils {
  static final SystemBean systemBean = SystemBean();

  static bool isUpperVersion() {
    try {
      List<String>? version = Utils.systemBean.version?.split("\.");

      String f = version?[0] ?? "2";
      String s = version?[1] ?? "10";
      String t = version?[2] ?? "0";

      int first = int.parse(f);
      int second = int.parse(s);
      int third = int.parse(t);

      /// 2.10.13 及以下版本

      if (first > 2) {
        return true;
      }
      if (second > 10) {
        return true;
      }
      if (third > 13) {
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  static void hideKeyBoard(BuildContext context) {
    FocusScope.of(context).requestFocus(FocusNode());
  }

  static String formatGMTTime(String gmtTime) {
    // "Wed Jan 12 2022 20:33:39 GMT+0800 (中国标准时间)"
    try {
      if (gmtTime.isEmpty) return "-";
      List<String> splitedStr = gmtTime.split(" ");

      int year = int.parse(splitedStr[3]);
      String time = splitedStr[4];
      List<String> splitedTime = time.split(":");
      int hour = int.parse(splitedTime[0]);
      int min = int.parse(splitedTime[1]);
      int second = int.parse(splitedTime[2]);

      int day = int.parse(splitedStr[2]);

      String month = "01";

      switch (splitedStr[1]) {
        case "Jan":
          month = "01";
          break;
        case "Feb":
          month = "02";
          break;
        case "Mar":
          month = "03";
          break;
        case "Apr":
          month = "04";
          break;
        case "May":
          month = "05";
          break;
        case "Jun":
          month = "06";
          break;
        case "Jul":
          month = "07";
          break;
        case "Aug":
          month = "08";
          break;
        case "Sep":
          month = "09";
          break;
        case "Oct":
          month = "10";
          break;
        case "Nov":
          month = "11";
          break;
        case "Dec":
          month = "12";
          break;
      }

      var date = DateTime(year, int.parse(month), day, hour, min, second);

      return formatMessageTime(date.millisecondsSinceEpoch);
    } catch (e) {
      return "-";
    }
  }

  static String formatMessageTime(int time) {
    if (time == 0) {
      return "-";
    }
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
