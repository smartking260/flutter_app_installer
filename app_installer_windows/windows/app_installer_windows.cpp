#include "include/app_installer_windows/app_installer_windows.h"

#include <flutter/plugin_registrar_windows.h>

#include "app_installer_windows_plugin.h"

void AppInstallerWindowsRegisterWithRegistrar(
    FlutterDesktopPluginRegistrarRef registrar) {
  app_installer_windows::AppInstallerWindowsPlugin::RegisterWithRegistrar(
      flutter::PluginRegistrarManager::GetInstance()
          ->GetRegistrar<flutter::PluginRegistrarWindows>(registrar));
}
