import 'package:flutter/material.dart';
import 'package:flutter_application/css/style.dart';

class DropdownMenuWater extends StatefulWidget {
  const DropdownMenuWater(
      {super.key,
      required this.onSelected,
      required this.selectedValue,
      required this.dropdownValues,
      required this.validatorText});

  final Function(String)? onSelected;
  final String? selectedValue;
  final List<String> dropdownValues;
  final String? validatorText;

  @override
  State<DropdownMenuWater> createState() => _DropdownMenuWaterState();
}

class _DropdownMenuWaterState extends State<DropdownMenuWater> {
  // String? selectedValue;
  // List<String>? dropdownValues;
  // String? validatorText;

  // String? dropdownValue;
  // final List<String> _list = ['เขื่อน', 'คลองชลประทาน', 'ทะเลสาบ/บ่อน้ำ'];

  // @override
  // void initState() {
  //   super.initState();
  //   selectedValue = widget.selectedValue;
  //   dropdownValues = widget.dropdownValues;
  //   validatorText = widget.validatorText;
  // }

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
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
        errorStyle: StyleLabelError,
        contentPadding: EdgeInsets.symmetric(vertical: 4, horizontal: 20),
      ),
      hint: const Text(
        "เลือกประเภทแหล่งน้ำ",
        style: StyleTextChart,
      ),

      // value: dropdownValue,
      value: widget.selectedValue,
      icon: const Icon(
        Icons.arrow_drop_down,
        size: 40,
      ),
      elevation: 16,
      style: StyleFontMenu,
      // onChanged: onSelected,
      onChanged: (String? newValue) {
        // setState(() {
        //   selectedValue = newValue!;
        // });

        widget.onSelected!(newValue!);
      },

      items: widget.dropdownValues.map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      isDense: false, //ข้อความไม่ลงขอบล่าง
      validator: (value) => value == null ? widget.validatorText : null,
    );
  }
}
