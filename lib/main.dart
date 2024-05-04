import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:safety_app/UI/menu/contacts/contacts_screen.dart';
import 'package:safety_app/UI/menu/contacts/phone_book_screen.dart';
import 'package:safety_app/UI/menu/settings_screen.dart';
import 'package:safety_app/UI/menu_screen.dart';
import 'package:safety_app/logic/providers/menu_provider.dart';
import 'package:safety_app/logic/providers/permission_provider.dart';
import 'package:safety_app/logic/providers/user_provider.dart';
import 'package:safety_app/logic/repositories/emergency_contact_repository.dart';
import 'package:safety_app/utils/constants.dart';

import 'UI/menu/home_screen.dart';
import 'UI/login_screen.dart';
import 'UI/menu/profile_screen.dart';
import 'UI/onboard_screen.dart';
import 'UI/register_screen.dart';
import 'UI/splash_screen.dart';
import 'logic/handlers/auth_ecxeption_handler.dart';
import 'logic/services/emergency_contact_service.dart';

import 'locator.dart' as di;

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp().then((value) => print(value.options.projectId));
  runApp(MyApp());
}

GoRouter router(String initialLocation, String? uid) {
  return GoRouter(
    initialLocation: initialLocation,
    routes: [
      GoRoute(
        path: '/splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
          path: '/welcome',
          builder: (context, state) => WelcomeScreen(),
          routes: [
            GoRoute(
              path: 'login',
              builder: (context, state) => const LoginScreen(),
            ),
            GoRoute(
              path: 'register',
              builder: (context, state) => const RegisterScreen(),
             ),
          ]
      ),
      GoRoute(
          path: '/home',
          //builder: (context, state) => const MenuScreen(),
          builder: (context, state)=>HomeScreen(uid: uid!,),
          routes: [
            GoRoute(
              path: 'profile',
              builder: (context, state) => const ProfileScreen(),
            ), 
            GoRoute(
              path: 'settings',
              builder: (context, state) => const SettingsScreen(),
            ),
            GoRoute(
              path: 'contacts',
              builder: (context, state) => const ContactsScreen(),
              routes: [
                GoRoute(
                    path: 'phonebook',
                    builder: (context, state) => const PhoneBookScreen()
                )
              ]
            ),
            // GoRoute(
            //   path: 'messenger',
            //   builder: (context, state) => const MessengerScreen(),
            //   routes: [
            //     GoRoute(
            //       path: 'chat',
            //       name: 'chat',
            //       builder: (context, state){
            //         AppUserModel? recipient = state.extra as AppUserModel?; //casting is important
            //         return ChatScreen(recipient: recipient!,);
            //       },
            //     ),
            //   ]
            // ),

          ]
      ),

    ],
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
        ChangeNotifierProvider.value(value: UserProvider.instance()),
        ChangeNotifierProvider.value(value: PermissionProvider()),
        ],
        builder: (context, child)=>Consumer<UserProvider>(
            builder: (context, user, _) {
          switch(user.status){
            case AuthStatus.uninitialized:
              return appSetUp('/welcome', null);
            case AuthStatus.unauthenticated:
            case AuthStatus.authenticating:
              return appSetUp('/welcome/login', null);
            case AuthStatus.authenticated:
              di.init(user.user!.uid);
              return appSetUp('/home', user.user!.uid);
            default:
              return appSetUp('/splash', null);
          }
        }
      )
    );
  }

  Widget appSetUp(String initialLocation, String? uid){
    return MaterialApp.router(
        title: 'SAFETY APP',
        theme: ThemeData(
          textTheme: TextTheme(
              //title
              headlineLarge: TextStyle(fontFamily: 'TTTravels',fontSize: 36, fontWeight: FontWeight.w900, color: accentColor),
              headlineMedium: TextStyle(fontFamily: 'TTTravels',fontSize: 36, fontWeight: FontWeight.w900, color: primaryColor),
              headlineSmall: TextStyle(fontFamily: 'TTTravels',fontSize: 36, fontWeight: FontWeight.w900, color: backgroundColor),
              //subtitle
              titleLarge: TextStyle(fontFamily: 'TTTravels',fontSize: 20, fontWeight: FontWeight.w700, color: accentColor),
              titleMedium: TextStyle(fontFamily: 'TTTravels',fontSize: 20, fontWeight: FontWeight.w700, color: primaryColor),
              titleSmall: TextStyle(fontFamily: 'TTTravels',fontSize: 20, fontWeight: FontWeight.w700, color: backgroundColor),
             //body
              bodyLarge:TextStyle(fontFamily: 'TTTravels',fontSize: 15, fontWeight: FontWeight.w500, color: accentColor),
              bodyMedium:TextStyle(fontFamily: 'TTTravels',fontSize: 15, fontWeight: FontWeight.w500, color: primaryColor),
              bodySmall:TextStyle(fontFamily: 'TTTravels',fontSize: 15, fontWeight: FontWeight.w500, color: backgroundColor),
          ),
          colorScheme: ColorScheme.fromSeed(seedColor: primaryColor),
          useMaterial3: true,
        ),
        routerConfig: router(initialLocation, uid)
    );
  }
}


