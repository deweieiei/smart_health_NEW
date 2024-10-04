import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:smart_health/station/background/color/style_color.dart';
import 'package:smart_health/station/views/ui/bottomnavigationbar/menubottombar.dart';
import 'package:smart_health/station/views/ui/bottomnavigationbar/test_menu_bar.dart';

class BottomNavigationBarApp extends StatefulWidget {
  const BottomNavigationBarApp({super.key});

  @override
  State<BottomNavigationBarApp> createState() => _BottomNavigationBarAppState();
}

class _BottomNavigationBarAppState extends State<BottomNavigationBarApp> {
  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;
    return Container(
      width: _width,
      //   color: StyleColor.backgroundbegin,
      height: _height * 0.08,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Settingbar(),
          //TestMenuBar()
        ],
      ),
    );
  }
}
