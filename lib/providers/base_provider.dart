import 'dart:async';

import 'package:flutter/foundation.dart';

class BaseProvider with ChangeNotifier {
  bool busy = false;

  void setBusy(bool value) {
    Timer(const Duration(milliseconds: 100), () {
      busy = value;
      notifyListeners();
    });
  }
}
