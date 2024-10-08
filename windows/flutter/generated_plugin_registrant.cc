//
//  Generated file. Do not edit.
//

// clang-format off

#include "generated_plugin_registrant.h"

#include <audioplayers_windows/audioplayers_windows_plugin.h>
#include <flutter_webrtc/flutter_web_r_t_c_plugin.h>
#include <openvidu_client/openvidu_client_plugin_c_api.h>
#include <permission_handler_windows/permission_handler_windows_plugin.h>
#include <quick_usb/quick_usb_plugin.h>
#include <zego_express_engine/zego_express_engine_plugin.h>

void RegisterPlugins(flutter::PluginRegistry* registry) {
  AudioplayersWindowsPluginRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("AudioplayersWindowsPlugin"));
  FlutterWebRTCPluginRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("FlutterWebRTCPlugin"));
  OpenviduClientPluginCApiRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("OpenviduClientPluginCApi"));
  PermissionHandlerWindowsPluginRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("PermissionHandlerWindowsPlugin"));
  QuickUsbPluginRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("QuickUsbPlugin"));
  ZegoExpressEnginePluginRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("ZegoExpressEnginePlugin"));
}
