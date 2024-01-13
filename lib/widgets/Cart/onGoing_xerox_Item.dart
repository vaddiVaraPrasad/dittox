import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:provider/provider.dart';
import 'package:timeline_tile/timeline_tile.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../providers/current_user.dart';
import '../../utils/color_pallets.dart';

class CarrOnGoingItem extends StatefulWidget {
  Map<String, dynamic> onGoingXeroxItem;
  CarrOnGoingItem({super.key, required this.onGoingXeroxItem});

  @override
  State<CarrOnGoingItem> createState() => _CarrOnGoingItemState();
}

class _CarrOnGoingItemState extends State<CarrOnGoingItem> {
  // String getDate(String data) {
  //   String dateTimeString = data;
  //   DateFormat dateFormat = DateFormat.yMMMMd();
  //   DateTime dateTime =
  //       DateFormat('EEEE, MMMM d, y - h:mm:ss a').parse(dateTimeString);
  //   String dateString = dateFormat.format(dateTime);
  //   return dateString;
  // }

  String getDate(String data) {
    String dateTimeString = data;
    DateTime dateTime = DateTime.parse(dateTimeString);
    DateFormat dateFormat = DateFormat.yMMMMd();
    String dateString = dateFormat.format(dateTime.toLocal());
    return dateString;
  }

  Widget KeyValueLong(String key, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 12),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                maxLines: 1,
                key,
                style: const TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 12,
                    color: ColorPallets.deepBlue),
                overflow: TextOverflow.ellipsis,
              ),
              // const SizedBox(
              //   width: 5,
              // ),
              const Text(":",
                  style: TextStyle(
                    fontSize: 12,
                    color: ColorPallets.deepBlue,
                    fontWeight: FontWeight.w600,
                  ))
            ],
          ),
          // const SizedBox(
          //   height: 5,
          // ),
          Text(
            value,
            maxLines: 1,
            style: const TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 12,
                color: Colors.black54),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget KeyValueOfFeature(String key, String value, double size) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 12),
      child: Row(
        children: [
          Expanded(
            child: Text(
              maxLines: 2,
              key,
              style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: size,
                  color: ColorPallets.deepBlue),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(
            width: 5,
          ),
          Text(
            ":",
            style: TextStyle(
              fontSize: size,
              color: ColorPallets.deepBlue,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          Expanded(
            child: Text(
              maxLines: 8,
              value,
              style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: size,
                  color: Colors.black54),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget expandedTitle() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 16),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Image.asset(
              "assets/image/xerox_sample.png",
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(
            width: 20,
          ),
          Expanded(
            flex: 4,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.onGoingXeroxItem["orderId"].toString(),
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: ColorPallets.deepBlue,
                    fontSize: 18,
                    // fontWeight: FontWeight.,
                    fontStyle: FontStyle.normal,
                  ),
                ),
                const SizedBox(
                  height: 3,
                ),
                Text(
                  widget.onGoingXeroxItem["storeName"],
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(
                  height: 3,
                ),
                Text(
                  getDate(
                    widget.onGoingXeroxItem["orderDate"].toString(),
                  ),
                  // "2024-01-13T05:44:10.092Z"),
                  style: TextStyle(fontSize: 13),
                ),
                const SizedBox(
                  height: 3,
                ),
                // Row(
                //   children: [
                //     const Text(
                //       "Order-Id :    ",
                //       style: TextStyle(fontSize: 13),
                //     ),
                //     Text(
                //       widget.onGoingXeroxItem["orderId"].toString(),
                //       style: const TextStyle(fontSize: 13),
                //       overflow: TextOverflow.ellipsis,
                //     )
                //   ],
                // ),
                // Chip(
                //   backgroundColor: ColorPallets.deepBlue,
                //   label: Padding(
                //       padding: const EdgeInsets.symmetric(
                //           horizontal: 7, vertical: 10),
                //       child: FittedBox(
                //         child: Text(
                //           // ignore: unnecessary_brace_in_string_interps
                //           "${widget.onGoingXeroxItem["priceOfOrder"]} Rs",
                //           overflow: TextOverflow.ellipsis,
                //           style: const TextStyle(
                //               fontSize: 20, color: ColorPallets.white),
                //         ),
                //       )),
                // ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget progressOrderTracker(String orderStatus) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
      child: Column(
        children: [
          Text(
            orderStatus,
            style: TextStyle(
                fontSize: 22,
                color: (orderStatus == "rejected" || orderStatus == "failed")
                    ? Colors.red
                    : ColorPallets.deepBlue),
          ),
          TimelineTile(
            axis: TimelineAxis.vertical,
            alignment: TimelineAlign.manual,
            lineXY: 0.15,
            isFirst: true,
            endChild: Container(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Order accepted",
                      style: TextStyle(
                        fontSize: 22,
                        color: (orderStatus == "rejected" ||
                                orderStatus == "failed")
                            ? Colors.red
                            : ColorPallets.deepBlue,
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                        "your order has been accepted by ${widget.onGoingXeroxItem["storeName"]}")
                  ]),
            ),
            afterLineStyle: LineStyle(
              color: (orderStatus == "rejected" || orderStatus == "failed")
                  ? Colors.red
                  : (orderStatus == "Pending"
                      ? ColorPallets.lightBlue
                      : ColorPallets.deepBlue),
              thickness: (orderStatus == "rejected" || orderStatus == "failed")
                  ? 2
                  : (orderStatus == "Pending" ? 2 : 5),
            ),
            indicatorStyle: (orderStatus == "rejected" ||
                    orderStatus == "failed")
                ? const IndicatorStyle(color: Colors.red, height: 10, width: 10)
                : (orderStatus == "Pending"
                    ? const IndicatorStyle(
                        color: ColorPallets.lightBlue, height: 10, width: 10)
                    : const IndicatorStyle(
                        color: ColorPallets.deepBlue, height: 20, width: 20)),
          ),
          TimelineTile(
            axis: TimelineAxis.vertical,
            alignment: TimelineAlign.manual,
            lineXY: 0.15,
            endChild: Container(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Printing",
                      style: TextStyle(
                        fontSize: 22,
                        color: (orderStatus == "rejected" ||
                                orderStatus == "failed")
                            ? Colors.red
                            : ColorPallets.deepBlue,
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                        "${widget.onGoingXeroxItem["storeName"]} has start priting your order")
                  ]),
            ),
            beforeLineStyle:
                (orderStatus == "rejected" || orderStatus == "failed")
                    ? const LineStyle(color: Colors.red, thickness: 2)
                    : ((orderStatus == "accepted" ||
                            orderStatus == "printing" ||
                            orderStatus == "ready")
                        ? const LineStyle(
                            color: ColorPallets.deepBlue, thickness: 5)
                        : const LineStyle(
                            color: ColorPallets.lightBlue, thickness: 2)),
            afterLineStyle:
                (orderStatus == "rejected" || orderStatus == "failed")
                    ? const LineStyle(color: Colors.red, thickness: 2)
                    : ((orderStatus == "printing" || orderStatus == "ready")
                        ? const LineStyle(
                            color: ColorPallets.deepBlue, thickness: 5)
                        : const LineStyle(
                            color: ColorPallets.lightBlue, thickness: 2)),
            indicatorStyle: (orderStatus == "rejected" ||
                    orderStatus == "failed")
                ? const IndicatorStyle(color: Colors.red, height: 10, width: 10)
                : ((orderStatus != "Pending" && orderStatus != "accepted")
                    ? const IndicatorStyle(
                        color: ColorPallets.deepBlue, height: 20, width: 20)
                    : const IndicatorStyle(
                        color: ColorPallets.lightBlue, height: 10, width: 10)),
          ),
          TimelineTile(
            axis: TimelineAxis.vertical,
            alignment: TimelineAlign.manual,
            lineXY: 0.15,
            isLast: true,
            endChild: Container(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Ready To Pick",
                      style: TextStyle(
                        fontSize: 22,
                        color: (orderStatus == "rejected" ||
                                orderStatus == "failed")
                            ? Colors.red
                            : ColorPallets.deepBlue,
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    const Text("you can come or colleted your copies"),
                    const Text("Tap on our Navigation Icon for Google maps "),
                  ]),
            ),
            beforeLineStyle:
                (orderStatus == "rejected" || orderStatus == "failed")
                    ? const LineStyle(color: Colors.red, thickness: 2)
                    : ((orderStatus == "printing" || orderStatus == "ready")
                        ? const LineStyle(
                            color: ColorPallets.deepBlue, thickness: 5)
                        : const LineStyle(
                            color: ColorPallets.lightBlue, thickness: 2)),
            indicatorStyle: (orderStatus == "rejected" ||
                    orderStatus == "failed")
                ? const IndicatorStyle(color: Colors.red, height: 10, width: 10)
                : (orderStatus == "ready"
                    ? const IndicatorStyle(
                        color: ColorPallets.deepBlue, height: 20, width: 20)
                    : const IndicatorStyle(
                        color: ColorPallets.lightBlue, height: 10, width: 10)),
          ),
        ],
      ),
    );
  }

  Widget AditionalOrderDetails(CurrentUser curUSer) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Shop Address",
            style: TextStyle(
              color: ColorPallets.deepBlue,
              fontSize: 22,
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          Text(widget.onGoingXeroxItem["storeAddress"]),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(
                  child: Text(
                "Total Pages - ${widget.onGoingXeroxItem["totalPages"]}",
                style: const TextStyle(fontSize: 18),
              )),
              Expanded(
                  child: Text("Rs ${widget.onGoingXeroxItem["totalCost"]}",
                      style: const TextStyle(
                          fontSize: 24, color: ColorPallets.deepBlue))),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          // Text(
          //   "Takes ${widget.onGoingXeroxItem["durationFromCurrentLocation"]} to reach ${widget.onGoingXeroxItem["shopName"]} Shop which is ${widget.onGoingXeroxItem["shopDistanceFromCurrentLocation"]} far",
          //   style: TextStyle(),
          //   maxLines: 4,
          // ),
          // const SizedBox(
          //   height: 10,
          // ),
          TextButton.icon(
              onPressed: () {
                // openMapsNavigation(
                //     curUSer.getUsetLatitude,
                //     curUSer.getUserLongitude,
                //     double.parse(widget.onGoingXeroxItem["shopLatitude"]),
                //     double.parse(widget.onGoingXeroxItem["shopLongitude"]));
                mapLauncher(
                    widget.onGoingXeroxItem["storeAddress"].toString(),
                    widget.onGoingXeroxItem["storeLocationX"].toString(),
                    widget.onGoingXeroxItem["storeLocationY"].toString());
                // launchGoogleMaps(
                //   double.parse(widget.onGoingXeroxItem["shopLatitude"]),
                //   double.parse(widget.onGoingXeroxItem["shopLongitude"]),
                // );
              },
              icon: const Icon(
                FontAwesomeIcons.locationArrow,
                color: ColorPallets.deepBlue,
              ),
              label: const Text(
                "Tap here to open Google Maps",
                style: TextStyle(fontSize: 18, color: ColorPallets.deepBlue),
              ))
        ],
      ),
    );
  }

  void mapLauncher(String mapAddress, String latitude, String longitude) {
    MapsLauncher.launchCoordinates(
        double.parse(latitude), double.parse(longitude));
    // MapsLauncher.launchQuery(mapAddress);
  }

  void openMapsNavigation(double startLatitude, double startLongitude,
      double destinationLatitude, double destinationLongitude) async {
    // String googleMapsUrl =
    //     'https://www.google.com/maps/dir/?api=1&origin=$startLatitude,$startLongitude&destination=$destinationLatitude,$destinationLongitude&travelmode=driving';
    String url =
        'https://www.google.com/maps/dir/?api=1&destination=$destinationLatitude,$destinationLongitude&travelmode=driving';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw 'Could not open the map.';
    }
  }

  Widget build(BuildContext context) {
    CurrentUser curUser = Provider.of<CurrentUser>(context);
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          decoration: BoxDecoration(
              border: Border.all(
                color: ColorPallets.deepBlue,
                width: 1,
              ),
              borderRadius: BorderRadius.circular(8)),
          child: ExpansionTile(
            iconColor: ColorPallets.deepBlue,
            title: expandedTitle(),
            backgroundColor:
                Color.fromARGB(255, 178, 239, 240).withOpacity(0.1),
            // trailing: SizedBox(),
            // trailing: Icon(Icons.arrow_drop_down),
            // subtitle: const Text(
            //   'view more',
            //   style: TextStyle(
            //     color: ColorPallets.deepBlue,
            //     fontStyle: FontStyle.italic,
            //   ),
            // ),
            children: <Widget>[
              progressOrderTracker(widget.onGoingXeroxItem["status"]),
              // const SizedBox(
              //   height: 20,
              // ),
              AditionalOrderDetails(curUser),
            ],
          ),
        ));
  }
}
