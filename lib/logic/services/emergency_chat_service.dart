import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/chat_message_model.dart';
import '../repositories/emergency_chat_repository.dart';

class EmergencyChatService {
  final ChatRepository _chatRepository;

  const EmergencyChatService({
    required ChatRepository chatRepository,
  }) : _chatRepository = chatRepository;

  Stream<QuerySnapshot<Map<String, dynamic>>>? getRecipients()=>_chatRepository.getRecipients();
  Stream<QuerySnapshot<Map<String, dynamic>>>? getChatMessages(String recipientId)=>_chatRepository.getChatMessages(recipientId);

  void sendMessage(String recipientId,ChatMessageModel message)=>_chatRepository.sendMessage(recipientId, message);
  void deleteMessage(String recipientId, String messageId)=>_chatRepository.deleteMessage(recipientId, messageId);
}