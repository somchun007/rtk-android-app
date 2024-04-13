// ignore_for_file: avoid_print

import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import '../css/style.dart';
import '../widgets/widget.dart';

class Mockpage extends StatefulWidget {
  const Mockpage({super.key});

  @override
  State<Mockpage> createState() => _MockpageState();
}

class _MockpageState extends State<Mockpage> {
  Timer? timer; //ตั้งค่าเวลา Loop
  late Future futureAddress;

  @override
  void initState() {
    super.initState();
    _handleLocationPermission();
    futureAddress = fetchAddress();
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      futureAddress = fetchAddress();
    });
  }

  //ตรวจสอบการเปิดใช้งาน Location
  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      log("บริการระบุตำแหน่งถูกปิดใช้งาน กรุณาเปิดใช้บริการ");
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        log("การอนุญาตเข้าถึงตำแหน่งถูกปฏิเสธ");
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      log("การอนุญาตเข้าถึงตำแหน่งถูกปฏิเสธอย่างถาวร เราไม่สามารถขอสิทธิ์ได้");
      return false;
    }
    log("ได้รับการอนุญาตการเข้าถึงตำแหน่ง");
    return true;
  }

  //new
  late Position position;
  double? latitude;
  double? longitude;
  double? altitude;
  double? accuracy;
  late int timeSatellite;
  double? speed;

  double? cutAccuracy;
  double? cutAltitude;
  double? cutSpeed;
  String? formDate;

  double toPrecision(double input, int n) {
    return double.parse(input.toStringAsFixed(n));
  }

  Future fetchAddress() async {
    position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best);

    if (mounted) {
      setState(() {
        accuracy = position.accuracy;
        latitude = position.latitude;
        longitude = position.longitude;
        formDate = formDate;
        speed = position.speed;
        altitude = position.altitude;

        cutAccuracy = toPrecision(accuracy!, 4);
        cutAltitude = toPrecision(altitude!, 6);
        cutSpeed = toPrecision(speed!, 6);
      });
    }
    if (!mounted) {
      timer?.cancel();
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: futureAddress,
        builder: (context, snapshot) {
          // 1. เชื่อมต่อไม่ได้
          if (snapshot.hasError) {
            return Scaffold(
              backgroundColor: const Color.fromARGB(255, 207, 205, 205),
              appBar: AppBar(
                toolbarHeight: 80, //ขนาดความสูง Appbar
                title: const Text(
                  'เชื่อมต่อ RTK',
                  style: StyleAppbar,
                ),
                flexibleSpace: const BackgroundAppbar(),
                automaticallyImplyLeading: false, //ยกเลิกปุ่มย้อนกลับ
                centerTitle: true, //ข้อความตรงกลาง
                backgroundColor:
                    Colors.transparent, //สีพื้นหลังเริ่มต้น->โปร่งใส
                elevation: 0, //ลบแรเงา
              ),
              body: SingleChildScrollView(
                child: Container(
                  padding: const EdgeInsets.only(top: 100),
                  child: const Center(
                    child: Column(
                      children: [
                        Text(
                          "ไม่พบข้อมูล",
                          style: StyleTextError,
                        ),
                        Text(
                          "โปรดไปยังที่ที่มีสัญญาณ แล้วลองอีกครั้ง",
                          style: StyleTextError,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }
          // // 2. กำลังโหลดข้อมูล
          // else if (snapshot.connectionState == ConnectionState.waiting) {
          //   return const Center(child: CircularProgressIndicator());
          // }
          // 3. เชื่อมต่อสำเร็จ

          return Scaffold(
            backgroundColor: const Color.fromARGB(255, 207, 205, 205),
            appBar: AppBar(
              toolbarHeight: 80, //ขนาดความสูง Appbar
              title: const Text(
                'เชื่อมต่อ RTK',
                style: StyleAppbar,
              ),
              flexibleSpace: const BackgroundAppbar(),
              automaticallyImplyLeading: false, //ยกเลิกปุ่มย้อนกลับ
              centerTitle: true, //ข้อความตรงกลาง
              backgroundColor: Colors.transparent, //สีพื้นหลังเริ่มต้น->โปร่งใส
              elevation: 0, //ลบแรเงา
            ),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.only(left: 50, right: 50),
                    child: Column(
                      children: [
                        const SizedBox(height: 50),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 25,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Column(
                            children: [
                              //ไฮทไลท์
                              Container(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                child: Column(
                                  children: [
                                    Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            if (snapshot.connectionState ==
                                                ConnectionState.done)
                                              Text(
                                                "$cutAccuracy",
                                                style: TextStyle(
                                                  fontFamily: "Kanit",
                                                  fontSize: 70,
                                                  color: cutAccuracy! <= 0.04 &&
                                                          cutAccuracy! != 0.00
                                                      ? Colors.green
                                                      : Colors.red,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              )
                                            else
                                              Text(
                                                "$cutAccuracy",
                                                style: const TextStyle(
                                                  fontFamily: "Kanit",
                                                  fontSize: 70,
                                                  // color: cutAccuracy! <= 0.05
                                                  //     ? Colors.green
                                                  //     : Colors.red,
                                                  color: Colors.red,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            const SizedBox(width: 20),
                                            Container(
                                              padding: const EdgeInsets.only(
                                                  top: 12),
                                              child: const Text(
                                                "m.",
                                                style: TextStyle(
                                                  fontFamily: "Kanit",
                                                  fontSize: 60,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const Padding(
                                          padding: EdgeInsets.only(top: 120),
                                          child: Text("Accuracy",
                                              style: StyleTitleMock),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 50),
                              //ส่วนย่อย
                              SizedBox(
                                // padding:
                                //     const EdgeInsets.only(left: 10, right: 30),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        const Text(
                                          "Time",
                                          style: StyleTitleMock,
                                        ),
                                        const SizedBox(width: 105),
                                        Text("$formDate",
                                            style: StyleResultMock),
                                      ],
                                    ),
                                    const SizedBox(height: 20),
                                    Row(
                                      children: [
                                        const Text(
                                          "Latitude",
                                          style: StyleTitleMock,
                                        ),
                                        const SizedBox(width: 64),
                                        Text("$latitude",
                                            style: StyleResultMock),
                                      ],
                                    ),
                                    const SizedBox(height: 20),
                                    Row(
                                      children: [
                                        const Text(
                                          "Longitude",
                                          style: StyleTitleMock,
                                        ),
                                        const SizedBox(width: 44),
                                        Text("$longitude",
                                            style: StyleResultMock),
                                      ],
                                    ),
                                    const SizedBox(height: 20),
                                    Row(
                                      children: [
                                        const Text(
                                          "Altitude",
                                          style: StyleTitleMock,
                                        ),
                                        const SizedBox(width: 68),
                                        Text("$cutAltitude",
                                            style: StyleResultMock),
                                      ],
                                    ),
                                    const SizedBox(height: 20),
                                    Row(
                                      children: [
                                        const Text(
                                          "Speed",
                                          style: StyleTitleMock,
                                        ),
                                        const SizedBox(width: 90),
                                        Text(
                                          "$cutSpeed",
                                          style: StyleResultMock,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 40),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }
}
