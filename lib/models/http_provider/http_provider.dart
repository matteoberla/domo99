import 'package:flutter/cupertino.dart';

class HttpProvider extends ChangeNotifier {
  bool isLoading = false;

  updateLoadingState(bool newState) {
    isLoading = newState;
    notifyListeners();
  }
}
