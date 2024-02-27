import 'package:flutter/material.dart';

import '../../utils/color_pallets.dart';
import '../../utils/dynamicSizing.dart';

class NoOrders extends StatelessWidget {
  const NoOrders({super.key});

  @override
  Widget build(BuildContext context) {
    double totalScreenHeight = MediaQuery.of(context).size.height;
    double totalScreenWidth = MediaQuery.of(context).size.width;
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
        Text(
          "No On-Going prints ",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: ColorPallets.deepBlue,
            // fontSize: 26,
            fontSize: calculateDynamicFontSize(
              totalScreenHeight: totalScreenHeight,
              totalScreenWidth: totalScreenWidth,
              currentFontSize: 50,
              // heightSpecific: true,
            ),
          ),
        ),
        SizedBox(
          // height: 5,
          height: calculateDynamicFontSize(
            totalScreenHeight: totalScreenHeight,
            totalScreenWidth: totalScreenWidth,
            currentFontSize: 10,
            // heightSpecific: true,
          ),
        ),
        Text(
          "Navigate to Home Screen to place \nPhotoCopy order ",
          textAlign: TextAlign.center,
          style: TextStyle(
              color: ColorPallets.lightBlue,
              // fontSize: 16,
              fontSize: calculateDynamicFontSize(
                totalScreenHeight: totalScreenHeight,
                totalScreenWidth: totalScreenWidth,
                currentFontSize: 35,
                // heightSpecific: true,
              )),
        ),
      ],
    );
  }
}
