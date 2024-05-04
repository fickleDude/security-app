// import 'package:flutter/cupertino.dart';
// import 'package:provider/provider.dart';
// import 'package:safety_app/UI/menu/contacts/contacts_screen.dart';
// import 'package:safety_app/UI/menu/contacts/phone_book_screen.dart';
// import 'package:safety_app/UI/menu/home_screen.dart';
// import 'package:safety_app/logic/providers/menu_provider.dart';
//
// import '../logic/providers/user_provider.dart';
// import '../logic/repositories/emergency_contact_repository.dart';
// import '../logic/services/emergency_contact_service.dart';
//
// class MenuScreen extends StatefulWidget {
//   const MenuScreen({super.key});
//
//   @override
//   State<MenuScreen> createState() => _MenuScreenState();
// }
//
// class _MenuScreenState extends State<MenuScreen>{
//
//   @override
//   Widget build(BuildContext context) {
//     String uid = Provider.of<UserProvider>(context, listen: false).user!.uid;
//     return MultiProvider(
//       providers: [
//         Provider<ContactRepository>(
//             create: (_) => EmergencyContactRepository(uid: uid)
//         ),
//         Consumer<ContactRepository>(
//             builder: (context, repository, child)=>
//             Provider<EmergencyContactService>(
//                 create: (_)=>EmergencyContactService(contactRepository: repository),
//                 child: child,
//             )
//         ),
//       ],
//       child: Consumer<HomeProvider>(
//         builder: (context, menu, child) {
//           switch(menu.type){
//             case HomeType.contact:
//               return ContactsScreen();
//             case HomeType.phoneBook:
//               return PhoneBookScreen();
//             default:
//               return HomeScreen();
//           }
//         }
//       )
//       //     (context, child)=>Consumer<EmergencyContactService>(
//       //     builder: (context, menu, _) {
//       //       return ContactsScreen();
//       //     }
//       // )
//     );
//   }
//
// }