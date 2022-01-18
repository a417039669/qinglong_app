import 'package:flutter/material.dart';
import 'package:flutter_highlight/flutter_highlight.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qinglong_app/base/http/api.dart';
import 'package:qinglong_app/base/http/http.dart';
import 'package:qinglong_app/base/ql_app_bar.dart';
import 'package:qinglong_app/base/theme.dart';
import 'package:qinglong_app/base/ui/lazy_load_state.dart';
import 'package:qinglong_app/module/others/task_log/task_log_bean.dart';
import 'package:qinglong_app/utils/extension.dart';

/// @author NewTab
class ScriptDetailPage extends ConsumerStatefulWidget {
  final String title;
  final String? path;

  const ScriptDetailPage({
    Key? key,
    required this.title,
    this.path,
  }) : super(key: key);

  @override
  _ScriptDetailPageState createState() => _ScriptDetailPageState();
}

class _ScriptDetailPageState extends ConsumerState<ScriptDetailPage>
    with LazyLoadState<ScriptDetailPage> {
  String? content;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: QlAppBar(
        canBack: true,
        backCall: () {
          Navigator.of(context).pop();
        },
        title: "脚本详情",
      ),
      body: SingleChildScrollView(
        child: HighlightView(
          content ?? "",
          language: getLanguageType(widget.title),
          padding: const EdgeInsets.symmetric(
            horizontal: 15,
          ),
          theme: ref.watch(themeProvider).themeColor.codeEditorTheme(),
          tabSize: 14,
        ),
      ),
    );
  }

  Future<void> loadData() async {
    HttpResponse<String> response = await Api.scriptDetail(
      widget.title,
      widget.path,
    );

    if (response.success) {
      content = response.bean;
      setState(() {});
    } else {
      response.message?.toast();
    }
  }

  getLanguageType(String title) {
    if (title.endsWith(".js")) {
      return "js";
    }

    if (title.endsWith(".sh")) {
      return "sh";
    }

    if (title.endsWith(".py")) {
      return "py";
    }
    if (title.endsWith(".json")) {
      return "json";
    }
    if (title.endsWith(".yaml")) {
      return "yaml";
    }
    return "html";
  }

  @override
  void onLazyLoad() {
    loadData();
  }
}
