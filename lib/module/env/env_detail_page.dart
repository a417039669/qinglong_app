import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qinglong_app/base/ql_app_bar.dart';
import 'package:qinglong_app/base/routes.dart';
import 'package:qinglong_app/base/theme.dart';
import 'package:qinglong_app/module/env/env_bean.dart';
import 'package:qinglong_app/module/env/env_viewmodel.dart';
import 'package:qinglong_app/utils/utils.dart';

class EnvDetailPage extends ConsumerStatefulWidget {
  final EnvBean envBean;

  const EnvDetailPage(this.envBean, {Key? key}) : super(key: key);

  @override
  _TaskDetailPageState createState() => _TaskDetailPageState();
}

class _TaskDetailPageState extends ConsumerState<EnvDetailPage> {
  List<Widget> actions = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    actions.clear();
    actions.addAll(
      [
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            Navigator.of(context).pop();
            Navigator.of(context).pushNamed(Routes.routeAddEnv, arguments: widget.envBean);
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
                widget.envBean.status! == 0 ? "禁用" : "启用",
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
        title: widget.envBean.name ?? "",
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
      body: SingleChildScrollView(
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
                  EnvDetailCell(
                    title: "ID",
                    desc: widget.envBean.sId ?? "",
                  ),
                  EnvDetailCell(
                    title: "变量名称",
                    desc: widget.envBean.name ?? "",
                  ),
                  EnvDetailCell(
                    title: "创建时间",
                    desc: Utils.formatMessageTime(widget.envBean.created ?? 0),
                  ),
                  EnvDetailCell(
                    title: "更新时间",
                    desc: Utils.formatGMTTime(widget.envBean.timestamp ?? ""),
                  ),
                  EnvDetailCell(
                    title: "值",
                    desc: widget.envBean.value ?? "",
                  ),
                  EnvDetailCell(
                    title: "备注",
                    desc: widget.envBean.remarks ?? "",
                  ),
                  EnvDetailCell(
                    title: "变量状态",
                    desc: widget.envBean.status == 1 ? "已禁用" : "已启用",
                    hideDivide: true,
                  ),
                ],
              ),
            ),
            SizedBox(
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
    );
  }

  void enableTask() async {
    await ref.read(envProvider).enableEnv(widget.envBean.sId!, widget.envBean.status!);
    setState(() {});
  }

  void delTask(BuildContext context, WidgetRef ref) {
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text("确认删除"),
        content: Text("确认删除环境变量 ${widget.envBean.name ?? ""} 吗"),
        actions: [
          CupertinoDialogAction(
            child: const Text("取消"),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          CupertinoDialogAction(
            child: const Text("确定"),
            onPressed: () async {
              Navigator.of(context).pop();
              await ref.read(envProvider).delEnv(widget.envBean.sId!);
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }
}

class EnvDetailCell extends ConsumerWidget {
  final String title;
  final String? desc;
  final Widget? icon;
  final bool hideDivide;
  final Function? taped;

  const EnvDetailCell({
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
