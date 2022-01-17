import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qinglong_app/base/base_viewmodel.dart';
import 'package:qinglong_app/base/http/api.dart';
import 'package:qinglong_app/base/http/http.dart';
import 'package:qinglong_app/module/env/env_bean.dart';

var envProvider = ChangeNotifierProvider((ref) => EnvViewModel());

class EnvViewModel extends BaseViewModel {
  List<EnvBean> list = [];

  Future<void> loadData([isLoading = true]) async {
    if (isLoading) {
      loading(notify: true);
    }

    HttpResponse<List<EnvBean>> result = await Api.envs("");

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
      return a.status!.compareTo(b.status!);
    });
  }

  Future<void> delEnv(String id) async {
    HttpResponse<NullResponse> result = await Api.delEnv(id);
    if (result.success) {
      list.removeWhere((element) => element.sId == id);
      notifyListeners();
    } else {
      failed(result.message, notify: true);
    }
  }

  void updateEnv(EnvBean result) {
    if (result.sId == null) {
      loadData(false);
      return;
    }
    EnvBean bean = list.firstWhere((element) => element.sId == result.sId);
    bean.name = result.name;
    bean.remarks = result.remarks;
    bean.value = result.value;
    notifyListeners();
  }

  void enableEnv(String sId, int status) async {
    if (status == 1) {
      HttpResponse<NullResponse> response = await Api.enableEnv(sId);

      if (response.success) {
        list.firstWhere((element) => element.sId == sId).status = 1;
        sortList();
        success();
      } else {
        failToast(response.message, notify: true);
      }
    } else {
      HttpResponse<NullResponse> response = await Api.disableEnv(sId);

      if (response.success) {
        list.firstWhere((element) => element.sId == sId).status = 0;
        sortList();
        success();
      } else {
        failToast(response.message, notify: true);
      }
    }
  }
}
