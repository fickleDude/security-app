import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:safety_app/screens/home_screen.dart';
import 'package:safety_app/screens/login_screen.dart';
import 'package:safety_app/screens/profile_screen.dart';
import 'package:safety_app/screens/welcome_screen.dart';
import 'package:safety_app/screens/register_screen.dart';
import 'package:safety_app/utils/constants.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp().then((value) => print(value.options.projectId));
  runApp(const MyApp());
}

GoRouter router() {
  return GoRouter(
    initialLocation: '/home',
    routes: [
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
              // routes: [
              //   //path with object parameter
              //   GoRoute(
              //       path: 'note',
              //       name: 'note',
              //       builder: (context, state){
              //         NoteModel? note = state.extra as NoteModel?; // 👈 casting is important
              //         return NoteForm(note: note);
              //       }
              //   ),
              // ],
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
        routerConfig: router()
      );
  }
}
