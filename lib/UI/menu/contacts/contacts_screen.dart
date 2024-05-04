import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:safety_app/UI/splash_screen.dart';
import 'package:safety_app/UI/widgets/contact_widget.dart';
import 'package:safety_app/UI/widgets/custom_app_bar_widget.dart';
import 'package:safety_app/domain/contact_model.dart';
import 'package:safety_app/locator.dart';
import 'package:safety_app/logic/providers/emergency_contact_provider.dart';
import 'package:safety_app/utils/constants.dart';
import 'package:safety_app/utils/ui_theme_extension.dart';
import '../../../logic/providers/menu_provider.dart';
import '../../../logic/services/emergency_contact_service.dart';

class ContactsScreen extends StatelessWidget {
  const ContactsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (_) => EmergencyContactProvider(locator<EmergencyContactService>()),
        child: Scaffold(
            appBar: CustomAppBar(
              title: "контакты",
              titleStyle: context.titleAccent!,
              actions: [
                IconButton(
                  icon: Icon(Icons.add,size: 40,color: accentColor,weight: 80,),
                  onPressed: () {
                    context.go("/home/contacts/phonebook");
                  },
                ),
              ],
            ),
            body: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: fillColor,
                    image: const DecorationImage(
                      image: AssetImage("assets/fly_cut.png"),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                 Container(
                      margin: const EdgeInsets.symmetric(vertical: 20),
                      color: Colors.transparent,
                      child: Consumer<EmergencyContactProvider>(
                        builder: (context, provider, child) {
                          var stream = provider.contacts;
                          return StreamBuilder<List<EmergencyContact>>(
                            stream: stream,
                            builder: (context,snapshot,){
                              if(snapshot.hasData){
                                var list = snapshot.data;
                                return ListView.builder(
                                  itemCount: list?.length,
                                  itemBuilder: (context, i) => ContactWidget(
                                    contact: list![i],
                                    onUpdate: (details)=>provider.deleteContact(list![i]),
                                  ),
                                );
                              }
                              else{
                                return const Center(
                                  child: Text(
                                    "нет контактов",
                                  ),
                                );
                              }
                            },
                          );
                        },)

                  ),
              ],
            )

        ),
    );

  }
}

