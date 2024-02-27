import 'dart:convert';

import 'package:dittox/model/pdfFile.dart';
import 'package:dittox/utils/color_pallets.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:sn_progress_dialog/sn_progress_dialog.dart';
import 'package:http/http.dart' as http;
import 'package:razorpay_flutter/razorpay_flutter.dart';

import '../../providers/ListOfPdfFiles.dart';
import '../../providers/current_user.dart';
import '../../providers/seletedShop.dart';
import '../../utils/dynamicSizing.dart';
import '../nav_drawers/navBar.dart';

class SummaryScreen extends StatefulWidget {
  static const routeName = "/summary";
  String accessToken;
  SummaryScreen({super.key, required this.accessToken});

  @override
  State<SummaryScreen> createState() => _SummaryScreenState();
}

class _SummaryScreenState extends State<SummaryScreen> {
  bool isUploadingToFirebase = false;
  late Razorpay _razorPay;
  bool isInit = true;

  void _handlePaymentSuccess(
      BuildContext ctx, PaymentSuccessResponse response) {
    // Do something when payment succeeds
    print(
        "<<<<----------------------PAYMENT MADE SUCCESSFULLY----------------------->>>>>>>>>>");
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
    print(
        "<<<<<<--------------------PAYMENT IS FAILURE---------------->>>>>>>>>>>>>");
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
    print(
        "<<<-----------------EXTERNAL WALLET IS SELETED---------------------------->>>>>>>>>>>>>>>>");
  }

  // @override
  // void initState() {
  //   // TODO: implement initState
  //   super.initState();
  //   _razorPay = Razorpay();
  //   _razorPay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
  //   // _razorPay.on(Razorpay.EVENT_PAYMENT_SUCCESS, (response) {
  //   //   _handlePaymentSuccess(context, response);
  //   // });

  //   _razorPay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
  //   _razorPay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  // }

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

  @override
  Widget build(BuildContext context) {
    double totalScreenHeight = MediaQuery.of(context).size.height;
    double totalScreenWidth = MediaQuery.of(context).size.width;

    seletedShop finalShop = Provider.of<seletedShop>(context);
    ListOfPDFFiles listfinalPdfs = Provider.of<ListOfPDFFiles>(context);
    CurrentUser currentUser = Provider.of<CurrentUser>(context);

    Map<String, String> shopDetails = finalShop.shopOrderPreview();

    List<int> extractRangeValues(String rangeString) {
      List<int> result = [];
      // Split the range string by the dash "-"
      List<String> parts = rangeString.split('-');
      // Convert each part to an integer and add it to the result list
      for (String part in parts) {
        result.add(int.parse(part.trim()));
      }
      return result;
    }

    String getColorCode(String input) {
      switch (input.toLowerCase()) {
        case 'black & white':
          return 'bw';
        case 'all color':
          return 'multi';
        case 'partial color':
          return 'colpar';
        default:
          return ''; // or handle the case when the input is not recognized
      }
    }

    List<int> generateColorPageList(String input) {
      List<int> result = [];

      List<String> ranges = input.split(',');

      for (String range in ranges) {
        if (range.contains('-')) {
          List<String> rangeParts = range.split('-');
          int start = int.parse(rangeParts[0]);
          int end = int.parse(rangeParts[1]);
          for (int i = start; i <= end; i++) {
            result.add(i);
          }
        } else {
          result.add(int.parse(range));
        }
      }

      return result;
    }

    String getPaperSize(String input) {
      print("this is input ${input} and ${input.toUpperCase()}");
      switch (input.toUpperCase()) {
        case 'A4':
          return 'a4';
        case 'A5':
          return 'a5';
        case 'LEGAL':
          return 'legal';
        case 'LETTER':
          return 'letter';
        case 'B5':
          return 'b5';
        case 'A6':
          return 'a6';
        case 'POST CARD':
          return 'postCard';
        case '5*7':
          return '5*7';
        case '4*6':
          return '4*6';
        case '3.5*5':
          return '3.5*5';
        default:
          return ''; // or handle the case when the input is not recognized
      }
    }

    String getBindingType(String input) {
      switch (input.toLowerCase()) {
        case 'no binding':
          return 'noBinding';
        case 'staples':
          return 'Staples';
        case 'spiral':
          return 'Spiral';
        case 'stick file':
          return 'Stick File';
        default:
          return ''; // or handle the case when the input is not recognized
      }
    }

    Map<String, dynamic> preparePayLoadForOrder() {
      Map<String, dynamic> payload = {
        "items": [],
        "storeId": finalShop.getSeletedShop().id
      };
      // print(finalShop.getSeletedShop().toMap());
      for (PdfData eachPdf in listfinalPdfs.allPdfList) {
        // print(eachPdf.toMap);
        Map<String, dynamic> eachPDFPayload = {};
        eachPDFPayload["copies"] = eachPdf.copies.toString();
        eachPDFPayload["pageRange"] = extractRangeValues(eachPdf.pageRange);
        eachPDFPayload["sides"] =
            (eachPdf.pdfSides == "Single Side") ? "one" : "both";
        eachPDFPayload["printLayout"] = eachPdf.pdfPrintLayout;
        eachPDFPayload["colors"] = {"color": getColorCode(eachPdf.color)};
        if (getColorCode(eachPdf.color) == "colpar") {
          eachPDFPayload["colorPar"] = {
            "description": "",
            "total": 0,
            "pageNumbers": generateColorPageList(eachPdf.colorParPageNumbers),
          };
        } else {
          eachPDFPayload["colorPar"] = {
            "description": "",
            "total": 0,
            "pageNumbers": [],
          };
        }
        eachPDFPayload["paperSize"] = getPaperSize(eachPdf.paperSize);
        eachPDFPayload["bondPage"] = {
          "selected": eachPdf.bondPages ? "yes" : "no",
          "description": "",
          "total": 0
        };
        eachPDFPayload["binding"] = getBindingType(eachPdf.binding);
        eachPDFPayload["instructions"] = eachPdf.additionDesciption;
        eachPDFPayload["fileName"] = eachPdf.name;
        eachPDFPayload["totalPages"] = eachPdf.totalPages;
        eachPDFPayload["document"] = eachPdf.documents;

        payload["items"].add(eachPDFPayload);
      }
      print(payload);
      return payload;
    }

    Future<void> makePayment() async {
      try {
        final payload = preparePayLoadForOrder();
        String url = 'https://dittox.in/xerox/v1/orders/create';
        Map<String, String> headers = {
          "Content-Type": "application/json",
          "X-auth-token": "bearer ${widget.accessToken}",
        };

        final response = await http.post(
          Uri.parse(url),
          headers: headers,
          body: json.encode(payload),
        );
        Map<String, dynamic> jsonResponse = json.decode(response.body);
        if (response.statusCode == 200) {
          // If the server returns a 200 OK response, parse and print the JSON response
          Map<String, dynamic> jsonResponse = json.decode(response.body);
          if (jsonResponse["responseCode"] == "OK") {
            final orderID = jsonResponse["result"]["_id"];
            final totalCost = jsonResponse['result']['totalCost'];
            var options = {
              "key": "rzp_test_F9dV31vBF1OjLd",
              "amount": totalCost * 100,
              "currency": "INR",
              "name": "Dittox", //your business name
              "description": "Test Transaction",
              "orderId": orderID,
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
            var anotherOptios = {
              "amount": totalCost * 100,
              "orderId": orderID,
            };
            print(options);
            _razorPay.open(options);
            // await Future.delayed(const Duration(seconds: 5), () {
            //   print('After 10 seconds');
            // });
          } else {
            throw Exception(jsonResponse["message"]);
          }
        } else {
          // If the server returns an error response, print the error message
          throw Exception('Error in reaching Server! try again!!');
        }
      } catch (e) {
        print(e);
      }
    }

    return Scaffold(
      appBar: AppBar(
        foregroundColor: ColorPallets.white,
        title: const Text("Order Preview"),
      ),
      body: Container(
        // padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
        padding: EdgeInsets.symmetric(
            vertical: calculateDynamicFontSize(
              totalScreenHeight: totalScreenHeight,
              totalScreenWidth: totalScreenWidth,
              currentFontSize: 40,
              // heightSpecific: true,
            ),
            horizontal: calculateDynamicFontSize(
              totalScreenHeight: totalScreenHeight,
              totalScreenWidth: totalScreenWidth,
              currentFontSize: 30,
              // heightSpecific: false,
            )),
        child: ListView(
          children: [
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
                  fontWeight: FontWeight.bold),
            ),
            Divider(
              color: ColorPallets.deepBlue,
              // thickness: 2,
              thickness: calculateDynamicFontSize(
                totalScreenHeight: totalScreenHeight,
                totalScreenWidth: totalScreenWidth,
                currentFontSize: 4,
                // heightSpecific: true,
              ),
            ),
            for (PdfData eachPdf in listfinalPdfs.allPdfList)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  KeyValueOfFeature(
                      "Pdf File Name",
                      eachPdf.name.split(".")[0].toString(),
                      totalScreenHeight,
                      totalScreenWidth),
                  KeyValueOfFeature("Price ", "Rs ${shopDetails["price"]}",
                      totalScreenHeight, totalScreenWidth),
                  KeyValueOfFeature("No of Copies", eachPdf.copies.toString(),
                      totalScreenHeight, totalScreenWidth),
                  KeyValueOfFeature(
                      "Total No.of Pages",
                      "${eachPdf.totalPages} Pages X ${eachPdf.copies} Copies  ",
                      totalScreenHeight,
                      totalScreenWidth),
                  KeyValueOfFeature("Pages Range", eachPdf.pageRange,
                      totalScreenHeight, totalScreenWidth),
                  KeyValueOfFeature("Page Orientation ", eachPdf.pdfPrintLayout,
                      totalScreenHeight, totalScreenWidth),
                  KeyValueOfFeature("Page Sides", eachPdf.pdfSides,
                      totalScreenHeight, totalScreenWidth),
                  KeyValueOfFeature("Print Type", eachPdf.color,
                      totalScreenHeight, totalScreenWidth),
                  KeyValueOfFeature("Binding Type", eachPdf.binding,
                      totalScreenHeight, totalScreenWidth),
                  eachPdf.bondPages
                      ? KeyValueOfFeature("Bond Pages", "Yes",
                          totalScreenHeight, totalScreenWidth)
                      : KeyValueOfFeature("Bond Pages", "No", totalScreenHeight,
                          totalScreenWidth),
                  eachPdf.color == "Partial Color"
                      ? KeyValueOfFeature(
                          "Color page Range",
                          eachPdf.colorParPageNumbers,
                          totalScreenHeight,
                          totalScreenWidth)
                      : const SizedBox(),
                  eachPdf.additionDesciption.trim() != ""
                      ? KeyValueLong(
                          "Additional Instructions",
                          eachPdf.additionDesciption,
                          totalScreenHeight,
                          totalScreenWidth)
                      : const SizedBox(),
                  // Add more widgets here as needed
                  eachPdf !=
                          listfinalPdfs
                              .allPdfList[listfinalPdfs.allPdfList.length - 1]
                      ? Divider(
                          color: Colors.black54.withOpacity(.2),
                          // thickness: 1,
                          thickness: calculateDynamicFontSize(
                            totalScreenHeight: totalScreenHeight,
                            totalScreenWidth: totalScreenWidth,
                            currentFontSize: 2,
                            // heightSpecific: true,
                          ),
                        )
                      : const SizedBox(),
                  SizedBox(height: 0), // Example spacing between widgets
                ],
              ),
            SizedBox(
              // height: 30,
              height: calculateDynamicFontSize(
                totalScreenHeight: totalScreenHeight,
                totalScreenWidth: totalScreenWidth,
                currentFontSize: 60,
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
                  fontWeight: FontWeight.bold),
            ),
            Divider(
              color: ColorPallets.deepBlue,
              // thickness: 2,
              thickness: calculateDynamicFontSize(
                totalScreenHeight: totalScreenHeight,
                totalScreenWidth: totalScreenWidth,
                currentFontSize: 4,
                // heightSpecific: true,
              ),
            ),
            KeyValueOfFeature("Shope Name", shopDetails["shopName"].toString(),
                totalScreenHeight, totalScreenWidth),
            KeyValueOfFeature(
                "contact Number",
                shopDetails["contactNumber"].toString(),
                totalScreenHeight,
                totalScreenWidth),
            KeyValueOfFeature("Shop Email", shopDetails["shopEmail"].toString(),
                totalScreenHeight, totalScreenWidth),
            KeyValueOfFeature("Distance ", shopDetails["distance"].toString(),
                totalScreenHeight, totalScreenWidth),
            KeyValueOfFeature("Time taken", shopDetails["duration"].toString(),
                totalScreenHeight, totalScreenWidth),
            // KeyValueOfFeature("Shop Addres", shopDetails["shopAddress"].toString()),
            KeyValueLong("Shop Address", shopDetails["shopAddress"].toString(),
                totalScreenHeight, totalScreenWidth),
            SizedBox(
              // height: 90,
              height: calculateDynamicFontSize(
                totalScreenHeight: totalScreenHeight,
                totalScreenWidth: totalScreenWidth,
                currentFontSize: 180,
                // heightSpecific: true,
              ),
            )
          ],
        ),
      ),
      bottomSheet: Container(
        // height: 90,
        height: calculateDynamicFontSize(
          totalScreenHeight: totalScreenHeight,
          totalScreenWidth: totalScreenWidth,
          currentFontSize: 180,
          // heightSpecific: true,
        ),
        padding: EdgeInsets.symmetric(
          // horizontal: 20,
          horizontal: calculateDynamicFontSize(
            totalScreenHeight: totalScreenHeight,
            totalScreenWidth: totalScreenWidth,
            currentFontSize: 40,
            // heightSpecific: true,
          ),
          // vertical: 10,
          vertical: calculateDynamicFontSize(
            totalScreenHeight: totalScreenHeight,
            totalScreenWidth: totalScreenWidth,
            currentFontSize: 20,
            // heightSpecific: false,
          ),
        ),
        decoration: BoxDecoration(
            color: ColorPallets.lightBlue.withOpacity(.1),
            borderRadius: BorderRadius.only(
                // topLeft: Radius.circular(22),
                topLeft: Radius.circular(
                  calculateDynamicFontSize(
                    totalScreenHeight: totalScreenHeight,
                    totalScreenWidth: totalScreenWidth,
                    currentFontSize: 44,
                    // heightSpecific: true,
                  ),
                ),
                // topRight: Radius.circular(22),
                topRight: Radius.circular(
                  calculateDynamicFontSize(
                    totalScreenHeight: totalScreenHeight,
                    totalScreenWidth: totalScreenWidth,
                    currentFontSize: 44,
                    // heightSpecific: true,
                  ),
                )),
            boxShadow: [
              BoxShadow(
                color: ColorPallets.lightBlue.withOpacity(.1),
                // blurRadius: 20,
                blurRadius: calculateDynamicFontSize(
                  totalScreenHeight: totalScreenHeight,
                  totalScreenWidth: totalScreenWidth,
                  currentFontSize: 40,
                  // heightSpecific: true,
                ),
              )
            ]),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
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
            Chip(
              backgroundColor: ColorPallets.deepBlue,
              shape: RoundedRectangleBorder(
                  borderRadius:
                      // BorderRadius.circular(26), // Adjust the radius as needed
                      BorderRadius.circular(
                calculateDynamicFontSize(
                  totalScreenHeight: totalScreenHeight,
                  totalScreenWidth: totalScreenWidth,
                  currentFontSize: 52,
                  // heightSpecific: true,
                ),
              )),
              label: Padding(
                  padding: EdgeInsets.symmetric(
                    // horizontal: 7,
                    horizontal: calculateDynamicFontSize(
                      totalScreenHeight: totalScreenHeight,
                      totalScreenWidth: totalScreenWidth,
                      currentFontSize: 14,
                      // heightSpecific: false,
                    ),
                    // vertical: 10,
                    vertical: calculateDynamicFontSize(
                      totalScreenHeight: totalScreenHeight,
                      totalScreenWidth: totalScreenWidth,
                      currentFontSize: 20,
                      // heightSpecific: true,
                    ),
                  ),
                  child: FittedBox(
                    child: Text(
                      // ignore: unnecessary_brace_in_string_interps
                      "Rs ${shopDetails["price"]}",
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        // fontSize: 22,
                        fontSize: calculateDynamicFontSize(
                          totalScreenHeight: totalScreenHeight,
                          totalScreenWidth: totalScreenWidth,
                          currentFontSize: 44,
                          // heightSpecific: true,
                        ),
                        color: ColorPallets.white,
                      ),
                    ),
                  )),
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
            InkWell(
              onTap: () async {
                setState(() {
                  isUploadingToFirebase = true;
                });
                final pr = ProgressDialog(context: context);

                try {
                  pr.show(
                      max: 100,
                      progressType: ProgressType.valuable,
                      barrierColor: const Color.fromARGB(255, 183, 187, 187)
                          .withOpacity(.9),
                      msgColor: Colors.black,
                      // msgFontSize: 18,
                      msgFontSize: calculateDynamicFontSize(
                        totalScreenHeight: totalScreenHeight,
                        totalScreenWidth: totalScreenWidth,
                        currentFontSize: 36,
                        // heightSpecific: true,
                      ),
                      msgTextAlign: TextAlign.center,
                      progressBgColor: ColorPallets.deepBlue,
                      progressValueColor: Colors.white,
                      msg: "Working on you'r order");
                  await makePayment();
                  // await Future.delayed(Duration(seconds: 10), () {
                  //   print('After 10 seconds');
                  // });
                } catch (e) {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text("Something went wrong !!"),
                        content: Text(e.toString()),
                        actions: [
                          IconButton(
                            onPressed: () => Navigator.of(context).pop(),
                            icon: Icon(
                              FontAwesomeIcons.check,
                              // size: 30,
                              size: calculateDynamicFontSize(
                                totalScreenHeight: totalScreenHeight,
                                totalScreenWidth: totalScreenWidth,
                                currentFontSize: 60,
                                // heightSpecific: true,
                              ),
                            ),
                          )
                        ],
                      );
                    },
                  );
                } finally {
                  setState(() {
                    isUploadingToFirebase = false;
                    pr.close();
                    // await Future.delayed(Duration(seconds: 10), () {
                    //   print('After 10 seconds');
                    // });
                    // Navigator.of(context).pushAndRemoveUntil(
                    //     MaterialPageRoute(
                    //       builder: (ctx) => ButtonNavigationBar(
                    //         accessToken: widget.accessToken,
                    //       ),
                    //     ),
                    //     (route) => false);
                  });
                }
              },
              child: Container(
                  padding: EdgeInsets.symmetric(
                    // vertical: 10,
                    vertical: calculateDynamicFontSize(
                      totalScreenHeight: totalScreenHeight,
                      totalScreenWidth: totalScreenWidth,
                      currentFontSize: 20,
                      // heightSpecific: true,
                    ),
                    // horizontal: 15,
                    horizontal: calculateDynamicFontSize(
                      totalScreenHeight: totalScreenHeight,
                      totalScreenWidth: totalScreenWidth,
                      currentFontSize: 30,
                      // heightSpecific: false,
                    ),
                  ),
                  decoration: BoxDecoration(
                      // color: ColorPallets.deepBlue,
                      borderRadius: BorderRadius.circular(
                    // 18
                    calculateDynamicFontSize(
                      totalScreenHeight: totalScreenHeight,
                      totalScreenWidth: totalScreenWidth,
                      currentFontSize: 36,
                      // heightSpecific: true,
                    ),
                  )),
                  child: Row(
                    children: [
                      FittedBox(
                        child: Text(
                          "Pay",
                          style: TextStyle(
                            // fontSize: 28,
                            fontSize: calculateDynamicFontSize(
                              totalScreenHeight: totalScreenHeight,
                              totalScreenWidth: totalScreenWidth,
                              currentFontSize: 52,
                              // heightSpecific: true,
                            ),
                            fontWeight: FontWeight.bold,
                            color: ColorPallets.deepBlue,
                          ),
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
                      const Icon(
                        FontAwesomeIcons.arrowRight,
                        color: ColorPallets.deepBlue,
                      ),
                    ],
                  )),
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
          ],
        ),
      ),
    );
  }

  Widget KeyValueLong(String key, String value, double totalScreenHeight,
      double totalScreenWidth) {
    return Container(
      padding: EdgeInsets.symmetric(
        // vertical: 7,
        vertical: calculateDynamicFontSize(
          totalScreenHeight: totalScreenHeight,
          totalScreenWidth: totalScreenWidth,
          currentFontSize: 14,
          // heightSpecific: true,
        ),
        // horizontal: 12,
        horizontal: calculateDynamicFontSize(
          totalScreenHeight: totalScreenHeight,
          totalScreenWidth: totalScreenWidth,
          currentFontSize: 24,
          // heightSpecific: false,
        ),
      ),
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
                  // heightSpecific: false,
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
        ),
      ),
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
              maxLines: 10,
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
}
