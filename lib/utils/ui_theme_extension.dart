//https://medium.com/@m26.nicotra/texttheme-in-flutter-with-less-boilerplate-using-the-extension-methods-597802856c98

import 'package:flutter/material.dart';


extension UIThemeExtension on BuildContext {

  //DEFAULT
  TextStyle? get t1 => Theme.of(this).textTheme.titleLarge;

  TextStyle? get l1 => Theme.of(this).textTheme.labelLarge;
  TextStyle? get l2 => Theme.of(this).textTheme.labelMedium;
  TextStyle? get l3 => Theme.of(this).textTheme.labelSmall;
  TextStyle? get b2 => Theme.of(this).textTheme.bodyMedium;
  TextStyle? get b3 => Theme.of(this).textTheme.bodySmall;
  //PRIMARY
  TextStyle? get prL1 => Theme.of(this).primaryTextTheme.labelMedium;
  TextStyle? get prT2 => Theme.of(this).primaryTextTheme.titleMedium;
  TextStyle? get prT1 => Theme.of(this).primaryTextTheme.titleLarge;
  //ACCENT
}