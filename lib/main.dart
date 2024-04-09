import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application/screen/login.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Intl.defaultLocale = 'th';
  initializeDateFormatting();
  // var app = const MyApp();
  // runApp(app);

  runApp(const MyApp());
}

//widget stateless = เปลี่ยนแปลงค่าไม่ได้ เช่น ข้อความ ไอคอน
//widget stateful = เปลี่ยนแปลงค่าได้ เช่น Checkbox Slider Textfield
// ????? class --> name ต้องขึ้นต้นตัวพิมใหญ่

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "my App",
      //Scaffold = หน้าต่างสำเร็จรูป ช่วยคำนวณระยะห่างขอบจอกับหน้าแอพ

      //สีแถบของ appBar
      theme: ThemeData(
          colorScheme: ColorScheme.fromSwatch().copyWith(
        primary: Colors.blue[600],
        // secondary: Colors.green.shade600
      )),

      //ตั้งค่าเป็นประเทศไทย
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        // const Locale('en', 'US'),
        Locale('th', 'TH'),
      ],
      locale: const Locale('th'),

      // home: const ScrollScreen(),
      home: const LoginScreen(), //main
      // home: const PickScreen(), //test
    );
  }
}
