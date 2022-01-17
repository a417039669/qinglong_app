import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qinglong_app/base/common_dialog.dart';
import 'package:qinglong_app/base/http/api.dart';
import 'package:qinglong_app/base/http/http.dart';
import 'package:qinglong_app/base/ql_app_bar.dart';
import 'package:qinglong_app/module/env/env_bean.dart';
import 'package:qinglong_app/module/env/env_viewmodel.dart';
import 'package:qinglong_app/module/task/task_bean.dart';
import 'package:qinglong_app/module/task/task_detail/task_detail_bean.dart';
import 'package:qinglong_app/module/task/task_viewmodel.dart';

class AddEnvPage extends ConsumerStatefulWidget {
  final EnvBean? taskBean;

  const AddEnvPage({Key? key, this.taskBean}) : super(key: key);

  @override
  ConsumerState<AddEnvPage> createState() => _AddEnvPageState();
}

class _AddEnvPageState extends ConsumerState<AddEnvPage> {
  late EnvBean envBean;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _valueController = TextEditingController();
  final TextEditingController _remarkController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.taskBean != null) {
      envBean = widget.taskBean!;
      _nameController.text = envBean.name ?? "";
      _valueController.text = envBean.value ?? "";
      _remarkController.text = envBean.remarks ?? "";
    } else {
      envBean = EnvBean();
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
        title: envBean.name == null ? "新增环境变量" : "编辑环境变量",
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
                  "值:",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextField(
                  controller: _valueController,
                  maxLines: 8,
                  minLines: 1,
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                    hintText: "请输入值",
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
                  "备注:",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextField(
                  controller: _remarkController,
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                    hintText: "请输入备注",
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
      failDialog(context, "名称不能为空");
      return;
    }
    if (_valueController.text.isEmpty) {
      failDialog(context, "值不能为空");
      return;
    }

    envBean.name = _nameController.text;
    envBean.value = _valueController.text;
    envBean.remarks = _remarkController.text;
    HttpResponse<NullResponse> response = await Api.addEnv(
        _nameController.text, _valueController.text, _remarkController.text,
        id: envBean.sId);

    if (response.success) {
      successDialog(context, "操作成功").then((value) {
        ref.read(envProvider).updateEnv(envBean);
        Navigator.of(context).pop();
      });
    } else {
      failDialog(context, response.message ?? "");
    }
  }
}
