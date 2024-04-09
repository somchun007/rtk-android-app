import 'package:flutter/material.dart';

class ProfilePicture extends StatelessWidget {
  const ProfilePicture({
    super.key,
    required this.onPressed,
  });
  final Function() onPressed;

  @override
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const SizedBox(
          width: 200,
          height: 200,
          child: CircleAvatar(
            radius: 50,
            backgroundImage: AssetImage("assets/images/profile_pic.png"),
          ),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: ElevatedButton(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
              shape: const CircleBorder(),
              padding: const EdgeInsets.all(15),
              backgroundColor: Colors.grey[200], // <-- Button color
            ),
            child: const Padding(
              padding: EdgeInsets.only(top: 4),
              child: Icon(
                Icons.photo_camera_outlined,
                color: Colors.grey,
                size: 40,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
