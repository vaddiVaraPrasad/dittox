import 'package:dittox/utils/color_pallets.dart';
import 'package:flutter/material.dart';

class NotificationPage extends StatelessWidget {
  static const routeName = "/notification page";
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: ColorPallets.white,
      ),
      body: const Center(child: Text("this is notification Page")),
    );
  }
}
