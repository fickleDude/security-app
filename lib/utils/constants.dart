import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Color primaryColor = Color(0xff8673e9);
Color backgroundColor = Color(0xffe6e6e6);
Color gradientColorDark = Color(0xFF414680);
Color gradientColorBright = Color(0xFFFB8580);
Color defaultColor = Colors.grey;

dialog(BuildContext context, String text){
  showDialog(context: context,
      builder: (context) => AlertDialog(
        title: Text(text),
      ));
}