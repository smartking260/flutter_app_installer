#include "app_installer_windows_plugin.h"
#include "include/app_installer_windows/app_installer.h"

// This must be included before many other Windows headers.
#include <windows.h>

// For getPlatformVersion; remove unless needed for your plugin implementation.
#include <VersionHelpers.h>

#include <flutter/method_channel.h>
#include <flutter/plugin_registrar_windows.h>
#include <flutter/standard_method_codec.h>

#include <memory>
#include <sstream>

namespace app_installer_windows {

using flutter::EncodableList;
using flutter::EncodableValue;
using flutter::EncodableMap;
// static
void AppInstallerWindowsPlugin::RegisterWithRegistrar(
    flutter::PluginRegistrarWindows *registrar) {
  auto channel =
      std::make_unique<flutter::MethodChannel<flutter::EncodableValue>>(
          registrar->messenger(), "app_installer_windows",
          &flutter::StandardMethodCodec::GetInstance());

  auto plugin = std::make_unique<AppInstallerWindowsPlugin>();

  channel->SetMethodCallHandler(
      [plugin_pointer = plugin.get()](const auto &call, auto result) {
        plugin_pointer->HandleMethodCall(call, std::move(result));
      });

  registrar->AddPlugin(std::move(plugin));
}

AppInstallerWindowsPlugin::AppInstallerWindowsPlugin() {}

AppInstallerWindowsPlugin::~AppInstallerWindowsPlugin() {}

void AppInstallerWindowsPlugin::HandleMethodCall(
    const flutter::MethodCall<flutter::EncodableValue> &method_call,
    std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
    const auto *arguments = std::get_if<EncodableMap>(method_call.arguments());
     if (method_call.method_name().compare("installApp") == 0) {
             std::string filePath;
             if (arguments){
                try{
                         auto filePath_it = arguments->find(EncodableValue("path"));
                               if (filePath_it != arguments->end()){
                                 filePath = std::get<std::string>(filePath_it->second);
                               }

                               if (filePath.find(".msix") != std::string::npos)
                               {
                                   //its ok
                                   int64_t res = (int64_t)AppInstaller::runFileWindows(filePath);
                                   result->Success(flutter::EncodableValue(res));
                               }
                               else {
                                   result->Error("403", "File isn't msix");
                               }

                            
                }
                catch(const std::exception& e)
                {
                    result->Error("500", e.what());
              
                }

             } else {
                 result->Error("500", "Unknown Exception happened");
               
             }
           }
       else {
        result->NotImplemented();
      }
    }

}  // namespace app_installer_windows
