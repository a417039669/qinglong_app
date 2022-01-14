import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qinglong_app/base/base_viewmodel.dart';
import 'package:qinglong_app/base/http/api.dart';
import 'package:qinglong_app/base/http/http.dart';
import 'package:qinglong_app/module/config/config_bean.dart';

var configProvider = ChangeNotifierProvider((ref) => ConfigViewModel());

class ConfigViewModel extends BaseViewModel {
  List<ConfigBean> list = [];

  Map<String, String> content = {};

  Future<void> loadData([isLoading = true]) async {
    if (isLoading) {
      loading(notify: true);
    }

    HttpResponse<List<ConfigBean>> result = await Api.files();

    if (result.success && result.bean != null) {
      list.clear();
      list.addAll(result.bean!);

      for (var element in list) {
        await loadContent(element.value!);
      }

      success();
    } else {
      list.clear();
      failed(result.message, notify: true);
    }
  }

  Future<void> loadContent(String name) async {
    HttpResponse<String> result = await Api.content(name);

    if (result.success && result.bean != null) {
      content[name] = result.bean!;
    }
  }
}
