import 'package:code_editor/code_editor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qinglong_app/base/common_dialog.dart';
import 'package:qinglong_app/base/http/api.dart';
import 'package:qinglong_app/base/http/http.dart';
import 'package:qinglong_app/base/ql_app_bar.dart';
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

  @override
  Widget build(BuildContext context) {
    List<FileEditor> files = [
      FileEditor(
        name: widget.title,
        language: "sh",
        code: widget.content, // [code] needs a string
      ),
    ];
    EditorModel editMode = EditorModel(
      files: files,
      styleOptions: EditorModelStyleOptions(
        fontSize: 13,
      ),
    );
    return Scaffold(
      appBar: QlAppBar(
        canBack: true,
        backCall: () {
          Navigator.of(context).pop();
        },
        title: '编辑文件',
        actions: [
          InkWell(
            onTap: () async {
              if (value == null) {
                failDialog(context, "请先点击保存");
                return;
              }
              HttpResponse<NullResponse> response = await Api.saveFile(widget.title, value!);
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
        child: CodeEditor(
          model: editMode,
          edit: true,
          onSubmit: (title, v) {
            value = v;
          },
          disableNavigationbar: false,
        ),
      ),
    );
  }
}
