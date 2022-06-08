import 'dart:async';
import 'package:app_installer_platform_interface/app_installer_platform_interface.dart';
import 'package:flutter/services.dart';

class AppInstallerWindows extends AppInstallerPlatform {
  static const MethodChannel _channel = MethodChannel('app_installer_windows');

  static void registerWith() {
    AppInstallerPlatform.instance = AppInstallerWindows();
  }

  static Future<String?> get platformVersion async {
    final String? version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  @override
  Future<void> installApp(path) async =>
      await _channel.invokeMethod("installApp", {'path': path});
}
