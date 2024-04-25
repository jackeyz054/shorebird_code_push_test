//1. 自動檢查有無最新檔案
//2. 自動下載最新檔案
//3. 自動跳出提示窗: 需要重啟

//---
//關於在非UI區不使用到context傳遞的問題
//目前解法
//1. 直接使用reiverpod
//2. globalKey
//為了仿照可能會遇到大型專案，因此目前使用方案1

import 'package:codepush_test/helper/devlog.dart';
import 'package:codepush_test/model/shorebird_Data.dart';
import 'package:flutter/material.dart';
import 'package:shorebird_code_push/shorebird_code_push.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final shorebirdCodePush = ShorebirdCodePush();

class ShorebirdController {
  Future<void> autoCheckNewPatchAvailableForDownload(
    WidgetRef ref,
  ) async {
    final shorebirdProvider = ref.read(shorebirdData.notifier);
    bool isNewPatchAvailable = false;

    isNewPatchAvailable =
        await shorebirdCodePush.isNewPatchAvailableForDownload();

    print("有無新版本: $isNewPatchAvailable " "${isNewPatchAvailable ? "有" : "無"}");
    devLog("有無新版本", isNewPatchAvailable ? "有" : "無");

    shorebirdProvider.updateBannerState(isNewPatchAvailable);
  }

  void showScaffoldMessageBanner(BuildContext context) {
    ScaffoldMessenger.of(context).showMaterialBanner(
      MaterialBanner(
        content: const Text('有新的版本點擊下載'),
        actions: [
          TextButton(
            onPressed: () async {
              await shorebirdCodePush.downloadUpdateIfAvailable();

              ScaffoldMessenger.of(context).hideCurrentMaterialBanner();

              showRestartBanner(context);
            },
            child: const Text('下載'),
          ),
        ],
      ),
    );

    Future.delayed(
      const Duration(seconds: 15),
      () {
        ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
      },
    );
  }

  void showRestartBanner(BuildContext context) {
    ScaffoldMessenger.of(context).showMaterialBanner(
      const MaterialBanner(
        content: Text('下載完成! 請關閉App以確認更新'),
        actions: [],
      ),
    );
  }
}
