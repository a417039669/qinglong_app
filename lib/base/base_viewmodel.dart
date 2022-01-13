import 'package:flutter/cupertino.dart';

class ViewModel extends ChangeNotifier {}

class BaseViewModel extends ViewModel {
  PageState currentState = PageState.START;
  String? failReason;

  void loading({bool notify = false}) {
    currentState = PageState.LOADING;
    if (notify) {
      notifyListeners();
    }
  }

  void success({bool notify = true}) {
    currentState = PageState.CONTENT;
    if (notify) {
      notifyListeners();
    }
  }

  void failed(String? reason, {bool notify = false}) {
    currentState = PageState.FAILED;
    failReason = reason;
    if (notify) {
      notifyListeners();
    }
  }

  void empty({bool notify = false}) {
    currentState = PageState.EMPTY;
    if (notify) {
      notifyListeners();
    }
  }
}

enum PageState {
  START,
  LOADING,
  EMPTY,
  CONTENT,
  FAILED,
}
