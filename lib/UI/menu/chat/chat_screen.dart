import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:safety_app/domain/chat_recipient_model.dart';
import 'package:safety_app/logic/providers/user_provider.dart';
import 'package:safety_app/utils/constants.dart';
import 'package:safety_app/utils/ui_theme_extension.dart';

import '../../../locator.dart';
import '../../../logic/providers/emergency_chat_provider.dart';
import '../../../logic/services/emergency_chat_service.dart';
import '../../splash_screen.dart';
import '../../widgets/custom_app_bar_widget.dart';
import '../../widgets/message_input_field.dart';
import '../../widgets/single_message.dart';


class ChatScreen extends StatefulWidget {
  final ChatRecipientModel recipient;

  const ChatScreen({
    super.key,
    required this.recipient
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen>{

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (_) => EmergencyChatProvider(locator<EmergencyChatService>()),
        child: Scaffold(
          appBar: CustomAppBar(
              title: widget.recipient.name!,
              titleStyle: context.titlePrimary!,
              color: accentColor,
              leading: IconButton(
                icon: Icon(Icons.arrow_back,size: 40,color: primaryColor,weight: 80,),
                onPressed: () {
                  context.go("/home/messenger");
                },
              ),
            ),
          body: Container(
                  color: primaryColor,
                  child: Consumer<EmergencyChatProvider>(
                      builder: (context, provider, child) {
                        var stream = provider.getChatMessages(widget.recipient.id!);
                        return Column(
                          children: [
                            Expanded(
                              child: StreamBuilder(
                                  stream: stream,
                                  builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
                                    if(snapshot.hasData){
                                      if(snapshot.data!.docs.isEmpty){
                                        return Center(
                                          child: Text(
                                            "поговори с ${widget.recipient.name?.toUpperCase()}",
                                          ),
                                        );
                                      }
                                      return ListView.builder(
                                          itemCount: snapshot.data!.docs.length,
                                          itemBuilder: (BuildContext context, int index){
                                            final data = snapshot.data!.docs[index];
                                            return Dismissible(
                                              key: UniqueKey(),
                                              onDismissed: (direction){
                                                provider.deleteMessage(widget.recipient.id!,data.id);
                                              },
                                              child: SingleMessage(
                                                message: data['message'],
                                                date: data['date'],
                                                isMe: data['isMe'],
                                                recipientName: widget.recipient.name,
                                                userName: Provider.of<UserProvider>(context, listen: false).user?.displayName!,
                                                type: data['type'],
                                              ),
                                            );
                                          }
                                      );
                                    }else{
                                      return const SplashScreen();
                                    }
                                  }
                              ),
                            ),
                            MessageInputField(
                              currentUserId: Provider.of<UserProvider>(context, listen: false).user!.uid,
                              recipientId: widget.recipient.id!,
                            )
                          ],
                        );
                      }
                  ),
          )
        ),
    );
  }
}