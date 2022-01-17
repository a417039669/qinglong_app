import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qinglong_app/base/base_state_widget.dart';
import 'package:qinglong_app/base/routes.dart';
import 'package:qinglong_app/base/theme.dart';
import 'package:qinglong_app/base/ui/empty_widget.dart';
import 'package:qinglong_app/base/ui/menu.dart';
import 'package:qinglong_app/module/env/env_bean.dart';
import 'package:qinglong_app/module/env/env_viewmodel.dart';
import 'package:qinglong_app/utils/utils.dart';

class EnvPage extends StatefulWidget {
  const EnvPage({Key? key}) : super(key: key);

  @override
  _EnvPageState createState() => _EnvPageState();
}

class _EnvPageState extends State<EnvPage> {
  String _searchKey = "";

  @override
  Widget build(BuildContext context) {
    return BaseStateWidget<EnvViewModel>(
      builder: (ref, model, child) {
        return RefreshIndicator(
          color: Theme.of(context).primaryColor,
          onRefresh: () async {
            return model.loadData(false);
          },
          child: model.list.isEmpty
              ? const EmptyWidget()
              : ListView.builder(
                  keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                  itemBuilder: (context, index) {
                    EnvBean item = model.list[index];

                    return EnvItemCell(item, ref);
                  },
                  itemCount: model.list.length,
                ),
        );
      },
      model: envProvider,
      onReady: (viewModel) {
        viewModel.loadData();
      },
    );
  }
}

class EnvItemCell extends StatelessWidget {
  final EnvBean bean;
  final WidgetRef ref;

  const EnvItemCell(this.bean, this.ref, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoContextMenu(
      actions: [
        QLCupertinoContextMenuAction(
          child: const Text("编辑"),
          onPressed: () {
            Navigator.of(context).pop();
            Navigator.of(context).pushNamed(Routes.route_AddTask, arguments: bean);
          },
          trailingIcon: CupertinoIcons.pencil_outline,
        ),
        QLCupertinoContextMenuAction(
          child: Text(bean.status! == 0 ? "禁用" : "启用"),
          onPressed: () {
            Navigator.of(context).pop();
            enableEnv();
          },
          isDestructiveAction: true,
          trailingIcon: bean.status! == 0 ? Icons.dnd_forwardslash : Icons.check_circle_outline_sharp,
        ),
        QLCupertinoContextMenuAction(
          child: const Text("删除"),
          onPressed: () {
            Navigator.of(context).pop();
            delEnv(context, ref);
          },
          isDestructiveAction: true,
          trailingIcon: CupertinoIcons.delete,
        ),
      ],
      previewBuilder: (context, anima, child) {
        return IntrinsicWidth(
          child: Material(
            color: Colors.transparent,
            child: Text(
              bean.name ?? "",
              maxLines: 1,
              style: TextStyle(
                overflow: TextOverflow.ellipsis,
                color: bean.status == 0 ? const Color(0xffF85152) : ref.watch(themeProvider).themeColor.taskTitleColor(),
                fontSize: 18,
              ),
            ),
          ),
        );
      },
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 15,
                vertical: 8,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Material(
                          color: Colors.transparent,
                          child: Text(
                            bean.name ?? "",
                            maxLines: 1,
                            style: TextStyle(
                              overflow: TextOverflow.ellipsis,
                              color: bean.status == 1 ? const Color(0xffF85152) : ref.watch(themeProvider).themeColor.taskTitleColor(),
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Material(
                        color: Colors.transparent,
                        child: Text(
                          bean.remarks ?? "-",
                          maxLines: 1,
                          style: TextStyle(
                            overflow: TextOverflow.ellipsis,
                            color: ref.watch(themeProvider).themeColor.descColor(),
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Material(
                    color: Colors.transparent,
                    child: Text(
                      bean.value ?? "",
                      maxLines: 1,
                      style: TextStyle(
                        overflow: TextOverflow.ellipsis,
                        color: ref.watch(themeProvider).themeColor.descColor(),
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Divider(
              height: 1,
              indent: 15,
            ),
          ],
        ),
      ),
    );
  }

  void enableEnv() {
    ref.read(envProvider).enableEnv(bean.sId!, bean.status!);
  }

  void delEnv(BuildContext context, WidgetRef ref) {
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text("确认删除"),
        content: Text("确认删除环境变量 ${bean.name ?? ""} 吗"),
        actions: [
          CupertinoDialogAction(
            child: const Text("取消"),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          CupertinoDialogAction(
            child: const Text("确定"),
            onPressed: () {
              Navigator.of(context).pop();
              ref.read(envProvider).delEnv(bean.sId!);
            },
          ),
        ],
      ),
    );
  }
}
