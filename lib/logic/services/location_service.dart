import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:fluttertoast/fluttertoast.dart';

class LocationService{

  static final LocationService _instance = LocationService();
  static LocationService get instance => _instance;

  static bool? _permission;

  Future<bool> get permission async {
    _permission ??= await handlePermission();
    return _permission!;
  }

  //MANAGE LOCATION PERMISSIONS
  Future<bool> handlePermission() async{
    //is location service enabled
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      Fluttertoast.showToast(
          msg: 'Location services are disabled. '
              'Please enable the services');
      return false;
    }
    //does user granted permission to acquire the device’s location
    LocationPermission locationPermission = await Geolocator.checkPermission();
    if (locationPermission == LocationPermission.denied) {
      //request permission if not
      locationPermission = await Geolocator.requestPermission();
      if (locationPermission == LocationPermission.denied) {
        Fluttertoast.showToast(msg: 'Location permissions are denied');
        return false;
      }
    }
    if (locationPermission == LocationPermission.deniedForever) {
      Fluttertoast.showToast(
          msg: 'Location permissions are permanently denied,'
              ' we cannot request permissions.');
      return false;
    }
    return true;
  }

  //DEFINE PLACE
  Future<Position?> getPosition() async {
    //check for permission
    bool ifAllowed = await permission;
    if (!ifAllowed) return null;
    Position? position = await Geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    return position;
  }

  //FIND LOCATION
  Future<String?> getAddress() async {
      bool ifAllowed = await permission;
      if (!ifAllowed) return null;
      Position? position = await getPosition();
      if(position == null){
        return null;
      }
      List<Placemark> placeMarks = await placemarkFromCoordinates(
          position.latitude,
          position.longitude
      );
      Placemark place = placeMarks[0];
      return "${place.locality},${place.postalCode},${place.street}";
  }

  Future<String?> getOnMap() async{
    Position? position = await getPosition();
    String? address = await getAddress();
    if(position == null || address == null){
      return null;
    }
    return "https://www.google.com/maps/search/?api=1&query="
        "${position.latitude}%2C"
        "${position.longitude}";
  }

}