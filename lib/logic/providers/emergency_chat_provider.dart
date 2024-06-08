import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:safety_app/logic/services/emergency_chat_service.dart';

import '../../domain/chat_message_model.dart';

class EmergencyChatProvider extends ChangeNotifier {
  late final EmergencyChatService _chatService;

  EmergencyChatProvider(EmergencyChatService chatService){
    _chatService= chatService;
  }

  Stream<QuerySnapshot<Map<String, dynamic>>>? getRecipients(){
    return _chatService.getRecipients();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>>? getChatMessages(String recipientId){
    return _chatService.getChatMessages(recipientId);
  }

  void sendMessage(String recipientId,ChatMessageModel message){
   _chatService.sendMessage(recipientId, message);
   notifyListeners();
  }
  void deleteMessage(String recipientId, String messageId){
    _chatService.deleteMessage(recipientId, messageId);
    notifyListeners();
  }


}