import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application/model/profile.dart';
import 'package:flutter_application/screen/detail_water.dart';
import 'package:flutter_application/screen/login.dart';
import 'package:intl/intl.dart';
import '../css/style.dart';
import '../widgets/widget.dart';

class HistoryPage extends StatefulWidget {
  final List<Profile> userData;
  const HistoryPage({super.key, required this.userData});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  late Future<dynamic> futureUser;
  String selectedNode = 'first_node';
  String? id;
  String? addedBy;

  @override
  void initState() {
    super.initState();
    for (var data in widget.userData) {
      id = data.id;
      addedBy = data.email;
    }
    log("added_by= $addedBy");
    futureUser = fetchUserDetail();
    streamAddressSuccess;
    countAddress();
  }

  // *** FIREBASE ***
  // 1.เตรียม Firebase
  final Future<FirebaseApp> firebase = Firebase.initializeApp();
  // 2.กำหนด Collection ที่จะทำงาน
  CollectionReference usersCollection =
      FirebaseFirestore.instance.collection("users");
  CollectionReference addressCollection =
      FirebaseFirestore.instance.collection("addresses");

  Future fetchUserDetail() async {
    DocumentSnapshot docUser = await usersCollection.doc(id).get();
    final data = docUser.data() as Map<String, dynamic>;

    List<Profile> result = [];
    Profile detail = Profile(
      id: id,
      email: data['email'],
      fullname: data['fullname'],
      tel: data['tel'],
      imageRrofile: data['imageRrofile'],
    );
    result.add(detail);
    log("data: $result");
    return Profile.formMap(docUser);
  }

  late Stream<QuerySnapshot> streamAddressTotal = addressCollection
      .where('added_by', isEqualTo: addedBy)
      .where('approve', whereIn: ["success", "waiting", "refuse"])
      .orderBy("timestamp", descending: true)
      .snapshots();
  late Stream<QuerySnapshot> streamAddressSuccess = addressCollection
      .where('added_by', isEqualTo: addedBy)
      .where('approve', isEqualTo: "success")
      .orderBy("timestamp", descending: true)
      .snapshots();
  late Stream<QuerySnapshot> streamAddressRefuse = addressCollection
      .where('added_by', isEqualTo: addedBy)
      .where('approve', isEqualTo: "refuse")
      .orderBy("timestamp", descending: true)
      .snapshots();
  late Stream<QuerySnapshot> streamAddressCancel = addressCollection
      .where('added_by', isEqualTo: addedBy)
      .where('approve', isEqualTo: "cancel")
      .orderBy("timestamp", descending: true)
      .snapshots();

  double? totalAddress;
  double? totalAddressSuccess;
  double? totalAddressRefuse;
  double? totalAddressCancel;
  Future countAddress() async {
    //count --> total
    final countTotal = await addressCollection
        .where('added_by', isEqualTo: addedBy)
        .where('approve', whereIn: ["success", "waiting", "refuse"])
        .count()
        .get();
    totalAddress = countTotal.count.ceilToDouble();
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
    //count --> cancel
    final countCancel = await addressCollection
        .where('added_by', isEqualTo: addedBy)
        .where('approve', isEqualTo: "cancel")
        .count()
        .get();
    totalAddressCancel = countCancel.count.ceilToDouble();

    setState(() {
      totalAddress;
      totalAddressSuccess;
      totalAddressRefuse;
      totalAddressCancel;
    });
    //print
    log("Count total = $totalAddress");
    log("Count Success = $totalAddressSuccess");
    log("Count Refuse = $totalAddressRefuse");
    log("Count Waiting = $totalAddressCancel");
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<dynamic>(
      future: futureUser,
      builder: (context, snapshot) {
        // 1. เชื่อมต่อไม่ได้
        if (snapshot.hasError) {
          return Scaffold(
            backgroundColor: const Color.fromARGB(255, 207, 205, 205),
            appBar: AppBar(
              toolbarHeight: 80, //ขนาดความสูง Appbar
              title: const Text(
                'ประวัติการเพิ่มแหล่งน้ำ',
                style: StyleAppbar,
              ),
              flexibleSpace: const BackgroundAppbar(),
              automaticallyImplyLeading: false, //ยกเลิกปุ่มย้อนกลับ
              centerTitle: true, //ข้อความตรงกลาง
              backgroundColor: Colors.transparent, //สีพื้นหลังเริ่มต้น->โปร่งใส
              elevation: 0, //ลบแรเงา
            ),
            body: SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.only(top: 100),
                child: Column(
                  children: [
                    const Text(
                      "ไม่พบข้อมูล โปรดเข้าสู่ระบบอีกครั้ง",
                      style: StyleListWaterTitle,
                    ),
                    const SizedBox(height: 30),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 250),
                      child: ButtonSolid(
                        buttonText: "เข้าสู่ระบบ",
                        textStyle: StyleFontButtonBlue,
                        fixedheight: 60,
                        fixedwidth: 325,
                        icon: Icons.login,
                        colorIcon: Colors.white,
                        color: Colors.blue,
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const LoginScreen()));
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }
        // 2. กำลังโหลดข้อมูล
        else if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        // 3. เชื่อมต่อสำเร็จ
        return Scaffold(
          backgroundColor: const Color.fromARGB(255, 207, 205, 205),
          appBar: AppBar(
            toolbarHeight: 80, //ขนาดความสูง Appbar
            title: const Text(
              'ประวัติการเพิ่มแหล่งน้ำ',
              style: StyleAppbar,
            ),
            flexibleSpace: const BackgroundAppbar(),
            automaticallyImplyLeading: false, //ยกเลิกปุ่มย้อนกลับ
            centerTitle: true, //ข้อความตรงกลาง
            backgroundColor: Colors.transparent, //สีพื้นหลังเริ่มต้น->โปร่งใส
            elevation: 0, //ลบแรเงา
          ),
          body: SafeArea(
            child: SizedBox(
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  //ส่วนบน --> ปุ่มต่างๆ
                  Column(
                    children: [
                      const SizedBox(height: 10),
                      Row(
                        // crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ButtonUnderline(
                            horizont: 37,
                            buttonText: 'ทั้งหมด',
                            fontsize: 25,
                            circleContainer: Padding(
                              padding:
                                  const EdgeInsets.only(left: 4, bottom: 6),
                              child: Container(
                                width: 20,
                                height: 20,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.orange,
                                ),
                                child: Center(
                                  child: Text("${totalAddress?.toInt()}"),
                                ),
                              ),
                            ),
                            node: 'first_node',
                            isSelected: selectedNode == 'first_node',
                            onPressed: () {
                              setState(() {
                                selectedNode = 'first_node';
                              });
                            },
                          ),
                          ButtonUnderline(
                            horizont: 43,
                            buttonText: 'สำเร็จ',
                            fontsize: 25,
                            circleContainer: Padding(
                              padding:
                                  const EdgeInsets.only(left: 4, bottom: 6),
                              child: Container(
                                width: 20,
                                height: 20,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.orange,
                                ),
                                child: Center(
                                  child:
                                      Text("${totalAddressSuccess?.toInt()}"),
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
                          ButtonUnderline(
                            horizont: 35,
                            buttonText: 'ไม่สำเร็จ',
                            fontsize: 25,
                            circleContainer: Padding(
                              padding:
                                  const EdgeInsets.only(left: 4, bottom: 6),
                              child: Container(
                                width: 20,
                                height: 20,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.orange,
                                ),
                                child: Center(
                                  child: Text("${totalAddressRefuse?.toInt()}"),
                                ),
                              ),
                            ),
                            node: 'third_node',
                            isSelected: selectedNode == 'third_node',
                            // buttonText: "รออนุมัติ",
                            onPressed: () {
                              setState(() {
                                selectedNode = 'third_node';
                              });
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),

                  //ส่วนล่าง --> ผลลัพธ์
                  if (selectedNode == 'first_node') ...[
                    StreamBuilder<QuerySnapshot>(
                      stream: streamAddressTotal,
                      builder: (context, snapshot) {
                        // 1. โหลดข้อมูลไม่ได้
                        if (snapshot.hasError) {
                          return Center(
                              child: Text('Error: ${snapshot.error}'));
                        }
                        // 2. กำลังโหลดข้อมูล
                        else if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: Padding(
                              padding: EdgeInsets.only(top: 200),
                              child: CircularProgressIndicator(),
                            ),
                          );
                        }
                        // 3. เชื่อมต่อสำเร็จ
                        List<DocumentSnapshot> documents = snapshot.data!.docs;
                        return SizedBox(
                          height: 569,
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: documents.length,
                                  itemBuilder: (context, index) {
                                    DocumentSnapshot document =
                                        documents[index];
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
                                            // height: 130,
                                            child: Card(
                                              shape: RoundedRectangleBorder(
                                                side: const BorderSide(
                                                  color: Colors.grey,
                                                  width: 1,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                              ),
                                              child: ListTile(
                                                leading: Container(
                                                  height: 40,
                                                  width: 70,
                                                  decoration: BoxDecoration(
                                                    color: document[
                                                                'approve'] ==
                                                            "success"
                                                        ? Colors.green
                                                        : document['approve'] ==
                                                                "refuse"
                                                            ? Colors.red
                                                            : Colors.grey,
                                                    border: Border.all(
                                                      width: 2,
                                                      color: Colors.black,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                  ),
                                                  child: Center(
                                                    child: document['item'] !=
                                                            ""
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
                                                          "${document['province']}, ",
                                                          style: StyleTimeData,
                                                        ),
                                                        Text(
                                                          "${document['district']}, ",
                                                          style: StyleTimeData,
                                                        ),
                                                        Text(
                                                          document[
                                                              'subdistrict'],
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
                                                onTap: () {
                                                  log(documents[index].id);
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              DetailWaterScreen(
                                                                documentID:
                                                                    documents[
                                                                            index]
                                                                        .id,
                                                              )));
                                                },
                                              ),
                                            ),
                                          );
                                  },
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    )
                  ],
                  if (selectedNode == 'second_node') ...[
                    StreamBuilder<QuerySnapshot>(
                      stream: streamAddressSuccess,
                      builder: (context, snapshot) {
                        // 1. โหลดข้อมูลไม่ได้
                        if (snapshot.hasError) {
                          return Center(
                              child: Text('Error: ${snapshot.error}'));
                        }
                        // 2. กำลังโหลดข้อมูล
                        else if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: Padding(
                              padding: EdgeInsets.only(top: 200),
                              child: CircularProgressIndicator(),
                            ),
                          );
                        }
                        // 3. เชื่อมต่อสำเร็จ
                        List<DocumentSnapshot> documents = snapshot.data!.docs;
                        return SizedBox(
                          height: 569,
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: documents.length,
                                  itemBuilder: (context, index) {
                                    DocumentSnapshot document =
                                        documents[index];
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
                                            // height: 130,
                                            child: Card(
                                              shape: RoundedRectangleBorder(
                                                side: const BorderSide(
                                                  color: Colors.grey,
                                                  width: 1,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                              ),
                                              child: ListTile(
                                                leading: Container(
                                                  height: 40,
                                                  width: 70,
                                                  decoration: BoxDecoration(
                                                    color: Colors.green,
                                                    border: Border.all(
                                                      width: 2,
                                                      color: Colors.black,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                  ),
                                                  child: Center(
                                                    child: document['item'] !=
                                                            ""
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
                                                          "${document['province']}, ",
                                                          style: StyleTimeData,
                                                        ),
                                                        Text(
                                                          "${document['district']}, ",
                                                          style: StyleTimeData,
                                                        ),
                                                        Text(
                                                          document[
                                                              'subdistrict'],
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
                                                onTap: () {
                                                  log(documents[index].id);
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              DetailWaterScreen(
                                                                documentID:
                                                                    documents[
                                                                            index]
                                                                        .id,
                                                              )));
                                                },
                                              ),
                                            ),
                                          );
                                  },
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    )
                  ],
                  if (selectedNode == 'third_node') ...[
                    StreamBuilder<QuerySnapshot>(
                      stream: streamAddressRefuse,
                      builder: (context, snapshot) {
                        // 1. โหลดข้อมูลไม่ได้
                        if (snapshot.hasError) {
                          return Center(
                              child: Text('Error: ${snapshot.error}'));
                        }
                        // 2. กำลังโหลดข้อมูล
                        else if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: Padding(
                              padding: EdgeInsets.only(top: 200),
                              child: CircularProgressIndicator(),
                            ),
                          );
                        }
                        // 3. เชื่อมต่อสำเร็จ
                        List<DocumentSnapshot> documents = snapshot.data!.docs;
                        return SizedBox(
                          height: 569,
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: documents.length,
                                  itemBuilder: (context, index) {
                                    DocumentSnapshot document =
                                        documents[index];
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
                                              child: ListTile(
                                                leading: Container(
                                                  height: 40,
                                                  width: 70,
                                                  decoration: BoxDecoration(
                                                    color: Colors.red,
                                                    border: Border.all(
                                                      width: 2,
                                                      color: Colors.black,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                  ),
                                                  child: Center(
                                                    child: document['item'] !=
                                                            ""
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
                                                          "${document['province']}, ",
                                                          style: StyleTimeData,
                                                        ),
                                                        Text(
                                                          "${document['district']}, ",
                                                          style: StyleTimeData,
                                                        ),
                                                        Text(
                                                          document[
                                                              'subdistrict'],
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
                                                onTap: () {
                                                  log(documents[index].id);
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              DetailWaterScreen(
                                                                documentID:
                                                                    documents[
                                                                            index]
                                                                        .id,
                                                              )));
                                                },
                                              ),
                                            ),
                                          );
                                  },
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    )
                  ]
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
