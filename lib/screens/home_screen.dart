import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:safety_app/components/custom_slider.dart';
import 'package:safety_app/utils/constants.dart';
import 'package:safety_app/utils/ui_theme_extension.dart';
import 'package:safety_app/widgets/emergency.dart';
import 'package:safety_app/widgets/explore.dart';
import 'package:safety_app/widgets/life_safe.dart';

import '../utils/quotes.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}


class _HomeScreenState extends State<HomeScreen> {

  late double screenWidth;
  late double screenHeight;

  @override
  Widget build(BuildContext context) {

    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      floatingActionButton: FloatingActionButton.large(
        heroTag: null,
        backgroundColor: primaryColor,
        shape: const CircleBorder(),
        onPressed: (){
          context.go("/welcome/login");
        },
        child: const Icon(Icons.logout, color: Colors.black),),
      appBar: AppBar(
        centerTitle: true,
        title: Text('CALL GALIA',style: context.prT1,),
        backgroundColor: primaryColor,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                  color: primaryColor,
                  image: const DecorationImage(
                      fit: BoxFit.fill,
                      image: AssetImage('assets/route.jpg'))),
              child: const Text('CALL GALIA', style: TextStyle(color: Colors.transparent),),
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('PROFILE'),
              onTap: () => context.go('/home/profile'),
            ),
            const ListTile(
              leading: Icon(Icons.settings),
              title: Text('SETTINGS'),
              onTap: null,
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
            children: [
              Expanded(
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    SizedBox(height: screenHeight*0.03,),
                    const ExploreWidget(),
                    SizedBox(height: screenHeight*0.03,),
                    const EmergencyWidget(),
                    SizedBox(height: screenHeight*0.03,),
                    const LifeSafeWidget(),
                  ],
                ),
              )
            ],
          ),
        ),
      );
  }
}
