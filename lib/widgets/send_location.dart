import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:safety_app/components/custom_card.dart';

class SendLocation extends StatefulWidget {
  const SendLocation({super.key});

  @override
  State<SendLocation> createState() => _SendLocationState();
}

class _SendLocationState extends State<SendLocation> {
  Position? _currentPosition;
  String? _currentAddress;
  // LocationPermission? permission;

  @override
  void initState(){
    super.initState();
    _getCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    String position = _currentPosition == null
        ? ""
        : _currentPosition!.latitude.toString()
        + _currentPosition!.longitude.toString();
    String address = _currentAddress == null
        ? ""
        : _currentAddress!;
    return CustomCard(position, address);
  }

  _getCurrentLocation() async {
    //check for permission
    final hasPermission = await _handleLocationPermission();
    if (!hasPermission) return;
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) {
      setState(() {
        _currentPosition = position;
        _getAddressFromLatLon();
      });
    }).catchError((e) {
      Fluttertoast.showToast(msg: e.toString());
    });
  }

  _getAddressFromLatLon() async {
    try {
      List<Placemark> placeMarks = await placemarkFromCoordinates(
          _currentPosition!.latitude, _currentPosition!.longitude);

      Placemark place = placeMarks[0];
      setState(() {
        _currentAddress =
            "${place.locality},${place.postalCode},${place.street},";
      });
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  Future<bool> _handleLocationPermission() async {
    LocationPermission permission;
    //is location service enabled
    bool serviceEnabled;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      Fluttertoast.showToast(
          msg: 'Location services are disabled. '
              'Please enable the services');
      return false;
    }
    //does user granted permission to acquire the device’s location
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      //request permission if not
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        Fluttertoast.showToast(msg: 'Location permissions are denied');
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      Fluttertoast.showToast(
          msg: 'Location permissions are permanently denied,'
              ' we cannot request permissions.');
      return false;
    }
    return true;
  }
}
