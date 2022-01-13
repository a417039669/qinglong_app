import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qinglong_app/base/base_viewmodel.dart';
import 'package:qinglong_app/base/http/api.dart';
import 'package:qinglong_app/base/http/http.dart';
import 'package:qinglong_app/module/config/config_bean.dart';

var configProvider = ChangeNotifierProvider((ref) => ConfigViewModel());

class ConfigViewModel extends BaseViewModel {
  List<ConfigBean> list = [];

  String content = "";
  String title = "";

  Future<void> loadData([isLoading = true]) async {
    if (isLoading) {
      loading(notify: true);
    }

    HttpResponse<List<ConfigBean>> result = await Api.files();

    if (result.success && result.bean != null) {
      list.clear();
      list.addAll(result.bean!);
      title = list[0].value!;
      success();
      loadContent(list[0].value!);
    } else {
      list.clear();
      failed(result.message, notify: true);
    }
  }

  Future<void> loadContent(String name) async {
    title = name;
    notifyListeners();
    HttpResponse<String> result = await Api.content(name);

    if (result.success && result.bean != null) {
      content = result.bean!;
      success();
    } else {
      failToast(result.message, notify: false);
    }
  }
}
