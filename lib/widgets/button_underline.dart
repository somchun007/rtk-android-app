import 'package:flutter/material.dart';

class ButtonUnderline extends StatelessWidget {
  const ButtonUnderline({
    super.key,
    required this.buttonText,
    required this.node,
    required this.isSelected,
    required this.onPressed,
    required this.horizont,
    this.circleContainer,
    required this.fontsize,
  });

  final String buttonText;
  final String node;
  final bool isSelected;
  final VoidCallback onPressed;
  final double horizont;
  final Widget? circleContainer;
  final double fontsize;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: horizont),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: isSelected ? Colors.blue : Colors.grey,
              width: 3,
            ),
          ),
        ),
        child: Row(
          children: [
            Text(
              buttonText,
              style: TextStyle(
                fontFamily: "Kanit",
                fontSize: fontsize,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
            circleContainer ?? Container(),
          ],
        ),
      ),
    );
  }
}
