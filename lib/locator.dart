import 'package:get_it/get_it.dart';

import 'logic/repositories/emergency_contact_repository.dart';
import 'logic/services/emergency_contact_service.dart';

final locator = GetIt.instance;

void init(String uid) {
  // use case
  locator.registerSingleton<ContactRepository>(EmergencyContactRepository(uid: uid));
  locator.registerSingleton(EmergencyContactService(contactRepository: locator()));
}