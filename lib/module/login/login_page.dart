import 'package:dio_log/dio_log.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qinglong_app/base/routes.dart';
import 'package:qinglong_app/main.dart';
import 'package:qinglong_app/module/login/login_viewmodel.dart';
import 'package:qinglong_app/utils/utils.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _hostController = TextEditingController(text: userInfoViewModel.host);
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    showDebugBtn(context, btnColor: Colors.blue);
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
        return SizedBox(
          height: MediaQuery.of(context).size.height,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height / 3,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 15,
                  ),
                  child: Row(
                    children: [
                      const SizedBox(
                        child: Text(
                          "域名:",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        width: 60,
                      ),
                      const SizedBox(
                        width: 15,
                      ),
                      Expanded(
                        child: TextField(
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
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 15,
                  ),
                  child: Row(
                    children: [
                      const SizedBox(
                        child: Text(
                          "用户名:",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        width: 60,
                      ),
                      const SizedBox(
                        width: 15,
                      ),
                      Expanded(
                        child: TextField(

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
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 10,
                  ),
                  child: Row(
                    children: [
                      const SizedBox(
                        child: Text(
                          "密码:",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        width: 60,
                      ),
                      const SizedBox(
                        width: 15,
                      ),
                      Expanded(
                        child: TextField(
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
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width - 30,
                  child: CupertinoButton(
                      color: (_hostController.text.isNotEmpty && _userNameController.text.isNotEmpty && _passwordController.text.isNotEmpty && !model.isLoading)
                          ? Theme.of(context).primaryColor
                          : Theme.of(context).primaryColor.withOpacity(0.3),
                      child: model.isLoading
                          ? const CupertinoActivityIndicator()
                          : const Text(
                              "登录",
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),
                      onPressed: () {
                        if (model.isLoading) return;
                        Utils.hideKeyBoard(context);
                        userInfoViewModel.updateHost(_hostController.text);
                        model.login(_userNameController.text, _passwordController.text);
                      }),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
