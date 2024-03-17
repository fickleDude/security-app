import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:safety_app/utils/constants.dart';
import 'package:safety_app/utils/ui_theme_extension.dart';
import 'package:safety_app/widgets/emergency.dart';
import 'package:safety_app/widgets/explore.dart';
import 'package:safety_app/widgets/life_safe.dart';
import 'package:safety_app/widgets/send_location.dart';
import 'package:safety_app/widgets/side_navigation.dart';

import '../../logic/providers/app_user_provider.dart';
import '../../logic/services/auth_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}


class _HomeScreenState extends State<HomeScreen> {

  late double screenWidth;
  late double screenHeight;

  final _authService = AuthService.auth;

  @override
  Widget build(BuildContext context) {

    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      floatingActionButton: FloatingActionButton.large(
        heroTag: null,
        backgroundColor: primaryColor,
        shape: const CircleBorder(),
        onPressed: () async{
          await _authService.logout().whenComplete(() async {
            // set userinfo to null, will rebuild the consumer in main.dart
            context.read<AppUserProvider>().logout();
          });
        },
        child: const Icon(Icons.logout, color: Colors.black),),
      appBar: AppBar(
        centerTitle: true,
        title: Text('CALL GALIA',style: context.prT1,),
        backgroundColor: primaryColor,
      ),
      drawer: const SideNavigation(),
      body: SafeArea(
        child: Column(
            children: [
              Expanded(
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    SizedBox(height: screenHeight*0.03,),
                    const ExploreWidget(),
                    SizedBox(height: screenHeight*0.01,),
                    const EmergencyWidget(),
                    SizedBox(height: screenHeight*0.01,),
                    const LifeSafeWidget(),
                    const SendLocation()
                  ],
                ),
              )
            ],
          ),
        ),
      );
  }
}
