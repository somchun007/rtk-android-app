import 'dart:developer';

import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application/css/style.dart';
import 'package:flutter_application/model/addressDetail.dart';
import 'package:flutter_application/widgets/widget.dart';
import 'package:insta_image_viewer/insta_image_viewer.dart';
import 'package:intl/intl.dart';
import 'package:quickalert/quickalert.dart';
import 'package:audioplayers/src/source.dart' as source;

class DetailWaterScreen extends StatefulWidget {
  final String documentID;
  const DetailWaterScreen({super.key, required this.documentID});

  @override
  State<DetailWaterScreen> createState() => _DetailWaterScreenState();
}

class _DetailWaterScreenState extends State<DetailWaterScreen> {
  // String? addressID =

  // *** FIREBASE ***
  // 1.เตรียม Firebase
  final Future<FirebaseApp> firebase = Firebase.initializeApp();
  // 2.กำหนด Collection ที่จะทำงาน
  CollectionReference addressCollection =
      FirebaseFirestore.instance.collection("addresses");

  late Future<dynamic> futureAddress;
  @override
  void initState() {
    futureAddress = fetchAddressDetail();
    audioPlayer = AudioPlayer();
    super.initState();
  }

  String? dateUpload;
  // List imagesList = [];

  Future fetchAddressDetail() async {
    DocumentSnapshot docAddress =
        await addressCollection.doc(widget.documentID).get();
    final data = docAddress.data() as Map<String, dynamic>;

    // print(data['urlImage1']);
    List<AddressDetail> result = [];
    AddressDetail detail = AddressDetail(
      id: docAddress.id,
      item: data['item'],
      accuracy: data['accuracy'],
      added_by: data['added_by'],
      altitude: data['altitude'],
      approve: data['approve'],
      district: data['district'],
      latitude: data['latitude'],
      longitude: data['longitude'],
      postcode: data['postcode'],
      province: data['province'],
      subdistrict: data['subdistrict'],
      timestamp: data['timestamp'],
      urlImage1: data['urlImage1'],
      urlImage2: data['urlImage2'],
      urlImage3: data['urlImage3'],
      urlImage4: data['urlImage4'],
      urlImage5: data['urlImage5'],
      watertype: data['watertype'],
      description: data['description'],
      urlAudio: data['urlAudio'],
    );
    result.add(detail);
    log("data: $result");

    DateTime tsdate = DateTime.fromMillisecondsSinceEpoch(data['timestamp']);
    int yearBuddhist = tsdate.year + 543;
    dateUpload = DateFormat('dd MMMM $yearBuddhist   hh:mm').format(tsdate);

    return AddressDetail.formMap(docAddress);
  }

  Future updateStatusCancel() async {
    await addressCollection.doc(widget.documentID).update({
      "approve": "cancel",
    });
    // setState(() {
    //   futureAddress = fetchAddressDetail();
    // });
  }

  Future updateStatusWaiting() async {
    await addressCollection.doc(widget.documentID).update({
      "approve": "waiting",
    });
    // setState(() {
    //   futureAddress = fetchAddressDetail();
    // });
  }

  bool isPlayingRecord = false;
  late AudioPlayer audioPlayer;

  Future playRecording(url) async {
    try {
      source.Source urlSource = UrlSource(url);
      await audioPlayer.play(urlSource);

      setState(() {
        isPlayingRecord = true;
      });
      audioPlayer.onPlayerComplete.listen((event) {
        setState(() {
          isPlayingRecord = false;
        });
      });
    } catch (e) {
      debugPrint("Error Playing Recording : $e");
    }
  }

  Future stopRecording() async {
    try {
      await audioPlayer.pause();
      setState(() {
        isPlayingRecord = false;
      });
    } catch (e) {
      debugPrint("Error stop Recording : $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<dynamic>(
        future: futureAddress,
        builder: (context, snapshot) {
          // 1. เชื่อมต่อไม่ได้
          if (snapshot.hasError) {
            return Scaffold(
              appBar: AppBar(
                title: const Text("Error"),
              ),
              body: Center(child: Text("${snapshot.error}")),
            );
          }
          // 2. กำลังโหลดข้อมูล
          else if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          // 3. เชื่อมต่อสำเร็จ
          final AddressDetail detail = snapshot.data!;
          return Scaffold(
            backgroundColor: const Color.fromARGB(255, 207, 205, 205),
            appBar: AppBar(
              toolbarHeight: 80, //ขนาดความสูง Appbar
              leading: Padding(
                padding: const EdgeInsets.only(left: 30, top: 20),
                child: IconButton(
                  icon: const Icon(
                    Icons.arrow_back_ios,
                    size: 30,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
              title: const Padding(
                padding: EdgeInsets.only(top: 15),
                child: Text(
                  "รายละเอียด",
                  style: StyleAppbar,
                ),
              ),
              flexibleSpace: const BackgroundAppbar(),
              centerTitle: true,
              backgroundColor: Colors.transparent,
              elevation: 0, //ลบแรเงา
            ),
            body: Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 35),
                  child: Column(
                    children: [
                      const SizedBox(height: 40),
                      Container(
                        // padding: const EdgeInsets.symmetric(vertical: 30),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          children: [
                            const SizedBox(height: 30),
                            //รายละเอียด
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                //ค่า Row ด้านซ้าย
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        top: 4,
                                        // left: 20,
                                      ),
                                      child: Text(
                                        "$dateUpload",
                                        style: StyleTimeData,
                                      ),
                                    ),
                                    const SizedBox(height: 15),
                                    Row(
                                      children: [
                                        const Text("Accuracy",
                                            style: StyleDetailTitle),
                                        const SizedBox(width: 20),
                                        Text("${detail.accuracy}",
                                            style: StyleDetailResult),
                                      ],
                                    ),
                                    const SizedBox(height: 15),
                                    Row(
                                      children: [
                                        const Text("Altitude",
                                            style: StyleDetailTitle),
                                        const SizedBox(width: 28),
                                        Text("${detail.altitude}",
                                            style: StyleDetailResult),
                                      ],
                                    ),
                                    const SizedBox(height: 15),
                                    Row(
                                      children: [
                                        const Text("ละติจูด",
                                            style: StyleDetailTitle),
                                        const SizedBox(width: 42),
                                        Text("${detail.latitude}",
                                            style: StyleDetailResult),
                                      ],
                                    ),
                                    const SizedBox(height: 15),
                                    Row(
                                      children: [
                                        const Text("ลองจิจูด",
                                            style: StyleDetailTitle),
                                        const SizedBox(width: 29),
                                        Text("${detail.longitude}",
                                            style: StyleDetailResult),
                                      ],
                                    ),
                                  ],
                                ),
                                const SizedBox(width: 20),
                                //ค่า Row ด้านขวา
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        const Text("สถานะ",
                                            style: StyleDetailTitle),
                                        const SizedBox(width: 30),
                                        //แถบสีสถานะ
                                        if (detail.approve == 'waiting')
                                          Row(
                                            children: [
                                              Container(
                                                width: 20,
                                                height: 20,
                                                decoration: const BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: Colors.grey,
                                                ),
                                              ),
                                              const SizedBox(width: 10),
                                              const Text(
                                                "รออนุมัติ",
                                                style: StyleStatusWaiting,
                                              ),
                                            ],
                                          )
                                        else if (detail.approve == 'success')
                                          Row(
                                            children: [
                                              Container(
                                                width: 20,
                                                height: 20,
                                                decoration: const BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: Colors.green,
                                                ),
                                              ),
                                              const SizedBox(width: 10),
                                              const Text(
                                                "สำเร็จ",
                                                style: StyleStatusSuccess,
                                              )
                                            ],
                                          )
                                        else if (detail.approve == 'refuse')
                                          Row(
                                            children: [
                                              Container(
                                                width: 20,
                                                height: 20,
                                                decoration: const BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: Colors.red,
                                                ),
                                              ),
                                              const SizedBox(width: 10),
                                              const Text(
                                                "ไม่สำเร็จ",
                                                style: StyleStatusRefuse,
                                              )
                                            ],
                                          )
                                        else
                                          Row(
                                            children: [
                                              Container(
                                                width: 20,
                                                height: 20,
                                                decoration: const BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: Colors.orange,
                                                ),
                                              ),
                                              const SizedBox(width: 10),
                                              const Text(
                                                "ยกเลิก",
                                                style: StyleStatusCancel,
                                              ),
                                            ],
                                          ),
                                      ],
                                    ),
                                    const SizedBox(height: 15),
                                    Row(
                                      children: [
                                        const Text("จังหวัด",
                                            style: StyleDetailTitle),
                                        const SizedBox(width: 24),
                                        Text("${detail.province}",
                                            style: StyleDetailResult),
                                      ],
                                    ),
                                    const SizedBox(height: 15),
                                    Row(
                                      children: [
                                        const Text("อำเภอ",
                                            style: StyleDetailTitle),
                                        const SizedBox(width: 32),
                                        Text("${detail.district}",
                                            style: StyleDetailResult),
                                      ],
                                    ),
                                    const SizedBox(height: 15),
                                    Row(
                                      children: [
                                        const Text("ตำบล",
                                            style: StyleDetailTitle),
                                        const SizedBox(width: 36),
                                        Text("${detail.subdistrict}",
                                            style: StyleDetailResult),
                                      ],
                                    ),
                                    const SizedBox(height: 15),
                                    Row(
                                      children: [
                                        const Text("ประเภท",
                                            style: StyleDetailTitle),
                                        const SizedBox(width: 25),
                                        Text("${detail.watertype}",
                                            style: StyleDetailResult),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            //  คำอธิบาย
                            Padding(
                              padding: const EdgeInsets.only(
                                top: 10,
                                left: 38,
                                right: 38,
                              ),
                              child: Row(
                                children: [
                                  const Text("คำอธิบาย",
                                      style: StyleDetailTitle),
                                  const SizedBox(width: 24),
                                  detail.description!.isEmpty
                                      ? const Text(
                                          "-",
                                          style: StyleDetailResult,
                                        )
                                      : Expanded(
                                          child: Text(
                                            "${detail.description}",
                                            style: StyleDetailResult,
                                            maxLines: 2,
                                            softWrap: false,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 10),
                            //ไฟล์เสียง
                            if (detail.urlAudio != null)
                              Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 10),
                                    child: IconButton(
                                      onPressed: () {
                                        isPlayingRecord
                                            ? stopRecording()
                                            : playRecording(detail.urlAudio);
                                      },
                                      icon: isPlayingRecord
                                          ? const Icon(
                                              Icons.pause_circle_outlined,
                                              size: 45,
                                              color: Colors.red,
                                            )
                                          : const Icon(
                                              Icons.play_circle_fill_outlined,
                                              size: 45,
                                              color: Color.fromARGB(
                                                  255, 4, 117, 119),
                                            ),
                                    ),
                                  ),
                                  const Text(
                                    "มี 1 ไฟล์เสียง",
                                    style: StyleDetailResult,
                                  ),
                                ],
                              ),
                            //รูปภาพ
                            Container(
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 15),
                              height: 290,
                              child: Column(
                                children: [
                                  Expanded(
                                    child: GridView(
                                      // shrinkWrap: true,
                                      gridDelegate:
                                          const SliverGridDelegateWithFixedCrossAxisCount(
                                              crossAxisCount: 3),
                                      children: [
                                        if (detail.urlImage1 != null)
                                          InstaImageViewer(
                                            child: Container(
                                              padding: const EdgeInsets.all(4),
                                              child: Image.network(
                                                detail.urlImage1.toString(),
                                                fit: BoxFit.cover,
                                                height: 250,
                                                width: 250,
                                              ),
                                            ),
                                          ),
                                        if (detail.urlImage2 != null)
                                          InstaImageViewer(
                                            child: Container(
                                              padding: const EdgeInsets.all(4),
                                              child: Image.network(
                                                detail.urlImage2.toString(),
                                                fit: BoxFit.cover,
                                                height: 250,
                                                width: 250,
                                              ),
                                            ),
                                          ),
                                        if (detail.urlImage3 != null)
                                          InstaImageViewer(
                                            child: Container(
                                              padding: const EdgeInsets.all(4),
                                              child: Image.network(
                                                detail.urlImage3.toString(),
                                                fit: BoxFit.cover,
                                                height: 250,
                                                width: 250,
                                              ),
                                            ),
                                          ),
                                        if (detail.urlImage4 != null)
                                          InstaImageViewer(
                                            child: Container(
                                              padding: const EdgeInsets.all(4),
                                              child: Image.network(
                                                detail.urlImage4.toString(),
                                                fit: BoxFit.cover,
                                                height: 250,
                                                width: 250,
                                              ),
                                            ),
                                          ),
                                        if (detail.urlImage5 != null)
                                          InstaImageViewer(
                                            child: Container(
                                              padding: const EdgeInsets.all(4),
                                              child: Image.network(
                                                detail.urlImage5.toString(),
                                                fit: BoxFit.cover,
                                                height: 250,
                                                width: 250,
                                              ),
                                            ),
                                          ),

                                        // detail.urlImage1 != null
                                        //     ? InstaImageViewer(
                                        //         child: Container(
                                        //           padding:
                                        //               const EdgeInsets.all(4),
                                        //           child: Image.network(
                                        //             detail.urlImage1.toString(),
                                        //             fit: BoxFit.cover,
                                        //             height: 250,
                                        //             width: 250,
                                        //           ),
                                        //         ),
                                        //       )
                                        //     : Container(),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 20),

                            //ปุ่ม
                            if (detail.approve == 'waiting')
                              ButtonSolid(
                                buttonText: "ยกเลิกแหล่งน้ำ",
                                textStyle: StyleFontButtonBlue,
                                fixedheight: 50,
                                fixedwidth: 300,
                                icon: Icons.cancel_outlined,
                                colorIcon: Colors.white,
                                color: Colors.orange,
                                onPressed: () {
                                  updateStatusCancel().whenComplete(() {
                                    QuickAlert.show(
                                      context: context,
                                      type: QuickAlertType.success,
                                      title: "แหล่งน้ำถูกยกเลิก",
                                      confirmBtnText: "โอเค",
                                      barrierDismissible:
                                          false, //การกดบริเวณนอก Alert
                                      onConfirmBtnTap: () {
                                        setState(() {
                                          futureAddress = fetchAddressDetail();
                                        });
                                        Navigator.pop(context);
                                      },
                                    );
                                  });
                                },
                              )
                            else if (detail.approve == 'cancel')
                              ButtonSolid(
                                buttonText: "เพิ่มแหล่งน้ำอีกครั้ง",
                                textStyle: StyleFontButtonBlue,
                                fixedheight: 50,
                                fixedwidth: 300,
                                icon: Icons.send_rounded,
                                colorIcon: Colors.white,
                                color: Colors.green,
                                onPressed: () {
                                  updateStatusWaiting().whenComplete(() {
                                    QuickAlert.show(
                                      context: context,
                                      type: QuickAlertType.success,
                                      title:
                                          "สำเร็จ! โปรดรอการอนุมัติจากหน่วยงาน",
                                      confirmBtnText: "โอเค",
                                      barrierDismissible:
                                          false, //การกดบริเวณนอก Alert
                                      onConfirmBtnTap: () {
                                        setState(() {
                                          futureAddress = fetchAddressDetail();
                                        });
                                        Navigator.pop(context);
                                      },
                                    );
                                  });
                                },
                              ),

                            const SizedBox(height: 15),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          );
        });
  }
}
