import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:safety_app/logic/models/user_model.dart';
import 'package:safety_app/logic/services/auth_service.dart';
import 'package:safety_app/logic/services/cloud_storage_service.dart';
import 'package:safety_app/screens/home_screens/chat/message_input_field.dart';
import 'package:safety_app/screens/home_screens/chat/single_message.dart';
import 'package:safety_app/screens/splash_screen.dart';
import 'package:safety_app/utils/constants.dart';
import 'package:safety_app/utils/ui_theme_extension.dart';


class ChatScreen extends StatefulWidget {
  final User currentUser = AuthService.auth.getCurrentUser()!;
  final AppUserModel recipient;

  ChatScreen({
    super.key,
    required this.recipient
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen>{

  final CloudService _cloudService = CloudService.cloud;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        backgroundColor: primaryColor,
        title: Text(widget.recipient.name!, style: context.prT1,),
      ),
        body: Column(
          children: [
            Expanded(
              child: StreamBuilder(
                  stream: _cloudService.getChatMessages(
                      widget.currentUser.uid,
                      widget.recipient.id!
                  ),
                  builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
                    if(snapshot.hasData){
                      if(snapshot.data!.docs.isEmpty){
                        return Center(
                            child: Text(
                                "TALK WITH ${widget.recipient.name}",
                                style: context.prT2
                            ),
                        );
                      }
                      return ListView.builder(
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (BuildContext context, int index){
                            final data = snapshot.data!.docs[index];
                            bool isMe = data['senderId'] == widget.currentUser.uid;
                            String type = data['type'];
                            return SingleMessage(
                              message: data['message'],
                              date: data['date'],
                              isMe: isMe,
                              recipientName: widget.recipient.name,
                              userName: widget.currentUser.displayName,
                              type: type,
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
              currentUserId: widget.currentUser.uid,
              recipientId: widget.recipient.id!,
            )
          ],
        ),
    );
  }

}