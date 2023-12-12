import "package:http/http.dart" as http;

import "dart:convert";

import "../model/auto_complete_result.dart";

class MapServices {
  final String key = "AIzaSyBMluIbE_w4OM-qRC5EsJKkwhcXZS2nbpU";
  final String types = "geocode";

  // https://maps.googleapis.com/maps/api/place/autocomplete/json
  // ?input=tade
  // &language=in
  // &types=geocode
  // &key=AIzaSyBMluIbE_w4OM-qRC5EsJKkwhcXZS2nbpU

  Future<List<AutoCompleteResult>> searchPlace(String searchInput) async {
    final String url =
        "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$searchInput&language=in&types=$types&key=$key";
    var responce = await http.get(Uri.parse(url));
    var json = JsonDecoder().convert(responce.body);
    var result = json["predictions"] as List;
    var return_res = result.map((e) => AutoCompleteResult.fromJson(e)).toList();
    // print(return_res);
    return return_res;
  }

  // https://maps.googleapis.com/maps/api/place/details/json
  // ?fields=geometry
  // &place_id=ChIJsyvJu7C0NzoRCgI1dytnJx8
  // &key=AIzaSyBMluIbE_w4OM-qRC5EsJKkwhcXZS2nbpU

  Future<Map<String, dynamic>> getPlaceDetails(String palceId) async {
    final String url =
        "https://maps.googleapis.com/maps/api/place/details/json?fields=geometry&place_id=$palceId&key=$key";

    var responce = await http.get(Uri.parse(url));
    var json = JsonDecoder().convert(responce.body);
    var return_res = json["result"] as Map<String, dynamic>;
    print(return_res);
    return return_res;
  }
}
