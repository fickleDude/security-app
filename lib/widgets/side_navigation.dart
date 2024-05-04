import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:safety_app/logic/providers/emergency_contact_provider.dart';
import 'package:safety_app/logic/providers/menu_provider.dart';
import 'package:safety_app/utils/ui_theme_extension.dart';

import '../logic/repositories/emergency_contact_repository.dart';
import '../logic/services/emergency_contact_service.dart';
import '../utils/constants.dart';

class SideNavigation extends StatelessWidget{
  final String uid;
  const SideNavigation({super.key, required this.uid});

  @override
  Widget build(BuildContext context) {
    return  Drawer(
            child: ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                DrawerHeader(
                  decoration: BoxDecoration(
                      color: primaryColor,
                      image: const DecorationImage(
                          fit: BoxFit.fill,
                          image: AssetImage('assets/route.jpg'))),
                  child: const Text('CALL GALIA', style: TextStyle(color: Colors.transparent),),
                ),
                ListTile(
                  leading: const Icon(Icons.person),
                  title: Text('профиль', style: context.subtitleBackground,),
                  onTap: () => context.go('/home/profile'),
                ),
                ListTile(
                  leading: const Icon(Icons.contacts),
                  title: Text('контакты', style: context.subtitleBackground,),
                  onTap: () => context.go('/home/contacts'),
                ),
                ListTile(
                  leading: const Icon(Icons.settings),
                  title: Text('настройки', style: context.subtitleBackground,),
                  onTap: () => context.go('/home/settings'),
                ),
                // ListTile(
                //   leading: const Icon(Icons.chat),
                //   title: const Text('CHATS'),
                //   onTap: () => context.go('/home/messenger'),
                // ),
              ],
            ),
          );
      }
  }

