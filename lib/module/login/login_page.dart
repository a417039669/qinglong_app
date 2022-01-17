import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qinglong_app/base/common_dialog.dart';
import 'package:qinglong_app/base/http/http.dart';
import 'package:qinglong_app/base/routes.dart';
import 'package:qinglong_app/base/userinfo_viewmodel.dart';
import 'package:qinglong_app/main.dart';
import 'package:qinglong_app/module/login/login_viewmodel.dart';
import 'package:qinglong_app/utils/utils.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _hostController = TextEditingController(text: getIt<UserInfoViewModel>().host);
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getIt<UserInfoViewModel>().updateToken("");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer(builder: (context, ref, child) {
        var model = ref.watch<LoginViewModel>(loginProvider);

        if (model.loginSuccess) {
          WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
            Navigator.of(context).popAndPushNamed(Routes.route_HomePage);
          });
        }
        if (model.msg.isNotEmpty) {
          WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
            failDialog(context, model.msg);
            model.msg = "";
          });
        }
        return SizedBox(
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
              SingleChildScrollView(
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
                        height: MediaQuery.of(context).size.height / 10,
                      ),
                      const Text(
                        "域名:",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
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
                      const SizedBox(
                        height: 20,
                      ),
                      const Text(
                        "用户名:",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
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
                        height: 20,
                      ),
                      const Text(
                        "密码:",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
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
                        height: 30,
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width - 80,
                        child: IgnorePointer(
                          ignoring: _hostController.text.isEmpty || _userNameController.text.isEmpty || _passwordController.text.isEmpty || model.isLoading,
                          child: CupertinoButton(
                              color: (_hostController.text.isNotEmpty &&
                                      _userNameController.text.isNotEmpty &&
                                      _passwordController.text.isNotEmpty &&
                                      !model.isLoading)
                                  ? Theme.of(context).primaryColor
                                  : Theme.of(context).primaryColor.withOpacity(0.4),
                              child: model.isLoading
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
                                model.login(_userNameController.text, _passwordController.text);
                              }),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
