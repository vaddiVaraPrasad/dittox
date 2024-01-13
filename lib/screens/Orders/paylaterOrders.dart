import 'package:dittox/utils/color_pallets.dart';
import 'package:flutter/material.dart';

class PayLater extends StatefulWidget {
  static const routeName = "/paylaterOrders";
  const PayLater({super.key});

  @override
  State<PayLater> createState() => _PayLaterState();
}

class _PayLaterState extends State<PayLater> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: ColorPallets.white,
        title: const Text("Pay-Later Orders"),
      ),
    );
  }
}
