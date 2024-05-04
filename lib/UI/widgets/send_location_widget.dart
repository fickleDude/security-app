import 'dart:async';

import 'package:background_sms/background_sms.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:safety_app/UI/widgets/custom_button.dart';
import 'package:safety_app/logic/services/location_service.dart';
import 'package:safety_app/utils/ui_theme_extension.dart';

import '../../logic/providers/permission_provider.dart';
import '../../logic/services/emergency_contact_service.dart';
import '../../utils/constants.dart';

class SendLocation extends StatefulWidget {
  const SendLocation({super.key});

  @override
  State<SendLocation> createState() => _SendLocationState();
}

class _SendLocationState extends State<SendLocation> {
  LocationService locationService = LocationService();

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Consumer<PermissionProvider>(
        builder: (context, permissions, child) {
           return FutureBuilder(
                future: locationService.getAddress(),
                builder: (context, AsyncSnapshot<String?> snapshot){
                  return InkWell(
                    onTap: (){
                      switch (snapshot.connectionState) {
                        case ConnectionState.waiting: _showBottomSheet(context,"загрузка",false);
                        default:
                          if (snapshot.hasError){
                            _showBottomSheet(context,"ошибка",false);
                          }
                          else if (permissions.getPermissionStatus(Permission.sms) != PermissionStatus.granted){
                            _showBottomSheet(context,snapshot.data!,false);
                          }
                          else{
                            _showBottomSheet(context,snapshot.data!,true);
                          }
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image(
                            image: const AssetImage("assets/share_location.png"),
                            height: height/7,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("для вашей безопасности", style: context.subtitlePrimary),
                              Row(
                                children: [
                                  Text("поделитесь", style: context.subtitlePrimary),
                                  Text(" своей", style: context.subtitleAccent),
                                ],
                              ),
                              Text("локацией", style: context.subtitleAccent),
                            ],
                          )

                        ],),
                    ),
                  );
                }
            );
        },
    );
  }

  Future _showBottomSheet(BuildContext context, String address, bool isGranted) {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
                    height: MediaQuery.of(context).size.height / 3,
                    width: double.infinity,
                    decoration: BoxDecoration(
                          color: primaryColor,
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(30),
                            topRight: Radius.circular(30),
                          ),
                          image: const DecorationImage(
                            image: AssetImage("assets/bottom_sheet.png"),
                            fit: BoxFit.cover,
                          ),
                      ),
                    child: Padding(
                      padding: const EdgeInsets.all(32.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Center(child: Text(address, style: context.subtitleAccent)),
                          CustomButton(
                              label: "отправить",
                              onPressed: !isGranted ? null : ()=>sendSms(),
                              color: backgroundColor,
                              labelStyle: context.subtitlePrimary!
                          )
                        ],
                      ),
                    ),
                  );
        }
    );
  }

  sendSms() async{
      await locationService.getOnMap().then((link) => {
      Provider.of<EmergencyContactService>(context, listen: false)
          .getContacts()
          .forEach((element) async {
      for (var element in element) {
        try{
          await BackgroundSms.sendMessage(
              phoneNumber: element.number!,
              message: "i am in trouble ${link}",
              simSlot: 1
          );
          Fluttertoast.showToast(msg: "сообщение отправлено");
        }catch(e){
          Fluttertoast.showToast(msg: "не получается отправить сообщение");
        }
      }
      })
      });

    }
}