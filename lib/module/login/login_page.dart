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

  @override
  void initState() {
    super.initState();

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
      if (getIt<UserInfoViewModel>().useSecretLogined) {
        cardKey.currentState?.toggleCard();
        getIt<UserInfoViewModel>().useSecretLogin(!(cardKey.currentState?.isFront ?? true));
        WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
          setState(() {});
        });
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
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height / 10,
                      ),
                      SizedBox(
                        height: 50,
                        width: MediaQuery.of(context).size.width,
                        child: Stack(
                          children: [
                            Positioned(
                              top: 0,
                              left: 0,
                              child: Image.asset(
                                "assets/images/login_tip.png",
                                height: 45,
                              ),
                            ),
                            const Positioned(
                              top: 10,
                              left: 0,
                              child: Text(
                                "登录",
                                style: TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Positioned(
                              top: 5,
                              right: 0,
                              child: Image.asset(
                                "assets/images/ql.png",
                                height: 45,
                              ),
                            ),
                          ],
                        ),
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
                        fill: Fill.fillBack,
                        // Fill the back side of the card to make in the same size as the front.
                        direction: FlipDirection.HORIZONTAL,
                        front: Column(
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
                        back: Column(
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
                      Row(
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
                              (cardKey.currentState?.isFront ?? true) ? "client_id登录" : "用户名密码登录",
                              style: const TextStyle(
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width - 80,
                        child: IgnorePointer(
                          ignoring: _hostController.text.isEmpty || _userNameController.text.isEmpty || _passwordController.text.isEmpty || isLoading,
                          child: CupertinoButton(
                            padding: const EdgeInsets.symmetric(
                              vertical: 5,
                            ),
                            color: canClickLoginBtn() ? ref.watch(themeProvider).themeColor.buttonBgColor() : Theme.of(context).primaryColor.withOpacity(0.4),
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
                              if (cardKey.currentState?.isFront ?? true) {
                                login(_userNameController.text, _passwordController.text);
                              } else {
                                login(_cIdController.text, _cSecretController.text);
                              }
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
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
    return !getIt<UserInfoViewModel>().useSecretLogined;
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
      getIt<UserInfoViewModel>().updateToken(response.bean?.token ?? "");
      getIt<UserInfoViewModel>().useSecretLogin(!loginByUserName());
      if (rememberPassword) {
        getIt<UserInfoViewModel>().updateUserName(userName, password);
      }

      if (!loginByUserName()) {
        Navigator.of(context).pushReplacementNamed(Routes.routeHomePage);
      } else {
        HttpResponse<UserBean> userResponse = await Api.user();
        if (userResponse.success) {
          if (userResponse.bean != null && userResponse.bean!.twoFactorActivated != null && userResponse.bean!.twoFactorActivated!) {
            ("你已开启两步验证,App暂不支持").toast();
            isLoading = false;
            setState(() {});
          } else {
            Navigator.of(context).pushReplacementNamed(Routes.routeHomePage);
          }
        } else {
          (response.message ?? "请检查网络情况").toast();
          isLoading = false;
          setState(() {});
        }
      }
    } else {
      (response.message ?? "请检查网络情况").toast();
      isLoading = false;
      setState(() {});
    }
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
}
