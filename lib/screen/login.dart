import 'dart:developer';

import 'package:bcrypt/bcrypt.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application/css/style.dart';
import 'package:flutter_application/all_connect.dart';
import 'package:flutter_application/model/profile.dart';
import 'package:flutter_application/screen/find_email.dart';
import 'package:flutter_application/screen/register.dart';
import 'package:quickalert/quickalert.dart';
import '../widgets/widget.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  //form นำมาใช้ตรวจเช็คฟอร์มว่าดำเนินการรูปแบบใด -> reset , submit
  final formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String errorText = '';

  // *** FIREBASE ***
  // 1.เตรียม Firebase

  final Future<FirebaseApp> firebase = Firebase.initializeApp();
  CollectionReference usersCollection =
      FirebaseFirestore.instance.collection("users");

  Future<List<Profile>> signin() async {
    String email = _emailController.text;

    QuerySnapshot querySnapshot = await usersCollection
        .where('email', isEqualTo: email)
        .where('position', isEqualTo: 'mobile')
        .where('approve', isEqualTo: true)
        .get();
    QuerySnapshot queryCheckEmailApprove = await usersCollection
        .where('email', isEqualTo: email)
        .where('position', isEqualTo: 'mobile')
        .where('approve', isEqualTo: false)
        .get();

    if (queryCheckEmailApprove.docs.isNotEmpty) {
      errorText = "อีเมลยังไม่ได้รับการอนุมัติ";
      log("Email not approve");
      return Future.error("อีเมลยังไม่ได้รับการอนุมัติ");
    }
    if (querySnapshot.docs.isEmpty) {
      errorText = "ไม่พบอีเมลในระบบ";
      log("Email not found");
      return Future.error("ไม่พบอีเมลในระบบ");
    }

    List<Profile> result = [];
    for (QueryDocumentSnapshot document in querySnapshot.docs) {
      Profile emailData = Profile(
        email: document['email'],
        password: document['password'],
        // firstname: document['firstname'],
        // lastname: document['lastname'],
        fullname: document['fullname'],
        tel: document['tel'],
        id: document.id,
      );
      result.add(emailData);
    }

    String? password;
    if (result.isNotEmpty) {
      for (Profile data in result) {
        password = data.password;
      }
    }

    var passwordIdentify = BCrypt.checkpw(_passwordController.text, password!);
    if (!passwordIdentify) {
      log("password is incorrect");
      return Future.error("รหัสผ่านไม่ถูกต้อง");
    }
    log("password is correct");
    // log("$result");
    log("data: $result");
    return result;
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
                backgroundColor: Colors.transparent,
                key: scaffoldKey,
                body: SafeArea(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          //left: 100, top: 380
                          padding: const EdgeInsets.only(left: 100, top: 250),
                          child: const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "เข้าสู่ระบบ",
                                style: StyleTitleLogin,
                              ),
                              Text(
                                "โปรดกรอกข้อมูล",
                                style: TextStyle(
                                  fontFamily: "Kanit",
                                  fontSize: 25,
                                  color: Color.fromARGB(255, 1, 108, 195),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.only(left: 80, right: 80),
                          child: Form(
                            key: formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // const SizedBox(height: 100),
                                const SizedBox(height: 50),
                                InputText(
                                  icon: Icons.email_rounded,
                                  sizeIcon: 35,
                                  colorIcon: Colors.white,
                                  labelText: "อีเมล",
                                  labelTextStyle: StyleLabelLogin,
                                  borderSideEnable: const BorderSide(
                                    color: Colors.white,
                                    width: 2,
                                  ),
                                  inputType: TextInputType.emailAddress,
                                  inputAction: TextInputAction.next,
                                  controller: _emailController,
                                  pattern: r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}',
                                  validatorText: "กรุณากรอกอีเมลที่ถูกต้อง",
                                  // onSaved: (email) {
                                  //   user.email = email;
                                  // },
                                ),
                                const SizedBox(height: 30),
                                InputPassword(
                                  icon: Icons.key,
                                  sizeIcon: 35,
                                  colorIcon: Colors.white,
                                  labelText: "รหัสผ่าน",
                                  labelTextStyle: StyleLabelLogin,
                                  borderSideEnable: const BorderSide(
                                    color: Colors.white,
                                    width: 2,
                                  ),
                                  inputType: TextInputType.text,
                                  inputAction: TextInputAction.next,
                                  controller: _passwordController,
                                  pattern: r'^[a-z A-z 0-9]+$',
                                  validatorText: "กรุณากรอกรหัสผ่านที่ถูกต้อง",
                                  // onSaved: (password) {
                                  //   user.password = password;
                                  // },
                                ),
                                Container(
                                  //left: 510, top: 20
                                  padding:
                                      const EdgeInsets.only(left: 260, top: 20),
                                  child: RichText(
                                    text: TextSpan(children: <TextSpan>[
                                      TextSpan(
                                          text: "ลืมรหัสผ่าน?",
                                          style: StyleUnderLineWhite,
                                          recognizer: TapGestureRecognizer()
                                            ..onTap = () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          const FindEmailScreen()));
                                            })
                                    ]),
                                  ),
                                ),
                                // const SizedBox(height: 70),
                                const SizedBox(height: 50),
                                Center(
                                  // padding: const EdgeInsets.symmetric(
                                  //     horizontal: 10),
                                  child: ButtonSolid(
                                    buttonText: "เข้าสู่ระบบ",
                                    textStyle: StyleFontButtonWhite,
                                    fixedheight: 60,
                                    fixedwidth: 325,
                                    icon: Icons.login,
                                    colorIcon: Colors.blue,
                                    color: Colors.white,
                                    onPressed: () {
                                      if (formKey.currentState!.validate()) {
                                        formKey.currentState!.save();
                                        signin()
                                            .then((res) => {
                                                  formKey.currentState!.reset(),
                                                  Navigator.pushReplacement(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          AllConnect(
                                                        userData: res,
                                                      ),
                                                    ),
                                                  ),
                                                })
                                            .catchError(
                                              (error) => {
                                                QuickAlert.show(
                                                  context: context,
                                                  type: error ==
                                                          'อีเมลยังไม่ได้รับการอนุมัติ'
                                                      ? QuickAlertType.warning
                                                      : QuickAlertType.error,
                                                  title: error,
                                                  confirmBtnText: "โอเค",
                                                  barrierDismissible:
                                                      false, //การกดบริเวณนอก Alert
                                                  onConfirmBtnTap: () {
                                                    if (error ==
                                                        "รหัสผ่านไม่ถูกต้อง") {
                                                      Navigator.pop(context);
                                                      _passwordController
                                                          .clear();
                                                    } else {
                                                      Navigator.pop(context);
                                                      _emailController.clear();
                                                      _passwordController
                                                          .clear();
                                                    }
                                                  },
                                                ),
                                              },
                                            );
                                        // formKey.currentState!.reset();
                                      }
                                    },
                                  ),
                                ),
                                // const SizedBox(height: 70),
                                const SizedBox(height: 50),
                                Center(
                                  child: RichText(
                                    text: TextSpan(
                                        text: "ยังไม่ได้สมัครสมาชิก?  ",
                                        style: StyleNormalTextWhite,
                                        children: <TextSpan>[
                                          TextSpan(
                                              text: "สมัครสมาชิก",
                                              style: StyleUnderLineWhite,
                                              recognizer: TapGestureRecognizer()
                                                ..onTap = () {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              const RegisterScreen()));
                                                })
                                        ]),
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
          ],
        );
      },
    );
  }
}
