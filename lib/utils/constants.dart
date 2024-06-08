import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Color accentColor = Color(0xFFF892C28);
Color fillColor = Color(0xFFF666D63);
Color primaryColor = Color(0xFFFDEDCDA);
Color backgroundColor = Color(0xFFF272E25);


dialog(BuildContext context, String text){
  showDialog(context: context,
      builder: (context) => AlertDialog(
        title: Text(text),
      ));
}