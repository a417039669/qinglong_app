import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qinglong_app/base/ql_app_bar.dart';
import 'package:qinglong_app/base/routes.dart';
import 'package:qinglong_app/base/theme.dart';
import 'package:qinglong_app/module/config/config_page.dart';
import 'package:qinglong_app/module/env/env_page.dart';
import 'package:qinglong_app/module/others/other_page.dart';
import 'package:qinglong_app/module/task/task_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _index = 0;
  String _title = "";

  List<IndexBean> titles = [];

  @override
  void initState() {
    initTitles();
    _title = titles[0].title;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> actions = [];

    if (_index == 0) {
      actions.add(InkWell(
        onTap: () {
          Navigator.of(context).pushNamed(
            Routes.route_AddTask,
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
            ),
          ),
        ),
      ));
    }

    actions.add(
      Consumer(builder: (context, ref, child) {
        return InkWell(
          onTap: () {
            ref.read(themeProvider).changeTheme();
          },
          child: const Center(child: Text("改变主题")),
        );
      }),
    );
    return Scaffold(
      appBar: QlAppBar(
        canBack: false,
        title: _title,
        actions: actions,
      ),
      body: IndexedStack(
        index: _index,
        children: const [
          TaskPage(),
          EnvPage(),
          ConfigPage(),
          OtherPage(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: titles
            .map(
              (e) => BottomNavigationBarItem(
                icon: Icon(e.icon),
                activeIcon: Icon(e.checkedIcon),
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
        type: BottomNavigationBarType.fixed,
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
      ),
    );
    titles.add(
      IndexBean(
        CupertinoIcons.hammer,
        CupertinoIcons.hammer_fill,
        "环境变量",
      ),
    );
    titles.add(
      IndexBean(
        CupertinoIcons.settings,
        CupertinoIcons.settings_solid,
        "配置文件",
      ),
    );
    titles.add(
      IndexBean(
        CupertinoIcons.cube,
        CupertinoIcons.cube_fill,
        "其他",
      ),
    );
  }
}

class IndexBean {
  IconData icon;
  IconData checkedIcon;
  String title;

  IndexBean(this.icon, this.checkedIcon, this.title);
}
