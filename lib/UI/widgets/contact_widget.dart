import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:safety_app/domain/contact_model.dart';
import 'package:safety_app/logic/providers/emergency_contact_provider.dart';
import 'package:safety_app/logic/providers/user_provider.dart';
import 'package:safety_app/utils/ui_theme_extension.dart';

import '../../utils/constants.dart';

class ContactWidget extends StatelessWidget{
  EmergencyContact contact;
  void Function(DismissUpdateDetails)? onUpdate;
  void Function()? onTap;

  ContactWidget({
    super.key,
    required this.contact,
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
      child: Dismissible(
        key: UniqueKey(),
        child: InkWell(
          child:ListTile(
            trailing: Icon(Icons.call, size: 25,color: accentColor,),
            title: Text(contact.name!, style: context.subtitleAccent,),
          ),
          onTap: onTap,
        ),
        onUpdate: onUpdate,
      ),
    );
  }

}