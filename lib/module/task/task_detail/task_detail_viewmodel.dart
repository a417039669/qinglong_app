import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qinglong_app/base/base_viewmodel.dart';
import 'package:qinglong_app/base/http/api.dart';
import 'package:qinglong_app/base/http/http.dart';
import 'package:qinglong_app/module/task/task_detail/task_detail_bean.dart';

var taskDetailProvider = AutoDisposeChangeNotifierProvider<TaskDetailViewModel>((ref) {
  return TaskDetailViewModel();
});

class TaskDetailViewModel extends BaseViewModel {
  TaskDetailBean? bean;

  TaskDetailViewModel();

  Future<void> loadDetail(String id) async {
    loading(notify: true);

    HttpResponse<TaskDetailBean> response = await Api.taskDetail(id);

    if (response.success) {
      bean = response.bean;
      success();
    } else {
      failed(response.message, notify: true);
    }
  }
}
