import 'package:flutter/material.dart';

class BackgroundSignup extends StatelessWidget {
  const BackgroundSignup({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/bg_signup.jpg"),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
