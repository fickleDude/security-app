import 'package:flutter/cupertino.dart';

enum HomeType {
  menu,
  contact,
  phoneBook,
}

class HomeProvider with ChangeNotifier {
  HomeType _type = HomeType.menu;

  HomeType get type => _type;

  set type(HomeType value) {
    _type = value;
    print("type changed");
    notifyListeners();
  }
}