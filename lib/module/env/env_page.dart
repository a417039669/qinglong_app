import 'package:drag_and_drop_lists/drag_and_drop_lists.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:qinglong_app/base/base_state_widget.dart';
import 'package:qinglong_app/base/common_dialog.dart';
import 'package:qinglong_app/base/theme.dart';
import 'package:qinglong_app/base/ui/empty_widget.dart';
import 'package:qinglong_app/module/env/env_bean.dart';
import 'package:qinglong_app/module/env/env_viewmodel.dart';

class EnvPage extends StatefulWidget {
  const EnvPage({Key? key}) : super(key: key);

  @override
  _EnvPageState createState() => _EnvPageState();
}

class _EnvPageState extends State<EnvPage> {
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BaseStateWidget<EnvViewModel>(
      builder: (ref, model, child) {
        List<EnvItemCell> list = [];

        for (var value in model.list) {
          if (_searchController.text.isEmpty ||
              (value.name?.contains(_searchController.text) ?? false) ||
              (value.value?.contains(_searchController.text) ?? false) ||
              (value.remarks?.contains(_searchController.text) ?? false)) {
            list.add(EnvItemCell(value, ref,key: ValueKey(value.sId),));
          }
        }

        return model.list.isEmpty
            ? const EmptyWidget()
            : RefreshIndicator(
                color: Theme.of(context).primaryColor,
                onRefresh: () async {
                  return model.loadData(false);
                },
                child: ReorderableListView(
                  header: searchCell(ref),
                  onReorder: (int oldIndex, int newIndex) {
                    if (list.length != model.list.length) {
                      WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
                        failDialog(context, "请先清空搜索关键词");
                      });
                      return;
                    }

                    setState(() {
                      //交换数据
                      if (newIndex > oldIndex) {
                        newIndex -= 1;
                      }
                      final EnvBean item = model.list.removeAt(oldIndex);
                      model.list.insert(newIndex, item);
                      model.update();
                    });
                  },
                  children: list,
                ),
              );
      },
      model: envProvider,
      onReady: (viewModel) {
        viewModel.loadData();
      },
    );
  }

  Widget searchCell(WidgetRef context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 15,
        vertical: 10,
      ),
      child: CupertinoSearchTextField(
        onSubmitted: (value) {
          setState(() {});
        },
        onSuffixTap: () {
          _searchController.text = "";
          setState(() {});
        },
        controller: _searchController,
        borderRadius: BorderRadius.circular(
          30,
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: 5,
          vertical: 5,
        ),
        suffixInsets: const EdgeInsets.only(
          top: 8,
          bottom: 8,
          right: 15,
        ),
        prefixInsets: const EdgeInsets.only(
          top: 10,
          bottom: 6,
          left: 15,
        ),
        placeholderStyle: TextStyle(
          fontSize: 14,
          color: context.watch(themeProvider).themeColor.descColor(),
        ),
        style: const TextStyle(
          fontSize: 14,
        ),
        placeholder: "搜索",
      ),
    );
  }
}

class EnvItemCell extends StatelessWidget {
  final EnvBean bean;
  final WidgetRef ref;

  const EnvItemCell(this.bean, this.ref, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Slidable(
      key: ValueKey(bean.sId),
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        extentRatio: 0.45,
        children: [
          SlidableAction(
            backgroundColor: Colors.grey,
            flex: 1,
            onPressed: (_) {},
            foregroundColor: Colors.white,
            icon: CupertinoIcons.pencil_outline,
          ),
          SlidableAction(
            backgroundColor: Colors.orange,
            flex: 1,
            onPressed: (_) {
              enableEnv();
            },
            foregroundColor: Colors.white,
            icon: bean.status == 0 ? Icons.dnd_forwardslash : Icons.check_circle_outline_sharp,
          ),
          SlidableAction(
            backgroundColor: Colors.red,
            flex: 1,
            onPressed: (_) {
              delEnv(context, ref);
            },
            foregroundColor: Colors.white,
            icon: CupertinoIcons.delete,
          ),
        ],
      ),
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
