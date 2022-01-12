import 'package:flutter/cupertino.dart';

class BaseViewModel extends ChangeNotifier {
  PageState currentState = PageState.START;

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

  void failed({bool notify = false}) {
    currentState = PageState.FAILED;
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
