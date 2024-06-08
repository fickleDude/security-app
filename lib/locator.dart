import 'package:get_it/get_it.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:safety_app/logic/repositories/emergency_chat_repository.dart';
import 'package:safety_app/logic/repositories/emergency_user_repository.dart';
import 'package:safety_app/logic/services/emergency_chat_service.dart';
import 'package:safety_app/logic/services/emergency_user_service.dart';

import 'logic/repositories/emergency_contact_repository.dart';
import 'logic/services/emergency_contact_service.dart';

final locator = GetIt.instance;

void init(User user) {
  if(!locator.isRegistered<ContactRepository>()){
    locator.registerSingleton<ContactRepository>(EmergencyContactRepository(uid: user.uid));
  }
  if(!locator.isRegistered<ChatRepository>()){
    locator.registerSingleton<ChatRepository>(EmergencyChatRepository(user: user));
  }
  if(!locator.isRegistered<UserRepository>()){
    locator.registerSingleton<UserRepository>(EmergencyUserRepository(uid: user.uid));
  }
  if(!locator.isRegistered<EmergencyContactService>()){
    locator.registerSingleton(EmergencyContactService(contactRepository: locator()));
  }
  if(!locator.isRegistered<EmergencyChatService>()){
    locator.registerSingleton(EmergencyChatService(chatRepository: locator()));
  }
  if(!locator.isRegistered<EmergencyUserService>()){
    locator.registerSingleton(EmergencyUserService(userRepository: locator()));
  }
}