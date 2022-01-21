import 'package:dio_log/dio_log.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qinglong_app/base/http/api.dart';
import 'package:qinglong_app/base/http/http.dart';
import 'package:qinglong_app/base/routes.dart';
import 'package:qinglong_app/base/theme.dart';
import 'package:qinglong_app/base/userinfo_viewmodel.dart';
import 'package:qinglong_app/main.dart';
import 'package:qinglong_app/module/login/user_bean.dart';
import 'package:qinglong_app/utils/extension.dart';
import 'package:qinglong_app/utils/update_utils.dart';
import 'package:qinglong_app/utils/utils.dart';
import 'package:flip_card/flip_card.dart';

import 'login_bean.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final TextEditingController _hostController = TextEditingController(text: getIt<UserInfoViewModel>().host);
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _cIdController = TextEditingController();
  final TextEditingController _cSecretController = TextEditingController();
  GlobalKey<FlipCardState> cardKey = GlobalKey<FlipCardState>();

  bool rememberPassword = false;

  bool useSecretLogin = false;

  @override
  void initState() {
    super.initState();
    useSecretLogin = getIt<UserInfoViewModel>().useSecretLogined;

    if (getIt<UserInfoViewModel>().userName != null && getIt<UserInfoViewModel>().userName!.isNotEmpty) {
      if (getIt<UserInfoViewModel>().useSecretLogined) {
        _cIdController.text = getIt<UserInfoViewModel>().userName!;
      } else {
        _userNameController.text = getIt<UserInfoViewModel>().userName!;
      }
      rememberPassword = true;
    } else {
      rememberPassword = false;
    }
    if (getIt<UserInfoViewModel>().passWord != null && getIt<UserInfoViewModel>().passWord!.isNotEmpty) {
      if (getIt<UserInfoViewModel>().useSecretLogined) {
        _cSecretController.text = getIt<UserInfoViewModel>().passWord!;
      } else {
        _passwordController.text = getIt<UserInfoViewModel>().passWord!;
      }
    }
    getIt<UserInfoViewModel>().updateToken("");
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      update();
      if (useSecretLogin) {
        cardKey.currentState?.toggleCard();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: ref.watch(themeProvider).themeColor.settingBgColor(),
      child: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: [
            Positioned(
              bottom: 0,
              child: Image.asset(
                "assets/images/login_bg.png",
                width: MediaQuery.of(context).size.width,
              ),
            ),
            Scaffold(
              backgroundColor: Colors.transparent,
              body: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 40,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: MediaQuery.of(context).size.height / 8,
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Image.asset(
                                    "assets/images/login_tip.png",
                                    height: 45,
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onDoubleTap: () {
                                  if (debugBtnIsShow()) {
                                    dismissDebugBtn();
                                  } else {
                                    showDebugBtn(context, btnColor: Colors.blue);
                                  }
                                  WidgetsBinding.instance?.endOfFrame;
                                },
                                child: Image.asset(
                                  "assets/images/ql.png",
                                  height: 45,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height / 15,
                          ),
                          const Text(
                            "域名:",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          TextField(
                            onChanged: (_) {
                              setState(() {});
                            },
                            controller: _hostController,
                            decoration: const InputDecoration(
                              contentPadding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                              hintText: "http://1.1.1.1:5700",
                            ),
                            autofocus: false,
                          ),
                          FlipCard(
                            key: cardKey,
                            onFlipDone: (back) {
                              useSecretLogin = back;
                              setState(() {});
                            },
                            direction: FlipDirection.HORIZONTAL,
                            front: SizedBox(
                              height: 200,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  const Text(
                                    "用户名:",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  TextField(
                                    onChanged: (_) {
                                      setState(() {});
                                    },
                                    controller: _userNameController,
                                    decoration: const InputDecoration(
                                      contentPadding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                                      hintText: "请输入用户名",
                                    ),
                                    autofocus: false,
                                  ),
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  const Text(
                                    "密码:",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  TextField(
                                    onChanged: (_) {
                                      setState(() {});
                                    },
                                    controller: _passwordController,
                                    obscureText: true,
                                    decoration: const InputDecoration(
                                      contentPadding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                                      hintText: "请输入密码",
                                    ),
                                    autofocus: false,
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                ],
                              ),
                            ),
                            back: SizedBox(
                              height: 200,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  const Text(
                                    "client_id:",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  TextField(
                                    onChanged: (_) {
                                      setState(() {});
                                    },
                                    controller: _cIdController,
                                    decoration: const InputDecoration(
                                      contentPadding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                                      hintText: "请输入client_id",
                                    ),
                                    autofocus: false,
                                  ),
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  const Text(
                                    "client_secret:",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  TextField(
                                    onChanged: (_) {
                                      setState(() {});
                                    },
                                    controller: _cSecretController,
                                    obscureText: true,
                                    decoration: const InputDecoration(
                                      contentPadding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                                      hintText: "请输入client_secret",
                                    ),
                                    autofocus: false,
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 25,
                      ),
                      child: Row(
                        children: [
                          Checkbox(
                            value: rememberPassword,
                            onChanged: (checked) {
                              rememberPassword = checked ?? false;
                              setState(() {});
                            },
                          ),
                          const Text(
                            "记住密码/client",
                            style: TextStyle(
                              fontSize: 14,
                            ),
                          ),
                          const Spacer(),
                          GestureDetector(
                            onTap: () {
                              cardKey.currentState?.toggleCard();
                              WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
                                setState(() {});
                              });
                            },
                            child: Text(
                              loginByUserName() ? "client_id登录" : "用户名密码登录",
                              style: const TextStyle(
                                fontSize: 14,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 40,
                      ),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width - 80,
                        child: IgnorePointer(
                          ignoring: !canClickLoginBtn(),
                          child: CupertinoButton(
                            padding: const EdgeInsets.symmetric(
                              vertical: 5,
                            ),
                            color: canClickLoginBtn() ? primaryColor : primaryColor.withOpacity(0.4),
                            child: isLoading
                                ? const CupertinoActivityIndicator()
                                : const Text(
                                    "登 录",
                                    style: TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                            onPressed: () {
                              Http.pushedLoginPage = false;
                              Utils.hideKeyBoard(context);
                              getIt<UserInfoViewModel>().updateHost(_hostController.text);
                              Http.clear();
                              if (loginByUserName()) {
                                login(_userNameController.text, _passwordController.text);
                              } else {
                                login(_cIdController.text, _cSecretController.text);
                              }
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool isLoading = false;

  bool loginByUserName() {
    return !useSecretLogin;
  }

  Future<void> login(String userName, String password) async {
    isLoading = true;
    setState(() {});
    HttpResponse<LoginBean> response;

    if (loginByUserName()) {
      response = await Api.login(userName, password);
    } else {
      response = await Api.loginByClientId(userName, password);
    }
    if (response.success) {
      loginSuccess(response, userName, password);
    } else if (loginByUserName() && response.code == 401) {
      //可能用户使用的是老版本qinglong
      HttpResponse<LoginBean> oldResponse = await Api.loginOld(userName, password);
      if (oldResponse.success) {
        loginSuccess(oldResponse, userName, password);
      } else {
        (oldResponse.message ?? "请检查网络情况").toast();
        if (oldResponse.code == 420) {
          twoFact(userName, password);
        } else {
          isLoading = false;
          setState(() {});
        }
      }
    } else {
      print(response.code);
      (response.message ?? "请检查网络情况").toast();
      //420代表需要2步验证
      if (response.code == 420) {
        twoFact(userName, password);
      } else {
        isLoading = false;
        setState(() {});
      }
    }
  }

  void loginFailed(HttpResponse<LoginBean> response) {
    (response.message ?? "请检查网络情况").toast();
    isLoading = false;
    setState(() {});
  }

  void loginSuccess(HttpResponse<LoginBean> response, String userName, String password) {
    getIt<UserInfoViewModel>().updateToken(response.bean?.token ?? "");
    getIt<UserInfoViewModel>().useSecretLogin(!loginByUserName());
    if (rememberPassword) {
      getIt<UserInfoViewModel>().updateUserName(userName, password);
    } else {
      getIt<UserInfoViewModel>().updateUserName("", "");
    }
    Navigator.of(context).pushReplacementNamed(Routes.routeHomePage);
  }

  bool canClickLoginBtn() {
    if (isLoading) return false;

    if (_hostController.text.isEmpty) return false;
    if (!loginByUserName()) {
      return _cIdController.text.isNotEmpty && _cSecretController.text.isNotEmpty;
    } else {
      return _userNameController.text.isNotEmpty && _passwordController.text.isNotEmpty;
    }
  }

  void twoFact(String userName, String password) {
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
                      color: primaryColor,
                    ),
                  ),
                  onPressed: () async {
                    Navigator.of(context).pop(true);
                    HttpResponse<LoginBean> response = await Api.loginTwo(userName, password, twoFact);
                    if (response.success) {
                      loginSuccess(response, userName, password);
                    } else {
                      loginFailed(response);
                    }
                  },
                ),
              ],
            )).then((value) {
      if (value == null) {
        isLoading = false;
        setState(() {});
      }
    });
  }

  void update() async {
    String? result = await UpdateUtils().checkUpdate();
    if (result != null && result.isNotEmpty) {
      UpdateDialog updateDialog = UpdateDialog(context, title: "发现新版本", updateContent: "版本号:v${result}", onUpdate: () {
        UpdateUtils.launchURL(result);
      });
      updateDialog.show();
    }
  }
}
