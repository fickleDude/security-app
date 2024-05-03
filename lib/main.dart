import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:safety_app/logic/models/user_model.dart';
import 'package:safety_app/logic/providers/contact_list_provider.dart';
import 'package:safety_app/screens/home_screens/add_contacts_screen.dart';
import 'package:safety_app/screens/home_screens/chat/chat_screen.dart';
import 'package:safety_app/screens/home_screens/messenger_screen.dart';
import 'package:safety_app/screens/home_screens/contacts_screen.dart';
import 'package:safety_app/screens/home_screens/home_screen.dart';
import 'package:safety_app/screens/login_screen.dart';
import 'package:safety_app/screens/home_screens/profile_screen.dart';
import 'package:safety_app/screens/splash_screen.dart';
import 'package:safety_app/screens/onboard_screen.dart';
import 'package:safety_app/screens/register_screen.dart';
import 'package:safety_app/utils/constants.dart';

import 'logic/providers/app_user_provider.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp().then((value) => print(value.options.projectId));
  runApp(const MyApp());
}

GoRouter router(String initialLocation) {
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
          builder: (context, state) => const HomeScreen(),
          routes: [
            GoRoute(
              path: 'profile',
              builder: (context, state) => const ProfileScreen(),
            ),
            GoRoute(
              path: 'contacts',
              builder: (context, state) => const AddContactsScreen(),
              routes: [
                GoRoute(
                    path: 'user_contacts',
                    builder: (context, state) => const ContactsScreen()
                )
              ]
            ),
            GoRoute(
              path: 'messenger',
              builder: (context, state) => const MessengerScreen(),
              routes: [
                GoRoute(
                  path: 'chat',
                  name: 'chat',
                  builder: (context, state){
                    AppUserModel? recipient = state.extra as AppUserModel?; //casting is important
                    return ChatScreen(recipient: recipient!,);
                  },
                ),
              ]
            ),

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
        ChangeNotifierProvider(create:(context) => AppUserProvider(),),
        ChangeNotifierProvider(create:(context) => ContactsListProvider(),),
        ],
        builder: (context, child)=>Consumer<AppUserProvider>(builder: (context, authState, _) {
          return FutureBuilder(
            future: authState.login(),
            builder: (context, snapshot) =>
            snapshot.connectionState == ConnectionState.waiting
                ? appSetUp('/splash')
                : authState.isAuthorized //check if user info empty or not
                ? appSetUp('/home/messenger')
                : authState.displayedOnboard.isNotEmpty
                ? appSetUp('/welcome/login')
                : appSetUp('/welcome'),
          );
        }
      )
    );
  }

  Widget appSetUp(String initialLocation){
    return MaterialApp.router(
        title: 'SAFETY APP',
        theme: ThemeData(
          textTheme: TextTheme(
            //screen label
            titleLarge: GoogleFonts.firaCode(fontSize: 40, color: primaryColor, fontWeight: FontWeight.bold),
            //button label
            labelLarge: GoogleFonts.firaCode(fontSize: 18, color: backgroundColor),
            //under button labels
            labelMedium: GoogleFonts.firaCode(fontSize: 11, color: primaryColor, fontWeight: FontWeight.bold),
            labelSmall: GoogleFonts.firaCode(fontSize: 11, color: primaryColor),
            //for messages in chat
            bodySmall:GoogleFonts.firaCode(fontSize: 11, color: CupertinoColors.white),
            bodyMedium: GoogleFonts.firaCode(fontSize: 18, color: backgroundColor,fontWeight: FontWeight.bold),
          ),
          primaryTextTheme: TextTheme(
            //label in text field
            labelMedium: GoogleFonts.firaCode(color: defaultColor),
            //section titles on home screen
            titleMedium: GoogleFonts.firaCode(fontSize: 20, color: backgroundColor,
              fontWeight: FontWeight.bold,
              letterSpacing: 2),
            //app bar title
            titleLarge: GoogleFonts.firaCode(fontSize: 40, color: backgroundColor, fontWeight: FontWeight.bold,
                letterSpacing: 2),
            labelSmall: GoogleFonts.firaCode(fontSize: 20, color: primaryColor, fontWeight: FontWeight.bold,
                letterSpacing: 2),

          ),
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        routerConfig: router(initialLocation)
    );
  }
}


