import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:safety_app/logic/providers/permission_provider.dart';

import '../../widgets/permission_widget.dart';

/// A Flutter application demonstrating the functionality of this plugin
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  _SettingsScreenState createState() =>
      _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer<PermissionProvider>(
        builder: (context, permissions, child) {
          return Scaffold(
            body: Center(
              child: ListView(
                  children: permissions.permissions.entries
                      .map((permission) => PermissionWidget(
                                      permission: permission.key,
                                      permissionStatus: permission.value)
                      )
                      .toList()),
            ),
          );
        }
    );

  }
}