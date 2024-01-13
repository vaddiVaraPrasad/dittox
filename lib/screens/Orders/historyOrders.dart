import 'package:flutter/material.dart';

import '../../utils/color_pallets.dart';

class HistoryOrders extends StatefulWidget {
  static const routeName = "/historyOrders";
  const HistoryOrders({super.key});

  @override
  State<HistoryOrders> createState() => _HistoryOrdersState();
}

class _HistoryOrdersState extends State<HistoryOrders> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: ColorPallets.white,
        title: const Text("History Orders"),
      ),
    );
  }
}
