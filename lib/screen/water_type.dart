import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application/css/style.dart';
import 'package:flutter_application/widgets/widget.dart';

class WaterTypeScreen extends StatefulWidget {
  const WaterTypeScreen({super.key});

  @override
  State<WaterTypeScreen> createState() => _WaterTypeScreenState();
}

class _WaterTypeScreenState extends State<WaterTypeScreen> {
  // *** FIREBASE ***
  // 1.เตรียม Firebase
  final Future<FirebaseApp> firebase = Firebase.initializeApp();
  // 2.กำหนด Collection ที่จะทำงาน
  CollectionReference watertypeCollection =
      FirebaseFirestore.instance.collection("watertype");

  late Stream<QuerySnapshot> streamWaterType = watertypeCollection.snapshots();

  int? totalWaterType;
  Future countData() async {
    final countWaterType = await watertypeCollection.count().get();
    totalWaterType = countWaterType.count;
    log("total water type: $totalWaterType");
  }

  @override
  void initState() {
    super.initState();
    countData();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: streamWaterType,
      builder: (context, snapshot) {
        // 1. โหลดข้อมูลไม่ได้
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        // 2. กำลังโหลดข้อมูล
        else if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: Container(
              padding: const EdgeInsets.only(top: 100),
              child: const CircularProgressIndicator(),
            ),
          );
        }
        // 3. เชื่อมต่อสำเร็จ
        List<DocumentSnapshot> documents = snapshot.data!.docs;
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
                "ข้อมูลประเภทแหล่งน้ำ",
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
              Expanded(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 30, horizontal: 55),
                  child: GridView.builder(
                    shrinkWrap: true,
                    itemCount: documents.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                    ),
                    itemBuilder: (context, index) {
                      DocumentSnapshot document = documents[index];
                      return documents.isEmpty
                          ? const Center(
                              child: Text(
                                "ไม่พบข้อมูลประเภทแหล่งน้ำ",
                              ),
                            )
                          : Container(
                              // color: Colors.red,
                              // padding: const EdgeInsets.only(
                              //   // top: 20,
                              //   left: 10,
                              //   right: 10,
                              // ),
                              margin: const EdgeInsets.symmetric(
                                vertical: 20,
                                horizontal: 10,
                              ),
                              child: InkWell(
                                child: Card(
                                  child: Center(
                                    child: Text(
                                      document['name'],
                                      style: StyleWaterName,
                                    ),
                                  ),
                                ),
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) => Dialog(
                                      child: Stack(
                                        alignment: Alignment.center,
                                        children: [
                                          Container(
                                            width: 580,
                                            height: 400,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                              color: Colors.white,
                                              border: Border.all(
                                                width: 4,
                                                color: const Color.fromARGB(
                                                    255, 88, 90, 91),
                                              ),
                                            ),
                                            child: Column(
                                              children: [
                                                const SizedBox(height: 20),
                                                Center(
                                                  child: Text(
                                                    document['name'],
                                                    style: StylewaterNameDialog,
                                                  ),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                    vertical: 20,
                                                    horizontal: 20,
                                                  ),
                                                  child: Text(
                                                    document['detail'],
                                                    style: StylewaterDetail,
                                                  ),
                                                ),
                                                Image.network(
                                                  document['urlImage'],
                                                  fit: BoxFit.cover,
                                                  height: 200,
                                                  width: 400,
                                                )
                                              ],
                                            ),
                                          ),
                                          Positioned(
                                            right: 10,
                                            top: 10,
                                            child: IconButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              icon: const Icon(
                                                Icons.close_rounded,
                                              ),
                                              iconSize: 40,
                                              color: Colors.red,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            );
                    },
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
