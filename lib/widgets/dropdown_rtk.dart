// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
// import '../css/style.dart';

class DropdownMenuRTK extends StatelessWidget {
  DropdownMenuRTK({
    super.key,
    this.onSelected,
  });

  final Function(String?)? onSelected;

  static List<String> list = <String>['CMR', 'RTCM23', 'VRS_RTCM32'];
  String dropdownValue = list.last;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField(
      decoration: const InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          borderSide: BorderSide(
            color: Colors.grey,
            width: 2,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          borderSide: BorderSide(
            color: Colors.grey,
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          borderSide: BorderSide(
            color: Colors.red,
            width: 2,
          ),
        ),
        contentPadding: EdgeInsets.all(15),
      ),
      value: dropdownValue,
      icon: const Icon(
        Icons.arrow_drop_down,
        size: 35,
      ),
      elevation: 16,
      style: const TextStyle(
        fontSize: 25,
        color: Colors.black,
      ),
      onChanged: onSelected,
      items: list.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      // isDense: false, //ข้อความไม่ลงขอบล่าง
    );
  }
}

//   Container(
// padding: const EdgeInsets.only(left: 10, right: 5),
// decoration: BoxDecoration(
//   borderRadius: BorderRadius.circular(10),
//   border: Border.all(
//     color: Colors.grey,
//     width: 2,
//   ),
// ),
// child: DropdownButtonFormField(
//   value: dropdownValue,
//   icon: const Icon(
//     Icons.arrow_drop_down,
//     size: 40,
//   ),
//   elevation: 16,
//   style: const TextStyle(
//     fontSize: 30,
//     color: Colors.black,
//   ),
//   onChanged: onSelected,
//   items: list.map<DropdownMenuItem<String>>((String value) {
//     return DropdownMenuItem<String>(
//       value: value,
//       child: Text(value),
//     );
//   }).toList(),
// ),
