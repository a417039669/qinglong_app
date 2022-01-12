import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qinglong_app/base/base_viewmodel.dart';

var taskProvider = ChangeNotifierProvider((ref) => TaskViewModel());

class TaskViewModel extends BaseViewModel {
  List<String> list = [];

  void loadData() {
    loading(notify: true);

    Future.delayed(Duration(seconds: 2), () {
      list.add("sdfsf");
      list.add("sdfsf");
      list.add("sdfsf");
      list.add("sdfsf");
      list.add("sdfsf");
      list.add("sdfsf");
      list.add("sdfsf");
      list.add("sdfsf");
      list.add("sdfsf");
      list.add("sdfsf");
      list.add("sdfsf");
      list.add("sdfsf");
      list.add("sdfsf");
      list.add("sdfsf");
      list.add("sdfsf");
      success();
    });
  }
}
