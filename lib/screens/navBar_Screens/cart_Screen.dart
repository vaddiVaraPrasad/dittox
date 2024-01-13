import "package:flutter/material.dart";

import "../../utils/color_pallets.dart";

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
          onPressed: () {},
          child: const Text("press"),
        ),
      ),
    );
  }
}
