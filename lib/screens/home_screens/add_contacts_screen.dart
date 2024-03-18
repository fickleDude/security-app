import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:safety_app/components/custom_button.dart';
import 'package:safety_app/logic/models/contact_model.dart';
import 'package:safety_app/logic/providers/contact_list_provider.dart';
import 'package:safety_app/logic/services/db_service.dart';
import 'package:safety_app/utils/constants.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AddContactsScreen extends StatefulWidget {
  const AddContactsScreen({super.key});

  @override
  State<AddContactsScreen> createState() => _AddContactsScreenState();
}

class _AddContactsScreenState extends State<AddContactsScreen> {

  @override
  Widget build(BuildContext context) {
    Provider.of<ContactsListProvider>(context, listen: false).fetchContacts();
    return SafeArea(
        child: Container(
          color: backgroundColor,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                CustomButton(
                    title: "ADD CONTACTS",
                    onPressed: () async {
                      context.go("/home/contacts/user_contacts");
                    }),
                    Consumer<ContactsListProvider>(
                      builder: (context, contactsProvider, _){
                        return Expanded(
                                child: ListView.builder(
                                  itemCount: contactsProvider.contactsList.length,
                                  itemBuilder: (BuildContext context, int index) {
                                    UserContact contact = contactsProvider.contactsList[index];
                                    return Card(
                                      color: primaryColor,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: ListTile(
                                          title: Text(contact.name),
                                          trailing: SizedBox(
                                            width: 100,
                                            child: Row(
                                              children: [
                                                IconButton(
                                                    onPressed: () async {
                                                      await FlutterPhoneDirectCaller.callNumber(
                                                          contact.number);
                                                    },
                                                    icon: Icon(
                                                      Icons.call,
                                                      color: backgroundColor,
                                                    )),
                                                IconButton(
                                                    onPressed: () {
                                                      _deleteContact(contact);
                                                    },
                                                    icon: Icon(
                                                      Icons.delete,
                                                      color: backgroundColor,
                                                    )),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                );
                            }
                          )
                        );
                    },
                  )
            ]
            ),
          ),
        )
    );
  }

  void _deleteContact(UserContact contact) async {
    var result = await Provider.of<ContactsListProvider>(context, listen: false).remove(contact);
    if (result) {
      Fluttertoast.showToast(msg: "contact removed successfully");
    }
  }

}