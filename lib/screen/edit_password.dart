import 'dart:developer';

import 'package:bcrypt/bcrypt.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application/model/profile.dart';
import 'package:flutter_application/widgets/widget.dart';
import 'package:quickalert/quickalert.dart';
import '../css/style.dart';

class EditPasswordScreen extends StatefulWidget {
  final List<Profile> userData;
  const EditPasswordScreen({super.key, required this.userData});

  @override
  State<EditPasswordScreen> createState() => _EditPasswordScreenState();
}

class _EditPasswordScreenState extends State<EditPasswordScreen> {
  //form นำมาใช้ตรวจเช็คฟอร์มว่าดำเนินการรูปแบบใด -> reset , submit
  final formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  // *** FIREBASE ***
  // 1.เตรียม Firebase
  final Future<FirebaseApp> firebase = Firebase.initializeApp();
  // 2.กำหนด Collection ที่จะทำงาน
  CollectionReference usersCollection =
      FirebaseFirestore.instance.collection("users");

  Future updatePassword() async {
    String password = _currentPasswordController.text;
    String newPassword = _newPasswordController.text;

    String? userID;
    for (Profile data in widget.userData) {
      userID = data.id;
    }
    DocumentSnapshot docUser = await usersCollection.doc(userID).get();
    final data = docUser.data() as Map<String, dynamic>;
    String passwordStored = data["password"];

    var passwordIdentify = BCrypt.checkpw(password, passwordStored);

    if (passwordIdentify) {
      if (passwordConfirmed()) {
        await usersCollection.doc(userID).update({
          "password": BCrypt.hashpw(newPassword, BCrypt.gensalt()),
        });
        log("update password success");
        return;
      } else {
        return Future.error("รหัสผ่านใหม่ไม่ตรงกัน");
      }
    } else {
      log("password is incorrect");
      return Future.error("รหัสผ่านปัจจุบันไม่ถูกต้อง");
    }
  }

  bool passwordConfirmed() {
    if (_newPasswordController.text.trim() ==
        _confirmPasswordController.text.trim()) {
      return true;
    } else {
      log("Password don't match");
      return false;
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
                      Navigator.pop(context);
                    },
                  ),
                ),
                title: const Padding(
                  padding: EdgeInsets.only(top: 15),
                  child: Text(
                    "เปลี่ยนรหัสผ่าน",
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
                                    InputPassword(
                                      icon: Icons.key,
                                      sizeIcon: 30,
                                      colorIcon: const Color.fromARGB(
                                          255, 105, 104, 104),
                                      labelText: "รหัสผ่านเดิม",
                                      labelTextStyle: StyleLabelRegister,
                                      borderSideEnable: const BorderSide(
                                        color:
                                            Color.fromARGB(255, 105, 104, 104),
                                        width: 2,
                                      ),
                                      inputType: TextInputType.text,
                                      inputAction: TextInputAction.next,
                                      controller: _currentPasswordController,
                                      pattern: r'^[a-z A-z 0-9]+$',
                                      validatorText:
                                          "กรุณากรอกรหัสผ่านที่ถูกต้อง",
                                      // onSaved: (password) {
                                      //   user.password = password;
                                      // },
                                    ),
                                    const SizedBox(height: 20),
                                    InputPassword(
                                      icon: Icons.lock_outline,
                                      sizeIcon: 30,
                                      colorIcon: const Color.fromARGB(
                                          255, 105, 104, 104),
                                      labelText: "รหัสผ่านใหม่",
                                      labelTextStyle: StyleLabelRegister,
                                      borderSideEnable: const BorderSide(
                                        color:
                                            Color.fromARGB(255, 105, 104, 104),
                                        width: 2,
                                      ),
                                      inputType: TextInputType.text,
                                      inputAction: TextInputAction.next,
                                      controller: _newPasswordController,
                                      pattern: r'^[a-z A-z 0-9]+$',
                                      validatorText:
                                          "กรุณากรอกรหัสผ่านที่ถูกต้อง",
                                      // onSaved: (password) {
                                      //   user.password = password;
                                      // },
                                    ),
                                    const SizedBox(height: 20),
                                    InputPassword(
                                      icon: Icons.lock_outline,
                                      sizeIcon: 30,
                                      colorIcon: const Color.fromARGB(
                                          255, 105, 104, 104),
                                      labelText: "ยืนยันรหัสผ่าน",
                                      labelTextStyle: StyleLabelRegister,
                                      borderSideEnable: const BorderSide(
                                        color:
                                            Color.fromARGB(255, 105, 104, 104),
                                        width: 2,
                                      ),
                                      inputType: TextInputType.text,
                                      inputAction: TextInputAction.done,
                                      controller: _confirmPasswordController,
                                      pattern: r'^[a-z A-z 0-9]+$',
                                      validatorText:
                                          "กรุณากรอกรหัสผ่านที่ถูกต้อง",
                                      // onSaved: (confirmPassword1) {
                                      //   confirmPassword = confirmPassword1!;
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
                                          updatePassword()
                                              .then((res) => {
                                                    QuickAlert.show(
                                                      context: context,
                                                      type: QuickAlertType
                                                          .success,
                                                      title:
                                                          "เปลี่ยนรหัสผ่านสำเร็จ",
                                                      confirmBtnText: "โอเค",
                                                      barrierDismissible:
                                                          false, //การกดบริเวณนอก Alert
                                                      onConfirmBtnTap: () {
                                                        Navigator.pop(context);
                                                        formKey.currentState!
                                                            .reset();

                                                        // // clearTextInput();
                                                        // Navigator.pop(context);
                                                      },
                                                    ),
                                                    // Navigator.pop(context),
                                                  })
                                              .catchError((error) => {
                                                    QuickAlert.show(
                                                      context: context,
                                                      type:
                                                          QuickAlertType.error,
                                                      title: error,
                                                      confirmBtnText: "โอเค",
                                                      barrierDismissible:
                                                          false, //การกดบริเวณนอก Alert
                                                      onConfirmBtnTap: () {
                                                        if (error ==
                                                            "รหัสผ่านปัจจุบันไม่ถูกต้อง") {
                                                          Navigator.pop(
                                                              context);
                                                          formKey.currentState!
                                                              .reset();
                                                        } else {
                                                          Navigator.pop(
                                                              context);
                                                          _newPasswordController
                                                              .clear();
                                                          _confirmPasswordController
                                                              .clear();
                                                        }
                                                      },
                                                    ),
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
