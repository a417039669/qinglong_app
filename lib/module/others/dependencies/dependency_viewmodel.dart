import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qinglong_app/base/base_viewmodel.dart';
import 'package:qinglong_app/base/http/api.dart';
import 'package:qinglong_app/base/http/http.dart';
import 'package:qinglong_app/module/others/dependencies/dependency_bean.dart';
import 'package:qinglong_app/utils/extension.dart';

/// @author NewTab

var dependencyProvider = ChangeNotifierProvider((ref) => DependencyViewModel());

class DependencyViewModel extends BaseViewModel {
  List<DependencyBean> nodeJsList = [];
  List<DependencyBean> python3List = [];
  List<DependencyBean> linuxList = [];

  Future<void> loadData(String type, [bool showLoading = true]) async {
    if (showLoading) {
      loading(notify: true);
    }

    HttpResponse<List<DependencyBean>> response = await Api.dependencies(type);
    if (response.success) {
      if (type == "nodejs") {
        nodeJsList.clear();
        nodeJsList.addAll(response.bean!);
      }
      if (type == "python3") {
        python3List.clear();
        python3List.addAll(response.bean!);
      }
      if (type == "linux") {
        linuxList.clear();
        linuxList.addAll(response.bean!);
      }
      success();
    } else {
      response.message?.toast();
    }
  }

  void reInstall(String type, String sId) async {
    await Api.dependencyReinstall(sId);
    loadData(type);
  }

  void del(String type, String sId) async {
    "删除中...".toast();
    await Api.delDependency(sId);
    loadData(type);
  }
}

enum DepedencyEnum { NodeJS, Python3, Linux }
