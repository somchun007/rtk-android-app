// ignore_for_file: must_be_immutable

import 'dart:async';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application/model/profile.dart';
import 'package:flutter_application/screen/detail_water.dart';
import 'package:flutter_application/screen/manuals.dart';
// import 'package:flutter_application/screen/notification.dart';
import 'package:flutter_application/screen/water_type.dart';
import 'package:flutter_application/widgets/widget.dart';
import 'package:intl/intl.dart';
import '../css/style.dart';

class HomePage extends StatefulWidget {
  List<Profile> userData;
  HomePage({super.key, required this.userData});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String selectedNode = 'first_node';
  String? addedBy;
  late Future futureCountAddress;

  @override
  void initState() {
    super.initState();
    for (var data in widget.userData) {
      addedBy = data.email;
    }
    log("added_by= $addedBy");
    streamAddressWaiting;
    futureCountAddress = countAddress();
  }

  // *** FIREBASE ***
  // 1.เตรียม Firebase

  final Future<FirebaseApp> firebase = Firebase.initializeApp();
  CollectionReference addressCollection =
      FirebaseFirestore.instance.collection("addresses");

  late Stream<QuerySnapshot> streamAddressWaiting = addressCollection
      .where('added_by', isEqualTo: addedBy)
      .where('approve', isEqualTo: "waiting")
      .orderBy("timestamp", descending: true)
      .snapshots();

  double? totalAddressWaiting;
  double? totalAddressSuccess;
  double? totalAddressRefuse;
  int? totalAddress;
  Future countAddress() async {
    //count --> waiting
    final countWaiting = await addressCollection
        .where('added_by', isEqualTo: addedBy)
        .where('approve', isEqualTo: "waiting")
        .count()
        .get();
    totalAddressWaiting = countWaiting.count.ceilToDouble();
    //count --> success
    final countSuccess = await addressCollection
        .where('added_by', isEqualTo: addedBy)
        .where('approve', isEqualTo: "success")
        .count()
        .get();
    totalAddressSuccess = countSuccess.count.ceilToDouble();
    //count --> refuse
    final countRefuse = await addressCollection
        .where('added_by', isEqualTo: addedBy)
        .where('approve', isEqualTo: "refuse")
        .count()
        .get();
    totalAddressRefuse = countRefuse.count.ceilToDouble();
    //count --> total
    totalAddress = totalAddressWaiting!.toInt() +
        totalAddressSuccess!.toInt() +
        totalAddressRefuse!.toInt();

    setState(() {
      totalAddressWaiting;
      totalAddressSuccess;
      totalAddressRefuse;
      totalAddress;
    });
    //print
    log("Count Waiting = $totalAddressWaiting");
    log("Count Success = $totalAddressSuccess");
    log("Count Refuse = $totalAddressRefuse");
    log("Count Total = $totalAddress");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 207, 205, 205),
      appBar: AppBar(
        toolbarHeight: 80, //ขนาดความสูง Appbar
        title: Row(
          children: [
            const SizedBox(width: 20),
            const Icon(
              Icons.person_2_outlined,
              size: 40,
              color: Colors.white,
            ),
            const SizedBox(width: 20),
            Stack(
              // crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(bottom: 40),
                  child: Text("สวัสดี", style: StyleAppbarWellcome),
                ),
                for (var data in widget.userData)
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Text(
                      "คุณ ${data.fullname}",
                      style: StyleAppbarNameUser,
                    ),
                  ),
              ],
            ),
          ],
        ),
        // actions: [
        //   Padding(
        //     padding: const EdgeInsets.only(right: 30),
        //     child: IconButton(
        //       icon: const Icon(
        //         Icons.notifications_none_outlined,
        //         size: 30,
        //         color: Colors.white,
        //       ),
        //       onPressed: () {
        //         Navigator.push(
        //             context,
        //             MaterialPageRoute(
        //                 builder: (context) =>
        //                     NotificationScreen(userData: widget.userData)));
        //       },
        //     ),
        //   )
        // ],
        flexibleSpace: const BackgroundAppbar(),
        automaticallyImplyLeading: false, //ยกเลิกปุ่มย้อนกลับ
        // centerTitle: true, //ข้อความตรงกลาง
        backgroundColor: Colors.transparent, //สีพื้นหลังเริ่มต้น->โปร่งใส
        elevation: 0, //ลบแรเงา
      ),
      body: SafeArea(
        child: SizedBox(
          child: Column(
            children: [
              const SizedBox(height: 30),
              //ส่วนบน --> ปุ่มต่างๆ
              Column(
                children: [
                  ButtonMenu(
                    icon: Icons.question_mark,
                    colorIcon: Colors.blue,
                    buttonText: "คู่มือการใช้งาน",
                    colorCircle: Colors.white,
                    colorIconAppend: Colors.grey,
                    colorBackground: Colors.white,
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const ManualsScreen()));
                    },
                  ),
                  const SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ButtonUnderline(
                        horizont: 95,
                        buttonText: 'ผลสรุป',
                        fontsize: 25,
                        node: 'first_node',
                        isSelected: selectedNode == 'first_node',
                        onPressed: () {
                          setState(() {
                            selectedNode = 'first_node';
                          });
                        },
                      ),
                      ButtonUnderline(
                        horizont: 76,
                        buttonText: 'รออนุมัติ',
                        fontsize: 25,
                        circleContainer: Padding(
                          padding: const EdgeInsets.only(left: 4, bottom: 6),
                          child: Container(
                            width: 20,
                            height: 20,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.orange,
                            ),
                            child: Center(
                              child: Text("${totalAddressWaiting?.toInt()}"),
                            ),
                          ),
                        ),
                        node: 'second_node',
                        isSelected: selectedNode == 'second_node',
                        onPressed: () {
                          setState(() {
                            selectedNode = 'second_node';
                          });
                        },
                      ),
                    ],
                  ),
                  // const SizedBox(height: 20),
                ],
              ),

              //ส่วนล่าง --> ผลลัพธ์
              if (selectedNode == 'second_node') ...[
                StreamBuilder<QuerySnapshot>(
                  stream: streamAddressWaiting,
                  builder: (context, snapshot) {
                    // 1. โหลดข้อมูลไม่ได้
                    if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    }
                    // 2. กำลังโหลดข้อมูล
                    else if (snapshot.connectionState ==
                        ConnectionState.waiting) {
                      return Center(
                        child: Container(
                          padding: const EdgeInsets.only(top: 100),
                          child: const CircularProgressIndicator(),
                        ),
                      );
                    }
                    // 3. เชื่อมต่อสำเร็จ
                    List<DocumentSnapshot> documents = snapshot.data!.docs;
                    return SizedBox(
                      height: 459,
                      child: SingleChildScrollView(
                        // physics: const ScrollPhysics(),
                        child: Column(
                          children: [
                            ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: documents.length,
                              itemBuilder: (context, index) {
                                DocumentSnapshot document = documents[index];
                                DateTime tsdate =
                                    DateTime.fromMillisecondsSinceEpoch(
                                        document['timestamp']);
                                int yearBuddhist = tsdate.year + 543;
                                String dateUpload =
                                    DateFormat('dd/MM/$yearBuddhist  hh:mm')
                                        .format(tsdate);
                                return documents.isEmpty
                                    ? const Center(
                                        child: Text(
                                          "ไม่พบข้อมูลแหล่งน้ำที่กำลังรอการอนุมัติ",
                                        ),
                                      )
                                    : Container(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 5, horizontal: 23),
                                        child: Card(
                                          shape: RoundedRectangleBorder(
                                            side: const BorderSide(
                                              color: Colors.grey,
                                              width: 1,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(15),
                                          ),
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                              vertical: 10,
                                            ),
                                            child: ListTile(
                                              leading: Container(
                                                height: 40,
                                                width: 70,
                                                decoration: BoxDecoration(
                                                  color: Colors.grey,
                                                  border: Border.all(
                                                    width: 2,
                                                    color: Colors.black,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                ),
                                                child: Center(
                                                  child: document['item'] != ""
                                                      ? Text(
                                                          document['item'],
                                                          style:
                                                              StyleDetailResult,
                                                        )
                                                      : const Text(
                                                          "NULL",
                                                          style:
                                                              StyleDetailResult,
                                                        ),
                                                ),
                                              ),
                                              title: Text(
                                                document['watertype'],
                                                style: StyleListWaterTitle,
                                              ),
                                              subtitle: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    dateUpload,
                                                    style: StyleTimeData,
                                                  ),
                                                  Wrap(
                                                    children: [
                                                      Text(
                                                        "${document['province']} , ",
                                                        style: StyleTimeData,
                                                      ),
                                                      Text(
                                                        "${document['district']} , ",
                                                        style: StyleTimeData,
                                                      ),
                                                      Text(
                                                        document['subdistrict'],
                                                        style: StyleTimeData,
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                              trailing: const Icon(
                                                Icons.arrow_forward_ios,
                                                size: 30,
                                                color: Color.fromARGB(
                                                    255, 97, 98, 100),
                                              ),
                                              onTap: () async {
                                                log(documents[index].id);
                                                await Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        DetailWaterScreen(
                                                      documentID:
                                                          documents[index].id,
                                                    ),
                                                  ),
                                                );
                                                setState(() {
                                                  streamAddressWaiting;
                                                  futureCountAddress =
                                                      countAddress();
                                                });
                                              },
                                            ),
                                          ),
                                        ),
                                      );
                              },
                            ),
                            const SizedBox(height: 20),
                          ],
                        ),
                      ),
                    );
                  },
                )
              ],
              if (selectedNode == 'first_node') ...[
                const SizedBox(height: 30),
                // Display Chart
                FutureBuilder(
                  future: futureCountAddress,
                  builder: (context, snapshot) {
                    // 1. โหลดข้อมูลไม่ได้
                    if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    }
                    // 2. กำลังโหลดข้อมูล
                    else if (snapshot.connectionState ==
                        ConnectionState.waiting) {
                      return Center(
                        child: Container(
                          padding: const EdgeInsets.only(top: 100),
                          child: const CircularProgressIndicator(),
                        ),
                      );
                    }
                    // 3. เชื่อมต่อสำเร็จ
                    return Container(
                      height: 220,
                      width: 480,
                      padding: const EdgeInsets.only(left: 10, right: 20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(
                          color: Colors.grey,
                        ),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.grey,
                            spreadRadius: 3,
                            blurRadius: 10,
                            offset: Offset(1, 4),
                          )
                        ],
                      ),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            //ค่า Row ด้านซ้าย
                            const SizedBox(width: 10),
                            Container(
                              width: 180,
                              height: 180,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.transparent,
                              ),
                              // Pie Chart
                              child: Column(
                                children: [
                                  Expanded(
                                    child: Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(bottom: 35),
                                          child: Text(
                                            "$totalAddress",
                                            style: StyleHeading,
                                          ),
                                        ),
                                        const Padding(
                                          padding: EdgeInsets.only(top: 50),
                                          child: Text(
                                            "รายการ",
                                            style: StyleTextChart,
                                          ),
                                        ),
                                        PieChart(
                                          PieChartData(
                                            borderData:
                                                FlBorderData(show: false),
                                            centerSpaceRadius: 60,
                                            sectionsSpace: 3,
                                            sections: [
                                              //item 1 สถานะ-->รออนุมัติ
                                              PieChartSectionData(
                                                value: totalAddressWaiting,
                                                color: Colors.grey,
                                                radius: 35,
                                                showTitle: false,
                                              ),
                                              //item 2 สถานะ-->สำเร็จ
                                              PieChartSectionData(
                                                value: totalAddressSuccess,
                                                color: Colors.green,
                                                radius: 35,
                                                showTitle: false,
                                              ),
                                              //item 3 สถานะ-->ไม่สำเร็จ
                                              PieChartSectionData(
                                                value: totalAddressRefuse,
                                                color: Colors.red,
                                                radius: 35,
                                                showTitle: false,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 20),
                            //ค่า Row ด้านขวา
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 45),
                                // 1
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      width: 24,
                                      height: 24,
                                      decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.green,
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    const Text(
                                      "สำเร็จ",
                                      style: StyleResultChart,
                                    ),
                                    const SizedBox(width: 50),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Text(
                                          "${totalAddressSuccess?.round()}",
                                          style: StyleResultChart,
                                        ),
                                        const SizedBox(width: 20),
                                        const Text(
                                          "รายการ",
                                          style: StyleResultChart,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 30),
                                // 2
                                Row(
                                  children: [
                                    Container(
                                      width: 24,
                                      height: 24,
                                      decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    const Text(
                                      "รออนุมัติ",
                                      style: StyleResultChart,
                                    ),
                                    const SizedBox(width: 29),
                                    Row(
                                      children: [
                                        Text(
                                          "${totalAddressWaiting?.round()}",
                                          style: StyleResultChart,
                                        ),
                                        const SizedBox(width: 20),
                                        const Text(
                                          "รายการ",
                                          style: StyleResultChart,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 30),
                                // 3
                                Row(
                                  children: [
                                    Container(
                                      width: 24,
                                      height: 24,
                                      decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.red,
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    const Text(
                                      "ไม่สำเร็จ",
                                      style: StyleResultChart,
                                    ),
                                    const SizedBox(width: 34),
                                    Row(
                                      children: [
                                        Text(
                                          "${totalAddressRefuse?.round()}",
                                          style: StyleResultChart,
                                        ),
                                        const SizedBox(width: 20),
                                        const Text(
                                          "รายการ",
                                          style: StyleResultChart,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 30),
                //ปุ่มประเภทแหล่งน้ำ
                SizedBox(
                  height: 110,
                  width: 480,
                  child: ButtonImage(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const WaterTypeScreen()));
                    },
                    buttonText: 'ข้อมูลประเภทแหล่งน้ำ',
                    imageWidth: 270,
                    imageHight: 180,
                    assetImage: 'assets/images/typewater.jpg',
                  ),
                ),
              ]
            ],
          ),
        ),
      ),
    );
  }
}
