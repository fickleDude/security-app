import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../utils/constants.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget{
  String title;
  TextStyle titleStyle;
  List<Widget>? actions;
  Widget? leading;
  Color? color;

  CustomAppBar({
    super.key,
    required this.title,
    required this.titleStyle,
    this.actions,
    this.leading,
    this.color
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: leading,
      toolbarHeight: 200,
      backgroundColor: color ?? primaryColor,
      //foregroundColor: color ?? primaryColor,
      title: Text(title, style: titleStyle,),
      centerTitle: true,
      actions: actions,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

}