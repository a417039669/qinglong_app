
import 'dart:async';

import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:flutter/material.dart';

/// @author newtab on 2021/7/16
///常用loading,fail,success对话框
class CommonDialog extends StatelessWidget {
  final String? text;
  final CommonDialogState? commonDialogState;

  const CommonDialog({Key? key, this.text, this.commonDialogState}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget result = Material(
      color: Colors.transparent,
      child: Align(
        alignment: Alignment.center,
        child: Container(
          decoration: BoxDecoration(color: Color.fromRGBO(17, 17, 17, 0.7), borderRadius: BorderRadius.circular(5)),
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width / 2,
            minWidth: 122,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                margin: EdgeInsets.only(top: 15.0),
                constraints: BoxConstraints(
                  minHeight: 40,
                ),
                child: IconTheme(
                    data: IconThemeData(
                      color: Colors.white,
                      size: 40.0,
                    ),
                    child: LoadingIcon()),
              ),
              SizedBox(
                height: 15,
              ),
              if (text != null)
                Padding(
                  padding: EdgeInsets.only(
                    left: 15,
                    right: 15,
                    bottom: 15,
                  ),
                  child: DefaultTextStyle(
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: Colors.white, fontSize: 14),
                    child: Text(text!),
                  ),
                ),
            ],
          ),
        ),
      ),
    );

    return result;
  }
}

class LoadingIcon extends StatefulWidget {
  final double size;

  LoadingIcon({this.size = 50.0});

  @override
  State<StatefulWidget> createState() => LoadingIconState();
}

class LoadingIconState extends State<LoadingIcon> with SingleTickerProviderStateMixin {
  AnimationController? _controller;
  Animation<double>? _doubleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = new AnimationController(vsync: this, duration: Duration(milliseconds: 1000))..repeat();
    _doubleAnimation = Tween(begin: 0.0, end: 360.0).animate(_controller!)
      ..addListener(() {
        setState(() {});
      });
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
        angle: _doubleAnimation!.value ~/ 30 * 30.0 * 0.0174533, child: Image.asset("assets/images/loading.png", width: widget.size, height: widget.size));
  }
}

enum CommonDialogState {
  LOADING,
  SUCCESS,
  FAILED,
}

typedef HideCallback = Future Function();

int backButtonIndex = 2;

HideCallback showCommonDialog(
    BuildContext context, {
      String? text,
      bool backButtonClose = false,
      CommonDialogState commonDialogState = CommonDialogState.LOADING,
    }) {
  Completer<VoidCallback> result = Completer<VoidCallback>();
  var backButtonName = 'QL_Toast$backButtonIndex';
  BackButtonInterceptor.add((stopDefaultButtonEvent, _) {
    if (backButtonClose) {
      result.future.then((hide) {
        hide();
      });
    }
    return true;
  }, zIndex: backButtonIndex, name: backButtonName);
  backButtonIndex++;

  var overlay = OverlayEntry(
    maintainState: true,
    builder: (_) => WillPopScope(
      onWillPop: () async {
        var hide = await result.future;
        hide();
        return false;
      },
      child: CommonDialog(
        text: text,
      ),
    ),
  );
  result.complete(() {
    overlay.remove();
    BackButtonInterceptor.removeByName(backButtonName);
  });
  Overlay.of(context)?.insert(overlay);

  return () async {
    var hide = await result.future;
    hide();
  };
}

Future successDialog(BuildContext context, String text) {
  HideCallback hideCallback = showCommonDialog(
    context,
    text: text,
    commonDialogState: CommonDialogState.SUCCESS,
    backButtonClose: true,
  );
  return Future.delayed(
      Duration(
        milliseconds: 1000,
      ), () {
    hideCallback();
  });
}

Future failDialog(BuildContext context, String text) {
  HideCallback hideCallback = showCommonDialog(
    context,
    text: text,
    commonDialogState: CommonDialogState.FAILED,
    backButtonClose: true,
  );
  return Future.delayed(
      Duration(
        milliseconds: 1000,
      ), () {
    hideCallback();
  });
}

HideCallback loadingDialog(BuildContext context, {String? text}) {
  return showCommonDialog(
    context,
    text: text,
    commonDialogState: CommonDialogState.LOADING,
    backButtonClose: true,
  );
}