import "package:dittox/widgets/Cart/no_items.dart";
import "package:flutter/material.dart";
import "package:provider/provider.dart";

import 'dart:convert';
import 'package:http/http.dart' as http;

import "../../providers/current_user.dart";
import "../../utils/color_pallets.dart";
import "../../widgets/Cart/onGoing_xerox_Item.dart";

class CartScreen extends StatefulWidget {
  static const routeName = "/cartScreen";
  String accessToken;
  CartScreen({super.key, required this.accessToken});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  List<dynamic> listOrders = [];
  bool isLoading = false;
  bool isInitState = true;
  // @override
  // void initState() async {
  //   // TODO: implement initState
  //   _fetchOrders();
  //   super.initState();
  // }

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
      final result = await ColletAllOnGoingOrders();
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

  Future<List<dynamic>> ColletAllOnGoingOrders() async {
    // var result = await getStoreDetails("654b3a7a6fbd53e8ae8954b2");
    // print(result);
    List<dynamic> allOrder = [];
    List<dynamic> allIds = [];
    try {
      setState(() {
        isLoading = true;
      });
      print("LIST ORDERS IS CALLED");
      const String url = 'https://dittox.in/xerox/v1/orders/list';

      final response = await http.get(
        Uri.parse(url),
        headers: {'X-auth-token': 'bearer ${widget.accessToken}'},
      );
      print(response);
      // print(response.body);

      if (response.statusCode == 200) {
        // If the response code is OK, parse the JSON
        Map<String, dynamic> data = json.decode(response.body);

        if (data['responseCode'] == 'OK') {
          List<dynamic> orderList = data["result"]["data"];
          for (var eachOrder in orderList) {
            if (eachOrder["orderLater"] == false &&
                eachOrder["status"] != "collected") {
              Map<String, dynamic> eachOrderWantedData = {};

              eachOrderWantedData["orderId"] = eachOrder["orderId"];

              allIds.add(eachOrder["_id"]);

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
                wantedItems.add(singleItem);
              }
              eachOrderWantedData["items"] = wantedItems;
              allOrder.add(eachOrderWantedData);

              print(allOrder.length);
            }
          }
          // If the response code is OK, return the result
        } else {
          // If the response code is not OK, raise an error with the message
          throw Exception(data['message']);
        }
      } else {
        // If the server did not return a 200 OK response, throw an exception.
        throw Exception('Failed to load store details');
      }
    } catch (e) {
      // Handle the exception
      print("Error: $e");
    } finally {
      setState(() {
        isLoading = false;
      });
      // print(allIds);
      return allOrder;
    }
  }

  @override
  Widget build(BuildContext context) {
    CurrentUser curUSer = Provider.of<CurrentUser>(context);
    print(curUSer.getUserId);
    return Scaffold(
        appBar: AppBar(
          foregroundColor: ColorPallets.white,
          title: const Text("On-Going Xerox"),
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
                                return CarrOnGoingItem(
                                  onGoingXeroxItem: eachOrderData,
                                );
                                // return SizedBox();
                              }),
                    )
                  ],
                ),
        ));
  }
}
