import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application/css/style.dart';
import 'package:flutter_application/model/profile.dart';
import 'package:flutter_application/widgets/widget.dart';
import 'package:intl/intl.dart';

class NotificationScreen extends StatefulWidget {
  final List<Profile> userData;
  const NotificationScreen({super.key, required this.userData});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  List<Map<String, dynamic>> notificationsList = [];
  String? addedBy;
  @override
  void initState() {
    for (var data in widget.userData) {
      addedBy = data.email;
    }
    fetchNotifications();
    super.initState();
  }

  // *** FIREBASE ***
  // 1.เตรียม Firebase
  final Future<FirebaseApp> firebase = Firebase.initializeApp();
  // 2.กำหนด Collection ที่จะทำงาน
  CollectionReference addressCollection =
      FirebaseFirestore.instance.collection("addresses");

  Future fetchNotifications() async {
    QuerySnapshot querySnapshot = await addressCollection
        .where('added_by', isEqualTo: addedBy)
        .orderBy("timestamp", descending: true)
        .get();

    setState(() {
      notificationsList = querySnapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
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
            "การแจ้งเตือน",
            style: StyleAppbar,
          ),
        ),
        flexibleSpace: const BackgroundAppbar(),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0, //ลบแรเงา
      ),
      body: ListView.builder(
        itemCount: notificationsList.length,
        itemBuilder: (context, index) {
          var data = notificationsList[index];
          DateTime tsdate =
              DateTime.fromMillisecondsSinceEpoch(data['timestamp']);
          int yearBuddhist = tsdate.year + 543;
          String dateUpload =
              DateFormat('dd/MM/$yearBuddhist  hh:mm').format(tsdate);
          return notificationsList.isEmpty
              ? const Center(
                  child: Text(
                    "ไม่มีการแต้งเตือนใหม้",
                  ),
                )
              : ListTile(
                  leading: Container(
                    height: 40,
                    width: 70,
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      border: Border.all(
                        width: 2,
                        color: Colors.black,
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Center(
                      child: Text(data['item']),
                    ),
                  ),
                  title: Text(
                    data['watertype'],
                    style: StyleListWaterTitle,
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        dateUpload,
                        style: StyleTimeData,
                      ),
                      Wrap(
                        children: [
                          Text(
                            data['province'],
                            style: StyleTimeData,
                          ),
                          Text(
                            data['district'],
                            style: StyleTimeData,
                          ),
                          Text(
                            data['subdistrict'],
                            style: StyleTimeData,
                          ),
                        ],
                      )
                    ],
                  ),
                );
        },
      ),
    );
  }
}
