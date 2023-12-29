import "package:flutter/material.dart";

class CustomIconButton extends StatelessWidget {
  IconData icon;
  Color iconColor;
  Color backGroundColor;
  int iconSize;
  int size;
  VoidCallback onPressed;
  CustomIconButton({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.backGroundColor,
    required this.size,
    required this.iconSize,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
          decoration: BoxDecoration(
              color: backGroundColor,
              borderRadius: BorderRadius.circular(size / 2)),
          height: size.toDouble(),
          width: size.toDouble(),
          child: Icon(
            icon,
            color: iconColor,
            size: iconSize.toDouble(),
          )),
    );
  }
}
