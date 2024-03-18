import 'package:flutter/foundation.dart';
import 'package:safety_app/logic/models/contact_model.dart';
import 'package:safety_app/logic/services/db_service.dart';

class ContactsListProvider extends ChangeNotifier {
  List<UserContact> _contactsList = [];
  final DatabaseService _databaseService = DatabaseService();

  void fetchContacts() {
    //replace with search by user id
    _databaseService.getContactList().then((value){
      _contactsList = value;
      notifyListeners();
    });
  }
  List<UserContact> get contactsList => _contactsList;

  Future<bool> add(UserContact contact) async{
    var res = await _databaseService.insertContact(contact);
    fetchContacts();
    return res != 0;
  }

  Future<bool> remove(UserContact contact) async {
    var res = await _databaseService.deleteContact(contact.id);
    fetchContacts();
    return res != 0;
  }

  void update(UserContact contact) {
    _databaseService.updateContact(contact);
    fetchContacts();
  }

  //to show in ListView
  UserContact getByIndex(int index){
    return _contactsList[index % _contactsList.length];
  }
}