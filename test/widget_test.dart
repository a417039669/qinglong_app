// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

void main() {
  String time = "Wed Jan 12 2022 20:33:39 GMT+0800 (中国标准时间)";

  var result = DateTime.tryParse(time);
  print(result);
}
