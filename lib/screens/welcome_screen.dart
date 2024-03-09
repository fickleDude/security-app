
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:safety_app/screens/login_screen.dart';
import 'package:safety_app/utils/constants.dart';
import 'package:safety_app/screens/register_screen.dart';

class WelcomeScreen extends StatelessWidget{

  late double screenWidth;
  late double screenHeight;

  WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {

    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: const Text("SAFETY APP", style: TextStyle(fontSize: 24),),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          _LogInButton(),
          const SizedBox(width: 8,),
          _RegisterButton()
        ],
      ),
    );
  }

}

class _LogInButton extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.large(
      heroTag: null,
      backgroundColor: primaryColor,
      shape: const CircleBorder(),
      onPressed: (){
        context.go("/welcome/login");
      },
      child: const Icon(Icons.login_rounded, color: Colors.black),);
  }
}

class _RegisterButton extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.large(
      heroTag: null,
      backgroundColor: primaryColor,
      shape: const CircleBorder(),
      onPressed: (){
        context.go("/welcome/register");
      },
      child: const Icon(Icons.person_add_alt_rounded, color: Colors.black),);
  }
}