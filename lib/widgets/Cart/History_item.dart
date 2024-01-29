import 'package:dittox/widgets/Cart/review.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../providers/current_user.dart';
import '../../utils/color_pallets.dart';

class HistoryCard extends StatefulWidget {
  Map<String, dynamic> historyXeroxItem;
  String accesstoken;
  HistoryCard({
    super.key,
    required this.historyXeroxItem,
    required this.accesstoken,
  });

  @override
  State<HistoryCard> createState() => _HistoryCardState();
}

class _HistoryCardState extends State<HistoryCard> {
  void fetchData(String downloadUrl) async {
    final response = await http.get(Uri.parse(downloadUrl)
        // Uri.parse('http://xerox-bucket.s3.ap-south-1.amazonaws.com/users/654b38f06fbd53e8ae895492-1705153162465-form%2011.pdf?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=AKIA2S5BGTLKY4PRAOMX%2F20240113%2Fap-south-1%2Fs3%2Faws4_request&X-Amz-Date=20240113T133923Z&X-Amz-Expires=604800&X-Amz-Signature=c98ad7cef56ca3975d387bc01714fe8288b97e2f2a715cec2ecc44915d2ad588&X-Amz-SignedHeaders=host'),
        );

    if (response.statusCode == 200) {
      // If the server returns a 200 OK response, you can process the data here
      print('Response data: ${response.body}');
    } else {
      // If the server did not return a 200 OK response, throw an exception
      throw Exception('Failed to load data');
    }
  }

  void launchWebsite(String downloadUrl) async {
    print(downloadUrl);
    Uri uri = Uri.parse(downloadUrl);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not open the map.';
    }
  }

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
                maxLines: 2,
                key,
                style: const TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 18,
                    color: ColorPallets.deepBlue),
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(
                width: 10,
              ),
              const Text(":",
                  style: TextStyle(
                    fontSize: 18,
                    color: ColorPallets.deepBlue,
                    fontWeight: FontWeight.w600,
                  ))
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            value,
            maxLines: 3,
            style: const TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 18,
                color: Colors.black54),
            overflow: TextOverflow.ellipsis,
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
                  widget.historyXeroxItem["orderId"],
                  style: const TextStyle(
                    color: ColorPallets.deepBlue,
                    fontSize: 22,
                    // fontWeight: FontWeight.,
                    fontStyle: FontStyle.normal,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(
                  height: 3,
                ),
                Text(
                  widget.historyXeroxItem["storeName"],
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 18),
                ),
                const SizedBox(
                  height: 3,
                ),
                Text(
                  getDate(
                    widget.historyXeroxItem["orderDate"],
                  ),
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
                //       widget.historyXeroxItem["orderId"]
                //           .toString()
                //           .substring(0, 6)
                //           .toString(),
                //       style: const TextStyle(fontSize: 13),
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

  Widget KeyValueOfFeature(String key, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 12),
      child: Row(
        children: [
          Expanded(
            child: Text(
              maxLines: 2,
              key,
              style: const TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 18,
                  color: ColorPallets.deepBlue),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          const Text(
            ":",
            style: TextStyle(
              fontSize: 18,
              color: ColorPallets.deepBlue,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(
            width: 20,
          ),
          Expanded(
            child: Text(
              maxLines: 8,
              value,
              style: const TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 18,
                  color: Colors.black54),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget KeyValueOfFeatureDownload(int fileNumber, String downloadUrl) {
    return Container(
      padding: const EdgeInsets.only(top: 5, left: 12, right: 12),
      child: Row(
        children: [
          Expanded(
            child: Text(
              maxLines: 2,
              "File ${fileNumber} ",
              style: const TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 18,
                  color: ColorPallets.deepBlue),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          const Text(
            ":",
            style: TextStyle(
              fontSize: 18,
              color: ColorPallets.deepBlue,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(
            width: 20,
          ),
          Expanded(
              child: TextButton(
            child: const Text(
              maxLines: 8,
              "download file",
              style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 18,
                  color: ColorPallets.darkPurple),
              overflow: TextOverflow.ellipsis,
            ),
            onPressed: () => launchWebsite(downloadUrl),
          )),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    CurrentUser curUser = Provider.of<CurrentUser>(context);
    List<dynamic> itemsList = widget.historyXeroxItem["items"];

    List<Widget> itemWidgets = [];

    for (int index = 0; index < itemsList.length; index++) {
      // print(itemsList[index]);
      // print(
      //     'take Review ----------------------->>>>>>.${itemsList[index]["takeReview"]}');
      itemWidgets.add(
        Column(
          children: [
            KeyValueOfFeatureDownload(
                index + 1, itemsList[index]["downloadUrl"]),
            KeyValueOfFeature("Copies ", itemsList[index]["copies"].toString()),
            KeyValueOfFeature(
                "Total Pages ", itemsList[index]["totalPages"].toString()),
            KeyValueOfFeature("Cost ", itemsList[index]["itemCost"].toString()),
            KeyValueOfFeature("Color ", itemsList[index]["itemColor"]),
            itemsList[index]["colorPartialPagesList"] != null &&
                    itemsList[index]["colorPartialPagesList"]
                        .toString()
                        .trim()
                        .isNotEmpty
                ? KeyValueOfFeature("Color Partials  ",
                    itemsList[index]["colorPartialPagesList"])
                : const SizedBox(),
            itemsList[index]["bondPage"] != null
                ? KeyValueOfFeature("Bond Papers  ", "Yes")
                : KeyValueOfFeature("Bond Papers  ", "No"),
            KeyValueOfFeature("Paper Size ", itemsList[index]["paperSize"]),
            KeyValueOfFeature("Print Layout ", itemsList[index]["printLayout"]),
            KeyValueOfFeature("Binding Formate ", itemsList[index]["binding"]),
            KeyValueOfFeature("Print Side Formate ", itemsList[index]["side"]),

            index == itemsList.length - 1
                ? const SizedBox()
                : Padding(
                    padding: const EdgeInsets.only(left: 12, right: 12),
                    child: Divider(
                        color: Colors.black54.withOpacity(.2), thickness: 1),
                  ),

            const SizedBox(
              height: 10,
            ), // Adjust the spacing as needed
          ],
        ),
      );
    }

    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 15),
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
                const Color.fromARGB(255, 178, 239, 240).withOpacity(0.1),
            children: <Widget>[
              // progressOrderTracker(widget.historyXeroxItem["orderStatus"]),
              const SizedBox(
                height: 20,
              ),
              widget.historyXeroxItem['takeReview']
                  ? ReviewWidget(
                      id: widget.historyXeroxItem['_Id'],
                      accessToken: widget.accesstoken,
                      shopId: widget.historyXeroxItem['storeId'])
                  : SizedBox(),
              const Text(
                "Document Details",
                style: TextStyle(
                    color: ColorPallets.deepBlue,
                    fontSize: 22,
                    fontStyle: FontStyle.italic),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Divider(color: ColorPallets.deepBlue, thickness: 2),
              ),

              Column(
                children: itemWidgets,
              ),

              // ListView.builder(
              //   shrinkWrap: true,
              //   itemCount: itemsList.length,
              //   itemBuilder: (context, index) {
              //     return Column(
              //       children: [
              //         KeyValueOfFeatureDownload(
              //             index + 1, itemsList[index]["downloadUrl"]),
              //         KeyValueOfFeature(
              //             "Copies ", itemsList[index]["copies"].toString()),
              //         KeyValueOfFeature("Total Pages ",
              //             itemsList[index]["totalPages"].toString()),
              //         KeyValueOfFeature(
              //             "Cost ", itemsList[index]["itemCost"].toString()),
              //         KeyValueOfFeature(
              //             "Color ", itemsList[index]["itemColor"]),
              //         if (itemsList[index]["colorPartialPagesList"] != null)
              //           KeyValueOfFeature("Color Partials  ",
              //               itemsList[index]["colorPartialPagesList"]),
              //         if (itemsList[index]["bondPage"] != null)
              //           KeyValueOfFeature("Bond Papers  ", "YES"),
              //         KeyValueOfFeature(
              //             "Paper Size ", itemsList[index]["paperSize"]),
              //         KeyValueOfFeature(
              //             "Print Layout ", itemsList[index]["printLayout"]),
              //         KeyValueOfFeature(
              //             "Binding Formate ", itemsList[index]["binding"]),
              //         KeyValueOfFeature(
              //             "Print Side Formate ", itemsList[index]["side"]),
              //         const SizedBox(
              //             height: 10), // Adjust the spacing as needed
              //       ],
              //     );
              //   },
              // ),
              // KeyValueOfFeatureDownload(1, itemsList[0]["downloadUrl"]),
              // KeyValueOfFeature("Copies ", itemsList[0]["copies"].toString()),
              // KeyValueOfFeature(
              //     "Total Pages ", itemsList[0]["totalPages"].toString()),
              // KeyValueOfFeature("Cost ", itemsList[0]["itemCost"].toString()),
              // KeyValueOfFeature("Color ", itemsList[0]["itemColor"]),
              // itemsList[0]["colorPartialPagesList"] != null
              //     ? KeyValueOfFeature(
              //         "Color Partials  ", itemsList[0]["colorPartialPagesList"])
              //     : const SizedBox(),
              // itemsList[0]["bondPage"] != null
              //     ? KeyValueOfFeature("Bond Papers  ", "YES")
              //     : const SizedBox(),
              // KeyValueOfFeature("Paper Size ", itemsList[0]["paperSize"]),
              // KeyValueOfFeature("Print Layout ", itemsList[0]["printLayout"]),
              // KeyValueOfFeature("Binding Formate ", itemsList[0]["binding"]),
              // KeyValueOfFeature("Print Side Formate ", itemsList[0]["side"]),

              // KeyValueOfFeature(
              //     "No of Copies", widget.historyXeroxItem["noOfCopies"]),
              // KeyValueOfFeature("Total No.of Pages",
              //     "${widget.historyXeroxItem["noOfPages"]} Pages X ${widget.historyXeroxItem["noOfCopies"]} Copies  "),
              // KeyValueOfFeature(
              //     "Page Orientation ", widget.historyXeroxItem["pageOrient"]),
              // KeyValueOfFeature(
              //     "Page Types", widget.historyXeroxItem["pageSize"]),
              // KeyValueOfFeature(
              //     "Print Type", widget.historyXeroxItem["pagePrintSide"]),
              // KeyValueOfFeature(
              //     "Color ", widget.historyXeroxItem["printJobType"]),
              // widget.historyXeroxItem["printJobType"] == "Partial Color"
              //     ? KeyValueOfFeature("Color Pages",
              //         "${widget.historyXeroxItem['colorPagesCount']} ( ${widget.historyXeroxItem['colorPagesRange']} )")
              //     : const SizedBox(),
              // widget.historyXeroxItem['bindingType'] != "NoBound"
              //     ? KeyValueOfFeature(
              //         "Binding Type", widget.historyXeroxItem['bindingType'])
              //     : const SizedBox(),
              // widget.historyXeroxItem['isBondPaperNeeded'] == "true"
              //     ? KeyValueOfFeature(
              //         "Bond Pages", widget.historyXeroxItem['bondPaperRange'])
              //     : const SizedBox(),
              // widget.historyXeroxItem['isTransparentSheetNeed'] == "true"
              //     ? KeyValueOfFeature("Transparent Color",
              //         widget.historyXeroxItem['transparentSheetColor'])
              //     : const SizedBox(),
              const SizedBox(
                height: 10,
              ),
              const Text(
                "Shop Detials",
                style: TextStyle(
                    color: ColorPallets.deepBlue,
                    fontSize: 22,
                    fontStyle: FontStyle.italic),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Divider(color: ColorPallets.deepBlue, thickness: 2),
              ),
              KeyValueOfFeature(
                  "Shope Name", widget.historyXeroxItem['storeName']),
              KeyValueOfFeature("Contact-Number",
                  widget.historyXeroxItem['storeContactNumber']),
              KeyValueOfFeature(
                  "Shop Email", widget.historyXeroxItem['storeEmail']),
              KeyValueLong(
                  "Shop Addres", widget.historyXeroxItem['storeAddress']),

              const SizedBox(
                height: 10,
              ),
              const Text(
                "Order Detials",
                style: TextStyle(
                    color: ColorPallets.deepBlue,
                    fontSize: 22,
                    fontStyle: FontStyle.italic),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Divider(color: ColorPallets.deepBlue, thickness: 2),
              ),
              // KeyValueOfFeature("OrderId", widget.historyXeroxItem['orderId']),

              KeyValueLong("OrderId", widget.historyXeroxItem['orderId']),
              KeyValueOfFeature("Date Of Order",
                  getDate(widget.historyXeroxItem['orderDate'])),
              // KeyValueLong("Date Of Order",
              //     getDate(widget.historyXeroxItem['orderDate'])),
              KeyValueOfFeature("Total Cost",
                  widget.historyXeroxItem['totalCost'].toString()),
              const SizedBox(
                height: 10,
              ),
            ],
          ),
        ));
  }
}
