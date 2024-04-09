import 'dart:developer';

import 'package:email_otp/email_otp.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application/css/style.dart';
import 'package:flutter_application/screen/reset_password.dart';
// import 'package:flutter_application/model/checkEmail.dart';
import 'package:flutter_application/widgets/field_otp.dart';
import 'package:flutter_application/widgets/widget.dart';

class CheckOtpScreen extends StatefulWidget {
  final EmailOTP myauth;
  final String? userID;

  const CheckOtpScreen({
    super.key,
    required this.myauth,
    required this.userID,
  });

  @override
  State<CheckOtpScreen> createState() => _CheckOtpScreenState();
}

class _CheckOtpScreenState extends State<CheckOtpScreen> {
  //form นำมาใช้ตรวจเช็คฟอร์มว่าดำเนินการรูปแบบใด -> reset , submit
  final formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController otp1Controller = TextEditingController();
  TextEditingController otp2Controller = TextEditingController();
  TextEditingController otp3Controller = TextEditingController();
  TextEditingController otp4Controller = TextEditingController();

  String? userID;
  late EmailOTP myauth;

  @override
  void initState() {
    super.initState();
    // for (CheckEmail data in widget.userOtp) {
    //   userID = data.id;
    //   myauth = data.otp;
    // }
    log("userID: ${widget.userID}");
    log("myauth: ${widget.myauth}");
  }

  String? otpAll;
  void mergeOTP() {
    otpAll = otp1Controller.text +
        otp2Controller.text +
        otp3Controller.text +
        otp4Controller.text;
    log("otp: $otpAll");
  }

  Future verifyOTP() async {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    if (await widget.myauth.verifyOTP(otp: otpAll) == true) {
      scaffoldMessenger.showSnackBar(
        const SnackBar(
          content: Text(
            "รหัส OTP ถูกต้อง",
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
    } else {
      scaffoldMessenger.showSnackBar(
        const SnackBar(
          content: Text(
            "รหัส OTP ไม่ถูกต้อง , ลองอีกครั้ง",
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
    return Stack(
      children: [
        const BackgroundAppClear(),
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
                  Navigator.pop(context);
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
                // crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.only(top: 100),
                    child: Image.asset(
                      "assets/images/otp_email.png",
                      fit: BoxFit.cover,
                      height: 190,
                      width: 190,
                    ),
                  ),
                  const SizedBox(height: 40),
                  Container(
                    padding: const EdgeInsets.only(left: 40, right: 40),
                    child: Form(
                      key: formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.only(left: 50, right: 50),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const SizedBox(height: 40),
                                const Text(
                                  "ตรวจสอบอีเมล",
                                  style: StyleResultMock,
                                ),
                                const SizedBox(height: 10),
                                const Text(
                                  "โปรดใส่รหัสที่ระบบส่งไปทางอีเมลของคุณ",
                                  style: StyleDetailText,
                                ),
                                const SizedBox(height: 40),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    InputNumber(
                                      controller: otp1Controller,
                                    ),
                                    InputNumber(
                                      controller: otp2Controller,
                                    ),
                                    InputNumber(
                                      controller: otp3Controller,
                                    ),
                                    InputNumber(
                                      controller: otp4Controller,
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 30),
                                Container(
                                  // padding: const EdgeInsets.symmetric(
                                  //   vertical: 10,
                                  // ),
                                  margin: const EdgeInsets.symmetric(
                                    vertical: 10,
                                  ),
                                  child: ButtonSolid(
                                    buttonText: "ตรวจสอบ",
                                    textStyle: StyleFontButtonBlue,
                                    fixedheight: 60,
                                    fixedwidth: 325,
                                    icon: Icons.send,
                                    colorIcon: Colors.white,
                                    color: Colors.blue,
                                    onPressed: () {
                                      // final docID = widget.userID;

                                      mergeOTP();
                                      verifyOTP().whenComplete(
                                        () async => {
                                          formKey.currentState!.reset(),
                                          await Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      ResetPasswordScreen(
                                                          userID:
                                                              widget.userID))),
                                        },
                                      );
                                    },
                                  ),
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
  }
}
