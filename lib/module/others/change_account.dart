import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:qinglong_app/base/http/api.dart';
import 'package:qinglong_app/base/http/http.dart';
import 'package:qinglong_app/base/ql_app_bar.dart';
import 'package:qinglong_app/base/routes.dart';
import 'package:qinglong_app/base/theme.dart';
import 'package:qinglong_app/base/userinfo_viewmodel.dart';
import 'package:qinglong_app/utils/extension.dart';
import 'package:qinglong_app/utils/login_helper.dart';

import '../../main.dart';

class ChangeAccountPage extends ConsumerStatefulWidget {
  const ChangeAccountPage({Key? key}) : super(key: key);

  @override
  _ChangeAccountPageState createState() => _ChangeAccountPageState();
}

class _ChangeAccountPageState extends ConsumerState<ChangeAccountPage> {
  String isLoginingHost = "";
  String preHost = "";

  @override
  void initState() {
    super.initState();
    preHost = getIt<UserInfoViewModel>().historyAccounts.first.host ?? "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: QlAppBar(
        canBack: true,
        title: "切换账号",
      ),
      body: SingleChildScrollView(
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height / 10,
              ),
              Text(
                "轻触账号以切换登录",
                style: TextStyle(
                  color: ref.watch(themeProvider).themeColor.titleColor(),
                  fontSize: 25,
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 15,
                ),
                child: ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      if (index ==
                          getIt<UserInfoViewModel>().historyAccounts.length) {
                        return addAccount();
                      }
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          color: Colors.white,
                          child: buildCell(index),
                        ),
                      );
                    },
                    separatorBuilder: (_, __) {
                      return const SizedBox(
                        height: 10,
                      );
                    },
                    itemCount:
                        getIt<UserInfoViewModel>().historyAccounts.length + 1),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildCell(int index) {
    Widget child = ListTile(
      title: Text(
        getIt<UserInfoViewModel>().historyAccounts[index].host ?? "",
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 15,
      ),
      minVerticalPadding: 10,
      subtitle: Padding(
        padding: const EdgeInsets.only(top: 10.0),
        child: Text(
          getIt<UserInfoViewModel>().historyAccounts[index].userName ?? "",
        ),
      ),
      trailing: index == 0
          ? Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 5,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                border: Border.all(
                    color: ref.watch(themeProvider).primaryColor, width: 1),
              ),
              child: Text(
                "已登录",
                style: TextStyle(
                    color: ref.watch(themeProvider).primaryColor, fontSize: 12),
              ),
            )
          : (isLoginingHost.isNotEmpty
              ? SizedBox(
                  width: 15,
                  height: 15,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: ref.watch(themeProvider).primaryColor,
                  ),
                )
              : const SizedBox.shrink()),
    );

    if (getIt<UserInfoViewModel>().historyAccounts[index].host ==
        getIt<UserInfoViewModel>().host) {
      return child;
    }

    return Slidable(
      key: ValueKey(index),
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        extentRatio: 0.15,
        children: [
          SlidableAction(
            backgroundColor: Colors.red,
            flex: 1,
            onPressed: (_) {
              getIt<UserInfoViewModel>().removeHistoryAccount(
                  getIt<UserInfoViewModel>().historyAccounts[index].host);
              setState(() {});
            },
            foregroundColor: Colors.white,
            icon: CupertinoIcons.delete,
          ),
        ],
      ),
      child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            loginNewByBean(getIt<UserInfoViewModel>().historyAccounts[index]);
          },
          child: child),
    );
  }

  LoginHelper? helper;

  void loginNewByBean(UserInfoBean historyAccount) async {
    isLoginingHost = historyAccount.host ?? "";
    setState(() {});
    helper = LoginHelper(
      historyAccount.useSecretLogined,
      historyAccount.host ?? "",
      historyAccount.userName ?? "",
      historyAccount.password ?? "",
      true,
    );
    var response = await helper!.login();
    dealLoginResponse(response);
  }

  void dealLoginResponse(int response) {
    if (response == LoginHelper.success) {
      Navigator.of(context)
          .pushNamedAndRemoveUntil(Routes.routeHomePage, (_) => false);
    } else if (response == LoginHelper.failed) {
      loginFailed();
    } else {
      twoFact();
    }
  }

  void loginFailed() {
    isLoginingHost = "";
    Http.clear();
    getIt<UserInfoViewModel>().updateHost(preHost);
    setState(() {});
  }

  void twoFact() {
    String twoFact = "";
    showCupertinoDialog(
        context: context,
        builder: (_) => CupertinoAlertDialog(
              title: const Text("两步验证"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Material(
                    color: Colors.transparent,
                    child: TextField(
                      onChanged: (value) {
                        twoFact = value;
                      },
                      maxLines: 1,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                        hintText: "请输入code",
                      ),
                      autofocus: true,
                    ),
                  ),
                ],
              ),
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
                    Navigator.of(context).pop(true);
                    if (helper != null) {
                      var response = await helper!.loginTwice(twoFact);
                      dealLoginResponse(response);
                    } else {
                      "状态异常".toast();
                    }
                  },
                ),
              ],
            )).then((value) {
      if (value == null) {
        isLoginingHost = "";
        setState(() {});
      }
    });
  }

  Widget addAccount() {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        Navigator.of(context).pushNamedAndRemoveUntil(
          Routes.routeLogin,
          (_) => false,
          arguments: true,
        );
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.symmetric(
            vertical: 15,
            horizontal: 15,
          ),
          color: Colors.white,
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(
                    color: ref.watch(themeProvider).themeColor.descColor(),
                  ),
                ),
                child: Icon(
                  CupertinoIcons.add,
                  color: ref.watch(themeProvider).themeColor.descColor(),
                ),
              ),
              const SizedBox(
                width: 15,
              ),
              Text(
                "添加账号",
                style: TextStyle(
                  color: ref.watch(themeProvider).themeColor.titleColor(),
                  fontSize: 18,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
