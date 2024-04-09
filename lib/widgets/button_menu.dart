import 'package:flutter/material.dart';
import '../css/style.dart';

class ButtonMenu extends StatelessWidget {
  const ButtonMenu({
    super.key,
    required this.icon,
    required this.buttonText,
    required this.colorIcon,
    required this.colorCircle,
    required this.colorIconAppend,
    required this.colorBackground,
    required this.onPressed,
  });

  final IconData icon;
  final String buttonText;
  final Color colorCircle, colorIconAppend, colorBackground, colorIcon;
  final Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 10),
      child: TextButton(
        style: TextButton.styleFrom(
          backgroundColor: colorBackground,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
            side: const BorderSide(
              color: Colors.grey,
              width: 1,
            ),
          ),
        ),
        onPressed: onPressed,
        child: Padding(
          padding: const EdgeInsets.only(left: 10, right: 10),
          child: Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: colorCircle,
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Icon(
                  icon,
                  size: 35,
                  color: colorIcon,
                ),
              ),
              const SizedBox(width: 40),
              Expanded(
                child: Text(
                  buttonText,
                  style: StyleFontMenu,
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                size: 35,
                color: colorIconAppend,
              )
            ],
          ),
        ),
      ),
    );
  }
}
