import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qinglong_app/base/base_viewmodel.dart';
import 'package:qinglong_app/base/http/api.dart';
import 'package:qinglong_app/base/http/http.dart';
import 'package:qinglong_app/module/task/task_bean.dart';
import 'package:qinglong_app/utils/extension.dart';

var taskProvider = ChangeNotifierProvider((ref) => TaskViewModel());

class TaskViewModel extends BaseViewModel {
  List<TaskBean> list = [];
  List<TaskBean> running = [];
  List<TaskBean> disabled = [];

  Future<void> loadData([isLoading = true]) async {
    if (isLoading) {
      loading(notify: true);
    }

    HttpResponse<List<TaskBean>> result = await Api.crons();

    if (result.success && result.bean != null) {
      list.clear();
      list.addAll(result.bean!);
      sortList();
      success();
    } else {
      list.clear();
      failed(result.message, notify: true);
    }
  }

  void sortList() {
    for (int i = 0; i < list.length; i++) {
      if (list[i].isPinned == 1) {
        final TaskBean item = list.removeAt(i);
        list.insert(0, item);
      }
    }

    running.clear();
    running.addAll(list.where((element) => element.status == 0));
    disabled.clear();
    disabled.addAll(list.where((element) => element.isDisabled == 1));
  }

  Future<void> runCrons(String cron) async {
    HttpResponse<NullResponse> result = await Api.startTasks([cron]);
    if (result.success) {
      list.firstWhere((element) => element.sId == cron).status = 0;
      notifyListeners();
    } else {
      failToast(result.message, notify: true);
    }
  }

  Future<void> stopCrons(String cron) async {
    HttpResponse<NullResponse> result = await Api.stopTasks([cron]);
    if (result.success) {
      list.firstWhere((element) => element.sId == cron).status = 1;
      notifyListeners();
    } else {
      failToast(result.message, notify: true);
    }
  }

  Future<void> delCron(String id) async {
    HttpResponse<NullResponse> result = await Api.delTask(id);
    if (result.success) {
      list.removeWhere((element) => element.sId == id);
      "删除成功".toast();
      notifyListeners();
    } else {
      failToast(result.message, notify: true);
    }
  }

  void updateBean(TaskBean result) {
    if (result.sId == null) {
      loadData(false);
      return;
    }
    TaskBean bean = list.firstWhere((element) => element.sId == result.sId);
    bean.name = result.name;
    bean.schedule = result.schedule;
    bean.command = result.command;
    notifyListeners();
  }

  Future<void> pinTask(String sId, int isPinned) async {
    if (isPinned == 1) {
      HttpResponse<NullResponse> response = await Api.unpinTask(sId);

      if (response.success) {
        "取消置顶成功".toast();
        list.firstWhere((element) => element.sId == sId).isPinned = 0;
        sortList();
        success();
      } else {
        failToast(response.message, notify: true);
      }
    } else {
      HttpResponse<NullResponse> response = await Api.pinTask(sId);

      if (response.success) {
        "置顶成功".toast();
        list.firstWhere((element) => element.sId == sId).isPinned = 1;
        sortList();
        success();
      } else {
        failToast(response.message, notify: true);
      }
    }
  }

  Future<void> enableTask(String sId, int isDisabled) async {
    if (isDisabled == 0) {
      HttpResponse<NullResponse> response = await Api.disableTask(sId);

      if (response.success) {
        "禁用成功".toast();
        list.firstWhere((element) => element.sId == sId).isDisabled = 1;
        sortList();
        success();
      } else {
        failToast(response.message, notify: true);
      }
    } else {
      HttpResponse<NullResponse> response = await Api.enableTask(sId);

      if (response.success) {
        "启用成功".toast();
        list.firstWhere((element) => element.sId == sId).isDisabled = 0;
        sortList();
        success();
      } else {
        failToast(response.message, notify: true);
      }
    }
  }
}
