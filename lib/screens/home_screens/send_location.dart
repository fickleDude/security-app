import 'package:background_sms/background_sms.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:safety_app/components/custom_button.dart';
import 'package:safety_app/logic/models/contact_model.dart';
import 'package:safety_app/logic/providers/contact_list_provider.dart';
import 'package:safety_app/logic/services/location_service.dart';
import 'package:safety_app/utils/ui_theme_extension.dart';

import '../../utils/constants.dart';

class SendLocation extends StatefulWidget {
  const SendLocation({super.key});

  @override
  State<SendLocation> createState() => _SendLocationState();
}

class _SendLocationState extends State<SendLocation> {
  // Position? _currentPosition;
  String? _currentAddress;
  // LocationPermission? permission;
  final _locationService = LocationService.instance;

  @override
  void initState(){
    super.initState();
    //permission to sent sms
    _getPermissions();
    _getCurrentAddress();
  }

  _getCurrentAddress() async {
    var position = await _locationService.getPosition();
    if(position != null){
      setState(() async {
        _currentAddress = await _locationService.getAddress();
      });

    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _showBottomSheet(context),
      child: Card(
        margin: const EdgeInsets.all(25.0),
        elevation: 5.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: SizedBox(
          height: 180,
          width: MediaQuery.of(context).size.width * 0.7,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Expanded(
                child: ListTile(
                  title: Text("Send location"),
                  subtitle: Text("Share location"),
                ),
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.asset('assets/route.jpg'),
              )
            ],
          ),
        ),
      ),
    );
  }

  //DEFINE PLACE
  // _getCurrentLocation() async {
  //   //check for permission
  //   final hasPermission = await _handleLocationPermission();
  //   if (!hasPermission) return;
  //   await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
  //       .then((Position position) {
  //     setState(() {
  //       _currentPosition = position;
  //       _getAddressFromLatLon();
  //     });
  //   }).catchError((e) {
  //     Fluttertoast.showToast(msg: e.toString());
  //   });
  // }
  //
  // //FIND LOCATION
  // _getAddressFromLatLon() async {
  //   try {
  //     List<Placemark> placeMarks = await placemarkFromCoordinates(
  //         _currentPosition!.latitude, _currentPosition!.longitude);
  //
  //     Placemark place = placeMarks[0];
  //     setState(() {
  //       _currentAddress =
  //           "${place.locality},${place.postalCode},${place.street},";
  //     });
  //   } catch (e) {
  //     Fluttertoast.showToast(msg: e.toString());
  //   }
  // }

  // //MANAGE LOCATION PERMISSIONS
  // Future<bool> _handleLocationPermission() async {
  //   // LocationPermission permission;
  //   //is location service enabled
  //   bool serviceEnabled;
  //   serviceEnabled = await Geolocator.isLocationServiceEnabled();
  //   if (!serviceEnabled) {
  //     Fluttertoast.showToast(
  //         msg: 'Location services are disabled. '
  //             'Please enable the services');
  //     return false;
  //   }
  //   //does user granted permission to acquire the device’s location
  //   permission = await Geolocator.checkPermission();
  //   if (permission == LocationPermission.denied) {
  //     //request permission if not
  //     permission = await Geolocator.requestPermission();
  //     if (permission == LocationPermission.denied) {
  //       Fluttertoast.showToast(msg: 'Location permissions are denied');
  //       return false;
  //     }
  //   }
  //   if (permission == LocationPermission.deniedForever) {
  //     Fluttertoast.showToast(
  //         msg: 'Location permissions are permanently denied,'
  //             ' we cannot request permissions.');
  //     return false;
  //   }
  //   return true;
  // }

  Future _showBottomSheet(BuildContext context) {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
              height: MediaQuery.of(context).size.height / 1.4,
              decoration: BoxDecoration(
                color: backgroundColor,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  )
              ),
              child: Padding(
                padding: const EdgeInsets.all(14.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('SENT YOUR CURRENT LOCATION', style: context.prT2),
                    const SizedBox(height: 10,),
                    if(_currentAddress != null) Center(child: Text(_currentAddress!, style: context.prT2)),
                    CustomButton(
                        title: "GET LOCATION",
                        onPressed: () async{
                      await _getCurrentAddress();
                    }
                    ),
                    const SizedBox(height: 10,),
                    CustomButton(
                        title: "SHARE LOCATION",
                        onPressed: () async{
                          List<UserContact> contactList = Provider
                                            .of<ContactsListProvider>(context, listen:false)
                                            .contactsList;
                          if (contactList.isEmpty) {
                            Fluttertoast.showToast(
                                msg: "emergency contact is empty");
                          }else{
                            String? messageBody = await _locationService.getOnMap();
                            if(messageBody == null){
                              Fluttertoast.showToast(
                                  msg: "enable define location");
                            }else{
                              if (await _isPermissionGranted()) {
                                for (var element in contactList) {
                                  _sendSms(element.number,
                                      "i am in trouble $messageBody");
                                }
                              } else {
                                Fluttertoast.showToast(msg: "something wrong");
                              }
                            }
                          }
                        }
                    ),
                  ],
                ),
              ));
        });
  }

  //HANDLE SMS
  _isPermissionGranted() async => await Permission.sms.status.isGranted;
  _getPermissions() async => await [Permission.sms].request();
  _sendSms(String phoneNumber, String message) async {
    SmsStatus result = await BackgroundSms.sendMessage(
        phoneNumber: phoneNumber, message: message, simSlot: 1);
    if (result == SmsStatus.sent) {
      Fluttertoast.showToast(msg: "send");
    } else {
      Fluttertoast.showToast(msg: "failed");
    }
  }


}
