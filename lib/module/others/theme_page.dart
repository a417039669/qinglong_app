import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qinglong_app/base/ql_app_bar.dart';
import 'package:qinglong_app/base/theme.dart';

class ThemePage extends ConsumerStatefulWidget {
  const ThemePage({Key? key}) : super(key: key);

  @override
  _ThemePageState createState() => _ThemePageState();
}

class _ThemePageState extends ConsumerState<ThemePage> {
  late Color _primaryColor;
  List<Color> colors = [];
  double colorHeight = 40;
  double smallColorHeight = 8;

  @override
  void initState() {
    super.initState();
    _primaryColor = ref.read(themeProvider).primaryColor;
    colors.add(const Color(0xFF299343));
    colors.addAll([
      Colors.red,
      Colors.pink,
      Colors.purple,
      Colors.deepPurple,
      Colors.indigo,
      Colors.blue,
      Colors.lightBlue,
      Colors.cyan,
      Colors.teal,
      Colors.green,
      Colors.lightGreen,
      Colors.lime,
      Colors.yellow,
      Colors.amber,
      Colors.orange,
      Colors.deepOrange,
      Colors.brown,
      Colors.blueGrey,
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff999999),
      appBar: QlAppBar(
        title: '主题设置',
        canBack: true,
        actions: [
          InkWell(
            onTap: () {
              submit();
            },
            child: const Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 15,
              ),
              child: Center(
                child: Text(
                  "保存",
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
          const SizedBox(
            height: 15,
          ),
          Expanded(
            child: SizedBox(
              height:
                  MediaQuery.of(context).size.height * 3 / 4 - kToolbarHeight,
              child: Row(
                children: [
                  const SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: Scaffold(
                        appBar: AppBar(
                          backgroundColor: _primaryColor,
                          title: Text("示例页面"),
                          elevation: 0,
                          automaticallyImplyLeading: false,
                          centerTitle: true,
                        ),
                        body: ListView.builder(
                          itemBuilder: (context, index) {
                            return Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  color: index == 0
                                      ? ref
                                          .watch(themeProvider)
                                          .themeColor
                                          .pinColor()
                                      : Colors.transparent,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 15,
                                    vertical: 8,
                                  ),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Expanded(
                                            child: Row(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Random().nextBool()
                                                    ? const SizedBox.shrink()
                                                    : SizedBox(
                                                        width: 15,
                                                        height: 15,
                                                        child:
                                                            CircularProgressIndicator(
                                                          strokeWidth: 2,
                                                          color: _primaryColor,
                                                        ),
                                                      ),
                                                SizedBox(
                                                  width: Random().nextBool()
                                                      ? 0
                                                      : 5,
                                                ),
                                                Expanded(
                                                  child: Material(
                                                    color: Colors.transparent,
                                                    child: Text(
                                                      "示例名称",
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        color: ref
                                                            .watch(
                                                                themeProvider)
                                                            .themeColor
                                                            .titleColor(),
                                                        fontSize: 18,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Material(
                                            color: Colors.transparent,
                                            child: Text(
                                              "上午10：00",
                                              maxLines: 1,
                                              style: TextStyle(
                                                overflow: TextOverflow.ellipsis,
                                                color: ref
                                                    .watch(themeProvider)
                                                    .themeColor
                                                    .descColor(),
                                                fontSize: 12,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 8,
                                      ),
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Random().nextBool()
                                              ? const Icon(
                                                  Icons.dnd_forwardslash,
                                                  size: 12,
                                                  color: Colors.red,
                                                )
                                              : const SizedBox.shrink(),
                                          const SizedBox(
                                            width: 5,
                                          ),
                                          Material(
                                            color: Colors.transparent,
                                            child: Text(
                                              "10 1-12/2 * * *",
                                              maxLines: 1,
                                              style: TextStyle(
                                                overflow: TextOverflow.ellipsis,
                                                color: ref
                                                    .watch(themeProvider)
                                                    .themeColor
                                                    .descColor(),
                                                fontSize: 12,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 8,
                                      ),
                                      Material(
                                        color: Colors.transparent,
                                        child: Text(
                                          "task raw post.js",
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            overflow: TextOverflow.ellipsis,
                                            color: ref
                                                .watch(themeProvider)
                                                .themeColor
                                                .descColor(),
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const Divider(
                                  height: 1,
                                  indent: 15,
                                ),
                              ],
                            );
                          },
                          itemCount: 100,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          Container(
            margin: const EdgeInsets.symmetric(
              horizontal: 15,
            ),
            height: colorHeight + 20,
            padding: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: ListView.separated(
              physics: BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(
                horizontal: 15,
              ),
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      pickColor();
                    },
                    child: SizedBox(
                      width: colorHeight,
                      height: colorHeight,
                      child: Stack(
                        children: [
                          Positioned(
                            child: Container(
                              width: smallColorHeight,
                              height: smallColorHeight,
                              decoration: BoxDecoration(
                                color: colors[0],
                                borderRadius:
                                    BorderRadius.circular(smallColorHeight),
                              ),
                            ),
                            left: 0,
                            top: colorHeight / 4 - smallColorHeight / 2,
                          ),
                          Positioned(
                            child: Container(
                              width: smallColorHeight,
                              height: smallColorHeight,
                              decoration: BoxDecoration(
                                color: colors[1],
                                borderRadius:
                                    BorderRadius.circular(smallColorHeight),
                              ),
                            ),
                            left: 0,
                            bottom: colorHeight / 4 - smallColorHeight / 2,
                          ),
                          Positioned(
                            child: Container(
                              width: smallColorHeight,
                              height: smallColorHeight,
                              decoration: BoxDecoration(
                                color: colors[2],
                                borderRadius:
                                    BorderRadius.circular(smallColorHeight),
                              ),
                            ),
                            left: colorHeight / 2 - smallColorHeight / 2,
                            top: 0,
                          ),
                          Positioned(
                            child: Container(
                              width: smallColorHeight,
                              height: smallColorHeight,
                              decoration: BoxDecoration(
                                color: colors[3],
                                borderRadius:
                                    BorderRadius.circular(smallColorHeight),
                              ),
                            ),
                            right: 0,
                            top: colorHeight / 4 - smallColorHeight / 2,
                          ),
                          Positioned(
                            child: Container(
                              width: smallColorHeight,
                              height: smallColorHeight,
                              decoration: BoxDecoration(
                                color: colors[4],
                                borderRadius:
                                    BorderRadius.circular(smallColorHeight),
                              ),
                            ),
                            right: 0,
                            bottom: colorHeight / 4 - smallColorHeight / 2,
                          ),
                          Positioned(
                            child: Container(
                              width: smallColorHeight,
                              height: smallColorHeight,
                              decoration: BoxDecoration(
                                color: colors[5],
                                borderRadius:
                                    BorderRadius.circular(smallColorHeight),
                              ),
                            ),
                            left: colorHeight / 2 - smallColorHeight / 2,
                            bottom: 0,
                          ),
                          Positioned(
                            child: Container(
                              width: smallColorHeight,
                              height: smallColorHeight,
                              decoration: BoxDecoration(
                                color: colors[6],
                                borderRadius:
                                    BorderRadius.circular(smallColorHeight),
                              ),
                            ),
                            left: colorHeight / 2 - smallColorHeight / 2,
                            bottom: 0,
                          ),
                          Positioned(
                            child: Container(
                              width: smallColorHeight,
                              height: smallColorHeight,
                              decoration: BoxDecoration(
                                color: colors[7],
                                borderRadius:
                                    BorderRadius.circular(smallColorHeight),
                              ),
                            ),
                            left: colorHeight / 2 - smallColorHeight / 2,
                            bottom: colorHeight / 2 - smallColorHeight / 2,
                          ),
                        ],
                      ),
                    ),
                  );
                } else {
                  index = index - 1;

                  return GestureDetector(
                    onTap: () {
                      _primaryColor = colors[index];
                      setState(() {});
                    },
                    child: SizedBox(
                      width: colorHeight,
                      height: colorHeight,
                      child: Container(
                        decoration: BoxDecoration(
                          color: colors[index],
                          borderRadius: BorderRadius.circular(colorHeight),
                        ),
                      ),
                    ),
                  );
                }
              },
              itemCount: colors.length + 1,
              separatorBuilder: (BuildContext context, int index) {
                return const SizedBox(
                  width: 15,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void pickColor() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          titlePadding: const EdgeInsets.all(0),
          contentPadding: const EdgeInsets.all(0),
          content: SingleChildScrollView(
            child: ColorPicker(
              pickerColor: _primaryColor,
              onColorChanged: (color) {
                _primaryColor = color;
                setState(() {});
              },
              colorPickerWidth: 300,
              pickerAreaHeightPercent: 0.7,
              enableAlpha: false,
              pickerAreaBorderRadius: const BorderRadius.only(
                topLeft: Radius.circular(2),
                topRight: Radius.circular(2),
              ),
              hexInputBar: false,
            ),
          ),
        );
      },
    );
  }

  void submit() {
    ref.read(themeProvider).changePrimaryColor(_primaryColor);
    Navigator.of(context).pop();
  }
}
