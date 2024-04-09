import 'package:flutter/material.dart';
import 'package:flutter_application/css/style.dart';

class ButtonSmall extends StatelessWidget {
  const ButtonSmall({
    super.key,
    required this.buttonText,
    required this.colorBackground,
    required this.onPressed,
  });

  final String buttonText;
  final Color colorBackground;
  final Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: colorBackground,
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 10,
        ),
      ),
      child: Text(
        buttonText,
        style: StyleDetailResult,
      ),
    );
  }
}
