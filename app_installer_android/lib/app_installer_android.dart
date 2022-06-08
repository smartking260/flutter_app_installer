import 'dart:async';

import 'package:app_installer_platform_interface/app_installer_platform_interface.dart';
import 'package:flutter/services.dart';

class AutoUpdaterAndroid extends AppInstallerPlatform {
  static const MethodChannel _channel = MethodChannel('app_installer_android');

  static void registerWith() {
    AppInstallerPlatform.instance = AutoUpdaterAndroid();
  }

  static Future<String?> get platformVersion async {
    final String? version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  @override
  Future<void> installApp(path) async =>
      await _channel.invokeListMethod("installApp", {'path': path});
}
