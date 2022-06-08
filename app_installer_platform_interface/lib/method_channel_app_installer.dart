import 'package:app_installer_platform_interface/app_installer_platform_interface.dart';
import 'package:flutter/services.dart';

const MethodChannel _channel = MethodChannel("auto_installer");

class MethodChanelAppInstaller extends AppInstallerPlatform {
  @override
  Future<void> installApp(String path) async =>
      await _channel.invokeListMethod<void>("installApp", {"path": path});
}
