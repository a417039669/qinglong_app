import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qinglong_app/base/base_state_widget.dart';
import 'package:qinglong_app/base/routes.dart';
import 'package:qinglong_app/base/ui/abs_underline_tabindicator.dart';
import 'package:qinglong_app/base/ui/empty_widget.dart';
import 'package:qinglong_app/main.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../base/ui/syntax_highlighter.dart';
import 'config_viewmodel.dart';

class ConfigPage extends StatefulWidget {
  const ConfigPage({Key? key}) : super(key: key);

  @override
  ConfigPageState createState() => ConfigPageState();
}

class ConfigPageState extends State<ConfigPage>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  int _initIndex = 0;
  BuildContext? childContext;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BaseStateWidget<ConfigViewModel>(
      builder: (ref, model, child) {
        if (model.list.isEmpty) {
          return const EmptyWidget();
        }

        return DefaultTabController(
          length: model.list.length,
          initialIndex: _initIndex,
          child: Builder(builder: (context) {
            childContext = context;
            return Column(
              children: [
                TabBar(
                  tabs: model.list
                      .map((e) => Tab(
                            text: e.title,
                          ))
                      .toList(),
                  isScrollable: true,
                  indicator: AbsUnderlineTabIndicator(
                    wantWidth: 20,
                    borderSide: BorderSide(
                      color: Theme.of(context).primaryColor,
                      width: 2,
                    ),
                  ),
                ),
                Expanded(
                  child: TabBarView(
                    children: model.list
                        .map(
                          (e) => CodeWidget(
                            content: model.content[e.title] ?? "",
                          ),
                        )
                        .toList(),
                  ),
                ),
              ],
            );
          }),
        );
      },
      model: configProvider,
      onReady: (viewModel) {
        viewModel.loadData();
      },
    );
  }

  void editMe(WidgetRef ref) {
    if (childContext == null) return;
    navigatorState.currentState?.pushNamed(Routes.routeConfigEdit, arguments: {
      "title": ref
          .read(configProvider)
          .list[DefaultTabController.of(childContext!)?.index ?? 0]
          .title,
      "content": ref.read(configProvider).content[ref
          .read(configProvider)
          .list[DefaultTabController.of(childContext!)?.index ?? 0]
          .title]
    }).then((value) async {
      if (value != null && (value as String).isNotEmpty) {
        await ref.read(configProvider).loadContent(value);
        setState(() {});
      }
    });
  }

  @override
  bool get wantKeepAlive => true;
}

class CodeWidget extends StatefulWidget {
  final String content;

  const CodeWidget({
    Key? key,
    required this.content,
  }) : super(key: key);

  @override
  State<CodeWidget> createState() => _CodeWidgetState();
}

class _CodeWidgetState extends State<CodeWidget>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    return SelectableText.rich(
      TextSpan(
        style: GoogleFonts.droidSansMono(fontSize: 14).apply(
          fontSizeFactor: 1,
        ),
        children: <TextSpan>[
          DartSyntaxHighlighter(SyntaxHighlighterStyle.lightThemeStyle())
              .format(widget.content)
        ],
      ),
      style: DefaultTextStyle.of(context).style.apply(
            fontSizeFactor: 1,
          ),
      selectionWidthStyle: BoxWidthStyle.max,
      selectionHeightStyle: BoxHeightStyle.max,
      autofocus: true,
    );
  }

  @override
  bool get wantKeepAlive => true;
}
