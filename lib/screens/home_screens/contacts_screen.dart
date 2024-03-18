import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:safety_app/logic/services/db_service.dart';
import 'package:safety_app/screens/splash_screen.dart';
import 'package:safety_app/utils/constants.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../logic/models/contact_model.dart';
import '../../logic/providers/contact_list_provider.dart';

class ContactsScreen extends StatefulWidget {
  const ContactsScreen({super.key});

  @override
  State<ContactsScreen> createState() => _ContactsScreenState();

}

class _ContactsScreenState extends State<ContactsScreen>{

  //to list contacts
  List<Contact> _contacts = [];
  List<Contact> _filteredContacts = [];
  //to filter contacts
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _askForContactsPermission();
  }

  @override
  Widget build(BuildContext context) {
    bool isSearchIng = searchController.text.isNotEmpty;
    bool listItemExit = (_filteredContacts.isNotEmpty || _contacts.isNotEmpty);
    return Scaffold(
      body: _contacts.isEmpty
        ? const SplashScreen()
        : SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  autofocus: true,
                  controller: searchController,
                  decoration: const InputDecoration(
                      labelText: "SEARCH CONTACT",
                      prefixIcon: Icon(Icons.search)),
                ),
              ),
              listItemExit == true
              ? Expanded(
                child: ListView.builder(
                itemCount: isSearchIng ? _filteredContacts.length : _contacts.length,
                itemBuilder: (BuildContext context, int index){
                  Contact contact = isSearchIng ? _filteredContacts[index] : _contacts[index];
                  return ListTile(
                    title: Text(contact.displayName ?? ""),
                    // subtitle: Text(contact.phones!.elementAt(0).value ?? ""),
                    leading: contact.avatar != null && contact.avatar!.isNotEmpty
                    ? CircleAvatar(
                      backgroundColor: primaryColor,
                      backgroundImage: MemoryImage(contact.avatar!),
                    )
                    : CircleAvatar(
                      backgroundColor: primaryColor,
                      child: Text(contact.initials()),
                    ),
                    onTap: () {
                      if (contact.phones!.isNotEmpty) {
                        final String phoneNum =
                        contact.phones!.elementAt(0).value!;
                        final String name = contact.displayName!;
                        _addContact(UserContact(phoneNum, name));
                      } else {
                        Fluttertoast.showToast(
                            msg:
                            "Oops! phone number of this contact does exist");
                      }
                    },
                  );
                }
      ),
              )
              : const Center(child: Text("SEARCHING")),
            ],
          ),
        ),
    );
  }

  //PERMISSIONS
  //ask for permission
  Future<PermissionStatus> _getContactsPermission() async{
    var status = await Permission.contacts.status;
    if (status != PermissionStatus.granted
        && status != PermissionStatus.permanentlyDenied) {
      // We haven't asked for permission yet or the permission has been denied before, but not permanently.
      status = await Permission.contacts.request();
    }
    return status;
  }
  //if went ok, get contacts
  Future<void> _askForContactsPermission() async{
    PermissionStatus permissionStatus = await _getContactsPermission();
    if(permissionStatus == PermissionStatus.granted){
      _getAllContacts();
      searchController.addListener(() {
        _filterContact();
      });
    }else{
      _handleInvalidPermissions(permissionStatus);
    }
  }
  //get contacts
  void _getAllContacts() async{
    List<Contact> contacts =
    // await ContactsService.getContacts(withThumbnails: false);
    await ContactsService.getContacts(withThumbnails: true);
    setState(() {
      _contacts = contacts;
    });
  }
  //handle permission denied
  void _handleInvalidPermissions(PermissionStatus permissionStatus){
    if(permissionStatus.isDenied){
      dialog(context, "Access to contacts denied by user.");
    }else if (permissionStatus.isPermanentlyDenied){
      dialog(context, "Something went wrong");
    }
  }

  //SEARCH FILTER
  String _flattenPhoneNumber(String phoneStr) {
    return phoneStr.replaceAllMapped(RegExp(r'^(\+)|\D'), (Match m) {
      return m[0] == "+" ? "+" : "";
    });
  }

  void _filterContact() {
    List<Contact> contacts = [];
    contacts.addAll(_contacts);
    if (searchController.text.isNotEmpty) {
      contacts.retainWhere((element) {
        String searchTerm = searchController.text.toLowerCase();
        String searchTermFlatten = _flattenPhoneNumber(searchTerm);
        String contactName = element.displayName!.toLowerCase();
        //filter by name
        if (contactName.contains(searchTerm)) {
          return true;
        }
        //filter by phone
        if(searchTermFlatten.isEmpty){
          return false;
        }
        var phone = element.phones!.firstWhere((element){
          String flattenPhone = _flattenPhoneNumber(element.value!);
          return flattenPhone.contains(searchTermFlatten);
        });
        return phone.value != null;
      });
    }
    setState(() {
      _filteredContacts = contacts;
    });
  }

  //INTEGRATION WITH DB
  void _addContact(UserContact newContact) async {
    var result = await Provider.of<ContactsListProvider>(context, listen: false).add(newContact);
    if (result) {
      Fluttertoast.showToast(msg: "contact added successfully");
    } else {
      Fluttertoast.showToast(msg: "Failed to add contacts");
    }
    context.go("/home/contacts");
  }
}