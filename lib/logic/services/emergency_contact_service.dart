import '../../domain/emergency_contact_model.dart';
import '../repositories/emergency_contact_repository.dart';

class EmergencyContactService {
  final ContactRepository _contactRepository;

  const EmergencyContactService({
    required ContactRepository contactRepository,
  }) : _contactRepository = contactRepository;

  Stream<List<EmergencyContact>> getContacts() => _contactRepository.getContacts();

  void addContact(EmergencyContact contact)=>_contactRepository.addContact(contact);
  void deleteContact(EmergencyContact contact)=>_contactRepository.deleteContact(contact);
  void updateContact(EmergencyContact contact)=>_contactRepository.updateContact(contact);
}