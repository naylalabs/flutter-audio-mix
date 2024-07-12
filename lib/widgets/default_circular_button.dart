import 'package:flutter/material.dart';

class DefaultCircularButton extends StatelessWidget {
  final String assetName;
  final VoidCallback? press;
  final Color? backgroundColor;
  final double? iconSize;
  final double? innerIconSize;
  final Color? iconColor;
  const DefaultCircularButton(
      {super.key,
      this.press,
      this.backgroundColor,
      this.innerIconSize,
      this.iconSize,
      this.iconColor,
      required this.assetName});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: press,
      child: Container(
        height: iconSize ?? 40,
        width: iconSize ?? 40,
        decoration: BoxDecoration(
            shape: BoxShape.circle, color: backgroundColor ?? Colors.black),
        child: Center(
          child: Image(
            color: iconColor,
            width: innerIconSize ?? 12,
            height: innerIconSize ?? 12,
            image: AssetImage(assetName),
          ),
        ),
      ),
    );
  }
}
