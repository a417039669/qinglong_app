import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qinglong_app/base/base_state_widget.dart';
import 'package:qinglong_app/base/code_editor/code_editor.dart';
import 'package:qinglong_app/base/code_editor/EditorModel.dart';
import 'package:qinglong_app/base/code_editor/EditorModelStyleOptions.dart';
import 'package:qinglong_app/base/code_editor/FileEditor.dart';
import 'package:qinglong_app/base/http/url.dart';
import 'package:qinglong_app/base/routes.dart';
import 'package:qinglong_app/base/theme.dart';
import 'package:qinglong_app/main.dart';

import 'config_viewmodel.dart';

class ConfigPage extends StatefulWidget {
  const ConfigPage({Key? key}) : super(key: key);

  @override
  ConfigPageState createState() => ConfigPageState();
}

class ConfigPageState extends State<ConfigPage> {
  GlobalKey<CodeEditorState> globalKey = GlobalKey();

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
            editorNormalFilenameColor: ref.read(themeProvider).themeColor.descColor(),
            heightOfContainer: MediaQuery.of(context).size.height - kToolbarHeight - kBottomNavigationBarHeight - 90,
            editorBorderColor: Theme.of(context).scaffoldBackgroundColor,
            editButtonBackgroundColor: Theme.of(context).scaffoldBackgroundColor,
            editorColor: Theme.of(context).scaffoldBackgroundColor,
            editorFilenameColor: Theme.of(context).primaryColor,
            theme: ref.watch(themeProvider).themeColor.codeEditorTheme(),
          ),
        );
        return CodeEditor(
          key: globalKey,
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

  void editMe(WidgetRef ref) {
    int index = globalKey.currentState?.getCurrentIndex() ?? 0;

    navigatorState.currentState?.pushNamed(Routes.route_ConfigEdit,
        arguments: {"title": ref.read(configProvider).list[index].title, "content": ref.read(configProvider).content[ref.read(configProvider).list[index].title]});
  }
}
