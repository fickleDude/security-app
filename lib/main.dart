import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:safety_app/screens/home_screens/add_contacts_screen.dart';
import 'package:safety_app/screens/home_screens/chat_screen.dart';
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
              path: 'chat',
              builder: (context, state) => const ChatScreen(),
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
    return
      ChangeNotifierProvider(
        create:(context) => AppUserProvider(),
        builder: (context, child)=>Consumer<AppUserProvider>(builder: (context, authState, _){
          return FutureBuilder(
            future: authState.login(),
            builder: (context, snapshot) =>
            snapshot.connectionState == ConnectionState.waiting
                ? appSetUp('/splash')
                : authState.isAuthorized //check if user info empty or not
                ? appSetUp('/home')
                : authState.displayedOnboard.isNotEmpty
                ? appSetUp('/welcome/login')
                : appSetUp('/welcome'),
          );
        },),
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
          ),
          primaryTextTheme: TextTheme(
            //label in text field
            labelMedium: GoogleFonts.firaCode(color: defaultColor),
            //section titles on home screen
            titleMedium: GoogleFonts.firaCode(fontSize: 20, color: primaryColor, fontWeight: FontWeight.bold),
            //app bar title
            titleLarge: GoogleFonts.firaCode(fontSize: 40, color: backgroundColor, fontWeight: FontWeight.bold),

          ),
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        routerConfig: router(initialLocation)
    );
  }
}
