// ignore_for_file: must_be_immutable

import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application/model/profile.dart';
import 'package:flutter_application/screen/edit_password.dart';
import 'package:flutter_application/screen/edit_profile.dart';
import 'package:flutter_application/screen/login.dart';
import 'package:flutter_application/widgets/widget.dart';
import 'package:image_picker/image_picker.dart';
import 'package:quickalert/quickalert.dart';
import '../css/style.dart';

class MenuPage extends StatefulWidget {
  //sos
  List<Profile> userData;
  MenuPage({super.key, required this.userData});

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  late Future<dynamic> futureUser;
  String? id;
  String? email;
  String? fullname;
  @override
  void initState() {
    super.initState();
    for (var data in widget.userData) {
      id = data.id;
      email = data.email;
      fullname = data.fullname;
    }
    futureUser = fetchUserDetail();
  }

  // *** FIREBASE ***
  // 1.เตรียม Firebase
  final Future<FirebaseApp> firebase = Firebase.initializeApp();
  // 2.กำหนด Collection ที่จะทำงาน
  CollectionReference usersCollection =
      FirebaseFirestore.instance.collection("users");

  // ***เตรียม Firebase Storage ***
  FirebaseStorage storageRef = FirebaseStorage.instance;

  Future fetchUserDetail() async {
    DocumentSnapshot docUser = await usersCollection.doc(id).get();
    final data = docUser.data() as Map<String, dynamic>;

    List<Profile> result = [];
    Profile detail = Profile(
      id: id,
      email: email,
      password: data['password'],
      fullname: data['fullname'],
      tel: data['tel'],
      imageRrofile: data['imageRrofile'],
    );
    result.add(detail);
    log("data: $result");

    setState(() {
      id;
      email;
      fullname;
    });

    return Profile.formMap(docUser);
  }

  final ImagePicker picker = ImagePicker();
  XFile? pickedFile;
  File? file;
  String? urlPicture;

  Future updateImageProfile() async {
    try {
      pickedFile = await picker.pickImage(source: ImageSource.gallery);
      setState(() {
        file = File(pickedFile!.path);
      });

      Reference reference = storageRef
          .ref()
          .child("profile_images")
          .child(email.toString())
          .child("profile.jpg");
      UploadTask uploadTask = reference.putFile(
          file!,
          SettableMetadata(
            contentType: "image/jpg",
          ));
      urlPicture = await (await uploadTask.whenComplete(() => null))
          .ref
          .getDownloadURL();
      debugPrint("urlPicture = $urlPicture");

      await usersCollection.doc(id).update({
        "imageRrofile": urlPicture,
      });
      log("Successfully updated");
      // return urlPicture;
    } catch (e) {
      debugPrint("Somthing Wrong. $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    //โหมดมืด
    // var isDark = MediaQuery.of(context).platformBrightness == Brightness.dark;

    return FutureBuilder<dynamic>(
      future: futureUser,
      builder: (context, snapshot) {
        // 1. เชื่อมต่อไม่ได้
        if (snapshot.hasError) {
          return Scaffold(
            backgroundColor: const Color.fromARGB(255, 207, 205, 205),
            appBar: AppBar(
              toolbarHeight: 80, //ขนาดความสูง Appbar
              title: const Text(
                'เมนูเพิ่มเติม',
                style: StyleAppbar,
              ),
              flexibleSpace: const BackgroundAppbar(),
              automaticallyImplyLeading: false, //ยกเลิกปุ่มย้อนกลับ
              centerTitle: true, //ข้อความตรงกลาง
              backgroundColor: Colors.transparent, //สีพื้นหลังเริ่มต้น->โปร่งใส
              elevation: 0, //ลบแรเงา
            ),
            body: SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.only(top: 100),
                child: Column(
                  children: [
                    const Text(
                      "ไม่พบข้อมูล โปรดเข้าสู่ระบบอีกครั้ง",
                      style: StyleTextError,
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 250),
                      child: ButtonSolid(
                        buttonText: "เข้าสู่ระบบ",
                        textStyle: StyleFontButtonBlue,
                        fixedheight: 60,
                        fixedwidth: 325,
                        icon: Icons.login,
                        colorIcon: Colors.white,
                        color: Colors.blue,
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const LoginScreen()));
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }
        // 2. กำลังโหลดข้อมูล
        else if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        // 3. เชื่อมต่อสำเร็จ
        final Profile detail = snapshot.data!;
        return Scaffold(
          backgroundColor: const Color.fromARGB(255, 207, 205, 205),
          appBar: AppBar(
            toolbarHeight: 80, //ขนาดความสูง Appbar
            title: const Text(
              'เมนูเพิ่มเติม',
              style: StyleAppbar,
            ),
            flexibleSpace: const BackgroundAppbar(),
            automaticallyImplyLeading: false, //ยกเลิกปุ่มย้อนกลับ
            centerTitle: true, //ข้อความตรงกลาง
            backgroundColor: Colors.transparent, //สีพื้นหลังเริ่มต้น->โปร่งใส
            elevation: 0, //ลบแรเงา
          ),
          body: SingleChildScrollView(
            child: Center(
              child: SizedBox(
                child: Column(
                  children: [
                    const SizedBox(height: 40),
                    //รูปโปรไฟล์
                    Stack(
                      children: [
                        Column(
                          children: [
                            detail.imageRrofile != null
                                ? ClipOval(
                                    child: Image.network(
                                      detail.imageRrofile.toString(),
                                      width: 150,
                                      height: 150,
                                      fit: BoxFit.cover,
                                    ),
                                  )
                                : const SizedBox(
                                    width: 150,
                                    height: 150,
                                    child: CircleAvatar(
                                      radius: 50,
                                      backgroundImage: AssetImage(
                                          "assets/images/profile_pic.png"),
                                    ),
                                  ),
                          ],
                        ),
                        Positioned(
                          bottom: 0,
                          right: -5,
                          child: ElevatedButton(
                            onPressed: () {
                              updateImageProfile().whenComplete(() {
                                setState(() {
                                  futureUser = fetchUserDetail();
                                });
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              shape: const CircleBorder(),
                              padding: const EdgeInsets.all(10),
                              backgroundColor:
                                  Colors.grey[200], // <-- Button color
                            ),
                            child: const Padding(
                              padding: EdgeInsets.only(top: 4),
                              child: Icon(
                                Icons.photo_camera_outlined,
                                color: Color.fromARGB(255, 133, 133, 133),
                                size: 30,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Column(
                      children: [
                        // for (var data in widget.userData)
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "${detail.fullname}",
                              style: StyleFontMenu,
                            ),
                            Text(
                              "${detail.email}",
                              style: StyleFontMenu,
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    ButtonMenu(
                      icon: Icons.person_outline,
                      colorIcon: Colors.black,
                      buttonText: 'แก้ไขโปรไฟล์',
                      colorBackground: Colors.white,
                      colorCircle: const Color.fromRGBO(255, 205, 210, 1),
                      colorIconAppend: Colors.grey,
                      onPressed: () async {
                        final updatedData = await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => EditProfileScreen(
                                      userData: widget.userData,
                                    )));
                        //sos
                        setState(() {
                          widget.userData = updatedData;
                          log("${widget.userData}");
                          futureUser = fetchUserDetail();
                        });
                      },
                    ),
                    ButtonMenu(
                      icon: Icons.key_rounded,
                      colorIcon: Colors.black,
                      buttonText: 'เปลี่ยนรหัสผ่าน',
                      colorBackground: Colors.white,
                      colorCircle: const Color.fromRGBO(255, 205, 210, 1),
                      colorIconAppend: Colors.grey,
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => EditPasswordScreen(
                                      userData: widget.userData,
                                    )));
                      },
                    ),
                    const SizedBox(height: 70),
                    ButtonMenu(
                      icon: Icons.logout,
                      colorIcon: Colors.black,
                      buttonText: 'ออกจากระบบ',
                      colorBackground: const Color.fromARGB(255, 247, 189, 189),
                      colorCircle: const Color.fromARGB(255, 243, 219, 224),
                      colorIconAppend: Colors.grey,
                      onPressed: () {
                        QuickAlert.show(
                          context: context,
                          type: QuickAlertType.warning,
                          title: "คุณต้องการออกจากระบบหรือไม่",
                          showCancelBtn: true,
                          confirmBtnText: "ออกจากระบบ",
                          confirmBtnColor: Colors.red,
                          cancelBtnText: "ยกเลิก",
                          onConfirmBtnTap: () {
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const LoginScreen()),
                                (route) => false);
                          },
                          onCancelBtnTap: () {
                            Navigator.pop(context);
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
