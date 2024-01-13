import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

import 'package:provider/provider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../providers/current_user.dart';
import '../../screens/nav_drawers/navBar.dart';
import '../../utils/color_pallets.dart';

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
    Navigator.of(context).pushAndRemoveUntil(
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
      context: context,
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
                  widget.PayLaterXeroxItem["orderId"],
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
                  widget.PayLaterXeroxItem["storeName"],
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 18),
                ),
                const SizedBox(
                  height: 3,
                ),
                Text(
                  getDate(
                    widget.PayLaterXeroxItem["orderDate"],
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
    CurrentUser currentUser = Provider.of<CurrentUser>(context);
    List<dynamic> itemsList = widget.PayLaterXeroxItem["items"];

    List<Widget> itemWidgets = [];

    for (int index = 0; index < itemsList.length; index++) {
      print(itemsList[index]);
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

    Future<void> makePayment() async {
      try {
        var options = {
          "key": "rzp_test_F9dV31vBF1OjLd",
          "amount": widget.PayLaterXeroxItem['totalCost'] * 100,
          "currency": "INR",
          "name": "Dittox", //your business name
          "description": "Test Transaction",
          "orderId": widget.PayLaterXeroxItem['_id'],
          "receipt": "cnlna",
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
        // _razorPay.open(options);
        print("-------------- PAYMENT IS DONE -------------");
      } catch (e) {
        print("ERROR ${e}");
      }
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
                  "Shope Name", widget.PayLaterXeroxItem['storeName']),
              KeyValueOfFeature("Contact-Number",
                  widget.PayLaterXeroxItem['storeContactNumber']),
              KeyValueOfFeature(
                  "Shop Email", widget.PayLaterXeroxItem['storeEmail']),
              KeyValueLong(
                  "Shop Addres", widget.PayLaterXeroxItem['storeAddress']),

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

              KeyValueLong("OrderId", widget.PayLaterXeroxItem['orderId']),
              KeyValueOfFeature("Date Of Order",
                  getDate(widget.PayLaterXeroxItem['orderDate'])),
              // KeyValueLong("Date Of Order",
              //     getDate(widget.historyXeroxItem['orderDate'])),
              KeyValueOfFeature("Total Cost",
                  widget.PayLaterXeroxItem['totalCost'].toString()),
              const SizedBox(
                height: 20,
              ),
              InkWell(
                onTap: () async {
                  await makePayment();
                },
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  // Make the container fill the entire width
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                  decoration: BoxDecoration(
                    color: ColorPallets
                        .deepBlue, // Set the background color to green
                    borderRadius:
                        BorderRadius.circular(10), // Set round borders
                  ),
                  child: const Center(
                    child: Text(
                      "Pay Now",
                      style: TextStyle(
                        color: Colors
                            .white, // Assuming ColorPallets.white is equivalent to Colors.white
                        fontSize: 22,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 15,
              )
            ],
          ),
        ));
  }
}
