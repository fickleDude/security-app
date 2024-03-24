import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:safety_app/logic/models/user_model.dart';

import '../utils/constants.dart';

class SideNavigation extends StatelessWidget{
  const SideNavigation({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
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
            title: const Text('PROFILE'),
            onTap: () => context.go('/home/profile'),
          ),
          ListTile(
            leading: const Icon(Icons.contacts),
            title: const Text('CONTACTS'),
            onTap: () => context.go('/home/contacts'),
          ),
          ListTile(
            leading: const Icon(Icons.chat),
            title: const Text('CHATS'),
            onTap: () => context.go('/home/messenger'),
          ),
        ],
      ),
    );
  }

}