import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:safety_app/utils/ui_theme_extension.dart';

import '../../utils/constants.dart';

class CustomFormTextField extends StatelessWidget{
  final String? hintText;
  final Widget? prefix;
  final Widget? suffix;

  final String? Function(String?)? validator;
  final void Function(String?)? onChange;

  final bool isVisible;

  const CustomFormTextField({
    super.key,
    this.hintText,
    this.prefix,
    this.suffix,
    this.validator,
    this.onChange,
    this.isVisible = false
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16),
      child: TextFormField(
        validator: validator,
        onChanged: onChange,
        obscureText: isVisible,
        decoration: InputDecoration(
          fillColor: primaryColor,
          filled: true,
          hintText: hintText,
          hintStyle: context.bodyBackground,
          errorStyle: context.bodyPrimary,
          prefixIcon: prefix,
          suffixIcon: suffix,
          focusedBorder: _fieldBorder(),
          enabledBorder: _fieldBorder(),
          focusedErrorBorder: _fieldBorder(),
          errorBorder: _fieldBorder(),
        ),
      ),
    );
  }

  InputBorder? _fieldBorder(){
    return OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide:  BorderSide(
        style: BorderStyle.solid,
        color: primaryColor
      )
    );
  }
}