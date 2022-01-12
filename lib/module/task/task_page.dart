import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qinglong_app/base/base_state_widget.dart';
import 'package:qinglong_app/module/task/task_viewmodel.dart';

class TaskPage extends StatefulWidget {
  const TaskPage({Key? key}) : super(key: key);

  @override
  _TaskPageState createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  @override
  Widget build(BuildContext context) {
    return BaseStateWidget<TaskViewModel>(
      builder: (context, model, child) {
        return ListView.builder(
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(model.list[index]),
            );
          },
          itemCount: model.list.length,
        );
      },
      model: taskProvider,
      onReady: (viewModel) {
        viewModel.loadData();
      },
    );
  }
}
