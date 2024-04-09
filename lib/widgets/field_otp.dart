import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application/css/style.dart';

class InputNumber extends StatelessWidget {
  const InputNumber({
    super.key,
    required this.controller,
  });

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 60,
      height: 60,
      alignment: Alignment.center,
      child: TextFormField(
        controller: controller,
        keyboardType: TextInputType.number,
        style: StyleNumOtp,
        textAlign: TextAlign.center,
        textAlignVertical: TextAlignVertical.center,
        inputFormatters: [
          LengthLimitingTextInputFormatter(1),
          FilteringTextInputFormatter.digitsOnly
        ],
        showCursor: false,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.only(bottom: 1),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              width: 3,
              color: Colors.green,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              width: 3,
              color: Colors.blue,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        onChanged: (value) {
          if (value.length == 1) {
            FocusScope.of(context).nextFocus();
          }
          if (value.isEmpty) {
            FocusScope.of(context).previousFocus();
          }
        },
      ),
    );
  }
}
