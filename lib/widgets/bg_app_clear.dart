import 'package:flutter/material.dart';

class BackgroundAppClear extends StatelessWidget {
  const BackgroundAppClear({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/bg_app_clear.png"),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
