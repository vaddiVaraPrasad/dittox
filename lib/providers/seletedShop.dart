import 'package:flutter/material.dart';

import '../model/shop.dart';

class seletedShop extends ChangeNotifier {
  late Shop userSeletedShop;

  void setSeletedShop(Shop shop) {
    userSeletedShop = shop;
    notifyListeners();
  }

  Shop getSeletedShop() {
    return userSeletedShop;
  }
}
