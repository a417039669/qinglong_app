import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qinglong_app/base/ql_app_bar.dart';
import 'package:qinglong_app/base/routes.dart';
import 'package:qinglong_app/base/theme.dart';
import 'package:qinglong_app/module/task/intime_log/intime_log_page.dart';
import 'package:qinglong_app/module/task/task_bean.dart';
import 'package:qinglong_app/utils/utils.dart';

import '../task_viewmodel.dart';

class TaskDetailPage extends ConsumerStatefulWidget {
  final TaskBean taskBean;
  final bool hideAppbar;

  const TaskDetailPage(this.taskBean, {Key? key, this.hideAppbar = false}) : super(key: key);

  @override
  _TaskDetailPageState createState() => _TaskDetailPageState();
}

class _TaskDetailPageState extends ConsumerState<TaskDetailPage> {
  List<Widget> actions = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget body = Material(
      color: Colors.transparent,
      child: Container(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 15,
                ),
                padding: const EdgeInsets.only(
                  top: 10,
                  bottom: 10,
                ),
                decoration: BoxDecoration(
                  color: ref.watch(themeProvider).themeColor.settingBgColor(),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TaskDetailCell(
                      title: "名称",
                      desc: widget.taskBean.name ?? "",
                    ),
                    TaskDetailCell(
                      title: "ID",
                      desc: widget.taskBean.sId ?? "",
                    ),
                    TaskDetailCell(
                      title: "任务",
                      desc: widget.taskBean.command ?? "",
                    ),
                    TaskDetailCell(
                      title: "创建时间",
                      desc: Utils.formatMessageTime(widget.taskBean.created ?? 0),
                    ),
                    TaskDetailCell(
                      title: "更新时间",
                      desc: Utils.formatGMTTime(widget.taskBean.timestamp ?? ""),
                    ),
                    TaskDetailCell(
                      title: "任务定时",
                      desc: widget.taskBean.schedule ?? "",
                    ),
                    TaskDetailCell(
                      title: "最后运行时间",
                      desc: Utils.formatMessageTime(widget.taskBean.lastExecutionTime ?? 0),
                    ),
                    TaskDetailCell(
                      title: "最后运行时长",
                      desc: widget.taskBean.lastRunningTime == null ? "-" : "${widget.taskBean.lastRunningTime ?? "-"}秒",
                    ),
                    GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {
                        showLog();
                      },
                      child: TaskDetailCell(
                        title: "日志路径",
                        desc: widget.taskBean.logPath ?? "-",
                        taped: () {
                          showLog();
                        },
                      ),
                    ),
                    TaskDetailCell(
                      title: "运行状态",
                      desc: widget.taskBean.status == 0 ? "正在运行" : "空闲",
                    ),
                    TaskDetailCell(
                      title: "脚本状态",
                      desc: widget.taskBean.isDisabled == 1 ? "已禁用" : "已启用",
                    ),
                    TaskDetailCell(
                      title: "是否置顶",
                      desc: widget.taskBean.isPinned == 1 ? "已置顶" : "未置顶",
                      hideDivide: true,
                    ),
                  ],
                ),
              ),
              widget.hideAppbar
                  ? const SizedBox.shrink()
                  : SizedBox(
                      width: MediaQuery.of(context).size.width - 80,
                      child: CupertinoButton(
                          padding: const EdgeInsets.symmetric(
                            vertical: 5,
                          ),
                          color: Colors.red,
                          child: const Text(
                            "删 除",
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                          onPressed: () {
                            delTask(context, ref);
                          }),
                    ),
              const SizedBox(
                height: 15,
              ),
            ],
          ),
        ),
      ),
    );

    if (widget.hideAppbar) {
      return body;
    }

    actions.clear();
    actions.addAll(
      [
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () async {
            Navigator.of(context).pop();
            if (widget.taskBean.status! == 1) {
              await startCron(context, ref);
            } else {
              await stopCron(context, ref);
            }
          },
          child: Container(
            padding: const EdgeInsets.symmetric(
              vertical: 15,
            ),
            alignment: Alignment.center,
            child: Material(
              color: Colors.transparent,
              child: Text(
                widget.taskBean.status! == 1 ? "运行" : "停止运行",
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ),
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            Navigator.of(context).pop();
            showLog();
          },
          child: Container(
            padding: const EdgeInsets.symmetric(
              vertical: 15,
            ),
            alignment: Alignment.center,
            child: const Material(
              color: Colors.transparent,
              child: Text(
                "查看日志",
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ),
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            Navigator.of(context).pop();
            Navigator.of(context).pushNamed(Routes.routeAddTask, arguments: widget.taskBean);
          },
          child: Container(
            padding: const EdgeInsets.symmetric(
              vertical: 15,
            ),
            alignment: Alignment.center,
            child: const Material(
              color: Colors.transparent,
              child: Text(
                "编辑",
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ),
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            Navigator.of(context).pop();
            pinTask();
          },
          child: Container(
            padding: const EdgeInsets.symmetric(
              vertical: 15,
            ),
            color: Colors.transparent,
            alignment: Alignment.center,
            child: Material(
              color: Colors.transparent,
              child: Text(
                widget.taskBean.isPinned! == 0 ? "置顶" : "取消置顶",
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ),
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            Navigator.of(context).pop();
            enableTask();
          },
          child: Container(
            padding: const EdgeInsets.symmetric(
              vertical: 15,
            ),
            alignment: Alignment.center,
            child: Material(
              color: Colors.transparent,
              child: Text(
                widget.taskBean.isDisabled! == 0 ? "禁用" : "启用",
                style: const TextStyle(
                  color: Colors.red,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ),
      ],
    );

    return Scaffold(
      appBar: QlAppBar(
        canBack: true,
        backCall: () {
          Navigator.of(context).pop();
        },
        title: widget.taskBean.name ?? "",
        actions: [
          InkWell(
            onTap: () {
              showCupertinoModalPopup(
                  context: context,
                  builder: (context) {
                    return CupertinoActionSheet(
                      title: Container(
                        alignment: Alignment.center,
                        child: const Material(
                          color: Colors.transparent,
                          child: Text(
                            "更多操作",
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                      actions: actions,
                      cancelButton: GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Container(
                          alignment: Alignment.center,
                          padding: const EdgeInsets.symmetric(
                            vertical: 10,
                          ),
                          child: const Material(
                            color: Colors.transparent,
                            child: Text(
                              "取消",
                              style: TextStyle(
                                color: Colors.red,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  });
            },
            child: const Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 15,
              ),
              child: Center(
                child: Icon(
                  Icons.more_horiz,
                  color: Colors.white,
                  size: 26,
                ),
              ),
            ),
          )
        ],
      ),
      body: body,
    );
  }

  startCron(BuildContext context, WidgetRef ref) async {
    await ref.read(taskProvider).runCrons(widget.taskBean.sId!);
    setState(() {});
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      showLog();
    });
  }

  stopCron(BuildContext context, WidgetRef ref) async {
    await ref.read(taskProvider).stopCrons(widget.taskBean.sId!);
    setState(() {});
  }

  void enableTask() async {
    await ref.read(taskProvider).enableTask(widget.taskBean.sId!, widget.taskBean.isDisabled!);
    setState(() {});
  }

  void pinTask() async {
    await ref.read(taskProvider).pinTask(widget.taskBean.sId!, widget.taskBean.isPinned!);
    setState(() {});
  }

  void delTask(BuildContext context, WidgetRef ref) {
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text("确认删除"),
        content: Text("确认删除定时任务 ${widget.taskBean.name ?? ""} 吗"),
        actions: [
          CupertinoDialogAction(
            child: const Text(
              "取消",
              style: TextStyle(
                color: Color(0xff999999),
              ),
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          CupertinoDialogAction(
            child: Text(
              "确定",
              style: TextStyle(
                color: ref.watch(themeProvider).primaryColor,
              ),
            ),
            onPressed: () async {
              Navigator.of(context).pop();
              await ref.read(taskProvider).delCron(widget.taskBean.sId!);
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  void showLog() {
    showCupertinoDialog(
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: Text(
              "${widget.taskBean.name}运行日志",
              maxLines: 1,
              style: const TextStyle(overflow: TextOverflow.ellipsis),
            ),
            content: InTimeLogPage(widget.taskBean.sId!, widget.taskBean.status == 0),
            actions: [
              CupertinoDialogAction(
                child: Text(
                  "知道了",
                  style: TextStyle(color: Theme.of(context).primaryColor),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                  ref.read(taskProvider).loadData(false);
                },
              ),
            ],
          );
        },
        context: context);
  }
}

class TaskDetailCell extends ConsumerWidget {
  final String title;
  final String? desc;
  final Widget? icon;
  final bool hideDivide;
  final Function? taped;

  const TaskDetailCell({
    Key? key,
    required this.title,
    this.desc,
    this.icon,
    this.hideDivide = false,
    this.taped,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(
            top: 10,
            left: 15,
            right: 10,
            bottom: 10,
          ),
          child: Row(
            children: [
              Text(
                title,
                style: TextStyle(
                  color: ref.watch(themeProvider).themeColor.titleColor(),
                  fontSize: 16,
                ),
              ),
              const SizedBox(
                width: 30,
              ),
              desc != null
                  ? Expanded(
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: SelectableText(
                          desc!,
                          textAlign: TextAlign.right,
                          selectionHeightStyle: BoxHeightStyle.max,
                          selectionWidthStyle: BoxWidthStyle.max,
                          onTap: () {
                            if (taped != null) {
                              taped!();
                            }
                          },
                          style: TextStyle(
                            color: ref.watch(themeProvider).themeColor.descColor(),
                            fontSize: 14,
                          ),
                        ),
                      ),
                    )
                  : Expanded(
                      child: Align(alignment: Alignment.centerRight, child: icon!),
                    ),
            ],
          ),
        ),
        hideDivide
            ? const SizedBox.shrink()
            : const Divider(
                indent: 15,
              ),
      ],
    );
  }
}
