import 'package:flutter/material.dart';
import '../css/style.dart';

class ButtonEditProfile extends StatelessWidget {
  const ButtonEditProfile({
    super.key,
    required this.buttonText,
    required this.icon,
    required this.color,
  });

  final String buttonText;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(100),
        ),
        child: const Icon(
          Icons.edit,
          size: 30,
        ),
      ),
      title: Text(
        buttonText,
        style: StyleFontButtonBlue,
      ),
      trailing: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(100),
        ),
        child: Icon(
          icon,
          size: 30,
        ),
      ),
    );
  }
}
