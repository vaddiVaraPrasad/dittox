// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:maps_launcher/maps_launcher.dart';
// import 'package:provider/provider.dart';
// import 'package:url_launcher/url_launcher.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:intl/intl.dart';
// import 'package:timeline_tile/timeline_tile.dart';

// import '../../Provider/current_user.dart';
// import '../../utils/color_pallets.dart';

// class CartItem extends StatefulWidget {
//   CartItem({super.key, required this.onGoingXeroxItem});

//   Map<String, dynamic> onGoingXeroxItem;
//   @override
//   State<CartItem> createState() => _CartItemState();
// }

// class _CartItemState extends State<CartItem> {
//   String getDate(String data) {
//     String dateTimeString = data;
//     DateFormat dateFormat = DateFormat.yMMMMd();
//     DateTime dateTime =
//         DateFormat('EEEE, MMMM d, y - h:mm:ss a').parse(dateTimeString);
//     String dateString = dateFormat.format(dateTime);
//     return dateString;
//   }

//   Widget KeyValueLong(String key, String value) {
//     return Container(
//       padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 12),
//       child: Column(
//         children: [
//           Row(
//             children: [
//               Text(
//                 maxLines: 1,
//                 key,
//                 style: const TextStyle(
//                     fontWeight: FontWeight.w400,
//                     fontSize: 12,
//                     color: ColorPallets.deepBlue),
//                 overflow: TextOverflow.ellipsis,
//               ),
//               // const SizedBox(
//               //   width: 5,
//               // ),
//               const Text(":",
//                   style: TextStyle(
//                     fontSize: 12,
//                     color: ColorPallets.deepBlue,
//                     fontWeight: FontWeight.w600,
//                   ))
//             ],
//           ),
//           // const SizedBox(
//           //   height: 5,
//           // ),
//           Text(
//             value,
//             maxLines: 1,
//             style: const TextStyle(
//                 fontWeight: FontWeight.w400,
//                 fontSize: 12,
//                 color: Colors.black54),
//             overflow: TextOverflow.ellipsis,
//           ),
//         ],
//       ),
//     );
//   }

//   Widget KeyValueOfFeature(String key, String value, double size) {
//     return Container(
//       padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 12),
//       child: Row(
//         children: [
//           Expanded(
//             child: Text(
//               maxLines: 2,
//               key,
//               style: TextStyle(
//                   fontWeight: FontWeight.w400,
//                   fontSize: size,
//                   color: ColorPallets.deepBlue),
//               overflow: TextOverflow.ellipsis,
//             ),
//           ),
//           const SizedBox(
//             width: 5,
//           ),
//           Text(
//             ":",
//             style: TextStyle(
//               fontSize: size,
//               color: ColorPallets.deepBlue,
//               fontWeight: FontWeight.w600,
//             ),
//           ),
//           const SizedBox(
//             width: 10,
//           ),
//           Expanded(
//             child: Text(
//               maxLines: 8,
//               value,
//               style: TextStyle(
//                   fontWeight: FontWeight.w400,
//                   fontSize: size,
//                   color: Colors.black54),
//               overflow: TextOverflow.ellipsis,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget expandedTitle() {
//     return Container(
//       margin: EdgeInsets.symmetric(vertical: 16),
//       child: Row(
//         children: [
//           Expanded(
//             flex: 2,
//             child: Image.asset(
//               "assets/image/xerox_sample.png",
//               fit: BoxFit.cover,
//             ),
//           ),
//           const SizedBox(
//             width: 20,
//           ),
//           Expanded(
//             flex: 4,
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.start,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   widget.onGoingXeroxItem["fileName"]
//                       .toString()
//                       .split(".")[0]
//                       .toString(),
//                   style: const TextStyle(
//                     color: ColorPallets.deepBlue,
//                     fontSize: 22,
//                     // fontWeight: FontWeight.,
//                     fontStyle: FontStyle.normal,
//                   ),
//                 ),
//                 const SizedBox(
//                   height: 3,
//                 ),
//                 Text(
//                   widget.onGoingXeroxItem["shopName"],
//                   style: TextStyle(fontSize: 18),
//                 ),
//                 const SizedBox(
//                   height: 3,
//                 ),
//                 Text(
//                   getDate(
//                     widget.onGoingXeroxItem["dateOfOrder"],
//                   ),
//                   style: TextStyle(fontSize: 13),
//                 ),
//                 const SizedBox(
//                   height: 3,
//                 ),
//                 Row(
//                   children: [
//                     const Text(
//                       "Order-Id :    ",
//                       style: TextStyle(fontSize: 13),
//                     ),
//                     Text(
//                       widget.onGoingXeroxItem["orderId"]
//                           .toString()
//                           .substring(0, 16)
//                           .toString(),
//                       style: const TextStyle(fontSize: 13),
//                     )
//                   ],
//                 ),
//                 // Chip(
//                 //   backgroundColor: ColorPallets.deepBlue,
//                 //   label: Padding(
//                 //       padding: const EdgeInsets.symmetric(
//                 //           horizontal: 7, vertical: 10),
//                 //       child: FittedBox(
//                 //         child: Text(
//                 //           // ignore: unnecessary_brace_in_string_interps
//                 //           "${widget.onGoingXeroxItem["priceOfOrder"]} Rs",
//                 //           overflow: TextOverflow.ellipsis,
//                 //           style: const TextStyle(
//                 //               fontSize: 20, color: ColorPallets.white),
//                 //         ),
//                 //       )),
//                 // ),
//               ],
//             ),
//           )
//         ],
//       ),
//     );
//   }

//   Widget progressOrderTracker(String orderStatus) {
//     return Container(
//       padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
//       child: Column(
//         children: [
//           Text(
//             orderStatus,
//             style: const TextStyle(fontSize: 22),
//           ),
//           TimelineTile(
//             axis: TimelineAxis.vertical,
//             alignment: TimelineAlign.manual,
//             lineXY: 0.15,
//             isFirst: true,
//             endChild: Container(
//               padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
//               child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: const [
//                     Text(
//                       "Xerox Order Places",
//                       style: TextStyle(
//                         fontSize: 22,
//                         color: ColorPallets.deepBlue,
//                       ),
//                     ),
//                     SizedBox(
//                       height: 5,
//                     ),
//                     Text("we have received your xerox order")
//                   ]),
//             ),
//             afterLineStyle: LineStyle(
//               color: orderStatus == "Recevided"
//                   ? ColorPallets.lightBlue
//                   : ColorPallets.deepBlue,
//               thickness: orderStatus == "Recevided" ? 2 : 5,
//             ),
//             indicatorStyle: const IndicatorStyle(
//                 color: ColorPallets.deepBlue, height: 20, width: 20),
//           ),
//           TimelineTile(
//             axis: TimelineAxis.vertical,
//             alignment: TimelineAlign.manual,
//             lineXY: 0.15,
//             endChild: Container(
//               padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
//               child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: const [
//                     Text(
//                       "Xerox is Stated Printing",
//                       style: TextStyle(
//                         fontSize: 22,
//                         color: ColorPallets.deepBlue,
//                       ),
//                     ),
//                     SizedBox(
//                       height: 5,
//                     ),
//                     Text("your xerox order is stated printing")
//                   ]),
//             ),
//             beforeLineStyle: (orderStatus == "Started" ||
//                     orderStatus == "Finished")
//                 ? const LineStyle(color: ColorPallets.deepBlue, thickness: 5)
//                 : const LineStyle(color: ColorPallets.lightBlue, thickness: 2),
//             afterLineStyle: orderStatus == "Finished"
//                 ? const LineStyle(color: ColorPallets.deepBlue, thickness: 5)
//                 : const LineStyle(color: ColorPallets.lightBlue, thickness: 2),
//             indicatorStyle: orderStatus != "Recevided"
//                 ? const IndicatorStyle(
//                     color: ColorPallets.deepBlue, height: 20, width: 20)
//                 : const IndicatorStyle(
//                     color: ColorPallets.lightBlue, height: 10, width: 10),
//           ),
//           TimelineTile(
//             axis: TimelineAxis.vertical,
//             alignment: TimelineAlign.manual,
//             lineXY: 0.15,
//             isLast: true,
//             endChild: Container(
//               padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
//               child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: const [
//                     Text(
//                       "Finished Printing",
//                       style: TextStyle(
//                         fontSize: 22,
//                         color: ColorPallets.deepBlue,
//                       ),
//                     ),
//                     SizedBox(
//                       height: 5,
//                     ),
//                     Text("you can come or colleted your xerox copy"),
//                     Text("Tap on our Navigation Icon for Google maps "),
//                   ]),
//             ),
//             beforeLineStyle: orderStatus == "Finished"
//                 ? const LineStyle(color: ColorPallets.deepBlue, thickness: 5)
//                 : const LineStyle(color: ColorPallets.lightBlue, thickness: 2),
//             indicatorStyle: orderStatus == "Finished"
//                 ? const IndicatorStyle(
//                     color: ColorPallets.deepBlue, height: 20, width: 20)
//                 : const IndicatorStyle(
//                     color: ColorPallets.lightBlue, height: 10, width: 10),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget AditionalOrderDetails(CurrentUser curUSer) {
//     return Container(
//       padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 30),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const Text(
//             "Shop Address",
//             style: TextStyle(
//               color: ColorPallets.deepBlue,
//               fontSize: 22,
//             ),
//           ),
//           const SizedBox(
//             height: 5,
//           ),
//           Text(widget.onGoingXeroxItem["shopAddress"]),
//           const SizedBox(
//             height: 10,
//           ),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceAround,
//             children: [
//               Expanded(
//                   child: Text(
//                 "${widget.onGoingXeroxItem["noOfPages"]} Pages X ${widget.onGoingXeroxItem["noOfCopies"]} Copies",
//                 style: const TextStyle(fontSize: 16),
//               )),
//               Expanded(
//                   child: Text("Rs ${widget.onGoingXeroxItem["priceOfOrder"]}",
//                       style: const TextStyle(
//                           fontSize: 24, color: ColorPallets.deepBlue))),
//             ],
//           ),
//           const SizedBox(
//             height: 10,
//           ),
//           Text(
//             "Takes ${widget.onGoingXeroxItem["durationFromCurrentLocation"]} to reach ${widget.onGoingXeroxItem["shopName"]} Shop which is ${widget.onGoingXeroxItem["shopDistanceFromCurrentLocation"]} far",
//             style: TextStyle(),
//             maxLines: 4,
//           ),
//           const SizedBox(
//             height: 10,
//           ),
//           TextButton.icon(
//               onPressed: () {
//                 // openMapsNavigation(
//                 //     curUSer.getUsetLatitude,
//                 //     curUSer.getUserLongitude,
//                 //     double.parse(widget.onGoingXeroxItem["shopLatitude"]),
//                 //     double.parse(widget.onGoingXeroxItem["shopLongitude"]));
//                 mapLauncher(
//                     widget.onGoingXeroxItem["shopAddress"],
//                     widget.onGoingXeroxItem["shopLatitude"],
//                     widget.onGoingXeroxItem["shopLongitude"]);
//                 // launchGoogleMaps(
//                 //   double.parse(widget.onGoingXeroxItem["shopLatitude"]),
//                 //   double.parse(widget.onGoingXeroxItem["shopLongitude"]),
//                 // );
//               },
//               icon: const Icon(FontAwesomeIcons.locationArrow),
//               label: const Text(
//                 "Tap here to open Google Maps",
//                 style: TextStyle(fontSize: 18, color: ColorPallets.deepBlue),
//               ))
//         ],
//       ),
//     );
//   }

//   void mapLauncher(String mapAddress, String latitude, String longitude) {
//     MapsLauncher.launchCoordinates(
//         double.parse(latitude), double.parse(longitude));
//     // MapsLauncher.launchQuery(mapAddress);
//   }

//   void openMapsNavigation(double startLatitude, double startLongitude,
//       double destinationLatitude, double destinationLongitude) async {
//     // String googleMapsUrl =
//     //     'https://www.google.com/maps/dir/?api=1&origin=$startLatitude,$startLongitude&destination=$destinationLatitude,$destinationLongitude&travelmode=driving';
//     String url =
//         'https://www.google.com/maps/dir/?api=1&destination=$destinationLatitude,$destinationLongitude&travelmode=driving';
//     if (await canLaunchUrl(Uri.parse(url))) {
//       await launchUrl(Uri.parse(url));
//     } else {
//       throw 'Could not open the map.';
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     CurrentUser curUser = Provider.of<CurrentUser>(context);
//     return Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: Container(
//           decoration: BoxDecoration(
//               border: Border.all(
//                 color: ColorPallets.deepBlue,
//                 width: 1,
//               ),
//               borderRadius: BorderRadius.circular(8)),
//           child: ExpansionTile(
//             iconColor: ColorPallets.deepBlue,
//             title: expandedTitle(),
//             backgroundColor:
//                 Color.fromARGB(255, 178, 239, 240).withOpacity(0.1),
//             // trailing: SizedBox(),
//             // trailing: Icon(Icons.arrow_drop_down),
//             // subtitle: const Text(
//             //   'view more',
//             //   style: TextStyle(
//             //     color: ColorPallets.deepBlue,
//             //     fontStyle: FontStyle.italic,
//             //   ),
//             // ),
//             children: <Widget>[
//               progressOrderTracker(widget.onGoingXeroxItem["orderStatus"]),
//               // const SizedBox(
//               //   height: 20,
//               // ),
//               AditionalOrderDetails(curUser),
//             ],
//           ),
//         ));
//   }
// }
