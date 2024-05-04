import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:safety_app/UI/widgets/contact_widget.dart';
import 'package:safety_app/domain/contact_model.dart';
import 'package:safety_app/logic/handlers/permission_ecxeption_handler.dart';
import 'package:safety_app/logic/providers/menu_provider.dart';
import 'package:safety_app/logic/services/emergency_contact_service.dart';
import 'package:safety_app/utils/ui_theme_extension.dart';
import '../../../logic/providers/permission_provider.dart';
import '../../../logic/providers/emergency_contact_provider.dart';
import '../../../utils/constants.dart';
import '../../widgets/custom_app_bar_widget.dart';
import 'package:fluttertoast/fluttertoast.dart';

class PhoneBookScreen extends StatefulWidget {
  const PhoneBookScreen({super.key});

  @override
  State<PhoneBookScreen> createState() => _PhoneBookScreenState();

}

class _PhoneBookScreenState extends State<PhoneBookScreen> {
  List<Contact> phoneBook = [];
  @override
  Widget build(BuildContext context) {
    return Consumer<PermissionProvider>(
        builder: (context, permissions, child) {
          if(permissions.getPermissionStatus(Permission.contacts)==PermissionStatus.granted){
            ContactsService.getContacts(withThumbnails: false)
                .then((value) => setState((){
              phoneBook = value;
            }));
            return Scaffold(
              appBar: CustomAppBar(
                title: "телефоны",
                titleStyle: context.titlePrimary!,
                color: accentColor,
                leading: IconButton(
                  icon: Icon(Icons.arrow_back,size: 40,color: primaryColor,weight: 80,),
                  onPressed: () {
                    context.go("/home/contacts");
                  },
                ),
              ),
              body: Stack(
                  children:[
                    Container(
                      decoration: BoxDecoration(
                        color: fillColor,
                        image: const DecorationImage(
                          image: AssetImage("assets/phone.png"),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    ListView.builder(
                      itemCount: phoneBook.length,
                      itemBuilder: (BuildContext context, int index){
                        var phone = phoneBook[index];
                        final String number = phone.phones!.elementAt(0).value!;
                        final String name = phone.displayName!;
                        return ContactWidget(
                          contact: EmergencyContact(number:number,name:name),
                          onTap: (){
                            Provider.of<EmergencyContactProvider>(context, listen: false)
                                .addContact(EmergencyContact(number: number, name: name));
                            context.go("/home/contacts");
                          },
                        );
                      },
                    ),
                  ]

              ),
            );
          }
          else{
            return Scaffold(
              appBar: CustomAppBar(
                title: "телефоны",
                titleStyle: context.titlePrimary!,
                color: accentColor,
                leading: IconButton(
                  icon: Icon(Icons.arrow_back,size: 40,color: primaryColor,weight: 80,),
                  onPressed: () {
                    context.go("/home/contacts");
                  },
                ),
              ),
              body:Container(
                decoration: BoxDecoration(
                  color: fillColor,
                  image: const DecorationImage(
                    image: AssetImage("assets/phone.png"),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Text("нет доступа к контактам", style: context.subtitleBackground),
              ),
              );
          }
        },
    );
  }

}