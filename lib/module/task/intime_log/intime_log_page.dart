import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qinglong_app/base/http/api.dart';
import 'package:qinglong_app/base/http/http.dart';

class InTimeLogPage extends StatefulWidget {
  final String cronId;
  final bool needTimer;

  const InTimeLogPage(this.cronId, this.needTimer, {Key? key})
      : super(key: key);

  @override
  _InTimeLogPageState createState() => _InTimeLogPageState();
}

class _InTimeLogPageState extends State<InTimeLogPage> {
  Timer? _timer;

  String? content;

  @override
  void initState() {
    super.initState();

    if (widget.needTimer) {
      _timer = Timer.periodic(
        const Duration(seconds: 2),
        (timer) {
          getLogData();
        },
      );
    } else {
      WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
        getLogData();
      });
    }
  }

  getLogData() async {
    HttpResponse<String> response = await Api.inTimeLog(widget.cronId);

    if (response.success) {
      content = response.bean;
      setState(() {});
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 15,
        vertical: 10,
      ),
      child: content == null
          ? const Center(
              child: CupertinoActivityIndicator(),
            )
          : CupertinoScrollbar(
              child: SelectableText(
                content!,
              ),
            ),
    );
  }
}
