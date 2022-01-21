import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_highlight/flutter_highlight.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qinglong_app/base/http/api.dart';
import 'package:qinglong_app/base/http/http.dart';
import 'package:qinglong_app/base/ql_app_bar.dart';
import 'package:qinglong_app/base/routes.dart';
import 'package:qinglong_app/base/theme.dart';
import 'package:qinglong_app/base/ui/lazy_load_state.dart';
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

class _ScriptDetailPageState extends ConsumerState<ScriptDetailPage> with LazyLoadState<ScriptDetailPage> {
  String? content;

  List<Widget> actions = [];

  @override
  void initState() {
    super.initState();
    actions.addAll(
      [
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            Navigator.of(context).pop();
            if (content == null || content!.isEmpty) {
              "未获取到脚本内容,请稍候重试".toast();
              return;
            }
            Navigator.of(context).pushNamed(
              Routes.routeScriptUpdate,
              arguments: {
                "title": widget.title,
                "path": widget.path,
                "content": content,
              },
            ).then((value) {
              if (value != null && value == true) {
                Navigator.of(context).pop(true);
              }
            });
          },
          child: Container(
            padding: const EdgeInsets.symmetric(
              vertical: 15,
            ),
            alignment: Alignment.center,
            child: const Material(
              color: Colors.transparent,
              child: Text(
                "编辑",
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ),
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () async {
            Navigator.of(context).pop();

            showCupertinoDialog(
              context: context,
              builder: (context) => CupertinoAlertDialog(
                title: const Text("确认删除"),
                content: const Text("确认删除该脚本吗"),
                actions: [
                  CupertinoDialogAction(
                    child: const Text(
                      "取消",
                      style: TextStyle(
                        color: Color(0xff999999),
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  CupertinoDialogAction(
                    child: Text(
                      "确定",
                      style: TextStyle(
                        color: ref.watch(themeProvider).primaryColor,
                      ),
                    ),
                    onPressed: () async {
                      Navigator.of(context).pop();
                      HttpResponse<NullResponse> result = await Api.delScript(widget.title, widget.path ?? "");
                      if (result.success) {
                        "删除成功".toast();
                        Navigator.of(context).pop(true);
                      } else {
                        result.message?.toast();
                      }
                    },
                  ),
                ],
              ),
            );
          },
          child: Container(
            padding: const EdgeInsets.symmetric(
              vertical: 15,
            ),
            alignment: Alignment.center,
            child: const Material(
              color: Colors.transparent,
              child: Text(
                "删除",
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: QlAppBar(
        canBack: true,
        backCall: () {
          Navigator.of(context).pop();
        },
        title: "脚本详情",
        actions: [
          InkWell(
            onTap: () {
              showCupertinoModalPopup(
                context: context,
                builder: (context) {
                  return CupertinoActionSheet(
                    title: Container(
                      alignment: Alignment.center,
                      child: const Material(
                        color: Colors.transparent,
                        child: Text(
                          "更多操作",
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                    actions: actions,
                    cancelButton: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.symmetric(
                          vertical: 10,
                        ),
                        child: const Material(
                          color: Colors.transparent,
                          child: Text(
                            "取消",
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            },
            child: const Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 15,
              ),
              child: Center(
                child: Icon(
                  Icons.more_horiz,
                  color: Colors.white,
                  size: 26,
                ),
              ),
            ),
          ),
        ],
      ),
      body: content == null
          ? const Center(
              child: CupertinoActivityIndicator(),
            )
          : SingleChildScrollView(
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
