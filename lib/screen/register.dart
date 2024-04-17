import 'dart:developer';

import 'package:bcrypt/bcrypt.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application/css/style.dart';
// import 'package:flutter_application/model/profile.dart';
import 'package:flutter_application/screen/login.dart';
import 'package:intl/intl.dart';
import 'package:quickalert/quickalert.dart';
// import 'package:encrypt/encrypt.dart' as encrypt;
import '../widgets/widget.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  //form นำมาใช้ตรวจเช็คฟอร์มว่าดำเนินการรูปแบบใด -> reset , submit
  final formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  // Profile user = Profile();
  // String confirmPassword = '';
  // final _emailController = TextEditingController();
  // final _passwordController = TextEditingController();
  // final _confirmPasswordController = TextEditingController();
  // final _firstnameController = TextEditingController();
  // final _lastnameController = TextEditingController();
  //new
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _fullnameController = TextEditingController();
  final _telController = TextEditingController();

  //date time
  int timestamp = DateTime.now().millisecondsSinceEpoch;

  final Future<FirebaseApp> firebase = Firebase.initializeApp();
  CollectionReference usersCollection =
      FirebaseFirestore.instance.collection("users");

  Future signup() async {
    String email = _emailController.text;
    String password = _passwordController.text;
    String fullname = _fullnameController.text;
    String tel = _telController.text;

    DateTime tsdate = DateTime.fromMillisecondsSinceEpoch(timestamp);
    int yearBuddhist = tsdate.year + 543;
    String dateCurrent = DateFormat('dd MMMM $yearBuddhist').format(tsdate);

    QuerySnapshot querySnapshot =
        await usersCollection.where('email', isEqualTo: email).get();
    if (querySnapshot.docs.isEmpty) {
      if (passwordConfirmed()) {
        await usersCollection.add({
          "email": email,
          "password": BCrypt.hashpw(password, BCrypt.gensalt()),
          "fullname": fullname,
          "tel": tel,
          "position": "mobile",
          "dateSignup": dateCurrent,
          "timestamp": timestamp,
          "approve": "pass",
        });
        log("success");
        return;
      } else {
        return Future.error("รหัสผ่านไม่ตรงกัน");
      }
    } else {
      log("Email has arrived");
      return Future.error("มีอีเมลนี้ในระบบแล้ว");
    }
  }

  bool passwordConfirmed() {
    if (_passwordController.text.trim() ==
        _confirmPasswordController.text.trim()) {
      return true;
    } else {
      log("Password don't match");
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    //ขั้นแรกให้ตรวจสอบว่าเชื่อม Firebase ได้ไหม โดยใช้ FutureBuilder
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
        // 2. เชื่อมต่อสำเร็จ
        return Stack(
          children: [
            const BackgroundApp(),
            Scaffold(
                appBar: AppBar(
                  toolbarHeight: 60,
                  leading: Padding(
                    padding: const EdgeInsets.only(left: 30, top: 20),
                    child: IconButton(
                      icon: const Icon(
                        Icons.arrow_back_ios,
                        size: 30,
                        color: Colors.black,
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoginScreen(),
                          ),
                        );
                      },
                    ),
                  ),
                  backgroundColor: Colors.transparent,
                  elevation: 0, // นำแรเงาออก
                ),
                backgroundColor: Colors.transparent,
                key: scaffoldKey,
                body: SafeArea(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          //left: 100, top: 310
                          padding: const EdgeInsets.only(left: 100, top: 150),
                          child: const Column(
                            children: [
                              Text(
                                "สมัครสมาชิก",
                                style: StyleTitleLogin,
                              ),
                              // Text(
                              //   "โปรดกรอกข้อมูล",
                              //   style: TextStyle(
                              //     fontFamily: "Kanit",
                              //     fontSize: 30,
                              //     color: Colors.blue,
                              //   ),
                              // ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.only(left: 40, right: 40),
                          child: Form(
                            key: formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 25),
                                Container(
                                  padding: const EdgeInsets.only(
                                      left: 40, right: 40),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Column(
                                    children: [
                                      const SizedBox(height: 10),
                                      InputText(
                                        icon: Icons.person_2_outlined,
                                        sizeIcon: 30,
                                        colorIcon: const Color.fromARGB(
                                            255, 131, 131, 131),
                                        labelText: "ชื่อ - สกุล",
                                        labelTextStyle: StyleLabelRegister,
                                        borderSideEnable: const BorderSide(
                                          color: Colors.grey,
                                          width: 2,
                                        ),
                                        inputType: TextInputType.text,
                                        inputAction: TextInputAction.next,
                                        controller: _fullnameController,
                                        validatorText:
                                            "กรุณากรอกชื่อภาษาไทยที่ถูกต้อง",
                                        pattern: r'^[ก-๏ /s]+$',
                                      ),
                                      const SizedBox(height: 15),
                                      InputText(
                                        icon: Icons.email_outlined,
                                        sizeIcon: 30,
                                        colorIcon: const Color.fromARGB(
                                            255, 131, 131, 131),
                                        labelText: "อีเมล",
                                        labelTextStyle: StyleLabelRegister,
                                        borderSideEnable: const BorderSide(
                                          color: Colors.grey,
                                          width: 2,
                                        ),
                                        inputType: TextInputType.emailAddress,
                                        inputAction: TextInputAction.next,
                                        controller: _emailController,
                                        validatorText:
                                            "กรุณากรอกอีเมลที่ถูกต้อง",
                                        pattern:
                                            r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}',
                                      ),
                                      const SizedBox(height: 15),
                                      InputPassword(
                                        icon: Icons.lock_outline,
                                        sizeIcon: 30,
                                        colorIcon: const Color.fromARGB(
                                            255, 131, 131, 131),
                                        labelText: "รหัสผ่าน",
                                        labelTextStyle: StyleLabelRegister,
                                        borderSideEnable: const BorderSide(
                                          color: Colors.grey,
                                          width: 2,
                                        ),
                                        inputType: TextInputType.text,
                                        inputAction: TextInputAction.next,
                                        controller: _passwordController,
                                        validatorText:
                                            "กรุณากรอกรหัสผ่านที่ถูกต้อง",
                                        pattern: r'^[a-z A-z 0-9]+$',
                                      ),
                                      const SizedBox(height: 15),
                                      InputPassword(
                                        icon: Icons.lock_outline,
                                        sizeIcon: 30,
                                        colorIcon: const Color.fromARGB(
                                            255, 131, 131, 131),
                                        labelText: "ยืนยันรหัสผ่าน",
                                        labelTextStyle: StyleLabelRegister,
                                        borderSideEnable: const BorderSide(
                                          color: Colors.grey,
                                          width: 2,
                                        ),
                                        inputType: TextInputType.text,
                                        inputAction: TextInputAction.next,
                                        controller: _confirmPasswordController,
                                        validatorText:
                                            "กรุณากรอกรหัสผ่านที่ถูกต้อง",
                                        pattern: r'^[a-z A-z 0-9]+$',
                                      ),
                                      const SizedBox(height: 15),
                                      InputText(
                                        icon: Icons.phone_android_outlined,
                                        sizeIcon: 30,
                                        colorIcon: const Color.fromARGB(
                                            255, 131, 131, 131),
                                        labelText: "เบอร์โทรศัพท์",
                                        labelTextStyle: StyleLabelRegister,
                                        borderSideEnable: const BorderSide(
                                          color: Colors.grey,
                                          width: 2,
                                        ),
                                        inputType: TextInputType.phone,
                                        inputAction: TextInputAction.next,
                                        controller: _telController,
                                        validatorText:
                                            "กรุณากรอกเบอร์โทรศัพท์ที่ถูกต้อง",
                                        pattern: r'^[0-9]',
                                      ),
                                      const SizedBox(height: 20),
                                      Row(
                                        children: [
                                          // ButtonCircle(
                                          //   colorBackground: Colors.red,
                                          //   icon: Icons.close,
                                          //   colorIcon: Colors.white,
                                          // ),
                                          // Text("   ยกเลิก",
                                          //     style: StyleLabelRegister),
                                          const SizedBox(width: 240),
                                          const Text("ยืนยัน   ",
                                              style: StyleNormalTextBlack),
                                          ButtonCircle(
                                            colorBackground: Colors.green,
                                            icon: Icons.check,
                                            colorIcon: Colors.white,
                                            onPressed: () {
                                              if (formKey.currentState!
                                                  .validate()) {
                                                formKey.currentState!.save();
                                                signup()
                                                    .then(
                                                      (res) => {
                                                        QuickAlert.show(
                                                          context: context,
                                                          type: QuickAlertType
                                                              .success,
                                                          title:
                                                              "สำเร็จ! โปรดรอการอนุมัติจากหน่วยงาน",
                                                          confirmBtnText:
                                                              "โอเค",
                                                          barrierDismissible:
                                                              false, //การกดบริเวณนอก Alert
                                                          onConfirmBtnTap: () {
                                                            formKey
                                                                .currentState!
                                                                .reset();
                                                            Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        const LoginScreen(),
                                                              ),
                                                            );
                                                          },
                                                        ),
                                                        formKey.currentState!
                                                            .reset(),
                                                      },
                                                    )
                                                    .catchError(
                                                      (error) => {
                                                        QuickAlert.show(
                                                          context: context,
                                                          type: QuickAlertType
                                                              .error,
                                                          title: error,
                                                          confirmBtnText:
                                                              "โอเค",
                                                          barrierDismissible:
                                                              false, //การกดบริเวณนอก Alert
                                                          onConfirmBtnTap: () {
                                                            if (error ==
                                                                "มีอีเมลนี้ในระบบแล้ว") {
                                                              Navigator.pop(
                                                                  context);
                                                              _emailController
                                                                  .clear();
                                                            } else {
                                                              Navigator.pop(
                                                                  context);
                                                              _passwordController
                                                                  .clear();
                                                              _confirmPasswordController
                                                                  .clear();
                                                            }
                                                          },
                                                        ),
                                                      },
                                                    );
                                              }
                                            },
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 20),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                )),
          ],
        );
      },
    );
  }
}
