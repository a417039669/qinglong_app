import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qinglong_app/base/theme.dart';

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
                  padding: const EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 15,
                  ),
                  child: Row(
                    children: [
                      Text(
                        "查看日志",
                        style: TextStyle(
                          color: ref.watch(themeProvider).themeColor.taskTitleColor(),
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
                Divider(
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
                        "查看日志",
                        style: TextStyle(
                          color: ref.watch(themeProvider).themeColor.taskTitleColor(),
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
                Divider(
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
                        "查看日志",
                        style: TextStyle(
                          color: ref.watch(themeProvider).themeColor.taskTitleColor(),
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
                    bottom: 0,
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
                          color: ref.watch(themeProvider).themeColor.taskTitleColor(),
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
                        "查看日志",
                        style: TextStyle(
                          color: ref.watch(themeProvider).themeColor.taskTitleColor(),
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
                Divider(
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
                        "查看日志",
                        style: TextStyle(
                          color: ref.watch(themeProvider).themeColor.taskTitleColor(),
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
        ],
      ),
    );
  }
}
