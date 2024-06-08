import 'package:permission_handler/permission_handler.dart';

class PermissionExceptionHandler {
  static String handlePermissionException(PermissionStatus status) {
    switch (status) {
      case PermissionStatus.granted:
        return "Permission provided";
      case PermissionStatus.denied:
        return "Access to contacts denied by user";
      case PermissionStatus.permanentlyDenied:
        return "Access to contacts denied permanently by user";
      default:
        return "Something went wrong";
    }

  }
}
