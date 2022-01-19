import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qinglong_app/base/http/api.dart';
import 'package:qinglong_app/base/http/http.dart';
import 'package:qinglong_app/base/ql_app_bar.dart';
import 'package:qinglong_app/base/routes.dart';
import 'package:qinglong_app/base/theme.dart';
import 'package:qinglong_app/module/others/scripts/script_bean.dart';
import 'package:qinglong_app/utils/extension.dart';

/// @author NewTab
class ScriptPage extends ConsumerStatefulWidget {
  const ScriptPage({Key? key}) : super(key: key);

  @override
  _ScriptPageState createState() => _ScriptPageState();
}

class _ScriptPageState extends ConsumerState<ScriptPage> {
  List<ScriptBean> list = [];

  @override
  void initState() {
    super.initState();
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: QlAppBar(
        canBack: true,
        backCall: () {
          Navigator.of(context).pop();
        },
        title: "脚本管理",
      ),
      body: list.isEmpty
          ? const Center(
              child: CupertinoActivityIndicator(),
            )
          : ListView.builder(
              itemBuilder: (context, index) {
                ScriptBean item = list[index];

                return ColoredBox(
                  color: ref.watch(themeProvider).themeColor.settingBgColor(),
                  child: (item.children != null && item.children!.isNotEmpty)
                      ? ExpansionTile(
                          title: Text(
                            item.title ?? "",
                            style: TextStyle(
                              color: (item.disabled ?? false)
                                  ? ref.watch(themeProvider).themeColor.descColor()
                                  : ref.watch(themeProvider).themeColor.titleColor(),
                              fontSize: 16,
                            ),
                          ),
                          children: item.children!
                              .map((e) => ListTile(
                                    onTap: () {
                                      Navigator.of(context).pushNamed(
                                        Routes.routeScriptDetail,
                                        arguments: {
                                          "title": e.title,
                                          "path": e.parent,
                                        },
                                      );
                                    },
                                    title: Text(
                                      e.title ?? "",
                                      style: TextStyle(
                                        color: (item.disabled ?? false)
                                            ? ref.watch(themeProvider).themeColor.descColor()
                                            : ref.watch(themeProvider).themeColor.titleColor(),
                                        fontSize: 14,
                                      ),
                                    ),
                                  ))
                              .toList(),
                        )
                      : ListTile(
                          onTap: () {
                            Navigator.of(context).pushNamed(
                              Routes.routeScriptDetail,
                              arguments: {
                                "title": item.title,
                                "path": "",
                              },
                            );
                          },
                          title: Text(
                            item.title ?? "",
                            style: TextStyle(
                              color: (item.disabled ?? false)
                                  ? ref.watch(themeProvider).themeColor.descColor()
                                  : ref.watch(themeProvider).themeColor.titleColor(),
                              fontSize: 16,
                            ),
                          ),
                        ),
                );
              },
              itemCount: list.length,
            ),
    );
  }

  Future<void> loadData() async {
    HttpResponse<List<ScriptBean>> response = await Api.scripts();

    if (response.success) {
      list.clear();
      list.addAll(response.bean ?? []);
      setState(() {});
    } else {
      response.message?.toast();
    }
  }
}
