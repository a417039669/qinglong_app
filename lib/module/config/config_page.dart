import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qinglong_app/base/base_state_widget.dart';
import 'package:code_editor/code_editor.dart';
import 'package:qinglong_app/base/routes.dart';
import 'package:qinglong_app/base/theme.dart';

import 'config_viewmodel.dart';

class ConfigPage extends StatefulWidget {
  const ConfigPage({Key? key}) : super(key: key);

  @override
  _ConfigPageState createState() => _ConfigPageState();
}

class _ConfigPageState extends State<ConfigPage> {
  final myController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BaseStateWidget<ConfigViewModel>(
      builder: (ref, model, child) {
        List<FileEditor> files = [
          FileEditor(
            name: model.title,
            language: "sh",
            code: model.content, // [code] needs a string
          ),
        ];
        EditorModel editMode = EditorModel(
          files: files,
          styleOptions: EditorModelStyleOptions(
            fontSize: 13,
            heightOfContainer: MediaQuery.of(context).size.height - kToolbarHeight - kBottomNavigationBarHeight - 150,
          ),
        );
        myController.text = model.content;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                DropdownButton<String>(
                  value: model.title,
                  items: model.list
                      .map(
                        (e) => DropdownMenuItem<String>(
                          value: e.value ?? "",
                          child: Text(e.value ?? ""),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    model.loadContent(value!);
                  },
                ),
                const Spacer(),
                CupertinoButton(
                    child: const Text("编辑"),
                    onPressed: () {
                      Navigator.of(context).pushNamed(Routes.route_ConfigEdit, arguments: {
                        "title": model.title,
                        "content": model.content,
                      });
                    }),
              ],
            ),
            Expanded(
              child: CodeEditor(
                model: editMode,
                edit: false,
                textEditingController: myController,
                disableNavigationbar: false,
              ),
            ),
          ],
        );
      },
      model: configProvider,
      onReady: (viewModel) {
        viewModel.loadData();
      },
    );
  }
}
