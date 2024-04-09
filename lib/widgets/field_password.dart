import 'package:flutter/material.dart';
import 'package:flutter_application/css/style.dart';
// import 'package:form_field_validator/form_field_validator.dart';
// import '../css/style.dart';

// ignore: must_be_immutable
class InputPassword extends StatelessWidget {
  const InputPassword({
    super.key,
    required this.icon,
    required this.colorIcon,
    required this.labelText,
    required this.labelTextStyle,
    required this.borderSideEnable,
    required this.inputType,
    required this.inputAction,
    this.onSaved,
    required this.controller,
    required this.validatorText,
    required this.pattern,
    required this.sizeIcon,
  });

  final IconData icon;
  final Color colorIcon;
  final String labelText;
  final TextStyle labelTextStyle;
  final BorderSide borderSideEnable;
  final TextInputType inputType;
  final TextInputAction inputAction;
  final Function(String?)? onSaved;
  final TextEditingController controller;
  final String validatorText;
  final String pattern;
  final double sizeIcon;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: const TextStyle(fontSize: 30),
      decoration: InputDecoration(
        // filled: true,
        // fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(vertical: 5),
        labelText: labelText,
        labelStyle: labelTextStyle,
        prefixIcon: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Icon(
            icon,
            size: sizeIcon,
            color: colorIcon,
          ),
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: borderSideEnable,
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: borderSideEnable,
        ),
        errorBorder: const UnderlineInputBorder(
          borderSide: BorderSide(
            color: Colors.red,
            width: 2,
          ),
        ),
        // enabledBorder: OutlineInputBorder(
        //   borderRadius: BorderRadius.circular(16),
        //   borderSide: const BorderSide(width: 3, color: Colors.green),
        // ),
        // focusedBorder: OutlineInputBorder(
        //   borderRadius: BorderRadius.circular(16),
        //   borderSide: const BorderSide(width: 4, color: Colors.white),
        // ),
        // errorBorder: OutlineInputBorder(
        //   borderRadius: BorderRadius.circular(16),
        //   borderSide: const BorderSide(width: 3, color: Colors.red),
        // ),
        errorStyle: StyleLabelError,
      ),
      keyboardType: inputType,
      textInputAction: inputAction,
      validator: (value) {
        if (value == null ||
            value.isEmpty ||
            !RegExp(pattern).hasMatch(value)) {
          return validatorText;
        }
        return null;
      },
      controller: controller,
      obscureText: true,
      // onSaved: onSaved,
    );
  }
}
