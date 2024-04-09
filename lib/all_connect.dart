// ignore_for_file: must_be_immutable
import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application/model/profile.dart';
import 'package:flutter_application/page/mock.dart';
import 'package:flutter_application/screen/add_water.dart';
// import 'page/connect.dart';
import 'page/home.dart';
import 'page/history.dart';
import 'page/menu.dart';

class AllConnect extends StatefulWidget {
  List<Profile> userData;
  AllConnect({super.key, required this.userData});

  @override
  State<AllConnect> createState() => _AllConnectState();
}

class _AllConnectState extends State<AllConnect> {
  late Future<List<Profile>> futureProfile;

  int currentTab = 0;

  final List<Widget> screens = [
    HomePage(userData: const []),
    const Mockpage(),
    const HistoryPage(userData: []),
    MenuPage(userData: const []),
    const AddWaterScreen(userData: []),
  ];

  final PageStorageBucket bucket = PageStorageBucket();

  Widget currentScreen = HomePage(userData: const []);

  // *** FIREBASE ***
  // 1.เตรียม Firebase
  final Future<FirebaseApp> firebase = Firebase.initializeApp();
  // 2.กำหนด Collection(User) ที่จะทำงาน
  CollectionReference usersCollection =
      FirebaseFirestore.instance.collection("users");

  Future<List<Profile>> fetchUpdatedData() async {
    List<Profile> updatedData = [];
    String? userID;
    for (Profile data in widget.userData) {
      userID = data.id;
    }
    DocumentSnapshot docUser = await usersCollection.doc(userID).get();
    final data = docUser.data() as Map<String, dynamic>;
    //sos
    Profile emailData = Profile(
      email: data['email'],
      password: data['password'],
      fullname: data['fullname'],
      tel: data['tel'],
      id: userID,
    );
    updatedData.add(emailData);
    return updatedData;
  } // อัปเดตข้อมูลใน List อีกครั้ง หลังการแก้ไข

  @override
  void initState() {
    super.initState();
    futureProfile = fetchUpdatedData();
    currentScreen = HomePage(userData: widget.userData);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Profile>>(
      future: futureProfile,
      builder: (context, snapshot) {
        // 1. เชื่อมต่อไม่ได้
        if (snapshot.hasError) {
          return Scaffold(
            appBar: AppBar(
              title: const Text("Error"),
            ),
            body: Center(child: Text("${snapshot.error}")),
          );
          // 2. กำลังโหลดข้อมูล
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        // 3. เชื่อมต่อสำเร็จ
        return Scaffold(
          // resizeToAvoidBottomInset: false,
          body: PageStorage(
            bucket: bucket,
            child: currentScreen,
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          floatingActionButton: SizedBox(
            height: 75,
            width: 75,
            child: FloatingActionButton(
              onPressed: () async {
                List<Profile> updatedData = await fetchUpdatedData();
                // setState(() {
                //   currentScreen = AddWaterScreen(userData: updatedData);
                // });
                if (!mounted) return;
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AddWaterScreen(
                            userData:
                                updatedData))); // ส่งค่า List ที่อัปเดตแล้วไป
                //sos
                setState(() {
                  widget.userData = updatedData;
                });
              },
              backgroundColor: const Color.fromARGB(255, 3, 109, 68),
              shape: const CircleBorder(),
              child: const Icon(
                Icons.add,
                size: 60,
              ),
            ),
          ),
          bottomNavigationBar: SizedBox(
            height: 85,
            child: BottomAppBar(
              shape: const CircularNotchedRectangle(),
              notchMargin: 5,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  //Tab Bar Icon ด้านซ้าย
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      MaterialButton(
                        minWidth: 110,
                        onPressed: () async {
                          List<Profile> updatedData = await fetchUpdatedData();
                          setState(() {
                            // widget.userData = updatedData;
                            currentScreen = HomePage(userData: updatedData);
                            currentTab = 0;
                          });
                        },
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.home_rounded,
                                size: 38,
                                color: currentTab == 0
                                    ? const Color.fromARGB(255, 3, 160, 8)
                                    : Colors.grey,
                              ),
                              Text(
                                "หน้าหลัก",
                                style: TextStyle(
                                  color: currentTab == 0
                                      ? const Color.fromARGB(255, 3, 160, 8)
                                      : Colors.grey,
                                  fontFamily: 'Kanit',
                                  fontSize: 15,
                                ),
                              )
                            ]),
                      ),
                      MaterialButton(
                        minWidth: 110,
                        onPressed: () {
                          setState(() {
                            currentScreen = const Mockpage();
                            currentTab = 1;
                          });
                        },
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.share_outlined,
                                size: 38,
                                color: currentTab == 1
                                    ? const Color.fromARGB(255, 3, 160, 8)
                                    : Colors.grey,
                              ),
                              Text(
                                "เชื่อมต่อ",
                                style: TextStyle(
                                  color: currentTab == 1
                                      ? const Color.fromARGB(255, 3, 160, 8)
                                      : Colors.grey,
                                  fontFamily: 'Kanit',
                                  fontSize: 15,
                                ),
                              )
                            ]),
                      ),
                    ],
                  ),

                  //Tab Bar Icon ด้านขวา
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      MaterialButton(
                        minWidth: 110,
                        onPressed: () async {
                          List<Profile> updatedData = await fetchUpdatedData();
                          setState(() {
                            currentScreen = HistoryPage(userData: updatedData);
                            currentTab = 2;
                          });
                        },
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.restore_rounded,
                                size: 38,
                                color: currentTab == 2
                                    ? const Color.fromARGB(255, 3, 160, 8)
                                    : Colors.grey,
                              ),
                              Text(
                                "ประวัติ",
                                style: TextStyle(
                                  color: currentTab == 2
                                      ? const Color.fromARGB(255, 3, 160, 8)
                                      : Colors.grey,
                                  fontFamily: 'Kanit',
                                  fontSize: 15,
                                ),
                              )
                            ]),
                      ),
                      MaterialButton(
                        minWidth: 110,
                        onPressed: () async {
                          List<Profile> updatedData = await fetchUpdatedData();
                          setState(() {
                            currentScreen = MenuPage(userData: updatedData);
                            currentTab = 3;
                          });
                        },
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.menu_rounded,
                                size: 38,
                                color: currentTab == 3
                                    ? const Color.fromARGB(255, 3, 160, 8)
                                    : Colors.grey,
                              ),
                              Text(
                                "เมนู",
                                style: TextStyle(
                                  color: currentTab == 3
                                      ? const Color.fromARGB(255, 3, 160, 8)
                                      : Colors.grey,
                                  fontFamily: 'Kanit',
                                  fontSize: 15,
                                ),
                              )
                            ]),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
