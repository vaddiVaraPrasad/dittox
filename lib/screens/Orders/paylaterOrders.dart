import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:dittox/utils/color_pallets.dart';
import 'package:flutter/material.dart';

import '../../widgets/Cart/History_item.dart';
import '../../widgets/Cart/no_items.dart';
import '../../widgets/Cart/payLater.dart';

class PayLater extends StatefulWidget {
  static const routeName = "/paylaterOrders";
  String accessToken;
  PayLater({super.key, required this.accessToken});

  @override
  State<PayLater> createState() => _PayLaterState();
}

class _PayLaterState extends State<PayLater> {
  List<dynamic> listOrders = [];
  bool isLoading = false;
  bool isInitState = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (isInitState) {
      _fetchOrders();
    }
    setState(() {
      isInitState = false;
    });
  }

  Future<void> _fetchOrders() async {
    try {
      final result = await ColletHistoryOrders();
      setState(() {
        listOrders = result;
        print("LIST ORDER IS SUCCESSFULLY MAPPED HERE");
      });
      print(listOrders[0]);
      print(listOrders.length);
    } catch (error) {
      // Handle any errors that may occur during the asynchronous operation
      print("Error fetching orders: $error");
    }
  }

  Future<Map<String, dynamic>> getStoreDetails(String storeId) async {
    final String url = 'https://dittox.in/xerox/v1/store/details/$storeId';
    Map<String, dynamic> storeData = {};
    final response = await http.get(
      Uri.parse(url),
      headers: {'X-auth-token': 'bearer ${widget.accessToken}'},
    );
    if (response.statusCode == 200) {
      // If the response code is OK, parse the JSON
      Map<String, dynamic> data = json.decode(response.body);
      if (data['responseCode'] == 'OK') {
        storeData["name"] = data['result']['name'];
        storeData["address"] = data['result']['address'];
        storeData["locationX"] = data['result']['location']['x'];
        storeData["locationY"] = data['result']['location']['y'];
        storeData["email"] = data['result']['meta']['email'];
        storeData["contactNumber"] = data['result']['meta']['contactNumber'];
        storeData["openingTime"] = data['result']['meta']['openingTime'];
        storeData["closingTime"] = data['result']['meta']['closingTime'];

        return storeData;
      } else {
        // If the response code is not OK, raise an error with the message
        throw Exception(data['message']);
      }
    } else {
      // If the server did not return a 200 OK response, throw an exception.
      throw Exception('Failed to load store details');
    }
  }

  String getColorPartialRange(List pageNumber) {
    return pageNumber.join(", ");
  }

  String getColor(String color) {
    if (color == "bw") {
      return "Black & White";
    } else if (color == "multi") {
      return "Color Print";
    } else {
      return "Partial Color";
    }
  }

  Future<List<dynamic>> ColletHistoryOrders() async {
    List<dynamic> allOrder = [];
    try {
      setState(() {
        isLoading = true;
      });

      const String url = 'https://dittox.in/xerox/v1/orders/list';

      final response = await http.get(
        Uri.parse(url),
        headers: {'X-auth-token': 'bearer ${widget.accessToken}'},
      );
      // print(response);

      if (response.statusCode == 200) {
        Map<String, dynamic> data = json.decode(response.body);
        if (data['responseCode'] == 'OK') {
          List<dynamic> orderList = data["result"]["data"];
          for (var eachOrder in orderList) {
            if (eachOrder["orderLater"] == true) {
              Map<String, dynamic> eachOrderWantedData = {};
              eachOrderWantedData["_id"] = eachOrder["_id"];
              eachOrderWantedData["orderId"] = eachOrder["orderId"];
              eachOrderWantedData["orderDate"] = eachOrder["createdAt"];
              eachOrderWantedData["totalPages"] = eachOrder["totalPages"];
              eachOrderWantedData["totalCost"] = eachOrder["totalCost"];
              eachOrderWantedData["status"] = eachOrder["status"];

              eachOrderWantedData["storeId"] = eachOrder["storeId"];
              Map<String, dynamic> shopDetails =
                  await getStoreDetails(eachOrderWantedData["storeId"]);
              eachOrderWantedData["storeName"] = shopDetails["name"];
              eachOrderWantedData["storeAddress"] = shopDetails["address"];
              eachOrderWantedData["storeLocationX"] = shopDetails["locationX"];
              eachOrderWantedData["storeLocationY"] = shopDetails["locationY"];
              eachOrderWantedData["storeEmail"] = shopDetails["email"];
              eachOrderWantedData["storeContactNumber"] =
                  shopDetails["contactNumber"];
              eachOrderWantedData["storeOpeningTime"] =
                  shopDetails["openingTime"];
              eachOrderWantedData["storeClosingTime"] =
                  shopDetails["closingTime"];

              List<dynamic> itemsList = eachOrder["items"];
              eachOrderWantedData["itemsCount"] = itemsList.length;
              List<dynamic> wantedItems = [];
              for (var eachItem in itemsList) {
                Map<String, dynamic> singleItem = {};
                singleItem["downloadUrl"] = eachItem["documents"];
                singleItem["copies"] = eachItem["copies"];
                singleItem["totalPages"] = eachItem["totalPages"];
                singleItem["itemCost"] = eachItem["cost"];
                singleItem["itemColor"] = getColor(eachItem["colors"]["color"]);
                if (eachItem["colors"]["color"] == "colPar") {}
                singleItem["colorPartialPagesList"] =
                    getColorPartialRange(eachItem["colorPar"]["pageNumbers"]);
                singleItem["bondPage"] = eachItem["bondPage"]["seleted"];
                singleItem["paperSize"] = eachItem["paperSize"];
                singleItem["printLayout"] = eachItem["printLayout"];
                singleItem["binding"] = eachItem["binding"];
                singleItem["side"] = eachItem["side"] == "one"
                    ? "single-side Print"
                    : "Both-side Print";
                wantedItems.add(singleItem);
              }
              eachOrderWantedData["items"] = wantedItems;
              allOrder.add(eachOrderWantedData);
              print(eachOrderWantedData);
              print(allOrder.length);
            }
          }
        } else {
          throw Exception(data['message']);
        }
      } else {
        throw Exception('Failed to load store details');
      }
    } catch (e) {
      print("Error $e");
    } finally {
      setState(() {
        isLoading = false;
      });
      return allOrder;
    }
  }

  @override
  Widget build(BuildContext context) {
    // CurrentUser curUSer = Provider.of<CurrentUser>(context);
    // print(curUSer.getUserId);
    return Scaffold(
        appBar: AppBar(
          foregroundColor: ColorPallets.white,
          title: const Text("Pay-Later Orders"),
        ),

        // ),
        body: Container(
          padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 15),
          child: isLoading == true
              ? const Center(
                  child: CircularProgressIndicator(
                    color: ColorPallets.deepBlue,
                  ),
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Flexible(
                      child: listOrders.isEmpty
                          ? const Center(
                              child: NoOrders(),
                            )
                          : ListView.builder(
                              itemCount: listOrders.length,
                              itemBuilder: (context, index) {
                                var eachOrderData = listOrders[index];
                                return PayLaterCard(
                                  PayLaterXeroxItem: eachOrderData,
                                  accessToken: widget.accessToken,
                                );
                                // return SizedBox();
                              }),
                    )
                  ],
                ),
        ));
  }
}
