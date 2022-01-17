import 'package:flutter/cupertino.dart';

class ViewModel extends ChangeNotifier {}

class BaseViewModel extends ViewModel {
  PageState currentState = PageState.START;
  String? failReason;
  String? failedToast;

  void loading({bool notify = false}) {
    failReason = null;
    failedToast = null;
    currentState = PageState.LOADING;
    if (notify) {
      notifyListeners();
    }
  }

  void success({bool notify = true}) {
    failReason = null;
    failedToast = null;
    currentState = PageState.CONTENT;
    if (notify) {
      notifyListeners();
    }
  }

  void failed(String? reason, {bool notify = false}) {
    currentState = PageState.FAILED;
    failReason = reason;
    failedToast = null;
    if (notify) {
      notifyListeners();
    }
  }

  void failToast(String? reason, {bool notify = false}) {
    currentState = PageState.CONTENT;
    failedToast = reason;
    failReason = reason;
    if (notify) {
      notifyListeners();
    }
  }

  void clearToast() {
    failedToast = null;
  }

  void empty({bool notify = false}) {
    failReason = null;
    failedToast = null;
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
