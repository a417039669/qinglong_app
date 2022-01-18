import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qinglong_app/base/base_state_widget.dart';
import 'package:qinglong_app/base/ql_app_bar.dart';
import 'package:qinglong_app/module/task/task_bean.dart';
import 'package:qinglong_app/module/task/task_detail/task_detail_viewmodel.dart';

class TaskDetailPage extends ConsumerStatefulWidget {
  final TaskBean taskBean;

  const TaskDetailPage(this.taskBean, {Key? key}) : super(key: key);

  @override
  _TaskDetailPageState createState() => _TaskDetailPageState();
}

class _TaskDetailPageState extends ConsumerState<TaskDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: QlAppBar(
        canBack: true,
        title: widget.taskBean.name ?? "",
      ),
      body: BaseStateWidget<TaskDetailViewModel>(
        model: taskDetailProvider,
        builder: (WidgetRef context, TaskDetailViewModel value, Widget? child) {
          return Container();
        },
        onReady: (model) {
          model.loadDetail(widget.taskBean.sId!);
        },
      ),
    );
  }
}
