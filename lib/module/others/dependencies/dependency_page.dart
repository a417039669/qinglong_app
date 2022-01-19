import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qinglong_app/base/base_state_widget.dart';
import 'package:qinglong_app/base/ql_app_bar.dart';
import 'package:qinglong_app/base/routes.dart';
import 'package:qinglong_app/base/theme.dart';
import 'package:qinglong_app/base/ui/abs_underline_tabindicator.dart';
import 'package:qinglong_app/base/ui/menu.dart';
import 'package:qinglong_app/module/others/dependencies/dependency_bean.dart';
import 'package:qinglong_app/module/others/dependencies/dependency_viewmodel.dart';
import 'package:qinglong_app/utils/utils.dart';

/// @author NewTab
class DependencyPage extends StatefulWidget {
  const DependencyPage({Key? key}) : super(key: key);

  @override
  _DependcyPageState createState() => _DependcyPageState();
}

class _DependcyPageState extends State<DependencyPage> with TickerProviderStateMixin {
  List<DepedencyEnum> types = [];

  TabController? _tabController;

  @override
  void initState() {
    super.initState();

    types.add(
      DepedencyEnum.NodeJS,
    );
    types.add(
      DepedencyEnum.Python3,
    );
    types.add(
      DepedencyEnum.Linux,
    );
    _tabController = TabController(length: types.length, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: QlAppBar(
        canBack: true,
        backCall: () {
          Navigator.of(context).pop();
        },
        title: "依赖管理",
        actions: [
          InkWell(
            onTap: () {
              Navigator.of(context).pushNamed(
                Routes.routeAddDependency,
              );
            },
            child: const Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 15,
              ),
              child: Center(
                child: Icon(
                  CupertinoIcons.add,
                  size: 20,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            TabBar(
              controller: _tabController,
              tabs: types
                  .map((e) => Tab(
                        text: e.name,
                      ))
                  .toList(),
              isScrollable: true,
              indicator: AbsUnderlineTabIndicator(
                wantWidth: 20,
                borderSide: BorderSide(
                  color: Theme.of(context).primaryColor,
                  width: 2,
                ),
              ),
            ),
            Expanded(
              child: BaseStateWidget<DependencyViewModel>(
                onReady: (model) {
                  model.loadData(types[0].name.toLowerCase());
                  model.loadData(types[1].name.toLowerCase());
                  model.loadData(types[2].name.toLowerCase());
                },
                model: dependencyProvider,
                builder: (context, model, child) {
                  return TabBarView(
                    controller: _tabController,
                    children: types.map(
                      (e) {
                        List<DependencyBean> list;
                        if (e.index == 0) {
                          list = model.nodeJsList;
                        } else if (e.index == 1) {
                          list = model.python3List;
                        } else {
                          list = model.linuxList;
                        }

                        return RefreshIndicator(
                          child: ListView.builder(
                            itemBuilder: (context, index) {
                              return DependencyCell(e, list[index]);
                            },
                            itemCount: list.length,
                          ),
                          onRefresh: () {
                            return model.loadData(types[_tabController!.index].name.toLowerCase(), false);
                          },
                        );
                      },
                    ).toList(),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DependencyCell extends ConsumerWidget {
  final DepedencyEnum type;
  final DependencyBean bean;

  const DependencyCell(this.type, this.bean, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ColoredBox(
      color: ref.watch(themeProvider).themeColor.settingBgColor(),
      child: CupertinoContextMenu(
        actions: [
          QLCupertinoContextMenuAction(
            child: Text(
              bean.status! == 0 ? "安装" : "重新安装",
            ),
            trailingIcon: CupertinoIcons.ant,
            onPressed: () {
              Navigator.of(context).pop();
              reInstall(ref, bean.sId);
            },
          ),
          QLCupertinoContextMenuAction(
            child: const Text("查看日志"),
            onPressed: () {
              Navigator.of(context).pop();
              showLog(ref, bean.sId);
            },
            trailingIcon: CupertinoIcons.clock,
          ),
          QLCupertinoContextMenuAction(
            child: const Text("删除"),
            onPressed: () {
              Navigator.of(context).pop();
              del(ref, bean.sId);
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
                  color: ref.watch(themeProvider).themeColor.titleColor(),
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
                  vertical: 10,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Material(
                          color: Colors.transparent,
                          child: Text(
                            bean.name ?? "",
                            maxLines: 1,
                            style: TextStyle(
                              overflow: TextOverflow.ellipsis,
                              color: ref.watch(themeProvider).themeColor.titleColor(),
                              fontSize: 18,
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        bean.status == 1
                            ? Icon(
                                CupertinoIcons.checkmark_circle,
                                color: primaryColor,
                                size: 16,
                              )
                            : (bean.status == 2
                                ? const Icon(
                                    CupertinoIcons.clear_circled,
                                    color: Colors.red,
                                    size: 16,
                                  )
                                : const SizedBox(
                                    width: 12,
                                    height: 12,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  )),
                        Expanded(
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: Material(
                              color: Colors.transparent,
                              child: Text(
                                (bean.created == null || bean.created == 0) ? "-" : Utils.formatMessageTime(bean.created!),
                                maxLines: 1,
                                style: TextStyle(
                                  overflow: TextOverflow.ellipsis,
                                  color: ref.watch(themeProvider).themeColor.descColor(),
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
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
      ),
    );
  }

  void showLog(WidgetRef ref, String? sId) {
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      showCupertinoDialog(
          builder: (BuildContext context) {
            return CupertinoAlertDialog(
              title: Text(
                "${bean.name}运行日志",
                maxLines: 1,
                style: const TextStyle(overflow: TextOverflow.ellipsis),
              ),
              content: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 10,
                ),
                child: bean.log == null
                    ? const Center(
                        child: Text("暂无日志"),
                      )
                    : CupertinoScrollbar(
                        child: SelectableText(
                          bean.log!.join("\n"),
                        ),
                      ),
              ),
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
          context: ref as BuildContext);
    });
  }

  void reInstall(WidgetRef ref, String? sId) {
    ref.read(dependencyProvider).reInstall(type.name.toLowerCase(), sId ?? "");
  }

  void del(WidgetRef ref, String? sId) {
    showCupertinoDialog(
      context: ref as BuildContext,
      builder: (context) => CupertinoAlertDialog(
        title: const Text("确认删除"),
        content: Text("确认删除依赖 ${bean.name ?? ""} 吗"),
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
              ref.read(dependencyProvider).del(type.name.toLowerCase(), sId ?? "");
            },
          ),
        ],
      ),
    );
  }
}
