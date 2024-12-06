import 'package:flutter/material.dart';
import 'package:streamkeys/windows/models/typedefs.dart';

class BrowseProvider extends ChangeNotifier{
  bool isLockedApp = false;

  FutureVoid openBrowse(FutureVoid Function() onOpen) async {
    isLockedApp = true;
    notifyListeners();

    await onOpen();

    isLockedApp = false;
    notifyListeners();
  }
}