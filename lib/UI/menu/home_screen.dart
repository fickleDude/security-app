import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:safety_app/logic/providers/user_provider.dart';
import 'package:safety_app/utils/constants.dart';
import 'package:safety_app/utils/ui_theme_extension.dart';
import 'package:safety_app/UI/widgets/life_safe.dart';
import 'package:safety_app/UI/widgets/side_navigation.dart';
import '../widgets/custom_app_bar_widget.dart';
import '../widgets/emergency_card_widget.dart';
import '../widgets/send_location_widget.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  late double width;
  late double height;

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Scaffold(
            appBar: CustomAppBar(
              color: fillColor,
              title: "call galya",
              titleStyle: context.titlePrimary!,
              actions: [IconButton(
                icon: Icon(Icons.arrow_forward,size: 40,color: primaryColor,weight: 80,),
                onPressed: () async{
                  await Provider.of<UserProvider>(context, listen: false).signOut();
                },
              )],
            ),
            drawer: SideNavigation(),
            body: Stack(
              children: [
                Container(
                    decoration: BoxDecoration(
                      color: fillColor,
                      image: const DecorationImage(
                        image: AssetImage("assets/home.png"),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: ListView(
                      scrollDirection: Axis.vertical,
                      children: const [
                        LifeSafeWidget(),
                        EmergencyWidget(),
                        SendLocation(),
                      ],
                    ))
              ],)
        );
  }
}
