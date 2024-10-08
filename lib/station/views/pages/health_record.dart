import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import 'package:http/http.dart' as http;
import 'package:smart_health/station/background/background.dart';
import 'package:smart_health/station/background/color/style_color.dart';
import 'package:smart_health/station/device/ad_ua651ble.dart';
import 'package:smart_health/station/device/hc08.dart';
import 'package:smart_health/station/device/hj_narigmed.dart';
import 'package:smart_health/station/device/mibfs.dart';
import 'package:smart_health/station/provider/provider.dart';
import 'package:smart_health/station/provider/provider_function.dart';
import 'package:smart_health/station/views/ui/widgetdew.dart/popup.dart';
import 'package:smart_health/station/views/ui/widgetdew.dart/widgetdew.dart';

class HealthRecord extends StatefulWidget {
  const HealthRecord({super.key});

  @override
  State<HealthRecord> createState() => _HealthRecordState();
}

class _HealthRecordState extends State<HealthRecord> {
  Timer? timer;
  bool prevent = false;
  bool ble = true;

  StreamSubscription? _streamSubscription;
  StreamSubscription? _functionSubscription;
  TextEditingController temp = TextEditingController();
  TextEditingController weight = TextEditingController();
  TextEditingController sys = TextEditingController();
  TextEditingController dia = TextEditingController();
  TextEditingController pulse = TextEditingController();
  TextEditingController pr = TextEditingController();
  TextEditingController spo2 = TextEditingController();
  TextEditingController fbs = TextEditingController();
  TextEditingController si = TextEditingController();
  TextEditingController uric = TextEditingController();
  TextEditingController height = TextEditingController();
  void restartdata() {
    timer = Timer.periodic(const Duration(seconds: 2), (_) {
      test();
    });
  }

  void test() {
    String temp_value = '';
    String weight_value = '';
    String sys_value = '';
    String dia_value = '';
    String spo2_value = '';
    String pr_value = '';
    String pulse_value = '';
    String fbs_value = '';
    String si_value = '';
    String uric_value = '';
    timer = Timer.periodic(const Duration(seconds: 2), (_) {
      setState(() {
        if (temp_value != context.read<DataProvider>().temp) {
          temp.text = context.read<DataProvider>().temp;
          temp_value = context.read<DataProvider>().temp;
        }
        if (weight_value != context.read<DataProvider>().weight) {
          weight.text = context.read<DataProvider>().weight;
          weight_value = context.read<DataProvider>().weight;
        }
        if (sys_value != context.read<DataProvider>().sys) {
          sys.text = context.read<DataProvider>().sys;
          sys_value = context.read<DataProvider>().sys;
        }
        if (dia_value != context.read<DataProvider>().dia) {
          dia.text = context.read<DataProvider>().dia;
          dia_value = context.read<DataProvider>().dia;
        }
        if (spo2_value != context.read<DataProvider>().spo2) {
          spo2.text = context.read<DataProvider>().spo2;
          spo2_value = context.read<DataProvider>().spo2;
        }
        if (pr_value != context.read<DataProvider>().pr) {
          pr.text = context.read<DataProvider>().pr;
          pr_value = context.read<DataProvider>().pr;
        }
        if (pulse_value != context.read<DataProvider>().pul) {
          pulse.text = context.read<DataProvider>().pul;
          pulse_value = context.read<DataProvider>().pul;
        }
        if (fbs_value != context.read<DataProvider>().fbs) {
          fbs.text = context.read<DataProvider>().fbs;
          fbs_value = context.read<DataProvider>().fbs;
        }
        if (si_value != context.read<DataProvider>().si) {
          si.text = context.read<DataProvider>().si;
          si_value = context.read<DataProvider>().si;
        }
        if (uric_value != context.read<DataProvider>().uric) {
          uric.text = context.read<DataProvider>().uric;
          uric_value = context.read<DataProvider>().uric;
        }
      });
    });
  }

  @override
  void dispose() {
    _streamSubscription?.cancel();
    super.dispose();
  }

  void stop() {
    setState(() {
      timer?.cancel();
      _streamSubscription?.cancel();
      _functionSubscription?.cancel();
      Get.offNamed('user_information');
    });
    ; // ยกเลิก StreamSubscription ถ้ามีการติดตาม Stream อยู่
  }

  void stop2() {
    setState(() {
      timer?.cancel();
      _streamSubscription?.cancel();
      _functionSubscription?.cancel();
    });
    ; // ยกเลิก StreamSubscription ถ้ามีการติดตาม Stream อยู่
  }

  void chackrecorddata() async {
    if (temp.text == '' ||
        weight.text == '' ||
        sys.text == '' ||
        dia.text == '' ||
        spo2.text == '' ||
        pulse == '') {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return Popup(
              texthead: 'ข้อมูลไม่ครบ',
              textbody: 'ต้องการส่งข้อมูลหรือไม่',
              fontSize: 0.05,
              pathicon: 'assets/warning.png',
              buttonbar: [
                GestureDetector(
                    onTap: () {
                      context.read<Datafunction>().playsound();
                      Navigator.pop(context);
                    },
                    child: MarkCheck(
                        pathicon: 'assets/close.png',
                        height: 0.05,
                        width: 0.05)),
                SizedBox(width: 50),
                GestureDetector(
                    onTap: () {
                      recorddata();
                      Navigator.pop(context);
                      //   context.read<Datafunction>().playsound();
                    },
                    child: MarkCheck(
                        pathicon: 'assets/check.png',
                        height: 0.08,
                        width: 0.08)),
                SizedBox(width: 50),
              ],
            );
          });
    } else {
      print('value!=null');
      recorddata();
    }
  }

  void recorddata() async {
    setState(() {
      prevent = true;
    });
    var url = Uri.parse('${context.read<DataProvider>().platfromURL}/add_hr');
    var res = await http.post(url, body: {
      "public_id": context.read<DataProvider>().id,
      "care_unit_id": context.read<DataProvider>().care_unit_id,
      "temp": "${temp.text}",
      "weight": "${weight.text}",
      "bp_sys": "${sys.text}",
      "bp_dia": "${dia.text}",
      "pulse_rate": "${pulse.text}",
      "spo2": "${spo2.text}",
      "fbs": "${fbs.text}",
      "height": "${height.text}",
      "bmi": "",
      "bp": "${sys.text}/${dia.text}",
      "rr": "",
    });
    var resTojson = json.decode(res.body);

    if (res.statusCode == 200) {
      setState(() {
        if (resTojson['message'] == "success") {
          setState(() {
            prevent = false;

            // showDialog(
            //     context: context,
            //     builder: (BuildContext context) {
            //       return Popup(
            //           fontSize: 0.05,
            //           texthead: 'สำเร็จ',
            //           pathicon: 'assets/correct.png');
            //     });
            Timer(Duration(seconds: 1), () {
              stop();
              Get.offNamed('user_information');
            });
          });
        } else {
          print(resTojson);
          setState(() {
            prevent = false;
            setState(() {
              prevent = false;
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return Popup(
                        texthead: 'ไม่สำเร็จ',
                        textbody: 'message unsuccessful',
                        pathicon: 'assets/warning (1).png');
                  });
            });
          });
        }
      });
    } else {
      setState(() {
        prevent = false;
        setState(() {
          prevent = false;
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return Popup(
                    texthead: 'ไม่สำเร็จ',
                    textbody: 'statusCode 404',
                    pathicon: 'assets/warning (1).png');
              });
        });
      });
    }
  }

  void clearprovider() {
    setState(() {
      context.read<DataProvider>().temp = '';
      context.read<DataProvider>().weight = '';
      context.read<DataProvider>().sys = '';
      context.read<DataProvider>().dia = '';
      context.read<DataProvider>().spo2 = '';
      context.read<DataProvider>().pr = '';
      context.read<DataProvider>().pul = '';
      context.read<DataProvider>().fbs = '';
      context.read<DataProvider>().si = '';
      context.read<DataProvider>().uric = '';
    });
  }

  void bleScan() {
    var namescan;

    FlutterBluePlus flutterBlue = FlutterBluePlus();
    final Map<String, String> online_devices = HashMap();
    namescan = DataProvider().namescan;
    StreamController<Map<String, String>> datas =
        StreamController<Map<String, String>>();
    FlutterBluePlus.scanResults.listen((results) {
      if (results.length > 0) {
        ScanResult r = results.last;

        if (namescan.contains(r.device.name.toString())) {
          r.device.connect(); //Yuwell HT-YHW
        }
      } else {}
    });

    _streamSubscription = Stream.periodic(Duration(seconds: 5)).listen((_) {
      FlutterBluePlus.startScan(timeout: const Duration(seconds: 4));
      FlutterBluePlus.scanResults.listen((results) {
        if (results.length > 0) {
          ScanResult r = results.last;
          // print(r.device.name);
          if (namescan.contains(r.device.id.toString())) {
            r.device.connect();
          }
        }
      });
    });

    _functionSubscription = Stream.periodic(Duration(seconds: 4))
        .asyncMap((_) => FlutterBluePlus.connectedDevices)
        .listen((connectedDevices) {
      connectedDevices.forEach((device) {
        print('functionstreamtimeกำลังทำงาน ');
        if (online_devices.containsKey(device.id.toString()) == false) {
          online_devices[device.id.toString()] = device.name;
          if (device.name == 'HC-08') {
            print('functionstreamtimeกำลังทำงาน ${device.name}');
            //HC-08
            // print("${device.id}");
            Hc08 hc08 = Hc08(device: device);
            hc08.parse().listen((temp) {
              if (temp != null && temp != '') {
                Map<String, String> val = HashMap();
                val['temp'] = temp;
                datas.add(val);
                setState(() {
                  context.read<DataProvider>().temp = temp;
                });
              }
            });
          } else if (device.name == 'HJ-Narigmed') {
            print('functionstreamtimeกำลังทำงาน ${device.name}');
            HjNarigmed hjNarigmed = HjNarigmed(device: device);
            hjNarigmed.parse().listen((mVal) {
              Map<String, String> val = HashMap();
              val['spo2'] = mVal['spo2'];
              val['pr'] = mVal['pr'];
              datas.add(val);
              setState(() {
                context.read<DataProvider>().spo2 = mVal['spo2'];
                context.read<DataProvider>().pr = mVal['pr'];
              });
            });
          } else if (device.name == 'A&D_UA-651BLE_D57B3F') {
            print('functionstreamtimeกำลังทำงาน ${device.name}');
            AdUa651ble adUa651ble = AdUa651ble(device: device);
            adUa651ble.parse().listen((nVal) {
              Map<String, String> val = HashMap();
              val['sys'] = nVal['sys'];
              val['dia'] = nVal['dia'];
              val['pul'] = nVal['pul'];
              datas.add(val);
              setState(() {
                context.read<DataProvider>().sys = nVal['sys'];
                context.read<DataProvider>().dia = nVal['dia'];
                context.read<DataProvider>().pul = nVal['pul'];
              });
            });
          } else if (device.name == 'MIBFS') {
            print('functionstreamtimeกำลังทำงาน ${device.name}');
            Mibfs mibfs = Mibfs(device: device);
            mibfs.parse().listen((weight) {
              Map<String, String> val = HashMap();
              val['weight'] = weight;
              setState(() {
                context.read<DataProvider>().weight = weight;
              });
            });
          }
        }
      });
    });
  }

  // Timer scanTimer([int milliseconds = 6]) =>
  //     Timer.periodic(Duration(seconds: milliseconds), (Timer timer) {
  //       FlutterBluePlus.instance.startScan(timeout: Duration(seconds: 5));
  //     });
  @override
  void initState() {
    clearprovider();
    restartdata();
    //   scanTimer();
    bleScan();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;
    double heightsizedbox = _height * 0.02;
    double heightline = _height * 0.03;
    Color teamcolor = Color.fromARGB(255, 47, 174, 164);

    return SafeArea(
      child: Scaffold(
        body: Stack(children: [
          backgrund(),
          Positioned(
              child: ListView(children: [
            BoxTime(),
            BoxDecorate2(
                color: Color.fromARGB(255, 43, 179, 161),
                child: InformationCard(
                    dataidcard: context.read<DataProvider>().dataidcard)),
            SizedBox(height: heightsizedbox),
            BoxDecorate2(
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                  BoxRecord(
                      image: 'assets/shr.png',
                      texthead: 'HEIGHT',
                      keyvavlue: height),
                  Line(height: heightline, color: teamcolor),
                  BoxRecord(
                      image: 'assets/srhnate.png',
                      texthead: 'WEIGHT',
                      keyvavlue: weight),
                ])),
            SizedBox(height: heightsizedbox),
            BoxDecorate2(
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                  BoxRecord(
                      image: 'assets/jhv.png', texthead: 'SYS', keyvavlue: sys),
                  Line(height: heightline, color: teamcolor),
                  BoxRecord(
                      image: 'assets/jhvkb.png',
                      texthead: 'DIA',
                      keyvavlue: dia),
                  Line(height: heightline, color: teamcolor),
                  BoxRecord(
                      image: 'assets/jhbjk;.png',
                      texthead: 'PULSE',
                      keyvavlue: pulse)
                ])),
            SizedBox(height: heightsizedbox),
            BoxDecorate2(
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                  BoxRecord(
                      image: 'assets/jhgh.png',
                      texthead: 'TEMP',
                      keyvavlue: temp),
                  Line(height: heightline, color: teamcolor),
                  BoxRecord(
                      image: 'assets/kauo.png',
                      texthead: 'SPO2',
                      keyvavlue: spo2),
                ])),
            SizedBox(height: heightsizedbox),
            // BoxDecorate2(
            //   child: Column(
            //     children: [
            //       Text('ค่าน้ำตาล',
            //           style: TextStyle(
            //               fontFamily: context.read<DataProvider>().fontFamily,
            //               fontSize: _width * 0.04,
            //               color: teamcolor)),
            //       SizedBox(height: heightsizedbox),
            //       Row(
            //           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            //           children: [
            //             BoxRecord(texthead: 'FBS', keyvavlue: fbs),
            //             Line(height: heightline, color: teamcolor),
            //             BoxRecord(texthead: 'SI', keyvavlue: si),
            //             Line(height: heightline, color: teamcolor),
            //             BoxRecord(texthead: 'URIC', keyvavlue: uric)
            //           ]),
            //     ],
            //   ),
            // ),
            // SizedBox(height: heightsizedbox),
            Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                      height: _height * 0.2,
                      child: Image.asset('assets/hraej.png')),
                  SizedBox(height: _height * 0.01),
                  Container(
                    child: prevent == false
                        ? GestureDetector(
                            onTap: () {
                              context.read<Datafunction>().playsound();

                              chackrecorddata();
                            },
                            child: BoxWidetdew(
                                height: 0.06,
                                width: 0.3,
                                text: 'บันทึก',
                                fontSize: 0.05,
                                radius: 15.0,
                                color: Color(0xff31D6AA),
                                textcolor: Colors.white),
                          )
                        : Container(
                            width: MediaQuery.of(context).size.width * 0.07,
                            height: MediaQuery.of(context).size.width * 0.07,
                            child: CircularProgressIndicator(),
                          ),
                  ),
                ],
              ),
            ),
          ]))
        ]),
        bottomNavigationBar: Container(
          height: _height * 0.03,
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: GestureDetector(
                  onTap: () {
                    stop();
                    context.read<Datafunction>().playsound();
                  },
                  child: Container(
                    height: _height * 0.025,
                    width: _width * 0.15,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                            color: Color.fromARGB(255, 201, 201, 201),
                            width: _width * 0.002)),
                    child: Center(
                        child: Text(
                      '< ย้อนกลับ',
                      style: TextStyle(
                          fontFamily: context.read<DataProvider>().fontFamily,
                          fontSize: _width * 0.03,
                          color: Color.fromARGB(255, 201, 201, 201)),
                    )),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
