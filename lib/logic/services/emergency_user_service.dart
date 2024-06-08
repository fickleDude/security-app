import 'package:safety_app/logic/repositories/emergency_user_repository.dart';

import '../../domain/emergency_contact_model.dart';
import '../../domain/emergency_user_model.dart';
import '../repositories/emergency_contact_repository.dart';

class EmergencyUserService {
  final UserRepository _userRepository;

  const EmergencyUserService({
    required UserRepository userRepository,
  }) : _userRepository = userRepository;

  Stream<List<EmergencyUser>> getContacts() => _userRepository.getUsers();

  void addContact(EmergencyUser user)=>_userRepository.addUser(user);
  void deleteContact(EmergencyUser user)=>_userRepository.deleteUser(user);
  void updateContact(EmergencyUser user)=>_userRepository.updateUser(user);
}