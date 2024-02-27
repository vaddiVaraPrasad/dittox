import 'package:dittox/widgets/Cart/review.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../providers/current_user.dart';
import '../../utils/color_pallets.dart';
import '../../utils/dynamicSizing.dart';

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

  Widget KeyValueLong(
    String key,
    String value,
    double totalScreenHeight,
    double totalScreenWidth,
  ) {
    return Container(
      // padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 12),
      padding: EdgeInsets.symmetric(
          vertical: calculateDynamicFontSize(
            totalScreenHeight: totalScreenHeight,
            totalScreenWidth: totalScreenWidth,
            currentFontSize: 2,
            // heightSpecific: true,
          ),
          horizontal: calculateDynamicFontSize(
            totalScreenHeight: totalScreenHeight,
            totalScreenWidth: totalScreenWidth,
            currentFontSize: 40,
            // heightSpecific: false,
          )),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                maxLines: 2,
                key,
                style: TextStyle(
                    fontWeight: FontWeight.w400,
                    // fontSize: 18,
                    fontSize: calculateDynamicFontSize(
                      totalScreenHeight: totalScreenHeight,
                      totalScreenWidth: totalScreenWidth,
                      currentFontSize: 33,
                      // heightSpecific: true,
                    ),
                    color: ColorPallets.deepBlue),
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(
                // width: 10,
                width: calculateDynamicFontSize(
                  totalScreenHeight: totalScreenHeight,
                  totalScreenWidth: totalScreenWidth,
                  currentFontSize: 20,
                  // heightSpecific: false,
                ),
              ),
              Text(":",
                  style: TextStyle(
                    // fontSize: 18,
                    fontSize: calculateDynamicFontSize(
                      totalScreenHeight: totalScreenHeight,
                      totalScreenWidth: totalScreenWidth,
                      currentFontSize: 33,
                      // heightSpecific: true,
                    ),
                    color: ColorPallets.deepBlue,
                    fontWeight: FontWeight.w600,
                  ))
            ],
          ),
          SizedBox(
            // height: 10,
            height: calculateDynamicFontSize(
              totalScreenHeight: totalScreenHeight,
              totalScreenWidth: totalScreenWidth,
              currentFontSize: 10,
              // heightSpecific: true,
            ),
          ),
          Text(
            value,
            maxLines: 3,
            style: TextStyle(
                fontWeight: FontWeight.w400,
                // fontSize: 18,
                fontSize: calculateDynamicFontSize(
                  totalScreenHeight: totalScreenHeight,
                  totalScreenWidth: totalScreenWidth,
                  currentFontSize: 33,
                  // heightSpecific: true,
                ),
                color: Colors.black54),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget expandedTitle(
    double totalScreenHeight,
    double totalScreenWidth,
  ) {
    return Container(
      margin: EdgeInsets.symmetric(
        // vertical: 16,
        vertical: calculateDynamicFontSize(
          totalScreenHeight: totalScreenHeight,
          totalScreenWidth: totalScreenWidth,
          currentFontSize: 30,
          // heightSpecific: true,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Image.asset(
              "assets/image/xerox_sample.png",
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(
            // width: 20,
            width: calculateDynamicFontSize(
              totalScreenHeight: totalScreenHeight,
              totalScreenWidth: totalScreenWidth,
              currentFontSize: 35,
              // heightSpecific: false,
            ),
          ),
          Expanded(
            flex: 4,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.historyXeroxItem["orderId"],
                  style: TextStyle(
                    color: ColorPallets.deepBlue,
                    // fontSize: 22,
                    fontSize: calculateDynamicFontSize(
                      totalScreenHeight: totalScreenHeight,
                      totalScreenWidth: totalScreenWidth,
                      currentFontSize: 38,
                      // heightSpecific: true,
                    ),
                    // fontWeight: FontWeight.,
                    fontStyle: FontStyle.normal,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(
                  // height: 3,
                  height: calculateDynamicFontSize(
                    totalScreenHeight: totalScreenHeight,
                    totalScreenWidth: totalScreenWidth,
                    currentFontSize: 3,
                    // heightSpecific: true,
                  ),
                ),
                Text(
                  widget.historyXeroxItem["storeName"],
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    // fontSize: 18,
                    fontSize: calculateDynamicFontSize(
                      totalScreenHeight: totalScreenHeight,
                      totalScreenWidth: totalScreenWidth,
                      currentFontSize: 30,
                      // heightSpecific: true,
                    ),
                  ),
                ),
                SizedBox(
                  // height: 3,
                  height: calculateDynamicFontSize(
                    totalScreenHeight: totalScreenHeight,
                    totalScreenWidth: totalScreenWidth,
                    currentFontSize: 8,
                    // heightSpecific: true,
                  ),
                ),
                Text(
                  getDate(
                    widget.historyXeroxItem["orderDate"],
                  ),
                  style: TextStyle(
                    // fontSize: 13,
                    fontSize: calculateDynamicFontSize(
                      totalScreenHeight: totalScreenHeight,
                      totalScreenWidth: totalScreenWidth,
                      currentFontSize: 30,
                      // heightSpecific: true,
                    ),
                  ),
                ),
                SizedBox(
                  // height: 3,
                  height: calculateDynamicFontSize(
                    totalScreenHeight: totalScreenHeight,
                    totalScreenWidth: totalScreenWidth,
                    currentFontSize: 8,
                    // heightSpecific: true,
                  ),
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

  Widget KeyValueOfFeature(
    String key,
    String value,
    double totalScreenHeight,
    double totalScreenWidth,
  ) {
    return Container(
      // padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 12),
      padding: EdgeInsets.symmetric(
          vertical: calculateDynamicFontSize(
            totalScreenHeight: totalScreenHeight,
            totalScreenWidth: totalScreenWidth,
            currentFontSize: 2,
            // heightSpecific: true,
          ),
          horizontal: calculateDynamicFontSize(
            totalScreenHeight: totalScreenHeight,
            totalScreenWidth: totalScreenWidth,
            currentFontSize: 40,
            // heightSpecific: false,
          )),
      child: Row(
        children: [
          Expanded(
            child: Text(
              maxLines: 2,
              key,
              style: TextStyle(
                  fontWeight: FontWeight.w400,
                  // fontSize: 18,
                  fontSize: calculateDynamicFontSize(
                    totalScreenHeight: totalScreenHeight,
                    totalScreenWidth: totalScreenWidth,
                    currentFontSize: 33,
                    // heightSpecific: true,
                  ),
                  color: ColorPallets.deepBlue),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          SizedBox(
            // width: 10,
            width: calculateDynamicFontSize(
              totalScreenHeight: totalScreenHeight,
              totalScreenWidth: totalScreenWidth,
              currentFontSize: 20,
              // heightSpecific: false,
            ),
          ),
          Text(
            ":",
            style: TextStyle(
              // fontSize: 18,
              fontSize: calculateDynamicFontSize(
                totalScreenHeight: totalScreenHeight,
                totalScreenWidth: totalScreenWidth,
                currentFontSize: 33,
                // heightSpecific: true,
              ),
              color: ColorPallets.deepBlue,
              fontWeight: FontWeight.w600,
            ),
          ),
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
              maxLines: 8,
              value,
              style: TextStyle(
                  fontWeight: FontWeight.w400,
                  // fontSize: 18,
                  fontSize: calculateDynamicFontSize(
                    totalScreenHeight: totalScreenHeight,
                    totalScreenWidth: totalScreenWidth,
                    currentFontSize: 33,
                    // heightSpecific: true,
                  ),
                  color: Colors.black54),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget KeyValueOfFeatureDownload(
    int fileNumber,
    String downloadUrl,
    double totalScreenHeight,
    double totalScreenWidth,
  ) {
    return Container(
      // padding: const EdgeInsets.only(top: 5, left: 12, right: 12),
      padding: EdgeInsets.only(
        top: calculateDynamicFontSize(
          totalScreenHeight: totalScreenHeight,
          totalScreenWidth: totalScreenWidth,
          currentFontSize: 0,
          // heightSpecific: true,
        ),
        left: calculateDynamicFontSize(
          totalScreenHeight: totalScreenHeight,
          totalScreenWidth: totalScreenWidth,
          currentFontSize: 40,
          // heightSpecific: false,
        ),
        right: calculateDynamicFontSize(
          totalScreenHeight: totalScreenHeight,
          totalScreenWidth: totalScreenWidth,
          currentFontSize: 40,
          // heightSpecific: false,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Text(
              maxLines: 2,
              "File ${fileNumber} ",
              style: TextStyle(
                  fontWeight: FontWeight.w400,
                  // fontSize: 18,
                  fontSize: calculateDynamicFontSize(
                    totalScreenHeight: totalScreenHeight,
                    totalScreenWidth: totalScreenWidth,
                    currentFontSize: 33,
                    // heightSpecific: true,
                  ),
                  color: ColorPallets.deepBlue),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          SizedBox(
            // width: 10,
            width: calculateDynamicFontSize(
              totalScreenHeight: totalScreenHeight,
              totalScreenWidth: totalScreenWidth,
              currentFontSize: 20,
              // heightSpecific: false,
            ),
          ),
          Text(
            ":",
            style: TextStyle(
              // fontSize: 18,
              fontSize: calculateDynamicFontSize(
                totalScreenHeight: totalScreenHeight,
                totalScreenWidth: totalScreenWidth,
                currentFontSize: 33,
                // heightSpecific: true,
              ),
              color: ColorPallets.deepBlue,
              fontWeight: FontWeight.w600,
            ),
          ),
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
              child: TextButton(
            child: Text(
              maxLines: 8,
              "download file",
              style: TextStyle(
                  fontWeight: FontWeight.w400,
                  // fontSize: 18,
                  fontSize: calculateDynamicFontSize(
                    totalScreenHeight: totalScreenHeight,
                    totalScreenWidth: totalScreenWidth,
                    currentFontSize: 33,
                    // heightSpecific: true,
                  ),
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
    double totalScreenHeight = MediaQuery.of(context).size.height;
    double totalScreenWidth = MediaQuery.of(context).size.width;

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
              index + 1,
              itemsList[index]["downloadUrl"],
              totalScreenHeight,
              totalScreenWidth,
            ),
            KeyValueOfFeature(
              "Copies ",
              itemsList[index]["copies"].toString(),
              totalScreenHeight,
              totalScreenWidth,
            ),
            KeyValueOfFeature(
              "Total Pages ",
              itemsList[index]["totalPages"].toString(),
              totalScreenHeight,
              totalScreenWidth,
            ),
            KeyValueOfFeature(
              "Cost ",
              itemsList[index]["itemCost"].toString(),
              totalScreenHeight,
              totalScreenWidth,
            ),
            KeyValueOfFeature(
              "Color ",
              itemsList[index]["itemColor"],
              totalScreenHeight,
              totalScreenWidth,
            ),
            itemsList[index]["colorPartialPagesList"] != null &&
                    itemsList[index]["colorPartialPagesList"]
                        .toString()
                        .trim()
                        .isNotEmpty
                ? KeyValueOfFeature(
                    "Color Partials  ",
                    itemsList[index]["colorPartialPagesList"],
                    totalScreenHeight,
                    totalScreenWidth,
                  )
                : const SizedBox(),
            itemsList[index]["bondPage"] != null
                ? KeyValueOfFeature(
                    "Bond Papers  ",
                    "Yes",
                    totalScreenHeight,
                    totalScreenWidth,
                  )
                : KeyValueOfFeature(
                    "Bond Papers  ",
                    "No",
                    totalScreenHeight,
                    totalScreenWidth,
                  ),
            KeyValueOfFeature(
              "Paper Size ",
              itemsList[index]["paperSize"],
              totalScreenHeight,
              totalScreenWidth,
            ),
            KeyValueOfFeature(
              "Print Layout ",
              itemsList[index]["printLayout"],
              totalScreenHeight,
              totalScreenWidth,
            ),
            KeyValueOfFeature(
              "Binding Formate ",
              itemsList[index]["binding"],
              totalScreenHeight,
              totalScreenWidth,
            ),
            KeyValueOfFeature(
              "Print Side Formate ",
              itemsList[index]["side"],
              totalScreenHeight,
              totalScreenWidth,
            ),

            index == itemsList.length - 1
                ? const SizedBox()
                : Padding(
                    padding: EdgeInsets.only(
                      // left: 12,
                      left: calculateDynamicFontSize(
                        totalScreenHeight: totalScreenHeight,
                        totalScreenWidth: totalScreenWidth,
                        currentFontSize: 20,
                        // heightSpecific: false,
                      ),
                      // right: 12,
                      right: calculateDynamicFontSize(
                        totalScreenHeight: totalScreenHeight,
                        totalScreenWidth: totalScreenWidth,
                        currentFontSize: 20,
                        // heightSpecific: false,
                      ),
                    ),
                    child: Divider(
                      color: Colors.black54.withOpacity(.2),
                      // thickness: 1,
                      thickness: calculateDynamicFontSize(
                        totalScreenHeight: totalScreenHeight,
                        totalScreenWidth: totalScreenWidth,
                        currentFontSize: 3,
                        // heightSpecific: false,
                      ),
                    ),
                  ),

            SizedBox(
              // height: 10,
              height: calculateDynamicFontSize(
                totalScreenHeight: totalScreenHeight,
                totalScreenWidth: totalScreenWidth,
                currentFontSize: 20,
                // heightSpecific: true,
              ),
            ), // Adjust the spacing as needed
          ],
        ),
      );
    }

    return Padding(
        padding: EdgeInsets.symmetric(
          // horizontal: 20,
          horizontal: calculateDynamicFontSize(
            totalScreenHeight: totalScreenHeight,
            totalScreenWidth: totalScreenWidth,
            currentFontSize: 20,
            // heightSpecific: false,
          ),
          vertical: 0,
        ),
        child: Container(
          margin: EdgeInsets.symmetric(
              // vertical: 15,
              vertical: calculateDynamicFontSize(
            totalScreenHeight: totalScreenHeight,
            totalScreenWidth: totalScreenWidth,
            currentFontSize: 20,
            // heightSpecific: true,
          )),
          decoration: BoxDecoration(
              border: Border.all(
                color: ColorPallets.deepBlue,
                // width: 1,
                width: calculateDynamicFontSize(
                  totalScreenHeight: totalScreenHeight,
                  totalScreenWidth: totalScreenWidth,
                  currentFontSize: 2,
                  // heightSpecific: false,
                ),
              ),
              borderRadius: BorderRadius.circular(
                // 8,
                calculateDynamicFontSize(
                  totalScreenHeight: totalScreenHeight,
                  totalScreenWidth: totalScreenWidth,
                  currentFontSize: 12,
                  // heightSpecific: true,
                ),
              )),
          child: ExpansionTile(
            iconColor: ColorPallets.deepBlue,
            title: expandedTitle(
              totalScreenHeight,
              totalScreenWidth,
            ),
            backgroundColor:
                const Color.fromARGB(255, 178, 239, 240).withOpacity(0.1),
            children: <Widget>[
              // progressOrderTracker(widget.historyXeroxItem["orderStatus"]),
              SizedBox(
                // height: 20,
                height: calculateDynamicFontSize(
                  totalScreenHeight: totalScreenHeight,
                  totalScreenWidth: totalScreenWidth,
                  currentFontSize: 0,
                  // heightSpecific: true,
                ),
              ),
              widget.historyXeroxItem['takeReview']
                  ? ReviewWidget(
                      id: widget.historyXeroxItem['_Id'],
                      accessToken: widget.accesstoken,
                      shopId: widget.historyXeroxItem['storeId'])
                  : SizedBox(),
              Text(
                "Document Details",
                style: TextStyle(
                    color: ColorPallets.deepBlue,
                    // fontSize: 22,
                    fontSize: calculateDynamicFontSize(
                      totalScreenHeight: totalScreenHeight,
                      totalScreenWidth: totalScreenWidth,
                      currentFontSize: 40,
                      // heightSpecific: true,
                    ),
                    fontStyle: FontStyle.italic),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                    // horizontal: 20,
                    horizontal: calculateDynamicFontSize(
                  totalScreenHeight: totalScreenHeight,
                  totalScreenWidth: totalScreenWidth,
                  currentFontSize: 35,
                  // heightSpecific: true,
                )),
                child: Divider(
                  color: ColorPallets.deepBlue,
                  // thickness: 2,
                  thickness: calculateDynamicFontSize(
                    totalScreenHeight: totalScreenHeight,
                    totalScreenWidth: totalScreenWidth,
                    currentFontSize: 4,
                    // heightSpecific: true,
                  ),
                ),
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
              SizedBox(
                // height: 10,
                height: calculateDynamicFontSize(
                  totalScreenHeight: totalScreenHeight,
                  totalScreenWidth: totalScreenWidth,
                  currentFontSize: 10,
                  // heightSpecific: true,
                ),
              ),
              Text(
                "Shop Detials",
                style: TextStyle(
                    color: ColorPallets.deepBlue,
                    // fontSize: 22,
                    fontSize: calculateDynamicFontSize(
                      totalScreenHeight: totalScreenHeight,
                      totalScreenWidth: totalScreenWidth,
                      currentFontSize: 40,
                      // heightSpecific: true,
                    ),
                    fontStyle: FontStyle.italic),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                    // horizontal: 20,
                    horizontal: calculateDynamicFontSize(
                  totalScreenHeight: totalScreenHeight,
                  totalScreenWidth: totalScreenWidth,
                  currentFontSize: 35,
                  // heightSpecific: true,
                )),
                child: Divider(
                  color: ColorPallets.deepBlue,
                  thickness: calculateDynamicFontSize(
                    totalScreenHeight: totalScreenHeight,
                    totalScreenWidth: totalScreenWidth,
                    currentFontSize: 4,
                    // heightSpecific: true,
                  ),
                ),
              ),
              KeyValueOfFeature(
                "Shope Name",
                widget.historyXeroxItem['storeName'],
                totalScreenHeight,
                totalScreenWidth,
              ),
              KeyValueOfFeature(
                "Contact-Number",
                widget.historyXeroxItem['storeContactNumber'],
                totalScreenHeight,
                totalScreenWidth,
              ),
              KeyValueOfFeature(
                "Shop Email",
                widget.historyXeroxItem['storeEmail'],
                totalScreenHeight,
                totalScreenWidth,
              ),
              KeyValueLong(
                "Shop Addres",
                widget.historyXeroxItem['storeAddress'],
                totalScreenHeight,
                totalScreenWidth,
              ),

              SizedBox(
                // height: 10
                // ,
                height: calculateDynamicFontSize(
                  totalScreenHeight: totalScreenHeight,
                  totalScreenWidth: totalScreenWidth,
                  currentFontSize: 20,
                  // heightSpecific: true,
                ),
              ),
              Text(
                "Order Detials",
                style: TextStyle(
                    color: ColorPallets.deepBlue,
                    // fontSize: 22,
                    fontSize: calculateDynamicFontSize(
                      totalScreenHeight: totalScreenHeight,
                      totalScreenWidth: totalScreenWidth,
                      currentFontSize: 40,
                      // heightSpecific: true,
                    ),
                    fontStyle: FontStyle.italic),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                    // horizontal: 20,
                    horizontal: calculateDynamicFontSize(
                  totalScreenHeight: totalScreenHeight,
                  totalScreenWidth: totalScreenWidth,
                  currentFontSize: 35,
                  // heightSpecific: false,
                )),
                child: Divider(
                  color: ColorPallets.deepBlue,
                  // thickness: 2,
                  thickness: calculateDynamicFontSize(
                    totalScreenHeight: totalScreenHeight,
                    totalScreenWidth: totalScreenWidth,
                    currentFontSize: 4,
                    // heightSpecific: true,
                  ),
                ),
              ),
              // KeyValueOfFeature("OrderId", widget.historyXeroxItem['orderId']),

              KeyValueLong(
                "OrderId",
                widget.historyXeroxItem['orderId'],
                totalScreenHeight,
                totalScreenWidth,
              ),
              KeyValueOfFeature(
                "Date Of Order",
                getDate(widget.historyXeroxItem['orderDate']),
                totalScreenHeight,
                totalScreenWidth,
              ),
              // KeyValueLong("Date Of Order",
              //     getDate(widget.historyXeroxItem['orderDate'])),
              KeyValueOfFeature(
                "Total Cost",
                widget.historyXeroxItem['totalCost'].toString(),
                totalScreenHeight,
                totalScreenWidth,
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
            ],
          ),
        ));
  }
}
