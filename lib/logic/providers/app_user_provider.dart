import 'package:flutter/cupertino.dart';

import '../../utils/constants.dart';
import '../models/user_model.dart';
import '../services/storage_service.dart';

class AppUserProvider extends ChangeNotifier {
  /// state  of UserModel information
  AppUserModel _user = const AppUserModel();
  AppUserModel get user => _user;

  set user(AppUserModel userModel) {
    _user = userModel;
    notifyListeners();
  }

  /// state of UserModel information in storage
  final StorageService _storageService = StorageService.storage;

  String displayedOnboard = "";

  void logout(){
    _user = const AppUserModel(); // api token is empty
    _storageService.deleteSecureData(userKey);
    notifyListeners();
  }

  void deleteAll(){
    _user = const AppUserModel(); // api token is empty
    _storageService.deleteAllSecureData();
    notifyListeners();
  }

  bool get isAuthorized{
    print("user in provider isAuthorized $_user");
    return _user.id != null && _user.id!.isNotEmpty;
  }

  Future<bool> login() async {
    // check on board from local storage
    displayedOnboard = await _storageService.readSecureData(onBoardKey) ?? "";
    print("displayedOnboard in provider login $displayedOnboard");
    if(displayedOnboard.isEmpty){
      // directly return false, when onboard never displayed
      return false;
    }

    // fetch user info
    final user = await _fetchUser();
    print("user in provider login $user");
    if (user != null) {
      _user = user;
      return true; // has a login record.
    }
    return false;
  }

  Future<AppUserModel?> _fetchUser() async{
    //only apply to shared preferences
    String? userJson = await _storageService.readSecureData(userKey);
    return userJson == null ? null : AppUserModel.userFromJson(userJson);
  }
}