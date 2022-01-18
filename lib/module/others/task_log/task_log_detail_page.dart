import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qinglong_app/base/http/api.dart';
import 'package:qinglong_app/base/http/http.dart';
import 'package:qinglong_app/base/ql_app_bar.dart';
import 'package:qinglong_app/base/theme.dart';
import 'package:qinglong_app/module/others/task_log/task_log_bean.dart';
import 'package:qinglong_app/utils/extension.dart';

/// @author NewTab
class TaskLogDetailPage extends ConsumerStatefulWidget {
  final String title;

  const TaskLogDetailPage({
    Key? key,
    required this.title,
  }) : super(key: key);

  @override
  _TaskLogDetailPageState createState() => _TaskLogDetailPageState();
}

class _TaskLogDetailPageState extends ConsumerState<TaskLogDetailPage> {
  String? content;

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
        title: "任务日志详情",
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 15,
        ),
        child: SelectableText(
          (content == null || content!.isEmpty) ? "暂无数据" : content!,
        ),
      ),
    );
  }

  Future<void> loadData() async {
    HttpResponse<String> response = await Api.taskLogDetail(
      widget.title,
    );

    if (response.success) {
      content = response.bean;
      setState(() {});
    } else {
      response.message?.toast();
    }
  }
}
