import "dart:async";

import "package:dittox/screens/maps/textLocation.dart";
import "package:flutter/material.dart";
import "package:font_awesome_flutter/font_awesome_flutter.dart";
import "package:geolocator/geolocator.dart";
import "package:google_maps_flutter/google_maps_flutter.dart";
import "package:provider/provider.dart";

import '../../helpers/user_location.dart';
import "../../providers/current_user.dart";
import "../../utils/color_pallets.dart";
import "../../utils/dynamicSizing.dart";
import '../../widgets/IconButton.dart';

class setLocationMaps extends StatefulWidget {
  const setLocationMaps({super.key});
  static const routeName = "/setLocationMaps";
  @override
  State<setLocationMaps> createState() => _setLocationMapsState();
}

class _setLocationMapsState extends State<setLocationMaps> {
  Completer<GoogleMapController> _controller = Completer();

  BitmapDescriptor? mapMaker;

  bool isLoading = false;

  @override
  void initState() {
    setCustomMarker();
    super.initState();
  }

  void setCustomMarker() async {
    mapMaker = await BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(), "assets/image/pin_gif.gif");
  }

  static const CameraPosition _initialCameraPosition = CameraPosition(
    target: LatLng(20.5937, 78.9629),
    zoom: 5,
  );

  Set<Marker> _markers = {};

  Future<void> goToSearchedPlace(double lat, double lag, double zoms) async {
    setState(() {
      isLoading = true;
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
      isLoading = false;
    });
  }

  void setMarkers(lat, lag) {
    setState(() {
      isLoading = true;
    });
    _markers = {};
    final Marker marker = Marker(
      markerId: MarkerId("marker $lat $lag"),
      position: LatLng(lat, lag),
      onTap: () async {
        await goToSearchedPlace(lat, lag, 16.5);
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
      isLoading = false;
    });
  }

  void goToProviderLocation(CurrentUser curUser, double zoms) async {
    setState(() {
      isLoading = true;
    });
    await goToSearchedPlace(
        curUser.getUsetLatitude, curUser.getUserLongitude, zoms);
    setMarkers(curUser.getUsetLatitude, curUser.getUserLongitude);
    setState(() {
      isLoading = false;
    });
  }

  void updateOnTapLocation(
      CurrentUser curUser, LatLng location, double zooms) async {
    setState(() {
      isLoading = true;
    });
    Map<String, dynamic> userPlaceMark = await UserLocation.getUserPlaceMarks(
        location.latitude, location.longitude);
    await goToSearchedPlace(location.latitude, location.longitude, zooms);
    setMarkers(location.latitude, location.longitude);
    curUser.setUserLatitudeLogitude(location.latitude, location.longitude);
    curUser.setUserPlaceName(userPlaceMark["locality"]);
    curUser.setUserContryName(userPlaceMark["country"]);
    setState(() {
      isLoading = false;
    });
  }

  void goToCurrentLocation(CurrentUser curUser, double zoms) async {
    setState(() {
      isLoading = true;
    });
    print("got to current location is called");
    Position userCurrentPosition = await UserLocation.getUserLatLong();
    Map<String, dynamic> userPlaceMark = await UserLocation.getUserPlaceMarks(
        userCurrentPosition.latitude, userCurrentPosition.longitude);
    await goToSearchedPlace(
        userCurrentPosition.latitude, userCurrentPosition.longitude, zoms);
    setMarkers(userCurrentPosition.latitude, userCurrentPosition.longitude);
    curUser.setUserLatitudeLogitude(
        userCurrentPosition.latitude, userCurrentPosition.longitude);
    curUser.setUserPlaceName(userPlaceMark["locality"]);
    curUser.setUserContryName(userPlaceMark["country"]);
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    CurrentUser curUser = Provider.of<CurrentUser>(context);

    return Scaffold(
      body: Column(
        children: [
          Stack(
            children: [
              SizedBox(
                height: screenHeight,
                width: screenWidth,
                child: GoogleMap(
                  initialCameraPosition: _initialCameraPosition,
                  mapType: MapType.normal,
                  onMapCreated: (GoogleMapController controller) {
                    _controller.complete(controller);
                    goToProviderLocation(curUser, 16);
                  },
                  // onCameraIdle: () {},
                  // onCameraMove: (position) {},
                  rotateGesturesEnabled: true,
                  scrollGesturesEnabled: true,
                  zoomControlsEnabled: false,
                  zoomGesturesEnabled: true,
                  onTap: (val) {
                    updateOnTapLocation(curUser, val, 18);
                  },

                  markers: _markers,
                ),
              ),
              // Positioned(
              //   top: screenHeight - 250,
              //   left: screenWidth / 4,
              //   child: GestureDetector(
              //     onTap: () {
              //       goToCurrentLocation(curUser, 18);
              //     },
              //     child: Container(
              //       padding: const EdgeInsets.only(top: 8, left: 15, bottom: 8),
              //       decoration: BoxDecoration(
              //           color: ColorPallets.deepBlue.withOpacity(0.9),
              //           borderRadius: BorderRadius.circular(25),
              //           boxShadow: [
              //             BoxShadow(
              //               color: ColorPallets.deepBlue.withOpacity(1),
              //               blurRadius: 5,
              //             )
              //           ]),
              //       height: 50,
              //       width: 190,
              //       child: Row(
              //         children: [
              //           Image.asset(
              //             "assets/image/current_loaction.png",
              //             fit: BoxFit.cover,
              //             color: Colors.white,
              //             height: 35,
              //             width: 35,
              //           ),
              //           const SizedBox(
              //             width: 13,
              //           ),
              //           const Text(
              //             "Current Location",
              //             style: TextStyle(color: Colors.white, fontSize: 17),
              //           )
              //         ],
              //       ),
              //     ),
              //   ),
              // ),
              // Positioned(
              //   top: screenHeight - 250,
              //   left: screenWidth / 4,
              //   child: GestureDetector(
              //     onTap: () {
              //       goToCurrentLocation(curUser, 18);
              //     },
              //     child: FittedBox(
              //       child: Container(
              //         padding:
              //             const EdgeInsets.only(top: 8, left: 15, bottom: 8),
              //         decoration: BoxDecoration(
              //           color: ColorPallets.deepBlue.withOpacity(0.9),
              //           borderRadius: BorderRadius.circular(25),
              //           boxShadow: [
              //             BoxShadow(
              //               color: ColorPallets.deepBlue.withOpacity(1),
              //               blurRadius: 5,
              //             )
              //           ],
              //         ),
              //         height: 50,
              //         width: 190,
              //         child: Row(
              //           children: [
              //             Image.asset(
              //               "assets/image/current_loaction.png",
              //               fit: BoxFit.cover,
              //               color: Colors.white,
              //               height: 35,
              //               width: 35,
              //             ),
              //             const SizedBox(
              //               width: 13,
              //             ),
              //             // const Expanded(
              //             //   child: Text(
              //             //     "Current Location",
              //             //     style:
              //             //         TextStyle(color: Colors.white, fontSize: 17),
              //             //   ),
              //             // )
              //             FittedBox(
              //               fit: BoxFit
              //                   .scaleDown, // Adjust the fit mode as needed
              //               child: Text(
              //                 "Current Location",
              //                 style:
              //                     TextStyle(color: Colors.white, fontSize: 17),
              //               ),
              //             )
              //           ],
              //         ),
              //       ),
              //     ),
              //   ),
              // ),
              Positioned(
                // top: screenHeight - 250,
                top: screenHeight -
                    calculateDynamicFontSize(
                      totalScreenHeight: screenHeight,
                      totalScreenWidth: screenWidth,
                      currentFontSize: 500,
                      // heightSpecific: true,
                    ),
                // left: screenWidth / 4,
                left: screenWidth /
                    calculateDynamicFontSize(
                      totalScreenHeight: screenHeight,
                      totalScreenWidth: screenWidth,
                      currentFontSize: 8,
                      // heightSpecific: false,
                    ),
                child: GestureDetector(
                  onTap: () {
                    goToCurrentLocation(curUser, 18);
                  },
                  child: FittedBox(
                    child: Container(
                      padding: EdgeInsets.only(
                        // top: 8,
                        // left: 15,
                        // bottom: 8,
                        left: calculateDynamicFontSize(
                          totalScreenHeight: screenHeight,
                          totalScreenWidth: screenWidth,
                          currentFontSize: 30,
                          // heightSpecific: false,
                        ),
                        top: calculateDynamicFontSize(
                          totalScreenHeight: screenHeight,
                          totalScreenWidth: screenWidth,
                          currentFontSize: 16,
                          // heightSpecific: true,
                        ),
                        bottom: calculateDynamicFontSize(
                          totalScreenHeight: screenHeight,
                          totalScreenWidth: screenWidth,
                          currentFontSize: 16,
                          // heightSpecific: true,
                        ),
                      ),
                      decoration: BoxDecoration(
                        color: ColorPallets.deepBlue.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(
                          // 25,
                          calculateDynamicFontSize(
                            totalScreenHeight: screenHeight,
                            totalScreenWidth: screenWidth,
                            currentFontSize: 50,
                            // heightSpecific: true,
                          ),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: ColorPallets.deepBlue.withOpacity(1),
                            // blurRadius: 5,
                            blurRadius: calculateDynamicFontSize(
                              totalScreenHeight: screenHeight,
                              totalScreenWidth: screenWidth,
                              currentFontSize: 10,
                              // heightSpecific: true,
                            ),
                          )
                        ],
                      ),
                      // height: 50,
                      height: calculateDynamicFontSize(
                        totalScreenHeight: screenHeight,
                        totalScreenWidth: screenWidth,
                        currentFontSize: 110,
                        // heightSpecific: true,
                      ),
                      // width: 190,
                      width: calculateDynamicFontSize(
                        totalScreenHeight: screenHeight,
                        totalScreenWidth: screenWidth,
                        currentFontSize: 350,
                        // heightSpecific: false,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment
                            .spaceBetween, // Adjust the alignment as needed
                        children: [
                          Image.asset(
                            "assets/image/current_loaction.png",
                            fit: BoxFit.cover,
                            color: Colors.white,
                            // height: 35,
                            // width: 35,
                            height: calculateDynamicFontSize(
                              totalScreenHeight: screenHeight,
                              totalScreenWidth: screenWidth,
                              currentFontSize: 60,
                              // heightSpecific: true,
                            ),
                            width: calculateDynamicFontSize(
                              totalScreenHeight: screenHeight,
                              totalScreenWidth: screenWidth,
                              currentFontSize: 60,
                              // heightSpecific: false,
                            ),
                          ),
                          SizedBox(
                            // width: 13,
                            width: calculateDynamicFontSize(
                              totalScreenHeight: screenHeight,
                              totalScreenWidth: screenWidth,
                              currentFontSize: 20,
                              // heightSpecific: false,
                            ),
                          ),
                          Expanded(
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                "Current Location",
                                style: TextStyle(
                                  color: Colors.white,
                                  // fontSize: 17,
                                  fontSize: calculateDynamicFontSize(
                                    totalScreenHeight: screenHeight,
                                    totalScreenWidth: screenWidth,
                                    currentFontSize: 33,
                                    // heightSpecific: true,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            // width: 15,
                            width: calculateDynamicFontSize(
                              totalScreenHeight: screenHeight,
                              totalScreenWidth: screenWidth,
                              currentFontSize: 35,
                              // heightSpecific: false,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              Positioned(
                // top: screenHeight - 180,
                top: screenHeight -
                    calculateDynamicFontSize(
                      totalScreenHeight: screenHeight,
                      totalScreenWidth: screenWidth,
                      currentFontSize: 330,
                      // heightSpecific: true,
                    ),
                left: 0,
                child: Container(
                  decoration: BoxDecoration(
                      color: ColorPallets.deepBlue.withOpacity(0.9),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(
                            // 22,
                            calculateDynamicFontSize(
                          totalScreenHeight: screenHeight,
                          totalScreenWidth: screenWidth,
                          currentFontSize: 40,
                          // heightSpecific: true,
                        )),
                        topRight: Radius.circular(
                            // 22,
                            calculateDynamicFontSize(
                          totalScreenHeight: screenHeight,
                          totalScreenWidth: screenWidth,
                          currentFontSize: 40,
                          // heightSpecific: true,
                        )),
                      ),
                      boxShadow: [
                        BoxShadow(
                            color: ColorPallets.deepBlue.withOpacity(1),
                            // blurRadius: 20,
                            blurRadius: calculateDynamicFontSize(
                              totalScreenHeight: screenHeight,
                              totalScreenWidth: screenWidth,
                              currentFontSize: 30,
                              // heightSpecific: true,
                            ))
                      ]),
                  // height: 180,
                  height: calculateDynamicFontSize(
                    totalScreenHeight: screenHeight,
                    totalScreenWidth: screenWidth,
                    currentFontSize: 330,
                    // heightSpecific: true,
                  ),
                  width: screenWidth,
                  child: isLoading
                      ? const Center(
                          child: CircularProgressIndicator(color: Colors.white),
                        )
                      : Column(
                          children: [
                            Expanded(
                              flex: 4,
                              child: Container(
                                // width: screenWidth - 20,
                                width: screenWidth -
                                    calculateDynamicFontSize(
                                      totalScreenHeight: screenHeight,
                                      totalScreenWidth: screenWidth,
                                      currentFontSize: 50,
                                      // heightSpecific: false,
                                    ),
                                // padding: const EdgeInsets.symmetric(
                                //     vertical: 20, horizontal: 30),
                                padding: EdgeInsets.symmetric(
                                    vertical: calculateDynamicFontSize(
                                      totalScreenHeight: screenHeight,
                                      totalScreenWidth: screenWidth,
                                      currentFontSize: 35,
                                      // heightSpecific: true,
                                    ),
                                    horizontal: calculateDynamicFontSize(
                                      totalScreenHeight: screenHeight,
                                      totalScreenWidth: screenWidth,
                                      currentFontSize: 50,
                                      // heightSpecific: false,
                                    )),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          flex:
                                              2, // Takes 2/3 of the available space
                                          child: FittedBox(
                                            fit: BoxFit.scaleDown,
                                            child: Text(
                                              curUser.getPlaceName,
                                              style: TextStyle(
                                                overflow: TextOverflow.ellipsis,
                                                color: Colors.white,
                                                // fontSize: 27,
                                                fontSize:
                                                    calculateDynamicFontSize(
                                                  totalScreenHeight:
                                                      screenHeight,
                                                  totalScreenWidth: screenWidth,
                                                  currentFontSize: 45,
                                                  // heightSpecific: true,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          // width: 10,
                                          width: calculateDynamicFontSize(
                                            totalScreenHeight: screenHeight,
                                            totalScreenWidth: screenWidth,
                                            currentFontSize: 25,
                                            // heightSpecific: false,
                                          ),
                                        ),
                                        Expanded(
                                          flex:
                                              1, // Takes 1/3 of the available space
                                          child: GestureDetector(
                                            onTap: () {
                                              Navigator.of(context).pushNamed(
                                                  LocationText.routeName);
                                            },
                                            child: Container(
                                              // height: 40,
                                              height: calculateDynamicFontSize(
                                                totalScreenHeight: screenHeight,
                                                totalScreenWidth: screenWidth,
                                                currentFontSize: 80,
                                                // heightSpecific: true,
                                              ),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                  // 22
                                                  calculateDynamicFontSize(
                                                    totalScreenHeight:
                                                        screenHeight,
                                                    totalScreenWidth:
                                                        screenWidth,
                                                    currentFontSize: 35,
                                                    // heightSpecific: true,
                                                  ),
                                                ),
                                                border: Border.all(
                                                  color: Colors.white,
                                                  // width: 2,
                                                  width:
                                                      calculateDynamicFontSize(
                                                    totalScreenHeight:
                                                        screenHeight,
                                                    totalScreenWidth:
                                                        screenWidth,
                                                    currentFontSize: 3,
                                                    // heightSpecific: false,
                                                  ),
                                                  style: BorderStyle.solid,
                                                ),
                                              ),
                                              child: Center(
                                                child: Text(
                                                  "Change",
                                                  style: TextStyle(
                                                    overflow: TextOverflow.clip,
                                                    color: Colors.white,
                                                    // fontSize: 18,
                                                    fontSize:
                                                        calculateDynamicFontSize(
                                                      totalScreenHeight:
                                                          screenHeight,
                                                      totalScreenWidth:
                                                          screenWidth,
                                                      currentFontSize: 35,
                                                      // heightSpecific: true,
                                                    ),
                                                  ),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Expanded(
                                        child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Container(
                                            padding: EdgeInsets.symmetric(
                                              // vertical: 8,
                                              vertical:
                                                  calculateDynamicFontSize(
                                                totalScreenHeight: screenHeight,
                                                totalScreenWidth: screenWidth,
                                                currentFontSize: 8,
                                                // heightSpecific: true,
                                              ),
                                            ),
                                            child: FittedBox(
                                              fit: BoxFit.scaleDown,
                                              child: Text(
                                                "${curUser.getPlaceName}, ${curUser.getUserContryName}",
                                                style: TextStyle(
                                                  overflow: TextOverflow.fade,
                                                  color: Colors.white,
                                                  // fontSize: 16,
                                                  fontSize:
                                                      calculateDynamicFontSize(
                                                    totalScreenHeight:
                                                        screenHeight,
                                                    totalScreenWidth:
                                                        screenWidth,
                                                    currentFontSize: 30,
                                                    // heightSpecific: true,
                                                  ),
                                                ),
                                              ),
                                            )),
                                      ],
                                    ))
                                  ],
                                ),
                              ),
                            ),
                            Expanded(
                                flex: 2,
                                child: GestureDetector(
                                  onTap: () {
                                    // print(curUser.getPlaceName);
                                    // print(curUser.getUserContryName);
                                    Navigator.of(context).pop();
                                  },
                                  child: Container(
                                    color: ColorPallets.lightBlue,
                                    child: Center(
                                      child: Text(
                                        "Confirm",
                                        style: TextStyle(
                                          color: Colors.white,
                                          // fontSize: 25,
                                          fontSize: calculateDynamicFontSize(
                                            totalScreenHeight: screenHeight,
                                            totalScreenWidth: screenWidth,
                                            currentFontSize: 50,
                                            // heightSpecific: true,
                                          ),
                                          letterSpacing:
                                              calculateDynamicFontSize(
                                            totalScreenHeight: screenHeight,
                                            totalScreenWidth: screenWidth,
                                            currentFontSize: 2,
                                            // heightSpecific: false,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ))
                          ],
                        ),
                ),
              ),
              Positioned(
                  // left: 30,
                  left: calculateDynamicFontSize(
                    totalScreenHeight: screenHeight,
                    totalScreenWidth: screenWidth,
                    currentFontSize: 50,
                    // heightSpecific: false,
                  ),
                  // top: 50,
                  top: calculateDynamicFontSize(
                    totalScreenHeight: screenHeight,
                    totalScreenWidth: screenWidth,
                    currentFontSize: 80,
                    // heightSpecific: true,
                  ),
                  child: CustomIconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: FontAwesomeIcons.chevronLeft,
                    iconColor: ColorPallets.white,
                    backGroundColor: ColorPallets.deepBlue,
                    // size: 40,
                    size: calculateDynamicFontSize(
                      totalScreenHeight: screenHeight,
                      totalScreenWidth: screenWidth,
                      currentFontSize: 80,
                      // heightSpecific: true,
                    ).toInt(),
                    // iconSize: 16,
                    iconSize: calculateDynamicFontSize(
                      totalScreenHeight: screenHeight,
                      totalScreenWidth: screenWidth,
                      currentFontSize: 40,
                      // heightSpecific: true,
                    ).toInt(),
                  ))
            ],
          )
        ],
      ),
    );
  }
}
