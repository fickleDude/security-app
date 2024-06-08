import 'package:flutter/cupertino.dart';
import 'package:safety_app/logic/services/emergency_contact_service.dart';
import '../../domain/emergency_contact_model.dart';

class EmergencyContactProvider extends ChangeNotifier{
  late final EmergencyContactService _contactService;
  late Stream<List<EmergencyContact>> _contacts;

  Stream<List<EmergencyContact>> get contacts => _contacts;

  EmergencyContactProvider(EmergencyContactService contactService) {
    _contactService = contactService;
    _contacts = _contactService.getContacts();
  }

  void addContact(EmergencyContact contact) {
    _contactService.addContact(contact);
    _contacts = _contactService.getContacts();
    notifyListeners();
  }

  void deleteContact(EmergencyContact contact) {
    _contactService.deleteContact(contact);
    _contacts = _contactService.getContacts();
    notifyListeners();
  }

  void updateContact(EmergencyContact contact) {
    _contactService.updateContact(contact);
    _contacts = _contactService.getContacts();
    notifyListeners();
  }
}