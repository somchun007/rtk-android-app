import 'package:flutter/material.dart';

class ButtonSolid extends StatelessWidget {
  const ButtonSolid({
    super.key,
    required this.buttonText,
    required this.textStyle,
    required this.icon,
    required this.color,
    required this.colorIcon,
    required this.onPressed,
    required this.fixedwidth,
    required this.fixedheight,
  });

  final String buttonText;
  final TextStyle textStyle;
  final IconData icon;
  final Color color;
  final Color colorIcon;
  final Function() onPressed;
  final double fixedwidth;
  final double fixedheight;

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: 60,
      // width: double.infinity, //325
      decoration:
          BoxDecoration(borderRadius: BorderRadiusDirectional.circular(16)),
      child: ElevatedButton.icon(
        icon: Icon(
          icon,
          size: 30,
          color: colorIcon,
        ),
        label: Text(
          buttonText,
          style: textStyle,
        ),
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          fixedSize: Size(fixedwidth, fixedheight),
          backgroundColor: color,
          shape: const StadiumBorder(),
        ),
      ),
    );
  }
}
