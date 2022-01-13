import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qinglong_app/base/base_viewmodel.dart';
import 'package:qinglong_app/base/http/api.dart';
import 'package:qinglong_app/base/http/http.dart';
import 'package:qinglong_app/module/task/task_bean.dart';

var taskProvider = ChangeNotifierProvider((ref) => TaskViewModel());

class TaskViewModel extends BaseViewModel {
  List<TaskBean> list = [];

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
    list.sort((a, b) {
      return a.isDisabled! - b.isDisabled!;
    });

    list.sort((a, b) {
      return a.status! - b.status!;
    });
  }

  Future<void> runCrons(String cron) async {
    HttpResponse<NullResponse> result = await Api.startTasks([cron]);
    if (result.success) {
      list.firstWhere((element) => element.sId == cron).status = 0;
      notifyListeners();
    }
  }

  Future<void> stopCrons(String cron) async {
    HttpResponse<NullResponse> result = await Api.stopTasks([cron]);
    if (result.success) {
      list.firstWhere((element) => element.sId == cron).status = 1;
      notifyListeners();
    }
  }
}
