import 'dart:developer';

import 'package:bcrypt/bcrypt.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application/css/style.dart';
import 'package:flutter_application/model/profile.dart';
import 'package:flutter_application/screen/login.dart';
import 'package:flutter_application/widgets/widget.dart';
import 'package:quickalert/quickalert.dart';

class ResetPasswordScreen extends StatefulWidget {
  final String? userID;
  const ResetPasswordScreen({super.key, required this.userID});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  //form นำมาใช้ตรวจเช็คฟอร์มว่าดำเนินการรูปแบบใด -> reset , submit
  final formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  late Future<dynamic> futureUser;
  String? id;
  String? email;
  @override
  void initState() {
    super.initState();
    id = widget.userID;
    futureUser = fetchUserDetail();
  }

  // *** FIREBASE ***
  // 1.เตรียม Firebase
  final Future<FirebaseApp> firebase = Firebase.initializeApp();
  // 2.กำหนด Collection ที่จะทำงาน
  CollectionReference usersCollection =
      FirebaseFirestore.instance.collection("users");

  Future fetchUserDetail() async {
    DocumentSnapshot docUser = await usersCollection.doc(id).get();
    final data = docUser.data() as Map<String, dynamic>;

    List<Profile> result = [];
    Profile detail = Profile(
      id: id,
      email: data['email'],
      password: data['password'],
      fullname: data['fullname'],
      tel: data['tel'],
      imageRrofile: data['imageRrofile'],
    );
    result.add(detail);
    log("data: $result");
    return Profile.formMap(docUser);
  }

  Future updatePassword() async {
    String newPassword = _newPasswordController.text;
    log(newPassword);
    log("$id");
    if (passwordConfirmed()) {
      await usersCollection.doc(id).update({
        "password": BCrypt.hashpw(newPassword, BCrypt.gensalt()),
      });
      log("update password success");
      return;
    } else {
      return Future.error("รหัสผ่านใหม่ไม่ตรงกัน");
    }
  }

  bool passwordConfirmed() {
    log("message");
    if (_newPasswordController.text.trim() ==
        _confirmPasswordController.text.trim()) {
      log("2222");
      return true;
    } else {
      log("Password don't match");
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: futureUser,
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
        // 3. เชื่อมต่อสำเร็จ;
        final Profile detail = snapshot.data!;
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
                          "assets/images/reset_password.png",
                          fit: BoxFit.cover,
                          height: 190,
                          width: 190,
                        ),
                      ),
                      const SizedBox(height: 30),
                      Container(
                        padding: const EdgeInsets.only(left: 40, right: 40),
                        child: Form(
                          key: formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 8),
                              Container(
                                padding:
                                    const EdgeInsets.only(left: 40, right: 40),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Column(
                                  children: [
                                    const SizedBox(height: 50),
                                    Row(
                                      children: [
                                        const SizedBox(width: 20),
                                        const Icon(
                                          Icons.email_outlined,
                                          size: 35,
                                          color: Colors.grey,
                                        ),
                                        const SizedBox(width: 20),
                                        Text(
                                          "${detail.email}",
                                          style: const TextStyle(fontSize: 22),
                                        )
                                      ],
                                    ),
                                    const SizedBox(height: 15),
                                    InputPassword(
                                      icon: Icons.lock_outline,
                                      sizeIcon: 35,
                                      colorIcon: Colors.grey,
                                      labelText: "รหัสผ่านใหม่",
                                      labelTextStyle: StyleLabelRegister,
                                      borderSideEnable: const BorderSide(
                                        color: Colors.grey,
                                        width: 2,
                                      ),
                                      inputType: TextInputType.text,
                                      inputAction: TextInputAction.next,
                                      controller: _newPasswordController,
                                      validatorText:
                                          "กรุณากรอกรหัสผ่านที่ถูกต้อง",
                                      pattern: r'^[a-z A-z 0-9]+$',
                                    ),
                                    const SizedBox(height: 20),
                                    InputPassword(
                                      icon: Icons.lock_outline,
                                      sizeIcon: 35,
                                      colorIcon: Colors.grey,
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
                                    const SizedBox(height: 30),
                                    Row(
                                      children: [
                                        const SizedBox(width: 230),
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
                                              updatePassword()
                                                  .then(
                                                    (res) => {
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
                                                          formKey.currentState!
                                                              .reset();
                                                          Navigator.pop(
                                                              context);
                                                          Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                  builder:
                                                                      (context) =>
                                                                          const LoginScreen()));
                                                        },
                                                      ),
                                                    },
                                                  )
                                                  .catchError((error) => {
                                                        QuickAlert.show(
                                                          context: context,
                                                          type: QuickAlertType
                                                              .error,
                                                          title: error,
                                                          confirmBtnText:
                                                              "โอเค",
                                                          barrierDismissible:
                                                              false, //การกดบริเวณน
                                                          onConfirmBtnTap: () {
                                                            Navigator.pop(
                                                                context);
                                                            formKey
                                                                .currentState!
                                                                .reset();
                                                          },
                                                        ),
                                                      });
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
