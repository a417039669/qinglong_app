import 'package:dio_log/dio_log.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qinglong_app/base/routes.dart';
import 'package:qinglong_app/base/theme.dart';
import 'package:qinglong_app/base/userinfo_viewmodel.dart';
import 'package:qinglong_app/main.dart';
import 'package:qinglong_app/utils/extension.dart';

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
              vertical: 30,
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
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    Navigator.of(context).pushNamed(
                      Routes.routeScript,
                    );
                  },
                  child: Padding(
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
                            color: ref.watch(themeProvider).themeColor.titleColor(),
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
                ),
                const Divider(
                  indent: 15,
                ),
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    Navigator.of(context).pushNamed(
                      Routes.routeDependency,
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 8,
                      horizontal: 15,
                    ),
                    child: Row(
                      children: [
                        Text(
                          "依赖管理",
                          style: TextStyle(
                            color: ref.watch(themeProvider).themeColor.titleColor(),
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
                ),
                const Divider(
                  indent: 15,
                ),
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    Navigator.of(context).pushNamed(
                      Routes.routeTaskLog,
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 8,
                      horizontal: 15,
                    ),
                    child: Row(
                      children: [
                        Text(
                          "任务日志",
                          style: TextStyle(
                            color: ref.watch(themeProvider).themeColor.titleColor(),
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
                ),
                const Divider(
                  indent: 15,
                ),
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    if (getIt<UserInfoViewModel>().useSecretLogined) {
                      "使用client_id方式登录无法获取登录日志".toast();
                    } else {
                      Navigator.of(context).pushNamed(
                        Routes.routeLoginLog,
                      );
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 15,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Text(
                          "登录日志",
                          style: TextStyle(
                            color: ref.watch(themeProvider).themeColor.titleColor(),
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
                GestureDetector(
                  onTap: () {
                    if (getIt<UserInfoViewModel>().useSecretLogined) {
                      "使用client_id方式登录无法修改密码".toast();
                    } else {
                      Navigator.of(context).pushNamed(
                        Routes.routeUpdatePassword,
                      );
                    }
                  },
                  behavior: HitTestBehavior.opaque,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 15,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "修改密码",
                          style: TextStyle(
                            color: ref.watch(themeProvider).themeColor.titleColor(),
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
                ),
                const Divider(
                  indent: 15,
                ),
                Padding(
                  padding: const EdgeInsets.only(
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
                          color: ref.watch(themeProvider).themeColor.titleColor(),
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
          const SizedBox(
            height: 30,
          ),
          Center(
            child: SizedBox(
              width: MediaQuery.of(context).size.width - 40,
              child: CupertinoButton(
                  padding: const EdgeInsets.symmetric(
                    vertical: 5,
                  ),
                  color: ref.watch(themeProvider).themeColor.buttonBgColor(),
                  child: const Text(
                    "退出登录",
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  onPressed: () {
                    showCupertinoDialog(
                      context: context,
                      builder: (context) => CupertinoAlertDialog(
                        title: const Text("确定退出登录吗?"),
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
                              getIt<UserInfoViewModel>().updateToken("");
                              Navigator.of(context).pushReplacementNamed(Routes.routeLogin);
                            },
                          ),
                        ],
                      ),
                    );
                  }),
            ),
          ),
        ],
      ),
    );
  }
}
