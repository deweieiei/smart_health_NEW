import 'package:flutter_blue_plus/flutter_blue_plus.dart';

FlutterBluePlus flutterBlue = FlutterBluePlus();
Future<bool> ble_on() async {
  //bool isBluetoothOn = await flutterBlue.isOn;
  bool isBluetoothOn = false;
  print("isBluetoothOn=${isBluetoothOn}");
  if (!isBluetoothOn) {
    return false;
  } else {
    return true;
  }
}
