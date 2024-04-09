import 'package:flutter/material.dart';
import 'package:flutter_application/css/style.dart';
// import 'package:form_field_validator/form_field_validator.dart';
// import '../css/style.dart';

// ignore: must_be_immutable
class PasswordInput extends StatelessWidget {
  const PasswordInput({
    super.key,
    required this.icon,
    required this.labelText,
    required this.inputAction,
    this.onSaved,
    required this.controller,
    required this.validatorText,
    required this.regExp,
  });

  final IconData icon;
  final String labelText;
  final TextInputAction inputAction;
  final Function(String?)? onSaved;
  final TextEditingController controller;
  final String validatorText;
  final String regExp;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: const TextStyle(fontSize: 30),
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(vertical: 40),
        labelText: labelText,
        prefixIcon: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Icon(
            icon,
            size: 50,
            color: Colors.black,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(width: 3, color: Colors.green),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(width: 4, color: Colors.blue),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(width: 3, color: Colors.red),
        ),
        labelStyle: StyleLabelRegister,
        errorStyle: StyleLabelError,
      ),
      textInputAction: inputAction,
      validator: (value) {
        if (value == null || value.isEmpty || !RegExp(regExp).hasMatch(value)) {
          return validatorText;
        }
        return null;
      },
      obscureText: true,
      controller: controller,
      onSaved: onSaved,
    );
  }
}
