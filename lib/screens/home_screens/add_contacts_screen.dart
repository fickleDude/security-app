import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:safety_app/components/custom_button.dart';
import 'package:safety_app/logic/models/contact_model.dart';
import 'package:safety_app/logic/services/db_service.dart';
import 'package:safety_app/screens/splash_screen.dart';
import 'package:safety_app/utils/constants.dart';
import 'package:sqflite/sqflite.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AddContactsScreen extends StatefulWidget {
  const AddContactsScreen({super.key});

  @override
  State<AddContactsScreen> createState() => _AddContactsScreenState();
}

class _AddContactsScreenState extends State<AddContactsScreen> {
  DatabaseService databaseService = DatabaseService();
  // List<UserContact>? contactList;
  // int count = 0;

  // @override
  // void initState() {
  //   super.initState();
  //   WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
  //     _showList();
  //   });
  // }

  @override
  Widget build(BuildContext context) {
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
                      // _showList();
                    }),
                    ChangeNotifierProvider(
                    create:(context) => DatabaseService(),
                    builder: (context, child)=>Consumer<DatabaseService>(builder: (context, dbService, _){
                      return FutureBuilder(
                          future: dbService.getContactList(),
                          builder: (context, contactList) {
                              return Expanded(
                                child: ListView.builder(
                                  itemCount: contactList.data?.length,
                                  itemBuilder: (BuildContext context, int index) {
                                    UserContact contact = contactList
                                        .data![index];
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
                                  },
                                ),
                              );
                            }
                          );

                    },
                  )
                  ,
                ),
              ],
            ),
          ),
        )
    );
  }

  //manipulate with data in sqlite
  // void _showList(){
  //   Future<Database> dbFuture = databaseService.initializeDatabase();
  //   dbFuture.then((database) {
  //     Future<List<UserContact>> contactListFuture =
  //     databaseService.getContactList();
  //     contactListFuture.then((value) {
  //       setState(() {
  //         contactList = value;
  //         count = value.length;
  //       });
  //     });
  //   });
  // }

  void _deleteContact(UserContact contact) async {
    int result = await databaseService.deleteContact(contact.id);
    if (result != 0) {
      Fluttertoast.showToast(msg: "contact removed successfully");
      // _showList();
    }
  }

}