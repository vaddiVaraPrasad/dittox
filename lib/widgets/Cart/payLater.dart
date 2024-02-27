import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

import 'package:provider/provider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../providers/current_user.dart';
import '../../screens/nav_drawers/navBar.dart';
import '../../utils/color_pallets.dart';
import '../../utils/dynamicSizing.dart';

class PayLaterCard extends StatefulWidget {
  Map<String, dynamic> PayLaterXeroxItem;
  String accessToken;
  PayLaterCard({
    super.key,
    required this.PayLaterXeroxItem,
    required this.accessToken,
  });

  @override
  State<PayLaterCard> createState() => _PayLaterCardState();
}

class _PayLaterCardState extends State<PayLaterCard> {
  late Razorpay _razorPay;
  bool isInit = true;

  void _handlePaymentSuccess(
      BuildContext ctx, PaymentSuccessResponse response) {
    // Do something when payment succeeds
    print("PAYMENT MADE SUCCESSFULLY");
    Navigator.of(ctx).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (ctx) => ButtonNavigationBar(
            accessToken: widget.accessToken,
          ),
        ),
        (route) => false);
  }

  void _handlePaymentError(BuildContext ctx, PaymentFailureResponse response) {
    // Do something when payment fails
    print("PAYMENT IS FAILURE");
    showDialog(
      context: ctx,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Payment Status'),
          content: Text('Payment is failed. Please try again once.'),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // Dismiss the dialog
                // showFailedAlertDialog(context);
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
    _razorPay.clear();
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    // Do something when an external wallet was selected
    print("EXTERNAL WALLET IS SELETED");
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (isInit) {
      _razorPay = Razorpay();
      // _razorPay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
      _razorPay.on(Razorpay.EVENT_PAYMENT_SUCCESS, (response) {
        _handlePaymentSuccess(context, response);
      });
      _razorPay.on(Razorpay.EVENT_PAYMENT_ERROR, (responce) {
        _handlePaymentError(context, responce);
      });
      _razorPay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    }
    setState(() {
      isInit = false;
    });
  }

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
            currentFontSize: 14,
            // heightSpecific: true,
          ),
          horizontal: calculateDynamicFontSize(
            totalScreenHeight: totalScreenHeight,
            totalScreenWidth: totalScreenWidth,
            currentFontSize: 24,
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
                      currentFontSize: 36,
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
                  // heightSpecific: true,
                ),
              ),
              Text(":",
                  style: TextStyle(
                    // fontSize: 18,
                    fontSize: calculateDynamicFontSize(
                      totalScreenHeight: totalScreenHeight,
                      totalScreenWidth: totalScreenWidth,
                      currentFontSize: 36,
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
              currentFontSize: 20,
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
                  currentFontSize: 36,
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
          currentFontSize: 20,
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
              currentFontSize: 40,
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
                  widget.PayLaterXeroxItem["orderId"],
                  style: TextStyle(
                    color: ColorPallets.deepBlue,
                    // fontSize: 22,
                    fontSize: calculateDynamicFontSize(
                      totalScreenHeight: totalScreenHeight,
                      totalScreenWidth: totalScreenWidth,
                      currentFontSize: 44,
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
                    currentFontSize: 6,
                    // heightSpecific: true,
                  ),
                ),
                Text(
                  widget.PayLaterXeroxItem["storeName"],
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    // fontSize: 18,
                    fontSize: calculateDynamicFontSize(
                      totalScreenHeight: totalScreenHeight,
                      totalScreenWidth: totalScreenWidth,
                      currentFontSize: 36,
                      // heightSpecific: true,
                    ),
                  ),
                ),
                SizedBox(
                  // height: 3,
                  height: calculateDynamicFontSize(
                    totalScreenHeight: totalScreenHeight,
                    totalScreenWidth: totalScreenWidth,
                    currentFontSize: 6,
                    // heightSpecific: true,
                  ),
                ),
                Text(
                  getDate(
                    widget.PayLaterXeroxItem["orderDate"],
                  ),
                  style: TextStyle(
                    // fontSize: 13,
                    fontSize: calculateDynamicFontSize(
                      totalScreenHeight: totalScreenHeight,
                      totalScreenWidth: totalScreenWidth,
                      currentFontSize: 26,
                      // heightSpecific true,
                    ),
                  ),
                ),
                SizedBox(
                  // height: 3,
                  height: calculateDynamicFontSize(
                    totalScreenHeight: totalScreenHeight,
                    totalScreenWidth: totalScreenWidth,
                    currentFontSize: 6,
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
            currentFontSize: 14,
            // heightSpecific: true,
          ),
          horizontal: calculateDynamicFontSize(
            totalScreenHeight: totalScreenHeight,
            totalScreenWidth: totalScreenWidth,
            currentFontSize: 24,
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
                    currentFontSize: 36,
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
                currentFontSize: 36,
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
                    currentFontSize: 36,
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
            currentFontSize: 10,
            // heightSpecific: true,
          ),
          left: calculateDynamicFontSize(
            totalScreenHeight: totalScreenHeight,
            totalScreenWidth: totalScreenWidth,
            currentFontSize: 24,
            // heightSpecific: false,
          ),
          right: calculateDynamicFontSize(
            totalScreenHeight: totalScreenHeight,
            totalScreenWidth: totalScreenWidth,
            currentFontSize: 24,
            // heightSpecific: false,
          )),
      child: Row(
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
                    currentFontSize: 36,
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
                currentFontSize: 36,
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
              // heightSpecific: true,
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
                    currentFontSize: 36,
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
    CurrentUser currentUser = Provider.of<CurrentUser>(context);
    List<dynamic> itemsList = widget.PayLaterXeroxItem["items"];
    double totalScreenHeight = MediaQuery.of(context).size.height;
    double totalScreenWidth = MediaQuery.of(context).size.width;

    List<Widget> itemWidgets = [];

    for (int index = 0; index < itemsList.length; index++) {
      print(itemsList[index]);
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
                    // padding: const EdgeInsets.only(left: 12, right: 12),
                    padding: EdgeInsets.symmetric(
                        vertical: calculateDynamicFontSize(
                          totalScreenHeight: totalScreenHeight,
                          totalScreenWidth: totalScreenWidth,
                          currentFontSize: 24,
                          // heightSpecific: true,
                        ),
                        horizontal: calculateDynamicFontSize(
                          totalScreenHeight: totalScreenHeight,
                          totalScreenWidth: totalScreenWidth,
                          currentFontSize: 24,
                          // heightSpecific: false,
                        )),
                    child: Divider(
                      color: Colors.black54.withOpacity(.2),
                      // thickness: 1,
                      thickness: calculateDynamicFontSize(
                        totalScreenHeight: totalScreenHeight,
                        totalScreenWidth: totalScreenWidth,
                        currentFontSize: 2,
                        // heightSpecific: true,
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

    Future<void> deleteOrder(String __id, BuildContext ctx) async {
      try {
        final String url = 'https://dittox.in/xerox/v1/orders/delete/${__id}';
        final response = await http.put(Uri.parse(url),
            headers: {'X-auth-token': 'bearer ${widget.accessToken}'});

        if (response.statusCode == 200) {
          // Check if response code is OK
          final jsonResponse = json.decode(response.body);
          if (jsonResponse['responseCode'] == 'OK') {
            // Response code is OK, handle success
            Navigator.of(ctx).pushAndRemoveUntil(
                MaterialPageRoute(
                  builder: (ctx) => ButtonNavigationBar(
                    accessToken: widget.accessToken,
                  ),
                ),
                (route) => false);
            print('Order deleted successfully');
          } else {
            // Response code is not OK, handle error
            throw Exception(
                'Failed to delete order: ${jsonResponse['message']}');
          }
        } else {
          // Handle non-200 status code
          throw Exception('Failed to delete order: ${response.statusCode}');
        }
      } catch (e) {
        ScaffoldMessenger.of(context).clearSnackBars();

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: ColorPallets.deepBlue,
            content: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const Icon(
                  FontAwesomeIcons.triangleExclamation,
                  color: Colors.red,
                ),
                Flexible(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      e.toString(),
                      style: TextStyle(
                        // fontSize: 18,
                        fontSize: calculateDynamicFontSize(
                          totalScreenHeight: totalScreenHeight,
                          totalScreenWidth: totalScreenWidth,
                          currentFontSize: 40,
                          // heightSpecific: true,
                        ),
                        fontStyle: FontStyle.normal,
                        color: ColorPallets.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }
    }

    Future<void> makePayment() async {
      try {
        var options = {
          "key": "rzp_test_F9dV31vBF1OjLd",
          "amount": widget.PayLaterXeroxItem['totalCost'] * 100,
          "currency": "INR",
          "name": "Dittox", //your business name
          "description": "Test Transaction",
          "orderId": widget.PayLaterXeroxItem['_id'],
          // "receipt": "cnlna",
          "timeout": 300,
          "prefill": {
            "name": currentUser.getUserName,
            "email": currentUser.getUserEmail,
            "contact": currentUser.getUserPhoneNumber,
          },
          "notes": {
            "address": "Razorpay Corporate Office",
          },
          "theme": {
            "color": "#3399cc",
          },
        };
        print(options);
        _razorPay.open(options);
        print("-------------- PAYMENT IS DONE -------------");
      } catch (e) {
        print("ERROR ${e}");
        ScaffoldMessenger.of(context).clearSnackBars();

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: ColorPallets.deepBlue,
          content: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const Icon(
                FontAwesomeIcons.triangleExclamation,
                color: Colors.red,
              ),
              Flexible(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    e.toString(),
                    style: TextStyle(
                      // fontSize: 18,
                      fontSize: calculateDynamicFontSize(
                        totalScreenHeight: totalScreenHeight,
                        totalScreenWidth: totalScreenWidth,
                        currentFontSize: 40,
                        // heightSpecific: true,
                      ),
                      fontStyle: FontStyle.normal,
                      color: ColorPallets.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ));
      }
    }

    return Padding(
        padding: EdgeInsets.symmetric(
          // horizontal: 20,
          horizontal: calculateDynamicFontSize(
            totalScreenHeight: totalScreenHeight,
            totalScreenWidth: totalScreenWidth,
            currentFontSize: 40,
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
              currentFontSize: 30,
              // heightSpecific: true,
            ),
          ),
          decoration: BoxDecoration(
              border: Border.all(
                color: ColorPallets.deepBlue,
                width: 2,
              ),
              borderRadius: BorderRadius.circular(8)),
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
                  currentFontSize: 40,
                  // heightSpecific: true,
                ),
              ),
              Text(
                "Document Details",
                style: TextStyle(
                    color: ColorPallets.deepBlue,
                    // fontSize: 22,
                    fontSize: calculateDynamicFontSize(
                      totalScreenHeight: totalScreenHeight,
                      totalScreenWidth: totalScreenWidth,
                      currentFontSize: 44,
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
                  currentFontSize: 40,
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

              Column(
                children: itemWidgets,
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
              Text(
                "Shop Detials",
                style: TextStyle(
                    color: ColorPallets.deepBlue,
                    // fontSize: 22,
                    fontSize: calculateDynamicFontSize(
                      totalScreenHeight: totalScreenHeight,
                      totalScreenWidth: totalScreenWidth,
                      currentFontSize: 44,
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
                  currentFontSize: 40,
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
              KeyValueOfFeature(
                "Shope Name",
                widget.PayLaterXeroxItem['storeName'],
                totalScreenHeight,
                totalScreenWidth,
              ),
              KeyValueOfFeature(
                "Contact-Number",
                widget.PayLaterXeroxItem['storeContactNumber'],
                totalScreenHeight,
                totalScreenWidth,
              ),
              KeyValueOfFeature(
                "Shop Email",
                widget.PayLaterXeroxItem['storeEmail'],
                totalScreenHeight,
                totalScreenWidth,
              ),
              KeyValueLong(
                "Shop Addres",
                widget.PayLaterXeroxItem['storeAddress'],
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
              Text(
                "Order Detials",
                style: TextStyle(
                    color: ColorPallets.deepBlue,
                    // fontSize: 22,
                    fontSize: calculateDynamicFontSize(
                      totalScreenHeight: totalScreenHeight,
                      totalScreenWidth: totalScreenWidth,
                      currentFontSize: 44,
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
                    currentFontSize: 40,
                    // heightSpecific: false,
                  ),
                ),
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
                widget.PayLaterXeroxItem['orderId'],
                totalScreenHeight,
                totalScreenWidth,
              ),
              KeyValueOfFeature(
                "Date Of Order",
                getDate(widget.PayLaterXeroxItem['orderDate']),
                totalScreenHeight,
                totalScreenWidth,
              ),
              // KeyValueLong("Date Of Order",
              //     getDate(widget.historyXeroxItem['orderDate'])),
              KeyValueOfFeature(
                "Total Cost",
                widget.PayLaterXeroxItem['totalCost'].toString(),
                totalScreenHeight,
                totalScreenWidth,
              ),
              SizedBox(
                // height: 20,
                height: calculateDynamicFontSize(
                  totalScreenHeight: totalScreenHeight,
                  totalScreenWidth: totalScreenWidth,
                  currentFontSize: 40,
                  // heightSpecific: true,
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: calculateDynamicFontSize(
                    totalScreenHeight: totalScreenHeight,
                    totalScreenWidth: totalScreenWidth,
                    currentFontSize: 30,
                    // heightSpecific: true,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () async {
                          print("Delete option is clicked");
                          await deleteOrder(
                              widget.PayLaterXeroxItem['_id'], context);
                        },
                        child: Container(
                          // width: MediaQuery.of(context).size.width * 0.3,
                          // Make the container fill the entire width
                          padding: EdgeInsets.symmetric(
                            // vertical: 10,
                            vertical: calculateDynamicFontSize(
                              totalScreenHeight: totalScreenHeight,
                              totalScreenWidth: totalScreenWidth,
                              currentFontSize: 20,
                              // heightSpecific: true,
                            ),
                            // horizontal: 8,
                            horizontal: calculateDynamicFontSize(
                              totalScreenHeight: totalScreenHeight,
                              totalScreenWidth: totalScreenWidth,
                              currentFontSize: 16,
                              // heightSpecific: false,
                            ),
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.redAccent,
                              width: calculateDynamicFontSize(
                                totalScreenHeight: totalScreenHeight,
                                totalScreenWidth: totalScreenWidth,
                                currentFontSize: 2,
                                // heightSpecific: true,
                              ),
                            ),
                            // color: ColorPallets
                            //     .deepBlue, // Set the background color to green
                            borderRadius: BorderRadius.circular(
                              // 10,
                              calculateDynamicFontSize(
                                totalScreenHeight: totalScreenHeight,
                                totalScreenWidth: totalScreenWidth,
                                currentFontSize: 20,
                                // heightSpecific: true,
                              ),
                            ), // Set round borders
                          ),
                          child: Center(
                            child: Text(
                              "Delete",
                              style: TextStyle(
                                color: Colors
                                    .redAccent, // Assuming ColorPallets.white is equivalent to Colors.white
                                // fontSize: 22,
                                fontSize: calculateDynamicFontSize(
                                  totalScreenHeight: totalScreenHeight,
                                  totalScreenWidth: totalScreenWidth,
                                  currentFontSize: 44,
                                  // heightSpecific: true,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: calculateDynamicFontSize(
                        totalScreenHeight: totalScreenHeight,
                        totalScreenWidth: totalScreenWidth,
                        currentFontSize: 40,
                        // heightSpecific: true,
                      ),
                    ),
                    Expanded(
                      child: InkWell(
                        onTap: () async {
                          print("make paymenet is clicked");
                          print("${widget.PayLaterXeroxItem['_id']}");
                          await makePayment();
                        },
                        child: Container(
                          // width: MediaQuery.of(context).size.width * 0.3,
                          // Make the container fill the entire width
                          padding: EdgeInsets.symmetric(
                            // vertical: 10,
                            vertical: calculateDynamicFontSize(
                              totalScreenHeight: totalScreenHeight,
                              totalScreenWidth: totalScreenWidth,
                              currentFontSize: 20,
                              // heightSpecific: true,
                            ),
                            // horizontal: 8,
                            horizontal: calculateDynamicFontSize(
                              totalScreenHeight: totalScreenHeight,
                              totalScreenWidth: totalScreenWidth,
                              currentFontSize: 16,
                              // heightSpecific: false,
                            ),
                          ),
                          decoration: BoxDecoration(
                            color: ColorPallets
                                .deepBlue, // Set the background color to green
                            borderRadius: BorderRadius.circular(
                                // 10,
                                calculateDynamicFontSize(
                              totalScreenHeight: totalScreenHeight,
                              totalScreenWidth: totalScreenWidth,
                              currentFontSize: 20,
                              // heightSpecific: true,
                            )), // Set round borders
                          ),
                          child: Center(
                            child: Text(
                              "Pay Now",
                              style: TextStyle(
                                color: Colors
                                    .white, // Assuming ColorPallets.white is equivalent to Colors.white
                                // fontSize: 22,
                                fontSize: calculateDynamicFontSize(
                                  totalScreenHeight: totalScreenHeight,
                                  totalScreenWidth: totalScreenWidth,
                                  currentFontSize: 44,
                                  // heightSpecific: true,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(
                // height: 15,
                height: calculateDynamicFontSize(
                  totalScreenHeight: totalScreenHeight,
                  totalScreenWidth: totalScreenWidth,
                  currentFontSize: 30,
                  // heightSpecific: true,
                ),
              )
            ],
          ),
        ));
  }
}
