import 'package:flutter/material.dart';
import 'package:safety_app/utils/constants.dart';
import 'package:safety_app/utils/ui_theme_extension.dart';

class CustomTextField extends StatelessWidget{
  final String? initialValue;
  final String? hintText;
  final TextEditingController? controller;
  final String? Function(String?)? onValidate;
  final void Function(String?)? onSave;
  final void Function(String?)? onChange;
  final int? maxLines;
  final bool enable;
  final bool? check;
  final bool isPassword;
  final TextInputType? keyboardType;
  final TextInputAction? inputAction;
  final Widget? prefix;
  final Widget? suffix;
  final FocusNode? focusNode; //widget to obtain the keyboard focus and to handle keyboard events

  const CustomTextField(
    {super.key,
      this.initialValue,
      this.hintText,
      this.controller,
      this.onValidate,
      this.onSave,
      this.onChange,
      this.maxLines,
      this.enable = true,
      this.check,
      this.isPassword = false,
      this.keyboardType,
      this.inputAction,
      this.prefix,
      this.suffix,
      this.focusNode}
      );

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: initialValue,
      onChanged: onChange,
      validator: onValidate,
      enabled: enable == true ? true : enable,
      controller: controller,
      textInputAction: inputAction,
      focusNode: focusNode,
      maxLines: maxLines ?? 1,
      keyboardType: keyboardType ?? TextInputType.name,
      onSaved: onSave,
      obscureText: isPassword == false ? false : isPassword,
      decoration: InputDecoration(
        labelText: hintText ?? 'hint text...',
        labelStyle: context.prL1,
        prefixIcon: prefix,
        suffixIcon: suffix,
        focusedBorder: OutlineInputBorder(
         borderRadius: BorderRadius.circular(30),
         borderSide:  BorderSide(
           style: BorderStyle.solid,
           color: defaultColor
         )
        ),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide:  BorderSide(
                style: BorderStyle.solid,
                color: primaryColor
            )
        ),
        focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide:  BorderSide(
                style: BorderStyle.solid,
                color: defaultColor
            )
        ),
        errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide:  BorderSide(
                style: BorderStyle.solid,
                color: primaryColor
            )
        ),
      ),
    );
  }

}