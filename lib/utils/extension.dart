import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:qinglong_app/main.dart';

//不推荐使用, 性能为o(n)
extension ContextExt on BuildContext {
  static QlAppState? _state;

  T read<T>(ProviderBase<T> provider) {
    _state ??= findRootAncestorStateOfType<QlAppState>();
    return _state!.ref.read(provider);
  }

  T watch<T>(ProviderBase<T> provider) {
    _state ??= findRootAncestorStateOfType<QlAppState>();
    return _state!.ref.watch(provider);
  }
}

extension StringExt on String? {
  void toast() {
    if (this == null || this!.isEmpty) return;
    Fluttertoast.showToast(
      msg: this!,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
    );
  }
}
