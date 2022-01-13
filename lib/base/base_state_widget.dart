import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'base_viewmodel.dart';

class BaseStateWidget<T extends BaseViewModel> extends ConsumerStatefulWidget {
  final Widget Function(WidgetRef context, T value, Widget? child) builder;
  final ProviderBase<T> model;
  final Widget? child;
  final Function(T)? onReady;

  const BaseStateWidget({
    Key? key,
    required this.builder,
    required this.model,
    this.child,
    this.onReady,
  }) : super(key: key);

  @override
  _BaseStateWidgetState<T> createState() => _BaseStateWidgetState<T>();
}

class _BaseStateWidgetState<T extends BaseViewModel> extends ConsumerState<BaseStateWidget<T>> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback(
      (timeStamp) {
        if (widget.onReady != null) {
          widget.onReady!(ref.read<T>(widget.model));
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var viewModel = ref.watch<T>(widget.model);
    if (viewModel.currentState == PageState.CONTENT) {
      return widget.builder(ref, viewModel, widget.child);
    }

    if (viewModel.currentState == PageState.LOADING) {
      return Container(
        alignment: Alignment.center,
        child: const CupertinoActivityIndicator(),
      );
    }

    if (viewModel.currentState == PageState.FAILED) {
      return Container(
        alignment: Alignment.center,
        child: Text(viewModel.failReason ??""),
      );
    }

    if (viewModel.currentState == PageState.EMPTY) {
      return Container(
        alignment: Alignment.center,
        child: Text("暂无数据"),
      );
    }

    return Container();
  }
}

abstract class BaseState<T extends StatefulWidget> extends State {
  late T parent;

  @override
  void initState() {
    parent = widget as T;
    super.initState();
    WidgetsBinding.instance?.endOfFrame.then((_) {
      firstFrameCalled();
    });
  }

  void firstFrameCalled() {}

  @override
  Widget build(BuildContext context) {
    return buildWidgets(context);
  }

  Widget buildWidgets(BuildContext context);
}
