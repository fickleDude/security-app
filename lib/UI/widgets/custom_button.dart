import 'package:flutter/material.dart';
import 'package:safety_app/utils/constants.dart';


class CustomButton extends StatelessWidget {
  final String label;
  final void Function()? onPressed;
  final Color color;
  final TextStyle labelStyle;
  final double? width;
  CustomButton({
    super.key,
    required this.label,
    required this.onPressed,
    required this.color,
    required this.labelStyle,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      width: width,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
            backgroundColor: color,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30))),
        child: Text(
          label,
          style: labelStyle,
        ),
      ),
    );
  }
}