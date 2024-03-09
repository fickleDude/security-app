import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:safety_app/utils/ui_theme_extension.dart';

import '../utils/constants.dart';

class EmergencyWidget extends StatelessWidget{
  const EmergencyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
            child: Text('EMERGENCY',style: context.prT2)
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width,
          height: 180,
          child: ListView(
            physics: const BouncingScrollPhysics(),
            scrollDirection: Axis.horizontal,
            children: [
              //police
              _EmergencyCard(
                  number: "002",
                  assetImage: 'assets/icons/alert.png',
                  title: "Police",
                  subtitle: "Call 0-0-2 for emergencies."),
              //ambulance
              _EmergencyCard(
                  number: "003",
                  assetImage: 'assets/ambulance.png',
                  title: "Ambulance",
                  subtitle: "Call 0-0-3 for ambulance."),
              //fire
              _EmergencyCard(
                  number: "001",
                  assetImage: 'assets/flame.png',
                  title: "Fire-brigade",
                  subtitle: "Call 0-0-1 for flames."),
              //terrorism
              _EmergencyCard(
                  number: "112",
                  assetImage: 'assets/army.png',
                  title: "Army Emergency",
                  subtitle: "Call 1-1-2 for national terrorism authority."),
            ],
          ),
        )
      ],
    );
  }

}

class _EmergencyCard extends StatelessWidget{

  String number;
  String assetImage;
  String title;
  String subtitle;

  _EmergencyCard({
    required this.number,
    required this.assetImage,
    required this.title,
    required this.subtitle
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10.0, bottom: 5),
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: InkWell(
          onTap: ()=>_callNumber(),
          child: Container(
            height: 180,
            width: MediaQuery.of(context).size.width * 0.7,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  gradientColorDark,
                  primaryColor,
                  gradientColorBright,
                ],
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                      backgroundColor: Colors.white.withOpacity(0.5),
                      radius: 25,
                      child: Center(
                          child: Image(
                            image: AssetImage(assetImage),
                            height: 35,
                          )
                      )
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: TextStyle(
                              color: backgroundColor,
                              fontWeight: FontWeight.bold,
                              fontSize: MediaQuery.of(context).size.width * 0.06),
                        ),
                        Text(
                          subtitle,
                          style: TextStyle(
                              color: backgroundColor,
                              fontSize: MediaQuery.of(context).size.width * 0.035
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        Container(
                          height: 30,
                          width: 80,
                          decoration: BoxDecoration(
                              color: backgroundColor,
                              borderRadius: BorderRadius.circular(300)),
                          child: Center(
                            child: Text(
                              number.split('').join('-'),
                              style: TextStyle(
                                  color: gradientColorBright,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  _callNumber() async {
    await FlutterPhoneDirectCaller.callNumber(number);
  }
}
