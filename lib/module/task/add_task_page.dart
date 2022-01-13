import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qinglong_app/base/common_dialog.dart';
import 'package:qinglong_app/base/http/api.dart';
import 'package:qinglong_app/base/http/http.dart';
import 'package:qinglong_app/base/ql_app_bar.dart';
import 'package:qinglong_app/module/task/task_bean.dart';
import 'package:qinglong_app/module/task/task_detail/task_detail_bean.dart';
import 'package:qinglong_app/module/task/task_viewmodel.dart';

class AddTaskPage extends ConsumerStatefulWidget {
  final TaskBean? taskBean;

  const AddTaskPage({Key? key, this.taskBean}) : super(key: key);

  @override
  ConsumerState<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends ConsumerState<AddTaskPage> {
  late TaskBean taskBean;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _commandController = TextEditingController();
  final TextEditingController _cronController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.taskBean != null) {
      taskBean = widget.taskBean!;
      _nameController.text = taskBean.name ?? "";
      _commandController.text = taskBean.command ?? "";
      _cronController.text = taskBean.schedule ?? "";
    } else {
      taskBean = TaskBean();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: QlAppBar(
        canBack: true,
        backCall: () {
          Navigator.of(context).pop();
        },
        title: taskBean.name == null ? "新增任务" : "编辑任务",
        actions: [
          InkWell(
            onTap: () {
              submit();
            },
            child: const Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 15,
              ),
              child: Center(
                child: Text("提交"),
              ),
            ),
          )
        ],
      ),
      body: Container(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 15,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  const Text(
                    "名称:",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                      hintText: "请输入名称",
                    ),
                    autofocus: false,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 15,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  const Text(
                    "命令:",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextField(
                    controller: _commandController,
                    maxLines: 4,
                    minLines: 1,
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                      hintText: "请输入命令",
                    ),
                    autofocus: false,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 15,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  const Text(
                    "定时:",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextField(
                    controller: _cronController,
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                      hintText: "请输入定时",
                    ),
                    autofocus: false,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void submit() async {
    if (_nameController.text.isEmpty) {
      failDialog(context, "任务名称不能为空");
      return;
    }
    if (_commandController.text.isEmpty) {
      failDialog(context, "命令不能为空");
      return;
    }
    if (_cronController.text.isEmpty) {
      failDialog(context, "定时不能为空");
      return;
    }

    taskBean.name = _nameController.text;
    taskBean.command = _commandController.text;
    taskBean.schedule = _cronController.text;
    HttpResponse<TaskDetailBean> response = await Api.addTask(_nameController.text, _commandController.text, _cronController.text, id: taskBean.sId);

    if (response.success) {
      successDialog(context, "操作成功").then((value) {
        ref.read(taskProvider).updateBean(taskBean);
        Navigator.of(context).pop();
      });
    } else {
      failDialog(context, response.message ??"");
    }
  }
}
