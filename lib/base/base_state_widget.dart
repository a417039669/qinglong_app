import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qinglong_app/base/ui/lazy_load_state.dart';
import 'package:qinglong_app/utils/extension.dart';
import 'base_viewmodel.dart';

class BaseStateWidget<T extends BaseViewModel> extends ConsumerStatefulWidget {
  final Widget Function(WidgetRef context, T value, Widget? child) builder;
  final ProviderBase<T> model;
  final Widget? child;
  final Function(T)? onReady;
  final bool lazyLoad;

  const BaseStateWidget({
    Key? key,
    required this.builder,
    required this.model,
    this.child,
    this.onReady,
    this.lazyLoad = false,
  }) : super(key: key);

  @override
  _BaseStateWidgetState<T> createState() => _BaseStateWidgetState<T>();
}

class _BaseStateWidgetState<T extends BaseViewModel> extends ConsumerState<BaseStateWidget<T>> with LazyLoadState<BaseStateWidget<T>> {
  @override
  Widget build(BuildContext context) {
    var viewModel = ref.watch<T>(widget.model);
    if (viewModel.failedToast != null) {
      WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
        (viewModel.failedToast ?? "").toast();
        viewModel.clearToast();
      });
    }
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
        child: Text(viewModel.failReason ?? ""),
      );
    }

    if (viewModel.currentState == PageState.EMPTY) {
      return Container(
        alignment: Alignment.center,
        child: const Text("暂无数据"),
      );
    }

    return Container();
  }

  @override
  void onLazyLoad() {
    if (widget.onReady != null && widget.lazyLoad) {
      widget.onReady!(ref.read<T>(widget.model));
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      if (widget.onReady != null && !widget.lazyLoad) {
        widget.onReady!(ref.read<T>(widget.model));
      }
    });
  }
}
