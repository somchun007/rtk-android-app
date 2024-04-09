import 'package:flutter/material.dart';
import '../css/style.dart';
import '../widgets/widget.dart';

class ConnectPage extends StatefulWidget {
  const ConnectPage({super.key});

  @override
  State<ConnectPage> createState() => _ConnectPageState();
}

class _ConnectPageState extends State<ConnectPage> {
  final formKey = GlobalKey<FormState>();

  final _ipAddressController = TextEditingController();
  final _portController = TextEditingController();
  final _userController = TextEditingController();
  final _passwordController = TextEditingController();
  // final _sourceListController = TextEditingController();
  // final _mountpointController = TextEditingController();

  static List<String> list = <String>['CMR', 'RTCM23', 'VRS_RTCM32'];
  String dropdownValue = list.last;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 207, 205, 205),
      appBar: AppBar(
        toolbarHeight: 80, //ขนาดความสูง Appbar
        title: const Text(
          'เชื่อมต่อ RTK',
          style: StyleAppbar,
        ),
        flexibleSpace: const BackgroundAppbar(),
        automaticallyImplyLeading: false, //ยกเลิกปุ่มย้อนกลับ
        centerTitle: true, //ข้อความตรงกลาง
        backgroundColor: Colors.transparent, //สีพื้นหลังเริ่มต้น->โปร่งใส
        elevation: 0, //ลบแรเงา
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.only(left: 70, right: 70),
                child: Form(
                  key: formKey,
                  child: Column(
                    children: [
                      const SizedBox(height: 50),
                      Container(
                        padding: const EdgeInsets.only(left: 50, right: 50),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 30),
                            InputTextNoicon(
                              labelText: "IP Address",
                              labelStyle: StyleLabelRegister,
                              borderSideEnable: const BorderSide(
                                color: Colors.grey,
                                width: 2,
                              ),
                              inputType: TextInputType.text,
                              inputAction: TextInputAction.next,
                              controller: _ipAddressController,
                              validatorText: "กรุณากรอก IP ที่ถูกต้อง",
                              pattern: r'^[0-9]',
                            ),
                            const SizedBox(height: 30),
                            InputTextNoicon(
                              labelText: "Port",
                              labelStyle: StyleLabelRegister,
                              borderSideEnable: const BorderSide(
                                color: Colors.grey,
                                width: 2,
                              ),
                              inputType: TextInputType.text,
                              inputAction: TextInputAction.next,
                              controller: _portController,
                              validatorText: "กรุณากรอก Port ที่ถูกต้อง",
                              pattern: r'^[0-9]',
                            ),
                            const SizedBox(height: 30),
                            const Text(
                              "Source List",
                              style: StyleLabelRegister,
                            ),
                            DropdownMenuRTK(
                              onSelected: (String? value) {
                                setState(() {
                                  dropdownValue = value!;
                                });
                              },
                            ),
                            const SizedBox(height: 30),
                            InputText(
                              icon: Icons.person_2_outlined,
                              sizeIcon: 35,
                              colorIcon: Colors.grey,
                              labelText: "Username",
                              labelTextStyle: StyleLabelRegister,
                              borderSideEnable: const BorderSide(
                                color: Colors.grey,
                                width: 2,
                              ),
                              inputType: TextInputType.text,
                              inputAction: TextInputAction.next,
                              controller: _userController,
                              validatorText: "กรุณากรอก Username ที่ถูกต้อง",
                              pattern: r'^[0-9]',
                            ),
                            const SizedBox(height: 30),
                            InputPassword(
                              icon: Icons.lock_outline,
                              sizeIcon: 35,
                              colorIcon: Colors.grey,
                              labelText: "Password",
                              labelTextStyle: StyleLabelRegister,
                              borderSideEnable: const BorderSide(
                                color: Colors.grey,
                                width: 2,
                              ),
                              inputType: TextInputType.text,
                              inputAction: TextInputAction.next,
                              controller: _passwordController,
                              validatorText: "กรุณากรอก Passwprd ที่ถูกต้อง",
                              pattern: r'^[a-z A-z 0-9]+$',
                            ),
                            const SizedBox(height: 30),
                            const Text(
                              "Mount Point",
                              style: StyleLabelRegister,
                            ),
                            DropdownMenuRTK(
                              onSelected: (String? value) {
                                setState(() {
                                  dropdownValue = value!;
                                });
                              },
                            ),
                            const SizedBox(height: 50),
                            Container(
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 60),
                              child: ButtonSolid(
                                buttonText: "เชื่อมต่อ",
                                textStyle: StyleFontButtonBlue,
                                fixedheight: 60,
                                fixedwidth: 325,
                                color: const Color.fromARGB(255, 3, 160, 8),
                                icon: Icons.send_rounded,
                                colorIcon: Colors.white,
                                onPressed: () {},
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
    );
  }
}
