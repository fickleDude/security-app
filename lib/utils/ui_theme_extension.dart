//https://medium.com/@m26.nicotra/texttheme-in-flutter-with-less-boilerplate-using-the-extension-methods-597802856c98

import 'package:flutter/material.dart';


extension UIThemeExtension on BuildContext {
  TextStyle? get titleAccent => Theme.of(this).textTheme.headlineLarge;
  TextStyle? get titlePrimary => Theme.of(this).textTheme.headlineMedium;
  TextStyle? get titleBackground => Theme.of(this).textTheme.headlineSmall;

  TextStyle? get subtitleAccent => Theme.of(this).textTheme.titleLarge;
  TextStyle? get subtitlePrimary => Theme.of(this).textTheme.titleMedium;
  TextStyle? get subtitleBackground => Theme.of(this).textTheme.titleSmall;

  TextStyle? get bodyAccent => Theme.of(this).textTheme.bodyLarge;
  TextStyle? get bodyPrimary => Theme.of(this).textTheme.bodyMedium;
  TextStyle? get bodyBackground => Theme.of(this).textTheme.bodySmall;
}