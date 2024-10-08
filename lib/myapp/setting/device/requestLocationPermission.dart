import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:permission_handler/permission_handler.dart';

bool hasLocationPermission = false;
bool hasbluetoothPermission = false;

void requestLocationPermission() async {
  PermissionStatus status = await Permission.location.request();
  PermissionStatus status2 = await Permission.bluetooth.request();
  PermissionStatus status3 = await Permission.camera.request();
  PermissionStatus status4 = await Permission.audio.request();
  FlutterBluePlus.startScan(timeout: const Duration(seconds: 4));
}
