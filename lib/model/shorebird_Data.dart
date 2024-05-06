import 'package:codepush_test/helper/devlog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
final shorebirdData =
    ChangeNotifierProvider.autoDispose<ScaffoldBannerState>((ref) {
  return ScaffoldBannerState();
});

class ScaffoldBannerState extends ChangeNotifier {
  bool bannerState = false;
  double downloadProgress = 0.0;

  void updateBannerState(bool value) {
    bannerState = value;
    devLog("測試", "我有來存取資料");
    print("我有來存取資料，資料:$bannerState");
    notifyListeners();
  }

  void updateDownloadProgress(double value) {
    downloadProgress = value;
    //devLog("進度條測試資料", downloadProgress.toString());
    notifyListeners();
  }
}
