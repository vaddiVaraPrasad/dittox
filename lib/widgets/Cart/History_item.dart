// import 'package:flutter/material.dart';
// import 'package:flutter/src/widgets/framework.dart';
// import 'package:flutter/src/widgets/placeholder.dart';
// import 'package:intl/intl.dart';
// import 'package:provider/provider.dart';

// import '../../Provider/current_user.dart';
// import '../../utils/color_pallets.dart';

// class HistoryCard extends StatefulWidget {
//   HistoryCard({super.key, required this.historyXeroxItem});
//   Map<String, dynamic> historyXeroxItem;
//   @override
//   State<HistoryCard> createState() => _HistoryCardState();
// }

// class _HistoryCardState extends State<HistoryCard> {
//   String getDate(String data) {
//     String dateTimeString = data;
//     DateFormat dateFormat = DateFormat.yMMMMd();
//     DateTime dateTime =
//         DateFormat('EEEE, MMMM d, y - h:mm:ss a').parse(dateTimeString);
//     String dateString = dateFormat.format(dateTime);
//     return dateString;
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
//                   widget.historyXeroxItem["fileName"]
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
//                   widget.historyXeroxItem["shopName"],
//                   style: TextStyle(fontSize: 18),
//                 ),
//                 const SizedBox(
//                   height: 3,
//                 ),
//                 Text(
//                   getDate(
//                     widget.historyXeroxItem["dateOfOrder"],
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
//                       widget.historyXeroxItem["orderId"]
//                           .toString()
//                           .substring(0, 6)
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

//   Widget KeyValueOfFeature(String key, String value) {
//     return Container(
//       padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 12),
//       child: Row(
//         children: [
//           Expanded(
//             child: Text(
//               maxLines: 2,
//               key,
//               style: const TextStyle(
//                   fontWeight: FontWeight.w400,
//                   fontSize: 18,
//                   color: ColorPallets.deepBlue),
//               overflow: TextOverflow.ellipsis,
//             ),
//           ),
//           const SizedBox(
//             width: 10,
//           ),
//           const Text(
//             ":",
//             style: TextStyle(
//               fontSize: 18,
//               color: ColorPallets.deepBlue,
//               fontWeight: FontWeight.w600,
//             ),
//           ),
//           const SizedBox(
//             width: 20,
//           ),
//           Expanded(
//             child: Text(
//               maxLines: 8,
//               value,
//               style: const TextStyle(
//                   fontWeight: FontWeight.w400,
//                   fontSize: 18,
//                   color: Colors.black54),
//               overflow: TextOverflow.ellipsis,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget AditionalOrderDetails(CurrentUser curUSer) {
//     return Expanded(
//       child: Container(
//           padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
//           child: ListView(children: [
//             const Text(
//               "Document Details",
//               style: TextStyle(
//                   color: ColorPallets.deepBlue,
//                   fontSize: 22,
//                   fontStyle: FontStyle.italic),
//             ),
//             // const Divider(color: ColorPallets.deepBlue, thickness: 2),
//             KeyValueOfFeature(
//                 "Pdf File Name",
//                 widget.historyXeroxItem["fileName"]
//                     .toString()
//                     .split(".")[0]
//                     .toString()),
//             KeyValueOfFeature(
//                 "Price ", widget.historyXeroxItem["priceOfOrder"]),
//             KeyValueOfFeature(
//                 "No of Copies", widget.historyXeroxItem["noOfCopies"]),
//             KeyValueOfFeature("Total No.of Pages",
//                 "${widget.historyXeroxItem["noOfPages"]} Pages X ${widget.historyXeroxItem["noOfCopies"]} Copies  "),
//             KeyValueOfFeature(
//                 "Page Orientation ", widget.historyXeroxItem["pageOrient"]),
//             KeyValueOfFeature(
//                 "Page Types", widget.historyXeroxItem["pageSize"]),
//             KeyValueOfFeature(
//                 "Print Type", widget.historyXeroxItem["pagePrintSide"]),
//             KeyValueOfFeature(
//                 "Color ", widget.historyXeroxItem["printJobType"]),
//             widget.historyXeroxItem["printJobType"] == "Partial Color"
//                 ? KeyValueOfFeature("Color Pages",
//                     "${widget.historyXeroxItem['colorPagesCount']} ( ${widget.historyXeroxItem['colorPagesRange']} )")
//                 : const SizedBox(),
//             widget.historyXeroxItem['bindingType'] != "NoBound"
//                 ? KeyValueOfFeature(
//                     "Binding Type", widget.historyXeroxItem['bindingType'])
//                 : const SizedBox(),
//             widget.historyXeroxItem['isBondPaperNeeded'] == "true"
//                 ? KeyValueOfFeature(
//                     "Bond Pages", widget.historyXeroxItem['bondPaperRange'])
//                 : const SizedBox(),
//             widget.historyXeroxItem['isTransparentSheetNeed'] == "true"
//                 ? KeyValueOfFeature("Transparent Color",
//                     widget.historyXeroxItem['transparentSheetColor'])
//                 : const SizedBox(),
//             const SizedBox(
//               height: 30,
//             ),
//             const Text(
//               "Shop Detials",
//               style: TextStyle(
//                   color: ColorPallets.deepBlue,
//                   fontSize: 22,
//                   fontWeight: FontWeight.bold),
//             ),
//             const Divider(color: ColorPallets.deepBlue, thickness: 2),
//             KeyValueOfFeature(
//                 "Shope Name", widget.historyXeroxItem['shopName']),
//             KeyValueOfFeature(
//                 "Owner Name", widget.historyXeroxItem['shopOwnerName']),
//             KeyValueOfFeature(
//                 "Shop Email", widget.historyXeroxItem['shopEmail']),
//             KeyValueOfFeature(
//                 "Shop Addres", widget.historyXeroxItem['shopAddress']),
//             // KeyValueLong("Shop Address", curOrder.orderShopAddress),
//             const SizedBox(
//               height: 80,
//             )
//           ])),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     CurrentUser curUser = Provider.of<CurrentUser>(context);

//     return Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
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
//             children: <Widget>[
//               // progressOrderTracker(widget.historyXeroxItem["orderStatus"]),
//               const SizedBox(
//                 height: 20,
//               ),
//               const Text(
//                 "Document Details",
//                 style: TextStyle(
//                     color: ColorPallets.deepBlue,
//                     fontSize: 22,
//                     fontStyle: FontStyle.italic),
//               ),
//               const Padding(
//                 padding: EdgeInsets.symmetric(horizontal: 20),
//                 child: Divider(color: ColorPallets.deepBlue, thickness: 2),
//               ),
//               KeyValueOfFeature(
//                   "Pdf File Name",
//                   widget.historyXeroxItem["fileName"]
//                       .toString()
//                       .split(".")[0]
//                       .toString()),
//               KeyValueOfFeature(
//                   "Price ", widget.historyXeroxItem["priceOfOrder"]),
//               KeyValueOfFeature(
//                   "No of Copies", widget.historyXeroxItem["noOfCopies"]),
//               KeyValueOfFeature("Total No.of Pages",
//                   "${widget.historyXeroxItem["noOfPages"]} Pages X ${widget.historyXeroxItem["noOfCopies"]} Copies  "),
//               KeyValueOfFeature(
//                   "Page Orientation ", widget.historyXeroxItem["pageOrient"]),
//               KeyValueOfFeature(
//                   "Page Types", widget.historyXeroxItem["pageSize"]),
//               KeyValueOfFeature(
//                   "Print Type", widget.historyXeroxItem["pagePrintSide"]),
//               KeyValueOfFeature(
//                   "Color ", widget.historyXeroxItem["printJobType"]),
//               widget.historyXeroxItem["printJobType"] == "Partial Color"
//                   ? KeyValueOfFeature("Color Pages",
//                       "${widget.historyXeroxItem['colorPagesCount']} ( ${widget.historyXeroxItem['colorPagesRange']} )")
//                   : const SizedBox(),
//               widget.historyXeroxItem['bindingType'] != "NoBound"
//                   ? KeyValueOfFeature(
//                       "Binding Type", widget.historyXeroxItem['bindingType'])
//                   : const SizedBox(),
//               widget.historyXeroxItem['isBondPaperNeeded'] == "true"
//                   ? KeyValueOfFeature(
//                       "Bond Pages", widget.historyXeroxItem['bondPaperRange'])
//                   : const SizedBox(),
//               widget.historyXeroxItem['isTransparentSheetNeed'] == "true"
//                   ? KeyValueOfFeature("Transparent Color",
//                       widget.historyXeroxItem['transparentSheetColor'])
//                   : const SizedBox(),
//               const SizedBox(
//                 height: 10,
//               ),
//               const Text(
//                 "Shop Detials",
//                 style: TextStyle(
//                     color: ColorPallets.deepBlue,
//                     fontSize: 22,
//                     fontStyle: FontStyle.italic),
//               ),
//               const Padding(
//                 padding: EdgeInsets.symmetric(horizontal: 20),
//                 child: Divider(color: ColorPallets.deepBlue, thickness: 2),
//               ),
//               KeyValueOfFeature(
//                   "Shope Name", widget.historyXeroxItem['shopName']),
//               KeyValueOfFeature(
//                   "Owner Name", widget.historyXeroxItem['shopOwnerName']),
//               KeyValueOfFeature(
//                   "Shop Email", widget.historyXeroxItem['shopEmail']),
//               KeyValueOfFeature(
//                   "Shop Addres", widget.historyXeroxItem['shopAddress']),
//               // KeyValueLong("Shop Address", curOrder.orderShopAddress),
//               const SizedBox(
//                 height: 10,
//               ),
//               const Text(
//                 "Order Detials",
//                 style: TextStyle(
//                     color: ColorPallets.deepBlue,
//                     fontSize: 22,
//                     fontStyle: FontStyle.italic),
//               ),
//               const Padding(
//                 padding: EdgeInsets.symmetric(horizontal: 20),
//                 child: Divider(color: ColorPallets.deepBlue, thickness: 2),
//               ),
//               KeyValueOfFeature("OrderId", widget.historyXeroxItem['orderId']),
//               KeyValueOfFeature(
//                   "Date Of Order", widget.historyXeroxItem['dateOfOrder']),
//               KeyValueOfFeature(
//                   "Order Status", widget.historyXeroxItem['orderStatus']),
//               KeyValueOfFeature(
//                   "Mode of Order", widget.historyXeroxItem['modeOfOrder']),
//               // AditionalOrderDetails(curUser),
//               const SizedBox(
//                 height: 10,
//               ),
//             ],
//           ),
//         ));
//   }
// }
