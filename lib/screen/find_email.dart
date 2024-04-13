import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_otp/email_otp.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application/css/style.dart';
// import 'package:flutter_application/model/checkEmail.dart';
import 'package:flutter_application/screen/check_otp.dart';
import 'package:flutter_application/screen/login.dart';
import 'package:flutter_application/widgets/widget.dart';
import 'package:quickalert/quickalert.dart';

class FindEmailScreen extends StatefulWidget {
  const FindEmailScreen({super.key});

  @override
  State<FindEmailScreen> createState() => _FindEmailScreenState();
}

class IDandOTP {
  String? id;
  int? otp;

  IDandOTP({this.id, this.otp});
}

class _FindEmailScreenState extends State<FindEmailScreen> {
  //form นำมาใช้ตรวจเช็คฟอร์มว่าดำเนินการรูปแบบใด -> reset , submit
  final formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final _emailController = TextEditingController();
  String errorText = '';
  String? docID;

  // *** FIREBASE ***
  // 1.เตรียม Firebase
  final Future<FirebaseApp> firebase = Firebase.initializeApp();
  // 2.กำหนด Collection ที่จะทำงาน
  CollectionReference usersCollection =
      FirebaseFirestore.instance.collection("users");

  Future validateEmail() async {
    String email = _emailController.text;
    QuerySnapshot querySnapshot =
        await usersCollection.where('email', isEqualTo: email).get();
    if (querySnapshot.docs.isEmpty) {
      errorText = "ไม่พบอีเมลในระบบ";
      log("Email not found");
      return Future.error("ไม่พบอีเมลในระบบ");
    }

    for (QueryDocumentSnapshot document in querySnapshot.docs) {
      docID = document.id;
    }
    await sendOTP();
  }

  bool? sendEmail;
  EmailOTP myauth = EmailOTP();
  Future sendOTP() async {
    myauth.setConfig(
      appEmail: "admin@gmail.com",
      appName: "OTP Email",
      userEmail: _emailController.text,
      otpLength: 4,
      otpType: OTPType.digitsOnly,
    );

    final scaffoldMessenger = ScaffoldMessenger.of(context);
    sendEmail = await myauth.sendOTP();

    if (sendEmail == true) {
      log("OTP sended");
      scaffoldMessenger.showSnackBar(
        const SnackBar(
          content: Text(
            "ระบบได้ส่ง OTP ไปยังอีเมลของคุณแล้ว",
            style: StyleNormalTextWhite,
          ),
          backgroundColor: Colors.lightBlue,
          duration: Duration(seconds: 5),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          )),
        ),
      );

      // Navigator.push(
      //     context,
      //     MaterialPageRoute(
      //       builder: (context) => CheckOtpScreen(
      //         myauth: myauth,
      //         userID: docID,
      //       ),
      //     ));
    } else {
      scaffoldMessenger.showSnackBar(
        const SnackBar(
          content: Text(
            "OTP ล้มเหลว , โปรดลองอีกครั้ง",
            style: StyleNormalTextWhite,
          ),
          backgroundColor: Colors.redAccent,
          duration: Duration(seconds: 5),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          )),
        ),
      );
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
        // 2. เชื่อมต่อสำเร็จ;
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
                        padding: const EdgeInsets.only(left: 100, top: 200),
                        child: const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "ตรวจสอบอีเมล",
                              style: StyleTitleLogin,
                            ),
                            Text(
                              "โปรดกรอกอีเมลที่ลงทะเบียน",
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
                        padding: const EdgeInsets.only(left: 40, right: 40),
                        child: Form(
                          key: formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 50),
                              Container(
                                padding:
                                    const EdgeInsets.only(left: 30, right: 30),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Column(
                                  children: [
                                    const SizedBox(height: 50),
                                    InputText(
                                      icon: Icons.email_outlined,
                                      sizeIcon: 35,
                                      colorIcon: Colors.grey,
                                      labelText: "อีเมล",
                                      labelTextStyle: StyleLabelRegister,
                                      borderSideEnable: const BorderSide(
                                        color: Colors.grey,
                                        width: 2,
                                      ),
                                      inputType: TextInputType.emailAddress,
                                      inputAction: TextInputAction.next,
                                      controller: _emailController,
                                      validatorText: "กรุณากรอกอีเมลที่ถูกต้อง",
                                      pattern:
                                          r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}',
                                    ),
                                    const SizedBox(height: 30),
                                    Row(
                                      children: [
                                        const SizedBox(width: 220),
                                        const Text("ตรวจสอบ   ",
                                            style: StyleNormalTextBlack),
                                        ButtonCircle(
                                          colorBackground: Colors.green,
                                          icon: Icons.send_rounded,
                                          colorIcon: Colors.white,
                                          onPressed: () {
                                            if (formKey.currentState!
                                                .validate()) {
                                              formKey.currentState!.save();
                                              validateEmail()
                                                  .then(
                                                    (res) async => {
                                                      formKey.currentState!
                                                          .save(),
                                                      if (sendEmail!)
                                                        {
                                                          formKey.currentState!
                                                              .reset(),
                                                          Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                              builder: (context) =>
                                                                  CheckOtpScreen(
                                                                myauth: myauth,
                                                                userID: docID,
                                                              ),
                                                            ),
                                                          ),
                                                        }
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
                                                            "รับทราบ",
                                                        barrierDismissible:
                                                            false, //การกดบริเวณนอก Alert
                                                        onConfirmBtnTap: () {
                                                          Navigator.pop(
                                                              context);
                                                          _emailController
                                                              .clear();
                                                        },
                                                      ),
                                                    },
                                                  );
                                            }
                                          },
                                        ),
                                      ],
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
              ),
            ),
          ],
        );
      },
    );
  }
}
