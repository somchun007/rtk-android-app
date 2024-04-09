import 'package:flutter/material.dart';
// import '../css/style.dart';

class ButtonCircle extends StatelessWidget {
  const ButtonCircle({
    super.key,
    // required this.buttonText,
    required this.icon,
    required this.colorBackground,
    required this.colorIcon,
    required this.onPressed,
  });

  // final String buttonText;
  final IconData icon;
  final Color colorBackground;
  final Color colorIcon;
  final Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 55,
      width: 55,
      child: FloatingActionButton(
        backgroundColor: colorBackground,
        onPressed: onPressed,
        child: Icon(
          icon,
          size: 40,
          color: colorIcon,
        ),
      ),
    );
  }
}
