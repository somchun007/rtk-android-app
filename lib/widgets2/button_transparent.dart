import 'package:flutter/material.dart';
import '../css/style.dart';

class ButtonTransparent extends StatelessWidget {
  const ButtonTransparent({
    super.key,
    required this.buttonText,
    required this.icon,
    required this.onPressed,
  });

  final String buttonText;
  final IconData icon;
  final Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      width: double.infinity,
      decoration: BoxDecoration(
          // color: Colors.grey[600]?.withOpacity(0.5),
          borderRadius: BorderRadiusDirectional.circular(16)),
      child: ElevatedButton.icon(
        icon: Icon(
          icon,
          size: 30,
          color: Colors.black,
        ),
        label: Text(
          buttonText,
          style: StyleFontButtonWhite,
        ),
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: Colors.transparent,
          shape: const StadiumBorder(
            side: BorderSide(color: Colors.black, width: 3),
          ),
        ),
      ),
    );
  }
}
