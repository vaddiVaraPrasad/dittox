import "package:flutter/material.dart";
import "../../utils/color_pallets.dart";
import "../../utils/dynamicSizing.dart";

class NetworkError extends StatelessWidget {
  const NetworkError({super.key});

  @override
  Widget build(BuildContext context) {
    double totalScreenHeight = MediaQuery.of(context).size.height;
    double totalScreenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
        body: Column(
      children: [
        const Expanded(flex: 1, child: Text("")),
        Expanded(
            flex: 3,
            child: Image.asset(
              "assets/image/no_connet.png",
              fit: BoxFit.cover,
            )),
        Expanded(
            flex: 2,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  // height: 60,
                  height: calculateDynamicFontSize(
                    totalScreenHeight: totalScreenHeight,
                    totalScreenWidth: totalScreenWidth,
                    currentFontSize: 100,
                    // heightSpecific: true,
                  ),
                ),
                Text(
                  "Connection Lost !!",
                  style: TextStyle(
                    // fontSize: 30,
                    fontSize: calculateDynamicFontSize(
                      totalScreenHeight: totalScreenHeight,
                      totalScreenWidth: totalScreenWidth,
                      currentFontSize: 70,
                      // heightSpecific: true,
                    ),
                    color: ColorPallets.deepBlue,
                  ),
                ),
                SizedBox(
                  // height: 25,
                  height: calculateDynamicFontSize(
                    totalScreenHeight: totalScreenHeight,
                    totalScreenWidth: totalScreenWidth,
                    currentFontSize: 50,
                    // heightSpecific: true,
                  ),
                ),
                Text(
                  "pls check you'r Connection!!",
                  style: TextStyle(
                      color: ColorPallets.pinkinshShadedPurple,
                      // fontSize: 15,
                      fontSize: calculateDynamicFontSize(
                        totalScreenHeight: totalScreenHeight,
                        totalScreenWidth: totalScreenWidth,
                        currentFontSize: 40,
                        // heightSpecific: true,
                      )),
                )
              ],
            ))
      ],
    ));
  }
}
