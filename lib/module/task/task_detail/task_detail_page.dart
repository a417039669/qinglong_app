import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qinglong_app/base/ql_app_bar.dart';
import 'package:qinglong_app/base/theme.dart';
import 'package:qinglong_app/module/task/intime_log/intime_log_page.dart';
import 'package:qinglong_app/module/task/task_bean.dart';
import 'package:qinglong_app/utils/utils.dart';

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
        backCall: () {
          Navigator.of(context).pop();
        },
        title: widget.taskBean.name ?? "",
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.symmetric(
            horizontal: 15,
            vertical: 10,
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
                desc: widget.taskBean.isDisabled == 1 ? "已禁用" : "正常",
                hideDivide: true,
              ),
            ],
          ),
        ),
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
