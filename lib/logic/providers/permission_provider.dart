import 'dart:async';

import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionProvider extends ChangeNotifier{
  final Map<Permission, PermissionStatus?> _permissions = {
    Permission.contacts: null,
    Permission.location: null,
    Permission.locationAlways: null,
    Permission.locationWhenInUse: null,
    Permission.camera: null,
    Permission.notification: null,
    Permission.audio: null,
    Permission.sms: null
  };

  Map<Permission, PermissionStatus?> get permissions => _permissions;
  PermissionProvider(){
    _permissions.forEach((key, value) {_requestPermission(key);});
  }

  Future<void> _requestPermission(Permission permission) async {
    final status = await permission.request();
    _permissions.update(permission, (value) => status);
    notifyListeners();
  }
  PermissionStatus? getPermissionStatus(Permission permission){
    if(_permissions[permission] != PermissionStatus.granted){
      _requestPermission(permission);
    }
    return _permissions[permission];
  }
}