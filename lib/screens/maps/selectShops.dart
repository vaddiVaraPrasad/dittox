import 'dart:async';
import 'dart:convert';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:http/http.dart' as http;

import 'package:carousel_slider/carousel_controller.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:dittox/utils/color_pallets.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import '../../model/shop.dart';
import '../../providers/ListOfShops.dart';
import '../../providers/current_user.dart';
import '../../providers/seletedShop.dart';
import '../additional/summaryScreen.dart';

class SelectShops extends StatefulWidget {
  static const routeName = "/selectShops";
  late String accessToken;
  SelectShops({super.key, required this.accessToken});

  @override
  State<SelectShops> createState() => _SelectShopsState();
}

class _SelectShopsState extends State<SelectShops> {
  Completer<GoogleMapController> _controller = Completer();
  static const CameraPosition _initialCameraPosition = CameraPosition(
    target: LatLng(20.5937, 78.9629),
    zoom: 5,
  );
  final carouselCtrl = CarouselController();
  final lat_lng_index = {};

  Set<Marker> _markers = {};

  bool _isloading = false;

  bool isInitState = true;

  Future<void> goToSearchedPlace(double lat, double lag, double zoms) async {
    setState(() {
      _isloading = true;
    });
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(lat, lag),
          zoom: zoms,
          bearing: 80.0,
          tilt: 90,
        ),
      ),
    );
    setState(() {
      _isloading = false;
    });
  }

  void setMarkers(lat, lag) {
    setState(() {
      _isloading = true;
    });
    // _markers = {};
    final Marker marker = Marker(
      markerId: MarkerId("marker $lat $lag"),
      position: LatLng(lat, lag),
      onTap: () async {
        await goToSearchedPlace(lat, lag, 19);
        carouselCtrl.animateToPage(lat_lng_index["$lat $lag"]);
        // add the functin to turn the calostral list !!!
      },
      icon: BitmapDescriptor.defaultMarker,
      draggable: true,
      onDragEnd: (value) {
        print("on drag end values is ${value}");
      },
    );
    setState(() {
      _markers.add(marker);
    });
    setState(() {
      _isloading = false;
    });
  }

  Future<Map<String, String>> getTravelTimeAndDistance(
      String origin, double latitude, double longitude, String apiKey) async {
    var url =
        'https://maps.googleapis.com/maps/api/directions/json?origin=$origin&destination=$latitude,$longitude&key=$apiKey';
    var response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      if (data['status'] == 'OK') {
        Map<String, String> temp = {};
        temp["duration"] = data['routes'][0]['legs'][0]['duration']['text'];
        temp["distance"] = data['routes'][0]['legs'][0]['distance']['text'];
        temp["shopAddresByPlacesId"] =
            data['routes'][0]['legs'][0]['end_address'];
        return temp;
      }
    }
    return {};
  }

  void goToProviderLocation(CurrentUser curUser, double zoms) async {
    setState(() {
      _isloading = true;
    });
    await goToSearchedPlace(
        curUser.getUsetLatitude, curUser.getUserLongitude, zoms);
    setState(() {
      _isloading = false;
    });
  }

  Future<void> fetchShopsData(
      CurrentUser curUser, NearestShop shopsList, String accessToken) async {
    // shopsList.emptyList();
    final String apiUrl = 'https://dittox.in/xerox/v1/store/list';
    int count_index = 0;

    final Map<String, String> headers = {
      "X-auth-token": "bearer ${widget.accessToken}",
    };

    final response = await http.get(Uri.parse(apiUrl), headers: headers);
    final Map<String, dynamic> responseData = json.decode(response.body);

    if (responseData["responseCode"] == "OK") {
      print('Response: $responseData');
      List<dynamic> shopsData = responseData['result']['data'];
      List<Map<String, dynamic>> fixedShopsData =
          List<Map<String, dynamic>>.from(shopsData);

      for (Map<String, dynamic> shopData in fixedShopsData) {
        print(shopData);
        double locationX = shopData['location']['x'];
        double locationY = shopData['location']['y'];
        Map<String, String> DisDuration = await getTravelTimeAndDistance(
            "${curUser.getUsetLatitude},${curUser.getUserLongitude}",
            locationX,
            locationY,
            "AIzaSyBMluIbE_w4OM-qRC5EsJKkwhcXZS2nbpU");
        print(DisDuration);
        String duration = DisDuration["duration"] as String;
        String distance = DisDuration["distance"] as String;
        String address = DisDuration["shopAddresByPlacesId"] as String;

        Shop tempShop = Shop.fromJson(shopData, 0, distance, address, duration);

        shopsList.addShop(tempShop);

        setMarkers(locationX, locationY);
        lat_lng_index["$locationX $locationY"] = count_index;
        setState(() {
          count_index = count_index + 1;
        });
      }
    } else {
      // Response code is not OK
      throw Exception('Error: ${responseData["message"]}');
    }
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    if (isInitState) {
      setState(() {
        _isloading = true;
      });
      //// write all code here
      try {
        CurrentUser curUser = Provider.of<CurrentUser>(context);
        NearestShop shopsList = Provider.of<NearestShop>(context);

        fetchShopsData(curUser, shopsList, widget.accessToken);
      } catch (error) {
        print("$error");
      } finally {
        setState(() {
          _isloading = false;
        });
      }
    }
    setState(() {
      isInitState = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    NearestShop shopsList = Provider.of<NearestShop>(context);
    seletedShop seletedShopProvider = Provider.of<seletedShop>(context);
    CurrentUser curUSer = Provider.of<CurrentUser>(context);

    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              height: screenHeight,
              width: screenWidth,
              child: GoogleMap(
                initialCameraPosition: _initialCameraPosition,
                mapType: MapType.normal,
                onMapCreated: (GoogleMapController controller) {
                  _controller.complete(controller);
                  goToProviderLocation(curUSer, 16);
                },
                rotateGesturesEnabled: true,
                scrollGesturesEnabled: true,
                zoomControlsEnabled: false,
                zoomGesturesEnabled: true,
                compassEnabled: false,
                markers: _markers,
              ),
            ),
            Positioned(
              bottom: 20,
              child: Container(
                // padding: EdgeInsets.symmetric(vertical: 5, horizontal: ),
                height: 230.0,
                width: screenWidth,
                child: CarouselSlider.builder(
                  carouselController: carouselCtrl,
                  options: CarouselOptions(
                    height: 210,
                    autoPlay: false,
                    reverse: false,
                    enableInfiniteScroll: false,
                    enlargeCenterPage: false,
                    initialPage: 0,
                    enlargeStrategy: CenterPageEnlargeStrategy.height,
                    onPageChanged: (index, reason) async {
                      await goToSearchedPlace(
                          shopsList.getShopAtIndexLat(index),
                          shopsList.getShopAtIndexLng(index),
                          19);
                    },
                  ),
                  itemCount: shopsList.getShopsListSize(),
                  itemBuilder: (context, index, realIndex) {
                    return ShopContainer(shopsList.getShopAtIndex(index),
                        context, seletedShopProvider);
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget ShopContainer(
      Shop shop, BuildContext ctx, seletedShop seletedShopProvider) {
    return Container(
        padding: EdgeInsets.symmetric(vertical: 0, horizontal: 4),
        height: 220,
        width: double.infinity,
        margin: const EdgeInsets.symmetric(horizontal: 18),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(18)),
          color: ColorPallets.deepBlue.withOpacity(.8),
        ),
        child: Row(
          children: [
            Expanded(
              flex: 3,
              child: Column(
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    shop.name,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.white, fontSize: 26),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const SizedBox(
                        width: 20,
                      ),
                      Expanded(
                          child: Text(
                        shop.distance,
                        style:
                            const TextStyle(color: Colors.white, fontSize: 18),
                      )),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                          child: Text(shop.duration,
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 18))),
                    ],
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  RatingBarIndicator(
                    rating: shop.avgRating.toDouble(),
                    itemBuilder: (context, index) => const Icon(
                      Icons.star,
                      color: Colors.amber,
                    ),
                    itemCount: 5,
                    itemSize: 20.0,
                    direction: Axis
                        .horizontal, // Change this line to make it horizontal
                  ),
                  const SizedBox(
                    height: 0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      const Text(
                        "Opens --",
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.green,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "${shop.openingTime} AM",
                        style: const TextStyle(
                            fontSize: 18, color: ColorPallets.white),
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      const Text(
                        "Closes --",
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.red,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "${shop.closingTime} PM",
                        style:
                            TextStyle(fontSize: 18, color: ColorPallets.white),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  InkWell(
                    onTap: () {
                      seletedShopProvider.setSeletedShop(shop);
                      // curOrder.setShopDetails(
                      //   shop.shopID,
                      //   shop.shopName,
                      //   shop.shopOwnerName,
                      //   shop.email,
                      //   shop.distanceFromCurrentLocation,
                      //   shop.durationFromCurrentLocation,
                      //   shop.shopAddressByGooglePlaces,
                      //   shop.shopPicUrl,
                      //   shop.shopLatitude.toString(),
                      //   shop.shopLongitude.toString(),
                      // );
                      Navigator.of(context).pushNamed(SummaryScreen.routeName);
                    },
                    child: Container(
                      // margin:const  EdgeInsets.symmetric(vertical: 10,horizontal: 10),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 10),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(18)),
                      ),
                      height: 40,
                      child: const Text(
                        "Proceed",
                        style: TextStyle(
                          color: ColorPallets.deepBlue,
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              width: 5,
            ),
            Expanded(
                flex: 2,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    Expanded(
                      flex: 2,
                      // child: FittedBox(
                      //   fit: BoxFit
                      //       .cover, // or any other BoxFit option based on your preference
                      //   child: Text(
                      //     "Rs: ${shop.cost}",
                      //     style: const TextStyle(
                      //       fontWeight: FontWeight.bold,
                      //       color: ColorPallets.white,
                      //       fontSize: 1,
                      //     ),
                      //   ),
                      // ),
                      child: Text(
                        "Rs: ${shop.cost}",
                        style: const TextStyle(
                            // fontWeight: FontWeight.bold,
                            color: ColorPallets.white,
                            fontSize: 30,
                            overflow: TextOverflow.ellipsis),
                      ),
                    ),
                    Expanded(
                        flex: 4,
                        child: Container(
                          margin: const EdgeInsets.only(
                              right: 12, top: 15, bottom: 15),
                          decoration: const BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(16)),
                              image: DecorationImage(
                                  image: AssetImage(
                                      "assets/image/defaultStore.jpg"))),
                        )),
                    const SizedBox(
                      height: 50,
                    ),
                  ],
                ))
          ],
        ));
  }
}
