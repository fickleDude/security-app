import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:safety_app/utils/ui_theme_extension.dart';
import '../../utils/constants.dart';

class EmergencyWidget extends StatelessWidget{
  const EmergencyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Container(
      width: double.infinity,
      height: height/4,
      child: ListView(
        physics: const BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        children: [
          _EmergencyCard(
              number: "102",
              image: 'assets/police.png',
              title: "полиция"
          ),
          _EmergencyCard(
              number: "103",
              image: 'assets/nurse.png',
              title: "скорая помощь"
          ),
          _EmergencyCard(
              number: "101",
              image: 'assets/fireman.png',
              title: "пожарная охрана"
          ),
          _EmergencyCard(
              number: "112",
              image: 'assets/omon.png',
              title: "омон"
          ),
        ],
      ),
    );
  }

}

class _EmergencyCard extends StatelessWidget{

  String number;
  String image;
  String title;

  _EmergencyCard({
    required this.number,
    required this.image,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Container(
      margin: EdgeInsets.all(16),
      child: InkWell(
        onTap: ()=>_callNumber(),
        child: Stack(children: [
          Card(
            color: primaryColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            child: Container(
              margin: const EdgeInsets.all(8),
              height: height/6,
              width: width/1.5,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: context.subtitleAccent,),
                    SizedBox(height: height/70,),
                    Text("если вам нужна", style: context.bodyBackground),
                    Text("помощь, звоните", style: context.bodyBackground),
                    SizedBox(height: height/70,),
                    Text(number, style: context.subtitleAccent),
                  ],),
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(left: 150, top: 30),
            child: Image(
              image: AssetImage(image),
              height: height/5,
            ),
          ),
        ],
        ),
      ),
    );

  }

  _callNumber() async {
    await FlutterPhoneDirectCaller.callNumber(number);
  }
}
