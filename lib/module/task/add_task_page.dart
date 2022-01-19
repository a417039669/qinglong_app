import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qinglong_app/base/http/api.dart';
import 'package:qinglong_app/base/http/http.dart';
import 'package:qinglong_app/base/ql_app_bar.dart';
import 'package:qinglong_app/module/task/task_bean.dart';
import 'package:qinglong_app/module/task/task_viewmodel.dart';
import 'package:qinglong_app/utils/extension.dart';

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


  final String scheduleCron = r"[ \t]*(@reboot|@yearly|@annually|@monthly|@weekly|@daily|@midnight|@hourly|((((([1-5]?[0-9])-)?([1-5]?[0-9])|\*)(/([1-5]?[0-9]))?,)*((([1-5]?[0-9])-)?([1-5]?[0-9])|\*)(/([1-5]?[0-9]))?)[ \t]+(((((2[0-3]|1[0-9]|[0-9])-)?(2[0-3]|1[0-9]|[0-9])|\*)(/(2[0-3]|1[0-9]|[0-9]))?,)*(((2[0-3]|1[0-9]|[0-9])-)?(2[0-3]|1[0-9]|[0-9])|\*)(/(2[0-3]|1[0-9]|[0-9]))?)[ \t]+(((((3[01]|[12][0-9]|[1-9])-)?(3[01]|[12][0-9]|[1-9])|\*)(/(3[01]|[12][0-9]|[1-9]))?,)*(((3[01]|[12][0-9]|[1-9])-)?(3[01]|[12][0-9]|[1-9])|\*)(/(3[01]|[12][0-9]|[1-9]))?)[ \t]+((((((1[0-2]|[1-9])|[Jj][Aa][Nn]|[Ff][Ee][Bb]|[Mm][Aa][Rr]|[Aa][Pp][Rr]|[Mm][Aa][Yy]|[Jj][Uu][Nn]|[Jj][Uu][Ll]|[Aa][Uu][Gg]|[Ss][Ee][Pp]|[Oo][Cc][Tt]|[Nn][Oo][Vv]|[Dd][Ee][Cc])-)?((1[0-2]|[1-9])|[Jj][Aa][Nn]|[Ff][Ee][Bb]|[Mm][Aa][Rr]|[Aa][Pp][Rr]|[Mm][Aa][Yy]|[Jj][Uu][Nn]|[Jj][Uu][Ll]|[Aa][Uu][Gg]|[Ss][Ee][Pp]|[Oo][Cc][Tt]|[Nn][Oo][Vv]|[Dd][Ee][Cc])|\*)(/((1[0-2]|[1-9])|[Jj][Aa][Nn]|[Ff][Ee][Bb]|[Mm][Aa][Rr]|[Aa][Pp][Rr]|[Mm][Aa][Yy]|[Jj][Uu][Nn]|[Jj][Uu][Ll]|[Aa][Uu][Gg]|[Ss][Ee][Pp]|[Oo][Cc][Tt]|[Nn][Oo][Vv]|[Dd][Ee][Cc]))?,)*((((1[0-2]|[1-9])|[Jj][Aa][Nn]|[Ff][Ee][Bb]|[Mm][Aa][Rr]|[Aa][Pp][Rr]|[Mm][Aa][Yy]|[Jj][Uu][Nn]|[Jj][Uu][Ll]|[Aa][Uu][Gg]|[Ss][Ee][Pp]|[Oo][Cc][Tt]|[Nn][Oo][Vv]|[Dd][Ee][Cc])-)?((1[0-2]|[1-9])|[Jj][Aa][Nn]|[Ff][Ee][Bb]|[Mm][Aa][Rr]|[Aa][Pp][Rr]|[Mm][Aa][Yy]|[Jj][Uu][Nn]|[Jj][Uu][Ll]|[Aa][Uu][Gg]|[Ss][Ee][Pp]|[Oo][Cc][Tt]|[Nn][Oo][Vv]|[Dd][Ee][Cc])|\*)(/((1[0-2]|[1-9])|[Jj][Aa][Nn]|[Ff][Ee][Bb]|[Mm][Aa][Rr]|[Aa][Pp][Rr]|[Mm][Aa][Yy]|[Jj][Uu][Nn]|[Jj][Uu][Ll]|[Aa][Uu][Gg]|[Ss][Ee][Pp]|[Oo][Cc][Tt]|[Nn][Oo][Vv]|[Dd][Ee][Cc]))?)[ \t]+((((([0-7]|[Ss][Uu][Nn]|[Mm][Oo][Nn]|[Tt][Uu][Ee]|[Ww][Ee][Dd]|[Tt][Hh][Uu]|[Ff][Rr][Ii]|[Ss][Aa][Tt])-)?([0-7]|[Ss][Uu][Nn]|[Mm][Oo][Nn]|[Tt][Uu][Ee]|[Ww][Ee][Dd]|[Tt][Hh][Uu]|[Ff][Rr][Ii]|[Ss][Aa][Tt])|\*)(/([0-7]|[Ss][Uu][Nn]|[Mm][Oo][Nn]|[Tt][Uu][Ee]|[Ww][Ee][Dd]|[Tt][Hh][Uu]|[Ff][Rr][Ii]|[Ss][Aa][Tt]))?,)*((([0-7]|[Ss][Uu][Nn]|[Mm][Oo][Nn]|[Tt][Uu][Ee]|[Ww][Ee][Dd]|[Tt][Hh][Uu]|[Ff][Rr][Ii]|[Ss][Aa][Tt])-)?([0-7]|[Ss][Uu][Nn]|[Mm][Oo][Nn]|[Tt][Uu][Ee]|[Ww][Ee][Dd]|[Tt][Hh][Uu]|[Ff][Rr][Ii]|[Ss][Aa][Tt])|\*)(/([0-7]|[Ss][Uu][Nn]|[Mm][Oo][Nn]|[Tt][Uu][Ee]|[Ww][Ee][Dd]|[Tt][Hh][Uu]|[Ff][Rr][Ii]|[Ss][Aa][Tt]))?))[ \t]*$";

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
                child: Text(
                  "提交",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
      body: Column(
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
                    fontWeight: FontWeight.w600,
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
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextField(
                  controller: _commandController,
                  maxLines: 4,
                  minLines: 1,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(scheduleCron)),
                  ],
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
                    fontWeight: FontWeight.w600,
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
    );
  }

  void submit() async {
    if (_nameController.text.isEmpty) {
      "任务名称不能为空".toast();
      return;
    }
    if (_commandController.text.isEmpty) {
      "命令不能为空".toast();
      return;
    }
    if (_cronController.text.isEmpty) {
      "定时不能为空".toast();
      return;
    }

    taskBean.name = _nameController.text;
    taskBean.command = _commandController.text;
    taskBean.schedule = _cronController.text;
    HttpResponse<NullResponse> response = await Api.addTask(
        _nameController.text, _commandController.text, _cronController.text,
        id: taskBean.sId);

    if (response.success) {
      "操作成功".toast();
      ref.read(taskProvider).updateBean(taskBean);
      Navigator.of(context).pop();
    } else {
      response.message.toast();
    }
  }
}
