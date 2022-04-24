import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qinglong_app/base/http/api.dart';
import 'package:qinglong_app/base/http/http.dart';
import 'package:qinglong_app/base/ql_app_bar.dart';
import 'package:qinglong_app/base/theme.dart';
import 'package:qinglong_app/module/config/config_page.dart';
import 'package:qinglong_app/module/config/config_viewmodel.dart';
import 'package:qinglong_app/utils/extension.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../base/ui/syntax_highlighter.dart';

class ConfigEditPage extends ConsumerStatefulWidget {
  final String content;
  final String title;

  const ConfigEditPage(this.title, this.content, {Key? key}) : super(key: key);

  @override
  _ConfigEditPageState createState() => _ConfigEditPageState();
}

class _ConfigEditPageState extends ConsumerState<ConfigEditPage> {
  String text = "";
  String pre_text = "";

  @override
  void initState() {
    super.initState();
    text = widget.content;
    pre_text = widget.content;
  }

  void replaceText(String oldText, String newText) {
    pre_text = text;

    if (oldText.isEmpty) {
      text = text + newText;
    } else {
      if (text.contains(oldText)) {
        text = text.replaceAll(oldText, newText);
      }
    }
    setState(() {});
  }

  void clearText() {
    pre_text = text;
    text = "";
    setState(() {});
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
              HttpResponse<NullResponse> response =
                  await Api.saveFile(widget.title, text);
              if (response.success) {
                "提交成功".toast();
                ref.read(configProvider).loadContent(widget.title);
                Navigator.of(context).pop(widget.title);
              } else {
                (response.message ?? "").toast();
              }
            },
            child: const Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 15,
              ),
              child: Center(
                child: Text(
                  "提交",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 10,
            ),
            child: SizedBox(
              height: 30,
              child: ListView(
                padding: EdgeInsets.symmetric(
                  horizontal: 15,
                ),
                scrollDirection: Axis.horizontal,
                children: [
                  GestureDetector(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 5,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(
                            color: ref.watch(themeProvider).primaryColor,
                            width: 1),
                      ),
                      child: Text(
                        "插入",
                        style: TextStyle(
                          color: ref.watch(themeProvider).primaryColor,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    onTap: () {
                      edit("插入内容", "", "请输入插入的内容,换行符自己添加");
                    },
                    behavior: HitTestBehavior.opaque,
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  GestureDetector(
                    onTap: () {
                      edit("替换内容", "原内容", "新内容");
                    },
                    behavior: HitTestBehavior.opaque,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 5,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(
                            color: ref.watch(themeProvider).primaryColor,
                            width: 1),
                      ),
                      child: Text(
                        "替换",
                        style: TextStyle(
                          color: ref.watch(themeProvider).primaryColor,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  GestureDetector(
                    onTap: () {
                      edit("删除内容", "输入要删除的内容", "");
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 5,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(
                            color: ref.watch(themeProvider).primaryColor,
                            width: 1),
                      ),
                      child: Text(
                        "删除",
                        style: TextStyle(
                          color: ref.watch(themeProvider).primaryColor,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  GestureDetector(
                    onTap: () {
                      clearText();
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 5,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(
                            color: ref.watch(themeProvider).primaryColor,
                            width: 1),
                      ),
                      child: Text(
                        "清空",
                        style: TextStyle(
                          color: ref.watch(themeProvider).primaryColor,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  GestureDetector(
                    onTap: () {
                      text = pre_text;
                      setState(() {});
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 5,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(
                            color: ref.watch(themeProvider).primaryColor,
                            width: 1),
                      ),
                      child: Text(
                        "撤销本次操作",
                        style: TextStyle(
                          color: ref.watch(themeProvider).primaryColor,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: CodeWidget(content: text,),
          ),
        ],
      ),
    );
  }

  void edit(String title, String oldDesc, String newDesc) {
    String oldText = "";
    String newText = "";
    showCupertinoDialog(
      context: context,
      builder: (_) => CupertinoAlertDialog(
        title: Text(title),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            oldDesc.isNotEmpty
                ? Material(
                    color: Colors.transparent,
                    child: TextField(
                      onChanged: (value) {
                        oldText = value;
                      },
                      maxLines: 3,
                      minLines: 1,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                        hintText: oldDesc,
                      ),
                      autofocus: true,
                    ),
                  )
                : const SizedBox.shrink(),
            newDesc.isNotEmpty
                ? Material(
                    color: Colors.transparent,
                    child: TextField(
                      onChanged: (value) {
                        newText = value;
                      },
                      maxLines: 3,
                      minLines: 1,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                        hintText: newDesc,
                      ),
                      autofocus: true,
                    ),
                  )
                : const SizedBox.shrink(),
          ],
        ),
        actions: [
          CupertinoDialogAction(
            child: const Text(
              "取消",
              style: TextStyle(
                color: Color(0xff999999),
              ),
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          CupertinoDialogAction(
            child: Text(
              "确定",
              style: TextStyle(
                color: ref.watch(themeProvider).primaryColor,
              ),
            ),
            onPressed: () async {
              Navigator.of(context).pop(true);
              replaceText(oldText, newText);
            },
          ),
        ],
      ),
    );
  }
}
