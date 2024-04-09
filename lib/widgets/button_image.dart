import 'package:flutter/material.dart';
import 'package:flutter_application/css/style.dart';

class ButtonImage extends StatelessWidget {
  const ButtonImage({
    super.key,
    required this.onPressed,
    required this.buttonText,
    required this.imageWidth,
    required this.imageHight,
    required this.assetImage,
  });

  final VoidCallback onPressed;
  final String buttonText;
  final double imageWidth;
  final double imageHight;
  final String assetImage;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Colors.white,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            //ทางซ้าย --> ข้อความ
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Text(
                buttonText,
                style: StyleFontMenu,
              ),
            ),
            //ทางขวา --> รูปภาพ
            Container(
              width: imageWidth,
              height: imageHight,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Colors.white,
              ),
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(15),
                  bottomRight: Radius.circular(15),
                ),
                child: Image.asset(
                  assetImage,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
