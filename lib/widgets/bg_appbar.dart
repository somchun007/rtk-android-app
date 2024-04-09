import 'package:flutter/material.dart';

class BackgroundAppbar extends StatelessWidget {
  const BackgroundAppbar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          image: DecorationImage(
        image: AssetImage('assets/images/bg_appbar.png'),
        fit: BoxFit.fill,
      )),
    );
  }
}
