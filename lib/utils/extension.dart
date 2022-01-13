import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

extension ContextExt on BuildContext {
  T read<T>(ProviderBase<T> provider) {
    return (this as WidgetRef).read<T>(provider);
  }

  T watch<T>(ProviderBase<T> provider) {
    return (this as WidgetRef).watch<T>(provider);
  }
}
