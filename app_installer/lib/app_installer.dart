library app_installer;

import 'package:app_installer/exceptions.dart';
import 'package:app_installer_platform_interface/app_installer_platform_interface.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

Future<void> installApp(String path) async {
  try {
    await AppInstallerPlatform.instance.installApp(path);
  } catch (e) {
    debugPrint(e.toString());
    if (e is PlatformException) {
      switch (e.code) {
        case "403":
          throw InstallerFileNotSupportedException();
        case "404":
          throw InstallerFileNotFoundException();
        case "500":
          throw InstallerException();
      }
    } else {
      throw InstallerException();
    }
  }
}
