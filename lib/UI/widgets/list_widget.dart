import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:safety_app/domain/emergency_contact_model.dart';
import 'package:safety_app/logic/providers/emergency_contact_provider.dart';
import 'package:safety_app/logic/providers/user_provider.dart';
import 'package:safety_app/utils/ui_theme_extension.dart';

import '../../utils/constants.dart';

class ListWidget extends StatelessWidget{
  void Function(DismissUpdateDetails)? onUpdate;
  void Function()? onTap;

  String label;
  Icon tailing;
  int index;

  ListWidget({
    super.key,
    required this.label,
    required this.tailing,
    required this.index,
    this.onUpdate,
    this.onTap
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
        color: primaryColor,
        borderRadius: BorderRadius.circular(90),
      ),
      // child: InkWell(
      //   onTap: onTap,
      //   child:ListTile(
      //     trailing: tailing,
      //     title: Text(label, style: context.subtitleAccent,),
      //   ),
      // ),
      child: Dismissible(
        // key: UniqueKey(),
        key: ValueKey<int>(index),
        onUpdate: onUpdate,
        child:
        InkWell(
          onTap: onTap,
          child:ListTile(
            trailing: tailing,
            title: Text(label, style: context.subtitleAccent,),
          ),
        ),
      ),
    );
  }

}