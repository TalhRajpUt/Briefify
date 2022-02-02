import 'package:briefify/data/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ButtonOne extends StatelessWidget {
  final String title;
  final VoidCallback onPressed;
  final EdgeInsetsGeometry padding;
  final double radius;
  final double minSize;
  final Color color;
  final double titleSize;

  const ButtonOne({
    Key? key,
    required this.title,
    required this.onPressed,
    this.radius = 300,
    this.minSize = 44.0,
    this.color = kPrimaryColorLight,
    this.titleSize = 16.0,
    this.padding = const EdgeInsets.symmetric(horizontal: 30, vertical: 00),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: CupertinoButton(
        onPressed: onPressed,
        child: Text(
          title,
          style: TextStyle(
            color: Colors.white,
            fontSize: titleSize,
            fontWeight: FontWeight.bold,
          ),
        ),
        padding: padding,
        color: color,
        minSize: minSize,
      ),
    );
  }
}
