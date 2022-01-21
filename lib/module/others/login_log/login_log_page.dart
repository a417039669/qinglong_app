import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qinglong_app/base/http/api.dart';
import 'package:qinglong_app/base/http/http.dart';
import 'package:qinglong_app/base/ql_app_bar.dart';
import 'package:qinglong_app/base/theme.dart';
import 'package:qinglong_app/base/ui/lazy_load_state.dart';
import 'package:qinglong_app/utils/extension.dart';
import 'package:qinglong_app/utils/utils.dart';

import 'login_log_bean.dart';

/// @author NewTab
class LoginLogPage extends ConsumerStatefulWidget {
  const LoginLogPage({Key? key}) : super(key: key);

  @override
  _LoginLogPageState createState() => _LoginLogPageState();
}

class _LoginLogPageState extends ConsumerState<LoginLogPage> with LazyLoadState<LoginLogPage> {
  List<LoginLogBean> list = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: QlAppBar(
        canBack: true,
        backCall: () {
          Navigator.of(context).pop();
        },
        title: "登录日志",
      ),
      body: list.isEmpty
          ? const Center(
              child: CupertinoActivityIndicator(),
            )
          : ListView.builder(
              itemBuilder: (context, index) {
                LoginLogBean item = list[index];

                return ColoredBox(
                  color: ref.watch(themeProvider).themeColor.settingBgColor(),
                  child: ListTile(
                    isThreeLine: true,
                    title: Text(
                      Utils.formatMessageTime(item.timestamp ?? 0),
                      style: TextStyle(
                        fontSize: 16,
                        color: ref.watch(themeProvider).themeColor.titleColor(),
                      ),
                    ),
                    subtitle: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 5,
                        ),
                        SelectableText(
                          "${item.address}",
                          selectionWidthStyle: BoxWidthStyle.max,
                          selectionHeightStyle: BoxHeightStyle.max,
                          style: TextStyle(
                            color: ref.watch(themeProvider).themeColor.descColor(),
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        SelectableText(
                          "${item.ip}",
                          selectionWidthStyle: BoxWidthStyle.max,
                          selectionHeightStyle: BoxHeightStyle.max,
                          style: TextStyle(
                            color: ref.watch(themeProvider).themeColor.descColor(),
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    trailing: item.status == 0
                        ? Icon(
                            CupertinoIcons.checkmark_circle,
                            color: ref.watch(themeProvider).primaryColor,
                            size: 16,
                          )
                        : const Icon(
                            CupertinoIcons.clear_circled,
                            color: Colors.red,
                            size: 16,
                          ),
                  ),
                );
              },
              itemCount: list.length,
            ),
    );
  }

  Future<void> loadData() async {
    HttpResponse<List<LoginLogBean>> response = await Api.loginLog();

    if (response.success) {
      list.clear();
      list.addAll(response.bean ?? []);
      setState(() {});
    } else {
      response.message?.toast();
    }
  }

  @override
  void onLazyLoad() {
    loadData();
  }
}
