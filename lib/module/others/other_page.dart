import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qinglong_app/base/routes.dart';
import 'package:qinglong_app/base/theme.dart';
import 'package:qinglong_app/base/userinfo_viewmodel.dart';
import 'package:qinglong_app/main.dart';

class OtherPage extends ConsumerStatefulWidget {
  const OtherPage({Key? key}) : super(key: key);

  @override
  _OtherPageState createState() => _OtherPageState();
}

class _OtherPageState extends ConsumerState<OtherPage> {
  var toggleValue = false;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.symmetric(
              horizontal: 15,
              vertical: 15,
            ),
            decoration: BoxDecoration(
              color: ref.watch(themeProvider).themeColor.settingBgColor(),
              borderRadius: const BorderRadius.all(
                Radius.circular(15),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    top: 12,
                    bottom: 8,
                    left: 15,
                    right: 15,
                  ),
                  child: Row(
                    children: [
                      Text(
                        "脚本管理",
                        style: TextStyle(
                          color: ref
                              .watch(themeProvider)
                              .themeColor
                              .taskTitleColor(),
                          fontSize: 16,
                        ),
                      ),
                      const Spacer(),
                      const Icon(
                        CupertinoIcons.right_chevron,
                        size: 16,
                      ),
                    ],
                  ),
                ),
                const Divider(
                  indent: 15,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 15,
                  ),
                  child: Row(
                    children: [
                      Text(
                        "依赖管理",
                        style: TextStyle(
                          color: ref
                              .watch(themeProvider)
                              .themeColor
                              .taskTitleColor(),
                          fontSize: 16,
                        ),
                      ),
                      const Spacer(),
                      const Icon(
                        CupertinoIcons.right_chevron,
                        size: 16,
                      ),
                    ],
                  ),
                ),
                const Divider(
                  indent: 15,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 15,
                  ),
                  child: Row(
                    children: [
                      Text(
                        "任务日志",
                        style: TextStyle(
                          color: ref
                              .watch(themeProvider)
                              .themeColor
                              .taskTitleColor(),
                          fontSize: 16,
                        ),
                      ),
                      const Spacer(),
                      const Icon(
                        CupertinoIcons.right_chevron,
                        size: 16,
                      ),
                    ],
                  ),
                ),
                const Divider(
                  indent: 15,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 15,
                  ),
                  child: Row(
                    children: [
                      Text(
                        "登录日志",
                        style: TextStyle(
                          color: ref
                              .watch(themeProvider)
                              .themeColor
                              .taskTitleColor(),
                          fontSize: 16,
                        ),
                      ),
                      const Spacer(),
                      const Icon(
                        CupertinoIcons.right_chevron,
                        size: 16,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(
              horizontal: 15,
              vertical: 15,
            ),
            decoration: BoxDecoration(
              color: ref.watch(themeProvider).themeColor.settingBgColor(),
              borderRadius: const BorderRadius.all(
                Radius.circular(15),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    top: 5,
                    bottom: 5,
                    left: 15,
                    right: 15,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "夜间模式",
                        style: TextStyle(
                          color: ref
                              .watch(themeProvider)
                              .themeColor
                              .taskTitleColor(),
                          fontSize: 16,
                        ),
                      ),
                      const Spacer(),
                      CupertinoSwitch(
                          value: ref.watch(themeProvider).isInDartMode(),
                          onChanged: (open) {
                            ref.watch(themeProvider).changeThemeReal(open);
                          }),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Center(
            child: SizedBox(
              width: MediaQuery.of(context).size.width - 40,
              child: CupertinoButton(
                  color: ref.watch(themeProvider).themeColor.buttonBgColor(),
                  child: const Text(
                    "退出登录",
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  onPressed: () {
                    getIt<UserInfoViewModel>().updateToken("");
                    Navigator.of(context)
                        .pushReplacementNamed(Routes.routeLogin);
                  }),
            ),
          ),
        ],
      ),
    );
  }
}
