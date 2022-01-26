import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qinglong_app/base/ql_app_bar.dart';
import 'package:qinglong_app/base/routes.dart';
import 'package:qinglong_app/module/config/config_page.dart';
import 'package:qinglong_app/module/env/env_page.dart';
import 'package:qinglong_app/module/others/other_page.dart';
import 'package:qinglong_app/module/task/task_page.dart';
import 'package:move_to_background/move_to_background.dart';
import 'package:qinglong_app/utils/update_utils.dart';
import 'dart:math' as math;

class HomePage extends ConsumerStatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> with TickerProviderStateMixin {
  int _index = 0;
  String _title = "";
  bool isNewYear = false;

  List<IndexBean> titles = [];

  GlobalKey<ConfigPageState> configKey = GlobalKey();

  late final AnimationController _controller = AnimationController(
    duration: const Duration(milliseconds: 1000),
    vsync: this,
  )..repeat();

  @override
  void initState() {
    isNewYearDuration();

    initTitles();
    _title = titles[0].title;
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      update();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> actions = [];

    if (_index == 0) {
      actions.add(
        InkWell(
          onTap: () {
            Navigator.of(context).pushNamed(
              Routes.routeAddTask,
            );
          },
          child: const Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 15,
            ),
            child: Center(
              child: Icon(
                CupertinoIcons.add,
                size: 24,
                color: Colors.white,
              ),
            ),
          ),
        ),
      );
    } else if (_index == 1) {
      actions.add(
        InkWell(
          onTap: () {
            Navigator.of(context).pushNamed(
              Routes.routeAddEnv,
            );
          },
          child: const Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 15,
            ),
            child: Center(
              child: Icon(
                CupertinoIcons.add,
                size: 24,
                color: Colors.white,
              ),
            ),
          ),
        ),
      );
    } else if (_index == 2) {
      actions.add(InkWell(
        onTap: () {
          configKey.currentState?.editMe(ref);
        },
        child: const Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 15,
          ),
          child: Center(
            child: Text(
              "编辑",
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          ),
        ),
      ));
    }

    return WillPopScope(
      onWillPop: () async {
        await MoveToBackground.moveTaskToBack();
        return false;
      },
      child: Scaffold(
        appBar: QlAppBar(
          canBack: false,
          title: _title,
          actions: actions,
        ),
        body: IndexedStack(
          index: _index,
          children: [
            const Positioned.fill(
              child: TaskPage(),
            ),
            const Positioned.fill(
              child: EnvPage(),
            ),
            Positioned.fill(
              child: ConfigPage(
                key: configKey,
              ),
            ),
            const Positioned.fill(
              child: OtherPage(),
            ),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: titles
              .map(
                (e) => BottomNavigationBarItem(
                  icon: (e.celebrate.isNotEmpty)
                      ? Image.asset(
                          e.celebrate,
                          width: 35,
                          height: 35,
                          fit: BoxFit.cover,
                        )
                      : Icon(e.icon),
                  activeIcon: (e.celebrate.isNotEmpty)
                      ? AnimatedBuilder(
                          builder: (context, _) {
                            return Transform.rotate(
                              angle: _controller.value * 2.0 * math.pi,
                              child: Image.asset(
                                e.celebrate,
                                width: 35,
                                height: 35,
                                fit: BoxFit.cover,
                              ),
                            );
                          },
                          animation: _controller,
                        )
                      : Icon(e.checkedIcon),
                  label: e.title,
                ),
              )
              .toList(),
          currentIndex: _index,
          onTap: (index) {
            _index = index;
            _title = titles[index].title;
            setState(() {});
          },
          elevation: 0,
          selectedFontSize: 12,
          unselectedFontSize: 12,
          type: BottomNavigationBarType.fixed,
          showSelectedLabels: !isNewYear,
          showUnselectedLabels: !isNewYear,
        ),
      ),
    );
  }

  void initTitles() {
    titles.clear();
    titles.add(
      IndexBean(
        CupertinoIcons.timer,
        CupertinoIcons.timer_fill,
        "定时任务",
        celebrate: !isNewYear ? "" : "assets/images/xin.png",
      ),
    );
    titles.add(
      IndexBean(
        CupertinoIcons.hammer,
        CupertinoIcons.hammer_fill,
        "环境变量",
        celebrate: !isNewYear ? "" : "assets/images/chun.png",
      ),
    );
    titles.add(
      IndexBean(
        CupertinoIcons.settings,
        CupertinoIcons.settings_solid,
        "配置文件",
        celebrate: !isNewYear ? "" : "assets/images/kuai.png",
      ),
    );
    titles.add(
      IndexBean(
        CupertinoIcons.cube,
        CupertinoIcons.cube_fill,
        "其他功能",
        celebrate: !isNewYear ? "" : "assets/images/le.png",
      ),
    );
  }

  void update() async {
    String? result = await UpdateUtils().checkUpdate();
    if (result != null && result.isNotEmpty) {
      UpdateDialog updateDialog = UpdateDialog(context, title: "发现新版本", updateContent: "版本号:v$result", onUpdate: () {
        UpdateUtils.launchURL(result);
      });
      updateDialog.show();
    }
  }

  void isNewYearDuration() {
    DateTime date = DateTime.now();
    DateTime dateYear1 = DateTime(2022, 1, 29);
    DateTime dateYear2 = DateTime(2022, 2, 6);

    if (date.isAfter(dateYear1) && date.isBefore(dateYear2)) {
      isNewYear = true;
    } else {
      isNewYear = false;
    }
  }
}

class IndexBean {
  IconData icon;
  IconData checkedIcon;
  String title;
  String celebrate;

  IndexBean(this.icon, this.checkedIcon, this.title, {this.celebrate = ""});
}
