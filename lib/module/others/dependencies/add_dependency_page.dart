import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qinglong_app/base/http/api.dart';
import 'package:qinglong_app/base/http/http.dart';
import 'package:qinglong_app/base/ql_app_bar.dart';
import 'package:qinglong_app/module/others/dependencies/dependency_viewmodel.dart';
import 'package:qinglong_app/utils/extension.dart';

class AddDependencyPage extends ConsumerStatefulWidget {
  const AddDependencyPage({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState<AddDependencyPage> createState() => _AddDependencyPageState();
}

class _AddDependencyPageState extends ConsumerState<AddDependencyPage> {
  final TextEditingController _nameController = TextEditingController();

  DepedencyEnum depedencyType = DepedencyEnum.NodeJS;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: QlAppBar(
        canBack: true,
        backCall: () {
          Navigator.of(context).pop();
        },
        title: "新增依赖",
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
                  "依赖类型:",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                DropdownButtonFormField<DepedencyEnum>(
                  items: [
                    DropdownMenuItem(
                      value: DepedencyEnum.NodeJS,
                      child: Text(DepedencyEnum.NodeJS.name),
                    ),
                    DropdownMenuItem(
                      value: DepedencyEnum.Python3,
                      child: Text(DepedencyEnum.Python3.name),
                    ),
                    DropdownMenuItem(
                      value: DepedencyEnum.Linux,
                      child: Text(DepedencyEnum.Linux.name),
                    ),
                  ],
                  value: DepedencyEnum.NodeJS,
                  onChanged: (value) {
                    depedencyType = value!;
                  },
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
        ],
      ),
    );
  }

  void submit() async {
    if (_nameController.text.isEmpty) {
      "依赖名称不能为空".toast();
      return;
    }

    HttpResponse<NullResponse> response = await Api.addDependency(
      _nameController.text,
      depedencyType.index,
    );

    if (response.success) {
      "新增成功".toast();
      ref.read(dependencyProvider).loadData(
            depedencyType.name.toLowerCase(),
          );
      Navigator.of(context).pop();
    } else {
      response.message.toast();
    }
  }
}
