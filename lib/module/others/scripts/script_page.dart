import 'package:flutter/material.dart';
import 'package:qinglong_app/base/ql_app_bar.dart';

/// @author NewTab
class ScriptPage extends StatefulWidget {
  const ScriptPage({Key? key}) : super(key: key);

  @override
  _ScriptPageState createState() => _ScriptPageState();
}

class _ScriptPageState extends State<ScriptPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: QlAppBar(
        canBack: true,
        backCall: () {
          Navigator.of(context).pop();
        },
        title: "脚本管理",
      ),
      body: Container(),
    );
  }
}
