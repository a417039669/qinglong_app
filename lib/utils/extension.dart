import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';

extension ContextExt on BuildContext {
  T read<T>(ProviderBase<T> provider) {
    return (this as WidgetRef).read<T>(provider);
  }

  T watch<T>(ProviderBase<T> provider) {
    return (this as WidgetRef).watch<T>(provider);
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
