import 'package:flutter/material.dart';
import 'package:safety_app/utils/constants.dart';
import 'package:safety_app/utils/ui_theme_extension.dart';

class CustomButton extends StatelessWidget {
  final String title;
  final Function onPressed;
  bool loading;
  CustomButton({
    super.key,
    required this.title,
    required this.onPressed,
    this.loading = false
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          onPressed();
        },
        style: ElevatedButton.styleFrom(
            backgroundColor: primaryColor,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30))),
        child: Text(
          title,
          style: context.l1,
        ),
      ),
    );
  }
}