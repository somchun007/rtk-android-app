import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_application/css/style.dart';
import 'package:flutter_application/widgets/widget.dart';

class ManualsScreen extends StatefulWidget {
  const ManualsScreen({super.key});

  @override
  State<ManualsScreen> createState() => _ManualsScreenState();
}

class _ManualsScreenState extends State<ManualsScreen> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  String selectedNode = 'first_node';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
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
            "คู่มือการใช้งาน",
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
              const SizedBox(height: 30),
              Row(
                // crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ButtonUnderline(
                    horizont: 40,
                    buttonText: 'วิธีเพิ่มข้อมูลแหล่งน้ำ',
                    fontsize: 20,
                    node: 'first_node',
                    isSelected: selectedNode == 'first_node',
                    onPressed: () {
                      setState(() {
                        selectedNode = 'first_node';
                      });
                      log(selectedNode);
                    },
                  ),
                  ButtonUnderline(
                    horizont: 40,
                    buttonText: 'วิธียกเลิกข้อมูลแหล่งน้ำ',
                    fontsize: 20,
                    node: 'second_node',
                    isSelected: selectedNode == 'second_node',
                    onPressed: () {
                      setState(() {
                        selectedNode = 'second_node';
                      });
                      log(selectedNode);
                    },
                  ),
                ],
              ),
              // const SizedBox(height: 20),
              if (selectedNode == 'first_node') ...[
                Container(
                  color: Colors.white,
                  padding: const EdgeInsets.only(left: 30, right: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 15),
                      const Row(
                        children: [
                          Text(
                            "1. ไปยังหน้าเพิ่มแหล่งน้ำ โดยกดปุ่ม",
                            style: StyleResultChart,
                          ),
                          Icon(
                            Icons.add,
                            size: 50,
                          ),
                          Text(
                            "แถบบาร์ด้านล่าง",
                            style: StyleResultChart,
                          ),
                        ],
                      ),
                      const Text(
                        "2. เลือกประเภทของแหล่งน้ำ",
                        style: StyleResultChart,
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        "3. เพิ่มคำอธิบายเพิ่มเติมของแหล่งน้ำ",
                        style: StyleResultChart,
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        "4. เพิ่มรูปภาพของแหล่งน้ำ และสามารถบันทึกเสียงเพิ่มได้",
                        style: StyleResultChart,
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        "5. กดปุ่มบันทึกแหล่งน้ำ",
                        style: StyleResultChart,
                      ),
                      const SizedBox(height: 30),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            Container(
                              margin: const EdgeInsets.only(right: 10),
                              child: Image.asset(
                                "assets/images/ui/add_water/addwater1.png",
                                fit: BoxFit.cover,
                                height: 370,
                                width: 230,
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(right: 10),
                              child: Image.asset(
                                "assets/images/ui/add_water/addwater2.png",
                                fit: BoxFit.cover,
                                height: 370,
                                width: 230,
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(right: 10),
                              child: Image.asset(
                                "assets/images/ui/add_water/addwater3.png",
                                fit: BoxFit.cover,
                                height: 370,
                                width: 230,
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(right: 10),
                              child: Image.asset(
                                "assets/images/ui/add_water/addwater4.png",
                                fit: BoxFit.cover,
                                height: 370,
                                width: 230,
                              ),
                            ),
                          ],
                        ),
                        // child: Row(
                        //   children: [
                        //     Container(
                        //       margin: const EdgeInsets.all(10),
                        //       width: 300,
                        //       height: 100,
                        //       padding: const EdgeInsets.all(10),
                        //       decoration: BoxDecoration(
                        //         borderRadius: BorderRadius.circular(10),
                        //         color: Colors.purple,
                        //       ),
                        //       child: const Center(
                        //         child: Text("YOUTUBE"),
                        //       ),
                        //     ),
                        //     Container(
                        //       margin: const EdgeInsets.all(10),
                        //       width: 300,
                        //       height: 100,
                        //       padding: const EdgeInsets.all(10),
                        //       decoration: BoxDecoration(
                        //         borderRadius: BorderRadius.circular(10),
                        //         color: Colors.purple,
                        //       ),
                        //       child: const Center(
                        //         child: Text("YOUTUBE"),
                        //       ),
                        //     ),
                        //     Container(
                        //       margin: const EdgeInsets.all(10),
                        //       width: 300,
                        //       height: 100,
                        //       padding: const EdgeInsets.all(10),
                        //       decoration: BoxDecoration(
                        //         borderRadius: BorderRadius.circular(10),
                        //         color: Colors.purple,
                        //       ),
                        //       child: const Center(
                        //         child: Text("YOUTUBE"),
                        //       ),
                        //     ),
                        //     Container(
                        //       margin: const EdgeInsets.all(10),
                        //       width: 300,
                        //       height: 100,
                        //       padding: const EdgeInsets.all(10),
                        //       decoration: BoxDecoration(
                        //         borderRadius: BorderRadius.circular(10),
                        //         color: Colors.purple,
                        //       ),
                        //       child: const Center(
                        //         child: Text("YOUTUBE"),
                        //       ),
                        //     ),
                        //   ],
                        // ),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        "เลื่อนไปทางขวา >>>",
                        style: TextStyle(
                          fontSize: 17,
                          color: Colors.red,
                          fontFamily: 'Kanit',
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              if (selectedNode == 'second_node') ...[
                Container(
                  padding: const EdgeInsets.only(left: 30, right: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 15),
                      const Row(
                        children: [
                          Text(
                            "1. ไปยังหน้าหลัก โดยกดปุ่ม ",
                            style: StyleResultChart,
                          ),
                          Icon(
                            Icons.home_rounded,
                            size: 45,
                          ),
                          Text(
                            " แถบบาร์ด้านล่าง",
                            style: StyleResultChart,
                          ),
                        ],
                      ),
                      const Text(
                        "2. กดปุ่มรออนุมัติ",
                        style: StyleResultChart,
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        "3. กดเลือกข้อมูลแหล่งน้ำที่ต้องการจะยกเลิก เพื่อไปยังหน้า",
                        style: StyleResultChart,
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        "    ที่แสดงข้อมูลรายละเอียดต่างๆ ของแหล่งน้ำนั้น",
                        style: StyleResultChart,
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        "4. กดปุ่มยกเลิกแหล่งน้ำ",
                        style: StyleResultChart,
                      ),
                      const SizedBox(height: 30),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            Container(
                              margin: const EdgeInsets.only(right: 10),
                              child: Image.asset(
                                "assets/images/ui/cancel_water/cancelwater1.png",
                                fit: BoxFit.cover,
                                height: 370,
                                width: 230,
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(right: 10),
                              child: Image.asset(
                                "assets/images/ui/cancel_water/cancelwater2.png",
                                fit: BoxFit.cover,
                                height: 370,
                                width: 230,
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(right: 10),
                              child: Image.asset(
                                "assets/images/ui/cancel_water/cancelwater3.png",
                                fit: BoxFit.cover,
                                height: 370,
                                width: 230,
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(right: 10),
                              child: Image.asset(
                                "assets/images/ui/cancel_water/cancelwater4.png",
                                fit: BoxFit.cover,
                                height: 370,
                                width: 230,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        "เลื่อนไปทางขวา >>>",
                        style: TextStyle(
                          fontSize: 17,
                          color: Colors.red,
                          fontFamily: 'Kanit',
                        ),
                      ),
                    ],
                  ),
                ),
              ]
            ],
          ),
        ),
      ),
    );
  }
}
