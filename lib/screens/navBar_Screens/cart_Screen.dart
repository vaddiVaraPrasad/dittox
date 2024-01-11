import "dart:io";
import 'dart:convert';
import "package:dittox/helpers/sqlLite.dart";
import "package:dittox/providers/ListOfPdfFiles.dart";
import "package:flutter/material.dart";
import "package:get/get.dart";
import "package:provider/provider.dart";
import 'package:http/http.dart' as http;
import 'package:file_picker/file_picker.dart';
import '../../helpers/fileUpload.dart';
// import "../../widgets/Cart/no_items.dart";
import "../../providers/current_user.dart";
import "../../utils/color_pallets.dart";
import "../maps/selectShops.dart";
// import "../../widgets/Cart/no_items.dart";
// import "../../widgets/Cart/onGoing_xerox_Item.dart";

class CartScreen extends StatefulWidget {
  static const routeName = "/cartScreen";
  String accessToken;
  CartScreen({super.key, required this.accessToken});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: ColorPallets.white,
        title: const Text("On-Going Xerox"),
      ),

      // ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            print("this is card screen");
          },
          child: const Text("press"),
        ),
      ),
    );
  }
}
