import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application/model/profile.dart';
import 'package:flutter_application/widgets/widget.dart';
import 'package:quickalert/quickalert.dart';
import '../css/style.dart';

class EditProfileScreen extends StatefulWidget {
  final List<Profile> userData;
  const EditProfileScreen({super.key, required this.userData});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  //form นำมาใช้ตรวจเช็คฟอร์มว่าดำเนินการรูปแบบใด -> reset , submit
  final formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  final _emailController = TextEditingController();
  final _fullnameController = TextEditingController();
  final _telController = TextEditingController();

  // *** FIREBASE ***
  // 1.เตรียม Firebase
  final Future<FirebaseApp> firebase = Firebase.initializeApp();
  // 2.กำหนด Collection ที่จะทำงาน
  CollectionReference usersCollection =
      FirebaseFirestore.instance.collection("users");

  Future updateUser() async {
    String email = _emailController.text;
    String fullname = _fullnameController.text;
    String tel = _telController.text;

    String? userID;
    for (Profile data in widget.userData) {
      userID = data.id;
    }
    await usersCollection.doc(userID).update({
      "email": email,
      "fullname": fullname,
      "tel": tel,
    });
    log("update profile success");
    // return;
  }

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
    for (var data in widget.userData) {
      _fullnameController.text = "${data.fullname}";
      _telController.text = "${data.tel}";
      _emailController.text = "${data.email}";
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: firebase,
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
        return Stack(children: [
          Scaffold(
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
                    onPressed: () async {
                      List<Profile> updatedData = await fetchUpdatedData();
                      // log("$updatedData");
                      // if (!mounted) return;
                      if (mounted) {
                        Navigator.pop(context, updatedData);
                      }
                    },
                  ),
                ),
                title: const Padding(
                  padding: EdgeInsets.only(top: 15),
                  child: Text(
                    "แก้ไขโปรไฟล์",
                    style: StyleAppbar,
                  ),
                ),
                flexibleSpace: const BackgroundAppbar(),
                centerTitle: true,
                backgroundColor: Colors.transparent,
                elevation: 0, //ลบแรเงา
              ),
              key: scaffoldKey,
              body: SafeArea(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.only(left: 50, right: 50),
                        child: Form(
                          key: formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 100),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 25,
                                  vertical: 10,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Column(
                                  children: [
                                    const SizedBox(height: 20),
                                    InputText(
                                      icon: Icons.email_outlined,
                                      sizeIcon: 30,
                                      colorIcon: const Color.fromARGB(
                                          255, 105, 104, 104),
                                      labelText: "อีเมล",
                                      labelTextStyle: StyleLabelRegister,
                                      borderSideEnable: const BorderSide(
                                        color:
                                            Color.fromARGB(255, 105, 104, 104),
                                        width: 2,
                                      ),
                                      inputType: TextInputType.emailAddress,
                                      inputAction: TextInputAction.next,
                                      controller: _emailController,
                                      pattern:
                                          r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}',
                                      validatorText: "กรุณากรอกอีเมลที่ถูกต้อง",
                                      // onSaved: (email) {
                                      //   user.email = email;
                                      // },
                                    ),
                                    const SizedBox(height: 20),
                                    InputText(
                                      icon: Icons.person_2_outlined,
                                      sizeIcon: 30,
                                      colorIcon: const Color.fromARGB(
                                          255, 105, 104, 104),
                                      labelText: "ชื่อ - สกุล",
                                      labelTextStyle: StyleLabelRegister,
                                      borderSideEnable: const BorderSide(
                                        color:
                                            Color.fromARGB(255, 105, 104, 104),
                                        width: 2,
                                      ),
                                      inputType: TextInputType.name,
                                      inputAction: TextInputAction.next,
                                      controller: _fullnameController,
                                      pattern: r'^[ก-๏ /s]+$',
                                      validatorText:
                                          "กรุณากรอกชื่อภาษาไทยที่ถูกต้อง",
                                      // onSaved: (fullname) {
                                      //   user.fullname = fullname;
                                      // },
                                    ),
                                    const SizedBox(height: 20),
                                    InputText(
                                      icon: Icons.phone_android_outlined,
                                      sizeIcon: 30,
                                      colorIcon: const Color.fromARGB(
                                          255, 105, 104, 104),
                                      labelText: "เบอร์โทรศัพท์",
                                      labelTextStyle: StyleLabelRegister,
                                      borderSideEnable: const BorderSide(
                                        color:
                                            Color.fromARGB(255, 105, 104, 104),
                                        width: 2,
                                      ),
                                      inputType: TextInputType.name,
                                      inputAction: TextInputAction.next,
                                      controller: _telController,
                                      pattern: r'^[0-9]+$',
                                      validatorText:
                                          "กรุณากรอกเบอร์โทรศัพท์ที่ถูกต้อง",
                                      // onSaved: (lastname) {
                                      //   user.lastname = lastname;
                                      // },
                                    ),
                                    const SizedBox(height: 70),
                                    ButtonSolid(
                                      buttonText: "ยืนยันการแก้ไข",
                                      textStyle: StyleFontButtonBlue,
                                      fixedheight: 55,
                                      fixedwidth: 310,
                                      icon: Icons.send_rounded,
                                      colorIcon: Colors.white,
                                      color: Colors.blue,
                                      onPressed: () {
                                        if (formKey.currentState!.validate()) {
                                          formKey.currentState!.save();
                                          updateUser().then((res) => {
                                                QuickAlert.show(
                                                  context: context,
                                                  type: QuickAlertType.success,
                                                  title: "แก้ไขข้อมูลสำเร็จ",
                                                  confirmBtnText: "โอเค",
                                                  barrierDismissible:
                                                      false, //การกดบริเวณนอก Alert
                                                  onConfirmBtnTap: () {
                                                    Navigator.pop(context);
                                                  },
                                                )
                                              });
                                        }
                                      },
                                    ),
                                    const SizedBox(height: 30),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )),
        ]);
      },
    );
  }
}
