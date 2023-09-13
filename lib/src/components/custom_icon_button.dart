// ignore_for_file: unused_import

import 'package:flutter/material.dart';

class CustomIconsButton extends StatelessWidget {
  const CustomIconsButton({
    required this.icon,
    super.key,
    required this.onPressed,
  });

  final void Function()? onPressed;

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      icon: Icon(
        icon,
        color: Colors.amber,
        size: 60,
      ),
    );
  }
}
