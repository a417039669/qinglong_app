import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qinglong_app/base/http/api.dart';
import 'package:qinglong_app/base/http/http.dart';
import 'package:qinglong_app/base/ql_app_bar.dart';
import 'package:qinglong_app/base/routes.dart';
import 'package:qinglong_app/base/theme.dart';
import 'package:qinglong_app/base/ui/lazy_load_state.dart';
import 'package:qinglong_app/module/others/task_log/task_log_bean.dart';
import 'package:qinglong_app/utils/extension.dart';

/// @author NewTab
class TaskLogPage extends ConsumerStatefulWidget {
  const TaskLogPage({Key? key}) : super(key: key);

  @override
  _TaskLogPageState createState() => _TaskLogPageState();
}

class _TaskLogPageState extends ConsumerState<TaskLogPage> with LazyLoadState<TaskLogPage> {
  List<TaskLogBean> list = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: QlAppBar(
        canBack: true,
        backCall: () {
          Navigator.of(context).pop();
        },
        title: "任务日志",
      ),
      body: list.isEmpty
          ? const Center(
              child: CupertinoActivityIndicator(),
            )
          : ListView.builder(
              itemBuilder: (context, index) {
                TaskLogBean item = list[index];

                return ColoredBox(
                  color: ref.watch(themeProvider).themeColor.settingBgColor(),
                  child: (item.isDir ?? false)
                      ? ExpansionTile(
                          title: Text(
                            item.name ?? "",
                            style: TextStyle(
                              color: ref.watch(themeProvider).themeColor.titleColor(),
                              fontSize: 16,
                            ),
                          ),
                          children: item.files!
                              .map((e) => ListTile(
                                    onTap: () {
                                      Navigator.of(context).pushNamed(Routes.routeTaskLogDetail, arguments: item.name! + "/" + e);
                                    },
                                    title: Text(
                                      e,
                                      style: TextStyle(
                                        color: ref.watch(themeProvider).themeColor.titleColor(),
                                        fontSize: 14,
                                      ),
                                    ),
                                  ))
                              .toList(),
                        )
                      : ListTile(
                          onTap: () {
                            Navigator.of(context).pushNamed(Routes.routeTaskLogDetail, arguments: item.name);
                          },
                          title: Text(
                            item.name ?? "",
                            style: TextStyle(
                              color: ref.watch(themeProvider).themeColor.titleColor(),
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
    HttpResponse<List<TaskLogBean>> response = await Api.taskLog();

    if (response.success) {
      list.clear();
      list.addAll(response.bean ?? []);
      setState(() {});
    } else {
      response.message?.toast();
    }
  }

  @override
  void onLazyLoad() {
    loadData();
  }
}
