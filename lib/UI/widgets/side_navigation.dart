import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:safety_app/UI/widgets/list_widget.dart';
import 'package:safety_app/utils/ui_theme_extension.dart';

import '../../utils/constants.dart';

class SideNavigation extends StatelessWidget{
  const SideNavigation({super.key});

  @override
  Widget build(BuildContext context) {
    return  Drawer(
            backgroundColor: fillColor,
            child: ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                DrawerHeader(
                  child: Center(child: Text('call galya', style: context.titlePrimary,)),
                ),
                ListWidget(
                    index: 0,
                    label: 'профиль',
                    tailing:Icon(Icons.person, size: 40,color: accentColor,weight: 80,),
                    onTap: () => context.go('/home/profile'),
                ),
                ListWidget(
                    index: 1,
                    label: 'контакты',
                    tailing:Icon(Icons.contacts_rounded, size: 40,color: accentColor,weight: 80,),
                    onTap: () => context.go('/home/contacts'),
                ),
                ListWidget(
                    index: 2,
                    label: 'чат',
                    tailing:Icon(Icons.messenger_outline, size: 40,color: accentColor,weight: 80,),
                    onTap: () => context.go('/home/messenger'),
                ),
              ],
            ),
          );
      }
  }

