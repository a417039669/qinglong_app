import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:qinglong_app/base/base_state_widget.dart';
import 'package:qinglong_app/base/routes.dart';
import 'package:qinglong_app/base/theme.dart';
import 'package:qinglong_app/module/task/intime_log/intime_log_page.dart';
import 'package:qinglong_app/module/task/task_bean.dart';
import 'package:qinglong_app/module/task/task_detail/task_detail_bean.dart';
import 'package:qinglong_app/module/task/task_viewmodel.dart';
import 'package:qinglong_app/utils/utils.dart';

class TaskPage extends StatefulWidget {
  const TaskPage({Key? key}) : super(key: key);

  @override
  _TaskPageState createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  String? _searchKey = null;
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BaseStateWidget<TaskViewModel>(
      builder: (ref, model, child) {
        return RefreshIndicator(
          onRefresh: () async {
            return model.loadData(false);
          },
          child: ListView.builder(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            itemBuilder: (context, index) {
              if (index == 0) {
                return searchCell(ref);
              }

              TaskBean item = model.list[index - 1];

              if ((item.name == null || item.name!.contains(_searchKey ?? "")) || (item.command == null || item.command!.contains(_searchKey ?? ""))) {
                return TaskItemCell(item);
              } else {
                return const SizedBox.shrink();
              }
            },
            itemCount: model.list.length + 1,
          ),
        );
      },
      model: taskProvider,
      onReady: (viewModel) {
        viewModel.loadData();
      },
    );
  }

  Widget searchCell(WidgetRef context) {
    return Container(
      color: context.watch(themeProvider).themeColor.searchBarBg(),
      padding: const EdgeInsets.symmetric(
        horizontal: 15,
        vertical: 10,
      ),
      child: CupertinoSearchTextField(
        onSubmitted: (value) {
          setState(() {
            _searchKey = value;
          });
        },
        onSuffixTap: () {
          _searchController.text = "";
          setState(() {
            _searchKey = "";
          });
        },
        controller: _searchController,
        borderRadius: BorderRadius.circular(
          30,
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 5,
        ),
        prefixInsets: const EdgeInsets.only(
          top: 10,
          bottom: 6,
          left: 15,
        ),
        placeholder: "搜索",
      ),
    );
  }
}

class TaskItemCell extends ConsumerStatefulWidget {
  final TaskBean bean;

  const TaskItemCell(this.bean, {Key? key}) : super(key: key);

  @override
  _TaskItemCellState createState() => _TaskItemCellState();
}

class _TaskItemCellState extends ConsumerState<TaskItemCell> {
  late TaskBean bean;

  @override
  void initState() {
    bean = widget.bean;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Slidable(
      key: const ValueKey(0),
      startActionPane: ActionPane(
        motion: const ScrollMotion(),
        extentRatio: 0.3,
        dragDismissible: false,
        children: [
          SlidableAction(
            flex: 1,
            icon: bean.status == 0 ? CupertinoIcons.stop_circle : CupertinoIcons.memories,
            foregroundColor: Colors.white,
            backgroundColor: const Color(0xFF0F77FE),
            onPressed: (BuildContext context) {
              if (bean.status == 0) {
                stopCron(context, ref);
              } else {
                startCron(context, ref);
              }
            },
          ),
          SlidableAction(
            flex: 1,
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
            icon: CupertinoIcons.clock_fill,
            onPressed: (BuildContext context) {
              logCron(context, ref);
            },
          ),
        ],
      ),
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        extentRatio: 0.15,
        children: [
          SlidableAction(
            backgroundColor: Colors.cyan,
            flex: 1,
            onPressed: (_) {
              more(context, ref);
            },
            foregroundColor: Colors.white,
            icon: CupertinoIcons.ellipsis,
          ),
        ],
      ),
      child: Container(
        color: bean.isPinned == 1 ? ref.watch(themeProvider).themeColor.searchBarBg() : Colors.transparent,
        margin: const EdgeInsets.only(bottom: 7, top: 7),
        padding: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 5,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  bean.name ?? "",
                  maxLines: 1,
                  style: TextStyle(
                    overflow: TextOverflow.ellipsis,
                    color: bean.isDisabled == 1 ? Color(0xffF85152) : ref.watch(themeProvider).themeColor.taskTitleColor(),
                    fontSize: 18,
                  ),
                ),
                const SizedBox(
                  width: 5,
                ),
                bean.status == 1
                    ? const SizedBox.shrink()
                    : const SizedBox(
                        width: 15,
                        height: 15,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                        ),
                      ),
                const Spacer(),
                Text(
                  (bean.lastExecutionTime == null || bean.lastExecutionTime == 0) ? "-" : Utils.formatMessageTime(bean.lastExecutionTime!),
                  maxLines: 1,
                  style: const TextStyle(
                    overflow: TextOverflow.ellipsis,
                    color: Color(0xff999999),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 5,
            ),
            Text(
              bean.schedule ?? "",
              maxLines: 1,
              style: const TextStyle(
                overflow: TextOverflow.ellipsis,
                color: Color(0xff999999),
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  startCron(BuildContext context, WidgetRef ref) {
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text("确认运行"),
        content: Text("确认运行定时任务 ${bean.name ?? ""} 吗"),
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
              ref.read(taskProvider).runCrons(bean.sId!);
            },
          ),
        ],
      ),
    );
  }

  stopCron(BuildContext context, WidgetRef ref) {
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text("确认停止"),
        content: Text("确认停止定时任务 ${bean.name ?? ""} 吗"),
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
              ref.read(taskProvider).stopCrons(bean.sId!);
            },
          ),
        ],
      ),
    );
  }

  logCron(BuildContext context, WidgetRef ref) {
    showCupertinoDialog(
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: Text(
              "${bean.name}运行日志",
              maxLines: 1,
              style: const TextStyle(overflow: TextOverflow.ellipsis),
            ),
            content: InTimeLogPage(bean.sId!, bean.status == 0),
            actions: [
              CupertinoDialogAction(
                child: const Text("知道了"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
        context: context);
  }

  more(BuildContext context, WidgetRef ref) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        title: const Text('更多操作'),
        actions: <CupertinoActionSheetAction>[
          CupertinoActionSheetAction(
            child: const Text('编辑'),
            onPressed: () {
              Navigator.pop(context);
              Navigator.of(context).pushNamed(Routes.route_AddTask, arguments: bean).then((value) {
                if (value != null) {
                  var result = value as TaskDetailBean;
                  bean.name = result.name;
                  bean.schedule = result.schedule;
                  bean.command = result.command;
                  setState(() {});
                }
              });
            },
          ),
          CupertinoActionSheetAction(
            child: Text(bean.isDisabled! == 1 ? "启用" : "禁用"),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          CupertinoActionSheetAction(
            child: const Text('删除'),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          CupertinoActionSheetAction(
            child: Text(bean.isPinned! == 0 ? "置顶" : "取消置顶"),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
