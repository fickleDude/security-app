import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:safety_app/logic/models/user_model.dart';
import 'package:safety_app/logic/services/auth_service.dart';
import 'package:safety_app/logic/services/cloud_storage_service.dart';
import 'package:safety_app/screens/splash_screen.dart';
import 'package:safety_app/utils/constants.dart';
import 'package:safety_app/utils/ui_theme_extension.dart';

class MessengerScreen extends StatefulWidget {
  const MessengerScreen({super.key});

  @override
  State<MessengerScreen> createState() => _MessengerScreenState();
}

class _MessengerScreenState extends State<MessengerScreen>{

  final CloudService _cloudService = CloudService.cloud;
  final AuthService _authService = AuthService.auth;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: primaryColor,
          title: Text("CHAT", style: context.prT1,),
        ),
        body: StreamBuilder(
          stream: _cloudService.getRecipients(_authService.getCurrentUser()?.email),
          builder: (BuildContext context,AsyncSnapshot<QuerySnapshot> snapshot) {
            if(!snapshot.hasData){
              return const SplashScreen();
            }
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (BuildContext context, int index) {
                final data = snapshot.data!.docs[index];
                return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: primaryColor,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: ListTile(
                        title: Padding(
                          padding:const EdgeInsets.all(8.0),
                          child: Text(data["name"], style: context.l1,),
                        ),
                        onTap: ()=>context.goNamed(
                            'chat',
                            extra: AppUserModel(id: data["id"], name: data["name"], email: data["email"])
                        ),
                      ),
                    ),
                );
              },
            );
          },
        ),
    );
  }

}