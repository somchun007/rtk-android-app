import 'package:flutter/material.dart';

class BackgroundApp extends StatelessWidget {
  const BackgroundApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/bg_app.png"),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
