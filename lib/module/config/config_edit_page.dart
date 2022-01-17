import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qinglong_app/base/common_dialog.dart';
import 'package:qinglong_app/base/http/api.dart';
import 'package:qinglong_app/base/http/http.dart';
import 'package:qinglong_app/base/ql_app_bar.dart';
import 'package:qinglong_app/base/theme.dart';
import 'package:qinglong_app/module/config/config_viewmodel.dart';

class ConfigEditPage extends ConsumerStatefulWidget {
  final String content;
  final String title;

  const ConfigEditPage(this.title, this.content, {Key? key}) : super(key: key);

  @override
  _ConfigEditPageState createState() => _ConfigEditPageState();
}

class _ConfigEditPageState extends ConsumerState<ConfigEditPage> {
  String? value;

  late TextEditingController _controller;

  @override
  void initState() {
    _controller = TextEditingController(text: widget.content);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: QlAppBar(
        canBack: true,
        backCall: () {
          Navigator.of(context).pop();
        },
        title: '编辑${widget.title}',
        actions: [
          InkWell(
            onTap: () async {
              if (value == null) {
                failDialog(context, "请先点击保存");
                return;
              }
              HttpResponse<NullResponse> response = await Api.saveFile(widget.title, _controller.text);
              if (response.success) {
                ref.read(configProvider).loadContent(widget.title);
                Navigator.of(context).pop();
              } else {
                failDialog(context, response.message ?? "");
              }
            },
            child: const Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 15,
              ),
              child: Center(
                child: Text("提交"),
              ),
            ),
          )
        ],
      ),
      body: Container(
        padding: const EdgeInsets.only(
          left: 15,
          right: 15,
        ),
        child: SingleChildScrollView(
          child: TextField(
            focusNode: FocusNode(),
            style: TextStyle(
              color: ref.read(themeProvider).themeColor.descColor(),
              fontSize: 14,
            ),
            controller: _controller,
            minLines: 1,
            maxLines: 100,
          ),
        ),
      ),
    );
  }
}
