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

import '../../model/pdfFile.dart';
import '../../model/shop.dart';
import '../../providers/ListOfPdfFiles.dart';
import '../../providers/ListOfShops.dart';
import '../../providers/current_user.dart';
import '../../providers/seletedShop.dart';
import '../../utils/dynamicSizing.dart';
import '../additional/summaryScreen.dart';

class SelectShops extends StatefulWidget {
  static const routeName = "/selectShops";
  late String accessToken;
  SelectShops({super.key, required this.accessToken});

  @override
  State<SelectShops> createState() => _SelectShopsState();
}

class _SelectShopsState extends State<SelectShops> {
  bool isNoService = false;

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

  String getModifiedSize(String crt) {
    if (crt == "A4") {
      return "sizeA4";
    } else if (crt == "A5") {
      return "sizeA5";
    } else if (crt == "Legal") {
      return "legal";
    } else if (crt == "Letter") {
      return "letter";
    } else if (crt == "B5") {
      return "sizeB5";
    } else if (crt == "A6") {
      return "sizeA6";
    } else if (crt == "Post Card") {
      return "postCard";
    } else if (crt == "5*7") {
      return "size5*7";
    } else if (crt == "4*6") {
      return "size4*6";
    } else {
      return "size35*6";
    }
  }

  String getModifiedBinding(String crt) {
    if (crt == "No binding") {
      return "No binding";
    } else if (crt == "Spiral") {
      return "spiralBinding";
    } else if (crt == "Staples") {
      return "staplesBinding";
    } else {
      return "stickFile";
    }
  }

  double calculateSingleFileCost(PdfData singlePdfFile, Shop shopDetails) {
    double singlePdfcost = 0.0;
    Map<String, dynamic> pdfDetails = singlePdfFile.toMap;
    Map<String, dynamic> storeDetails = shopDetails.toMap;
    print(pdfDetails["binding"]);
    // calculate cost for one side
    double sideCost = 0;
    if (pdfDetails["pdfSides"] == "Single side") {
      sideCost = double.parse(storeDetails["costOneSide"]);
    } else {
      sideCost = double.parse(storeDetails["costTwoSide"]);
    }

    // Calculate cost for color/bw/colorPar
    double totalBlackPages = 0;
    double totalColorPages = 0;
    double blackCost = 0;
    double colorCost = 0;

    if (pdfDetails["color"] == "Black & White") {
      totalBlackPages = double.parse(pdfDetails["totalPages"].toString());
      blackCost = double.parse(storeDetails["costBlack"]);
    } else if (pdfDetails["color"] == "All Color") {
      totalColorPages = double.parse(pdfDetails["totalPages"].toString());
      colorCost = double.parse(storeDetails["costColor"]);
    } else {
      totalColorPages = countDigits(pdfDetails["colorParPageNumbers"]);
      totalBlackPages = double.parse(pdfDetails["totalPages"].toString());
      -totalColorPages;
      blackCost = double.parse(storeDetails["costBlack"]);
      colorCost = double.parse(storeDetails["costColor"]);
    }

    // Calculate paper size cost
    double paperSizeCost = 0;
    String paperSize = getModifiedSize(pdfDetails["paperSize"]);
    if (storeDetails["paperSize"] != null) {
      paperSizeCost = double.parse(storeDetails[paperSize.toString()]);
    }

    // calculate bondpaper
    double bondPrice =
        pdfDetails["bondpages"] ? double.parse(storeDetails["bondPage"]) : 0;

    // Calculate binding cost
    double bindingCost = 0;
    String binding = getModifiedBinding(pdfDetails["binding"]);
    if (binding != "No binding") {
      bindingCost = double.parse(storeDetails[binding.toString()]);
    }

    // No binding
    // Spiral
    // Stick File
    // Staples

    // Calculate total color and black pages cost
    double totalColorPagesCost = totalColorPages * colorCost;
    double totalBlackPagesCost = totalBlackPages * blackCost;
    double totalPages = totalColorPages + totalBlackPages;
    double totalPapersSizeCost = paperSizeCost * totalPages;
    double totalSidesCost = sideCost * totalPages;
    double totalBondCost = bondPrice * totalPages;
    singlePdfcost = ((totalColorPagesCost +
                totalBlackPagesCost +
                totalPapersSizeCost +
                totalSidesCost +
                totalBondCost) *
            int.parse(pdfDetails["copies"].toString())) +
        bindingCost;

    print("totalBlackPages ${totalBlackPagesCost}");
    print("totalColorPagesCost ${totalColorPagesCost}");
    print("totalPages ${totalPages}");
    print(
        "totalPapersSizeCost = paperSizeCost * totalPages  ${totalPapersSizeCost}");
    print("totalSidesCost = sideCost * totalPages   ${totalSidesCost}");
    print("totalBondCost = bondPrice * totalPages ${totalBondCost}");
    print("copies ${pdfDetails["copies"]}");
    print("binding Cost  ${bindingCost}");
    print("totalcost ${singlePdfcost}");
    return singlePdfcost;
  }

  double countDigits(String input) {
    List<String> digitStrings = input.split(',');
    double count = 0;

    for (String digitString in digitStrings) {
      try {
        int digit = int.parse(digitString.trim());
        count += digit.toString().length;
      } catch (e) {
        // Handle parsing error if needed
      }
    }

    return count;
  }

  double calcualteTotalCost(List<PdfData> pdfFileList, Shop storeDetails) {
    double totalCost = 0.0;
    for (int i = 0; i < pdfFileList.length; i++) {
      double singlePdfCost =
          calculateSingleFileCost(pdfFileList[i], storeDetails);
      totalCost += singlePdfCost;
    }
    return totalCost;
  }

  Future<void> fetchShopsData(CurrentUser curUser, NearestShop shopsList,
      String accessToken, ListOfPDFFiles listofpdffile) async {
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
      if (fixedShopsData.isEmpty) {
        setState(() {
          isNoService = true;
        });
      }
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
        print(tempShop.toMap);
        tempShop.cost = calcualteTotalCost(listofpdffile.allPdfList, tempShop);
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
        ListOfPDFFiles listofPdfFile = Provider.of<ListOfPDFFiles>(context);
        // shopsList.emptyList();
        fetchShopsData(curUser, shopsList, widget.accessToken, listofPdfFile);
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
    double totalScreenHeight = MediaQuery.of(context).size.height;
    double totalScreenWidth = MediaQuery.of(context).size.width;
    NearestShop shopsList = Provider.of<NearestShop>(context);
    seletedShop seletedShopProvider = Provider.of<seletedShop>(context);
    CurrentUser curUSer = Provider.of<CurrentUser>(context);

    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: isNoService
          ? Center(
              child: Text("No Service"),
            )
          : SafeArea(
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
                    // bottom: 20,
                    bottom: calculateDynamicFontSize(
                      totalScreenHeight: totalScreenHeight,
                      totalScreenWidth: totalScreenWidth,
                      currentFontSize: 40,
                      // heightSpecific: true,
                    ),
                    child: Container(
                      // padding: EdgeInsets.symmetric(vertical: 5, horizontal: ),
                      // height: 230.0,
                      height: calculateDynamicFontSize(
                        totalScreenHeight: totalScreenHeight,
                        totalScreenWidth: totalScreenWidth,
                        currentFontSize: 480,
                        // heightSpecific: true,
                      ),
                      margin: EdgeInsets.symmetric(
                        vertical: calculateDynamicFontSize(
                          totalScreenHeight: totalScreenHeight,
                          totalScreenWidth: totalScreenWidth,
                          currentFontSize: 30,
                          // heightSpecific: true,
                        ),
                        horizontal: calculateDynamicFontSize(
                          totalScreenHeight: totalScreenHeight,
                          totalScreenWidth: totalScreenWidth,
                          currentFontSize: 30,
                          // heightSpecific: true,
                        ),
                      ),
                      width: screenWidth,
                      child: CarouselSlider.builder(
                        carouselController: carouselCtrl,
                        options: CarouselOptions(
                          // height: 210,
                          height: calculateDynamicFontSize(
                            totalScreenHeight: totalScreenHeight,
                            totalScreenWidth: totalScreenWidth,
                            currentFontSize: 460,
                            // heightSpecific: true,
                          ),
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
                          return ShopContainer(
                            shopsList.getShopAtIndex(index),
                            context,
                            seletedShopProvider,
                            totalScreenHeight,
                            totalScreenWidth,
                          );
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
      Shop shop,
      BuildContext ctx,
      seletedShop seletedShopProvider,
      double totalScreenHeight,
      double totalScreenWidth) {
    return Container(
        // padding: EdgeInsets.symmetric(
        //   vertical: 0,
        //   horizontal: 4,
        // ),
        padding: EdgeInsets.symmetric(
          vertical: calculateDynamicFontSize(
            totalScreenHeight: totalScreenHeight,
            totalScreenWidth: totalScreenWidth,
            currentFontSize: 0,
            // heightSpecific: true,
          ),
          horizontal: calculateDynamicFontSize(
            totalScreenHeight: totalScreenHeight,
            totalScreenWidth: totalScreenWidth,
            currentFontSize: 8,
            // heightSpecific: false,
          ),
        ),
        // height: 220,
        height: calculateDynamicFontSize(
          totalScreenHeight: totalScreenHeight,
          totalScreenWidth: totalScreenWidth,
          currentFontSize: 440,
          // heightSpecific: true,
        ),
        width: double.infinity,
        margin: EdgeInsets.symmetric(
            // horizontal: 18,
            horizontal: calculateDynamicFontSize(
          totalScreenHeight: totalScreenHeight,
          totalScreenWidth: totalScreenWidth,
          currentFontSize: 36,
          // heightSpecific: false,
        )),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(
              // 18,
              calculateDynamicFontSize(
            totalScreenHeight: totalScreenHeight,
            totalScreenWidth: totalScreenWidth,
            currentFontSize: 36,
            // heightSpecific: true,
          ))),
          color: ColorPallets.deepBlue.withOpacity(.8),
        ),
        child: Row(
          children: [
            Expanded(
              flex: 3,
              child: Column(
                children: [
                  SizedBox(
                    // height: 10,
                    height: calculateDynamicFontSize(
                      totalScreenHeight: totalScreenHeight,
                      totalScreenWidth: totalScreenWidth,
                      currentFontSize: 20,
                      // heightSpecific: true,
                    ),
                  ),
                  Text(
                    shop.name,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.white,
                        // fontSize: 26,
                        fontSize: calculateDynamicFontSize(
                          totalScreenHeight: totalScreenHeight,
                          totalScreenWidth: totalScreenWidth,
                          currentFontSize: 52,
                          // heightSpecific: true,
                        )),
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(
                    // height: 5,
                    height: calculateDynamicFontSize(
                      totalScreenHeight: totalScreenHeight,
                      totalScreenWidth: totalScreenWidth,
                      currentFontSize: 10,
                      // heightSpecific: true,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        // width: 20,
                        width: calculateDynamicFontSize(
                          totalScreenHeight: totalScreenHeight,
                          totalScreenWidth: totalScreenWidth,
                          currentFontSize: 40,
                          // heightSpecific: false,
                        ),
                      ),
                      Expanded(
                          child: Text(
                        shop.distance,
                        style: TextStyle(
                            color: Colors.white,
                            // fontSize: 18,
                            fontSize: calculateDynamicFontSize(
                              totalScreenHeight: totalScreenHeight,
                              totalScreenWidth: totalScreenWidth,
                              currentFontSize: 36,
                              // heightSpecific: true,
                            )),
                      )),
                      SizedBox(
                        // width: 10,
                        width: calculateDynamicFontSize(
                          totalScreenHeight: totalScreenHeight,
                          totalScreenWidth: totalScreenWidth,
                          currentFontSize: 20,
                          // heightSpecific: false,
                        ),
                      ),
                      Expanded(
                          child: Text(shop.duration,
                              style: TextStyle(
                                  color: Colors.white,
                                  // fontSize: 18,
                                  fontSize: calculateDynamicFontSize(
                                    totalScreenHeight: totalScreenHeight,
                                    totalScreenWidth: totalScreenWidth,
                                    currentFontSize: 36,
                                    // heightSpecific: true,
                                  )))),
                    ],
                  ),
                  SizedBox(
                    // height: 5,
                    height: calculateDynamicFontSize(
                      totalScreenHeight: totalScreenHeight,
                      totalScreenWidth: totalScreenWidth,
                      currentFontSize: 10,
                      // heightSpecific: true,
                    ),
                  ),
                  RatingBarIndicator(
                    rating: shop.avgRating.toDouble(),
                    itemBuilder: (context, index) => const Icon(
                      Icons.star,
                      color: Colors.amber,
                    ),
                    itemCount: 5,
                    // itemSize: 20.0,
                    itemSize: calculateDynamicFontSize(
                      totalScreenHeight: totalScreenHeight,
                      totalScreenWidth: totalScreenWidth,
                      currentFontSize: 40.0,
                      // heightSpecific: true,
                    ),
                    direction: Axis
                        .horizontal, // Change this line to make it horizontal
                  ),
                  const SizedBox(
                    height: 0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        "Opens --",
                        style: TextStyle(
                            // fontSize: 20,
                            fontSize: calculateDynamicFontSize(
                              totalScreenHeight: totalScreenHeight,
                              totalScreenWidth: totalScreenWidth,
                              currentFontSize: 40,
                              // heightSpecific: true,
                            ),
                            color: Colors.green,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "${shop.openingTime} AM",
                        style: TextStyle(
                          // fontSize: 18,
                          fontSize: calculateDynamicFontSize(
                            totalScreenHeight: totalScreenHeight,
                            totalScreenWidth: totalScreenWidth,
                            currentFontSize: 36,
                            // heightSpecific: true,
                          ),
                          color: ColorPallets.white,
                        ),
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        "Closes --",
                        style: TextStyle(
                            // fontSize: 20,
                            fontSize: calculateDynamicFontSize(
                              totalScreenHeight: totalScreenHeight,
                              totalScreenWidth: totalScreenWidth,
                              currentFontSize: 40,
                              // heightSpecific: true,
                            ),
                            color: Colors.red,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "${shop.closingTime} PM",
                        style: TextStyle(
                          // fontSize: 18,
                          fontSize: calculateDynamicFontSize(
                            totalScreenHeight: totalScreenHeight,
                            totalScreenWidth: totalScreenWidth,
                            currentFontSize: 36,
                            // heightSpecific: true,
                          ),
                          color: ColorPallets.white,
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    // height: 10,
                    height: calculateDynamicFontSize(
                      totalScreenHeight: totalScreenHeight,
                      totalScreenWidth: totalScreenWidth,
                      currentFontSize: 20,
                      // heightSpecific: true,
                    ),
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
                      // padding: const EdgeInsets.symmetric(
                      //   horizontal: 15,
                      //   vertical: 10,
                      // ),
                      padding: EdgeInsets.symmetric(
                          vertical: calculateDynamicFontSize(
                            totalScreenHeight: totalScreenHeight,
                            totalScreenWidth: totalScreenWidth,
                            currentFontSize: 20,
                            // heightSpecific: true,
                          ),
                          horizontal: calculateDynamicFontSize(
                            totalScreenHeight: totalScreenHeight,
                            totalScreenWidth: totalScreenWidth,
                            currentFontSize: 30,
                            // heightSpecific: false,
                          )),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(
                          // 18,
                          calculateDynamicFontSize(
                            totalScreenHeight: totalScreenHeight,
                            totalScreenWidth: totalScreenWidth,
                            currentFontSize: 36,
                            // heightSpecific: true,
                          ),
                        )),
                      ),
                      // height: 40,
                      height: calculateDynamicFontSize(
                        totalScreenHeight: totalScreenHeight,
                        totalScreenWidth: totalScreenWidth,
                        currentFontSize: 80,
                        // heightSpecific: true,
                      ),
                      child: Text(
                        "Proceed",
                        style: TextStyle(
                          color: ColorPallets.deepBlue,
                          // fontSize: 20,
                          fontSize: calculateDynamicFontSize(
                            totalScreenHeight: totalScreenHeight,
                            totalScreenWidth: totalScreenWidth,
                            currentFontSize: 40,
                            // heightSpecific: true,
                          ),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              // width: 5,
              width: calculateDynamicFontSize(
                totalScreenHeight: totalScreenHeight,
                totalScreenWidth: totalScreenWidth,
                currentFontSize: 10,
                // heightSpecific: false,
              ),
            ),
            Expanded(
                flex: 2,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    SizedBox(
                      // height: 20,
                      height: calculateDynamicFontSize(
                        totalScreenHeight: totalScreenHeight,
                        totalScreenWidth: totalScreenWidth,
                        currentFontSize: 40,
                        // heightSpecific: true,
                      ),
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
                        style: TextStyle(
                            // fontWeight: FontWeight.bold,
                            color: ColorPallets.white,
                            // fontSize: 23,
                            fontSize: calculateDynamicFontSize(
                              totalScreenHeight: totalScreenHeight,
                              totalScreenWidth: totalScreenWidth,
                              currentFontSize: 46,
                              // heightSpecific: true,
                            ),
                            overflow: TextOverflow.ellipsis),
                      ),
                    ),
                    Expanded(
                        flex: 4,
                        child: Container(
                          margin: EdgeInsets.only(
                            // right: 12,
                            // top: 15,
                            // bottom: 15,
                            right: calculateDynamicFontSize(
                              totalScreenHeight: totalScreenHeight,
                              totalScreenWidth: totalScreenWidth,
                              currentFontSize: 24,
                              // heightSpecific: false,
                            ),
                            top: calculateDynamicFontSize(
                              totalScreenHeight: totalScreenHeight,
                              totalScreenWidth: totalScreenWidth,
                              currentFontSize: 30,
                              // heightSpecific: true,
                            ),
                            bottom: calculateDynamicFontSize(
                              totalScreenHeight: totalScreenHeight,
                              totalScreenWidth: totalScreenWidth,
                              currentFontSize: 30,
                              // heightSpecific: true,
                            ),
                          ),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(
                                // 16,
                                calculateDynamicFontSize(
                                  totalScreenHeight: totalScreenHeight,
                                  totalScreenWidth: totalScreenWidth,
                                  currentFontSize: 32,
                                  // heightSpecific: true,
                                ),
                              )),
                              image: const DecorationImage(
                                  image: AssetImage(
                                      "assets/image/defaultStore.jpg"))),
                        )),
                    SizedBox(
                      // height: 50,
                      height: calculateDynamicFontSize(
                        totalScreenHeight: totalScreenHeight,
                        totalScreenWidth: totalScreenWidth,
                        currentFontSize: 80,
                        // heightSpecific: true,
                      ),
                    ),
                  ],
                ))
          ],
        ));
  }
}
