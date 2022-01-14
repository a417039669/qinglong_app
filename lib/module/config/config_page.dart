import 'package:flutter/material.dart';
import 'package:qinglong_app/base/base_state_widget.dart';
import 'package:code_editor/code_editor.dart';
import 'package:qinglong_app/base/theme.dart';
import 'package:qinglong_app/utils/qinglong_theme.dart';

import 'config_viewmodel.dart';

class ConfigPage extends StatefulWidget {
  const ConfigPage({Key? key}) : super(key: key);

  @override
  _ConfigPageState createState() => _ConfigPageState();
}

class _ConfigPageState extends State<ConfigPage> {
  @override
  Widget build(BuildContext context) {
    return BaseStateWidget<ConfigViewModel>(
      builder: (ref, model, child) {
        List<FileEditor> files = model.list
            .map(
              (e) => FileEditor(
                name: e.title,
                language: "sh",
                code: model.content[e.title], // [code] needs a string
              ),
            )
            .toList();
        EditorModel editMode = EditorModel(
          files: files,
          styleOptions: EditorModelStyleOptions(
            fontSize: 13,
            heightOfContainer: MediaQuery.of(context).size.height - kToolbarHeight - kBottomNavigationBarHeight - 90,
            editorBorderColor: Theme.of(context).scaffoldBackgroundColor,
            editButtonBackgroundColor: Theme.of(context).scaffoldBackgroundColor,
            editorColor: Theme.of(context).scaffoldBackgroundColor,
            editorFilenameColor: Theme.of(context).primaryColor,
            theme: ref.watch(themeProvider).themeColor.codeEditorTheme(),
          ),
        );
        return CodeEditor(
          model: editMode,
          edit: false,
          disableNavigationbar: false,
        );
      },
      model: configProvider,
      onReady: (viewModel) {
        viewModel.loadData();
      },
    );
  }
}
