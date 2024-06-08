import 'package:flutter/cupertino.dart';
import 'package:safety_app/domain/emergency_user_model.dart';
import '../services/emergency_user_service.dart';

class EmergencyUserProvider extends ChangeNotifier{
  late final EmergencyUserService _usersService;
  late Stream<List<EmergencyUser>> _users;

  Stream<List<EmergencyUser>> get users => _users;

  EmergencyUserProvider(EmergencyUserService userService) {
    _usersService = userService;
    _users = _usersService.getContacts();
  }

  void addContact(EmergencyUser contact) {
    _usersService.addContact(contact);
    _users = _usersService.getContacts();
    notifyListeners();
  }

  void deleteContact(EmergencyUser contact) {
    _usersService.deleteContact(contact);
    _users = _usersService.getContacts();
    notifyListeners();
  }

  void updateContact(EmergencyUser contact) {
    _usersService.updateContact(contact);
    _users = _usersService.getContacts();
    notifyListeners();
  }
}