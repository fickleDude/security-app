import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import '../providers/permission_provider.dart';

class LocationService{

  static final LocationService _instance = LocationService();
  static LocationService get instance => _instance;
  late PermissionStatus status;

  //DEFINE PLACE
  Future<Position?> getPosition() async {
    Position? position = await Geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    return position;
  }

  //FIND LOCATION
  Future<String?> getAddress() async {
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
    return "https://www.google.com/maps/search/?api=1&query="
        "${position?.latitude}%2C"
        "${position?.longitude}";
  }

}