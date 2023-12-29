import 'package:flutter/material.dart';

import '../model/shop.dart';

class NearestShop extends ChangeNotifier {
  List<Shop> allShops = [];

  void addShop(Shop newshop) {
    allShops.add(newshop);
    notifyListeners();
  }

  List<Shop> getAllShops() {
    return allShops;
  }

  void PrintShops() {
    allShops.forEach((element) {
      print("<<<<<---------- EACH SHOPS ----------->>>>>>>>");
      print(element.toMap());
    });
  }

  Shop getShopById(String id) {
    return allShops.firstWhere((element) => element.id == id);
  }

  int getShopsListSize() {
    return allShops.length;
  }

  void emptyList() {
    allShops = [];
    notifyListeners();
  }

  Shop getShopAtIndex(int index) {
    return allShops[index];
  }

  double getShopAtIndexLat(int index) {
    return allShops[index].locationX;
  }

  double getShopAtIndexLng(int index) {
    return allShops[index].locationY;
  }
}
