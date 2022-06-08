import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'method_channel_app_installer.dart';

abstract class AppInstallerPlatform extends PlatformInterface {
  AppInstallerPlatform() : super(token: _token);
  static final Object _token = Object();
  static AppInstallerPlatform _instance = MethodChanelAppInstaller();
  static AppInstallerPlatform get instance => _instance;

  static set instance(AppInstallerPlatform instance) {
    PlatformInterface.verify(instance, _token);
    _instance = instance;
  }

  Future<void> installApp(String path) {
    throw UnimplementedError('installApp() unimplemented error');
  }
}
