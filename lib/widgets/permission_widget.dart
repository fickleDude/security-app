import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:safety_app/logic/providers/permission_provider.dart';

class PermissionWidget extends StatelessWidget {

  final Permission permission;
  final PermissionStatus? permissionStatus;

  const PermissionWidget({super.key, required this.permission, required this.permissionStatus});

  Color getPermissionColor() {
    switch (permissionStatus) {
      case PermissionStatus.denied:
        return Colors.red;
      case PermissionStatus.granted:
        return Colors.green;
      case PermissionStatus.limited:
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        permission.toString(),
        style: Theme.of(context).textTheme.bodyLarge,
      ),
      subtitle: Text(
        permissionStatus.toString(),
        style: TextStyle(color: getPermissionColor()),
      ),
      onTap: (){
        Provider.of<PermissionProvider>(context, listen: false).getPermissionStatus(permission);
      },
    );
  }
}