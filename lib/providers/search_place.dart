import "package:flutter/material.dart";

import '../model/auto_complete_result.dart';

class PlaceResult extends ChangeNotifier {
  List<AutoCompleteResult> allreturnedResult = [];

  void setResult(allPlaces) {
    allreturnedResult = allPlaces;
    notifyListeners();
  }
}
