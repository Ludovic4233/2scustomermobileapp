// ignore_for_file: file_names
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final Color bgColor;
  final Color textColor;
  final Function() onPress;
  // final Color textColor;
  CustomButton(
      {super.key,
      required this.text,
      required this.bgColor,
      required this.textColor,
      onPress})
      : onPress = onPress ?? (() {});
  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        backgroundColor: bgColor,
        padding: const EdgeInsets.all(15.0),
      ),
      onPressed: onPress,
      child: Text(
        text,
        style: TextStyle(
          color: textColor,
          fontWeight: FontWeight.w500,
          letterSpacing: 1,
        ),
      ),
    );
  }
}
