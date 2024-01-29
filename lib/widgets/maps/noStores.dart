import 'package:flutter/material.dart';

import '../../utils/color_pallets.dart';

class NoStoresOrders extends StatelessWidget {
  const NoStoresOrders({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      // mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height * .6,
          width: double.infinity,
          child: Image.asset(
            "assets/image/no_order.png",
            fit: BoxFit.cover,
          ),
        ),
        const Text(
          "Sorry , we are not providing service here",
          textAlign: TextAlign.center,
          style: TextStyle(color: ColorPallets.deepBlue, fontSize: 26),
        ),
        const SizedBox(
          height: 5,
        ),
        const Text(
          "Try any other location where our servcie avilable ",
          style: TextStyle(color: ColorPallets.lightBlue, fontSize: 16),
        ),
      ],
    );
  }
}
