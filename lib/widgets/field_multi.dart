import 'package:flutter/material.dart';
import 'package:flutter_application/css/style.dart';
// import 'package:form_field_validator/form_field_validator.dart';
// import '../css/style.dart';

// ignore: must_be_immutable
class InputMultiLine extends StatelessWidget {
  const InputMultiLine({
    super.key,
    required this.labelText,
    required this.labelTextStyle,
    required this.borderSideEnable,
    required this.inputType,
    required this.inputAction,
    this.onSaved,
    required this.controller,
    this.validatorText,
    this.pattern,
    required this.maxLines,
  });

  final String labelText;
  final TextStyle labelTextStyle;
  final BorderSide borderSideEnable;
  final TextInputType inputType;
  final TextInputAction inputAction;
  final Function(String?)? onSaved;
  final TextEditingController controller;
  final String? validatorText;
  final String? pattern;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: StyleFontMenu,
      maxLines: maxLines,
      decoration: InputDecoration(
        // filled: true,
        // fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
        labelText: labelText,
        labelStyle: labelTextStyle,
        alignLabelWithHint: true,
        // enabledBorder: UnderlineInputBorder(
        //   borderSide: borderSideEnable,
        // ),
        // focusedBorder: UnderlineInputBorder(
        //   borderSide: borderSideEnable,
        // ),
        // errorBorder: const UnderlineInputBorder(
        //   borderSide: BorderSide(
        //     color: Colors.red,
        //     width: 2,
        //   ),
        // ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: borderSideEnable,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: borderSideEnable,
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(
            width: 2,
            color: Colors.red,
          ),
        ),

        errorStyle: StyleLabelError,
      ),
      keyboardType: inputType,
      textInputAction: inputAction,
      // validator: (value) {
      //   if (value == null ||
      //       value.isEmpty ||
      //       !RegExp(pattern!).hasMatch(value)) {
      //     return validatorText;
      //   }
      //   return null;
      // },
      controller: controller,
      // onSaved: onSaved,
    );
  }
}
