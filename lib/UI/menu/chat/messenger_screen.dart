import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:safety_app/domain/emergency_user_model.dart';
import 'package:safety_app/logic/providers/emergency_chat_provider.dart';
import 'package:safety_app/logic/providers/emetgency_users_provider.dart';
import 'package:safety_app/logic/services/emergency_chat_service.dart';
import 'package:safety_app/logic/services/emergency_user_service.dart';
import 'package:safety_app/utils/constants.dart';
import 'package:safety_app/utils/ui_theme_extension.dart';

import '../../../domain/chat_recipient_model.dart';
import '../../../locator.dart';
import '../../splash_screen.dart';
import '../../widgets/list_widget.dart';
import '../../widgets/custom_app_bar_widget.dart';

class MessengerScreen extends StatefulWidget {
  const MessengerScreen({super.key});

  @override
  State<MessengerScreen> createState() => _MessengerScreenState();
}

class _MessengerScreenState extends State<MessengerScreen>{

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (_) => EmergencyUserProvider(locator<EmergencyUserService>()),
        child: Scaffold(
          appBar: CustomAppBar(
              title: "чаты",
              titleStyle: context.titleAccent!,
              color: primaryColor,
              leading: IconButton(
                icon: Icon(Icons.arrow_back,size: 40,color: accentColor,weight: 80,),
                onPressed: () {
                  context.go("/home");
                },
              ),
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
                color: Colors.transparent,
                margin: const EdgeInsets.symmetric(vertical: 20),
                child: Consumer<EmergencyUserProvider>(
                  builder: (context, provider, child) {
                    var stream = provider.users;
                    return StreamBuilder<List<EmergencyUser>>(
                      stream: stream,
                      builder: (context,snapshot) {
                        if(!snapshot.hasData){
                          return const SplashScreen();
                        }
                        return ListView.builder(
                            itemCount: snapshot.data!.length,
                            itemBuilder: (BuildContext context, int index) {
                              final data = snapshot.data![index];
                              return ListWidget(
                                label: data.name!,
                                tailing: Icon(Icons.messenger_outline, size: 25,color: accentColor,),
                                index: index,
                                onTap: ()=>context.goNamed(
                                    'chat',
                                    extra: ChatRecipientModel(
                                        id: data.id,
                                        name: data.name,
                                        email: data.email
                                    )
                                ),
                              );
                            },
                          );
                      },
                    );
                  },
                ),
              )
            ]
          ),
        ),
    );

  }

}