import 'package:flutter/material.dart';

import '../../utils/color_pallets.dart';
import '../../utils/dynamicSizing.dart';

class InviteCont extends StatelessWidget {
  const InviteCont({super.key});

  @override
  Widget build(BuildContext context) {
    double totalScreenHeight = MediaQuery.of(context).size.height;
    double totalScreenWidth = MediaQuery.of(context).size.width;
    return Container(
      padding: EdgeInsets.all(
        // 5,
        calculateDynamicFontSize(
          totalScreenHeight: totalScreenHeight,
          totalScreenWidth: totalScreenWidth,
          currentFontSize: 15,
          // heightSpecific: true,
        ),
      ),
      decoration: BoxDecoration(
          color: ColorPallets.lightPurplishWhile.withOpacity(.4),
          borderRadius: BorderRadius.circular(
            // 14,
            calculateDynamicFontSize(
              totalScreenHeight: totalScreenHeight,
              totalScreenWidth: totalScreenWidth,
              currentFontSize: 30,
              // heightSpecific: true,
            ),
          )),
      child: Row(
        children: [
          Expanded(flex: 6, child: Image.asset("assets/image/referFriend.png")),
          Expanded(
              flex: 4,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Invite your\nFriend",
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
                        fontWeight: FontWeight.w500),
                  ),
                  SizedBox(
                    // height: 10,
                    height: calculateDynamicFontSize(
                      totalScreenHeight: totalScreenHeight,
                      totalScreenWidth: totalScreenWidth,
                      currentFontSize: 20,
                      // heightSpecific: true,
                    ),
                  ),
                  const Text(
                    "Get Reward of 50 Rs",
                    style: TextStyle(color: ColorPallets.deepBlue),
                  ),
                  SizedBox(
                    // height: 10,
                    height: calculateDynamicFontSize(
                      totalScreenHeight: totalScreenHeight,
                      totalScreenWidth: totalScreenWidth,
                      currentFontSize: 20,
                      // heightSpecific: true,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                        // horizontal: 8,
                        // vertical: 10,
                        vertical: calculateDynamicFontSize(
                          totalScreenHeight: totalScreenHeight,
                          totalScreenWidth: totalScreenWidth,
                          currentFontSize: 20,
                          // heightSpecific: true,
                        ),
                        horizontal: calculateDynamicFontSize(
                          totalScreenHeight: totalScreenHeight,
                          totalScreenWidth: totalScreenWidth,
                          currentFontSize: 15,
                          // heightSpecific: false,
                        )),
                    decoration: BoxDecoration(
                        color: ColorPallets.deepBlue,
                        borderRadius: BorderRadius.circular(
                          // 8,
                          calculateDynamicFontSize(
                            totalScreenHeight: totalScreenHeight,
                            totalScreenWidth: totalScreenWidth,
                            currentFontSize: 14,
                            // heightSpecific: true,
                          ),
                        )),
                    child: Text(
                      "INVITE NOW",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: ColorPallets.white,
                          // fontSize: 20,
                          fontSize: calculateDynamicFontSize(
                            totalScreenHeight: totalScreenHeight,
                            totalScreenWidth: totalScreenWidth,
                            currentFontSize: 34,
                            // heightSpecific: true,
                          ),
                          fontWeight: FontWeight.w500),
                    ),
                  )
                ],
              ))
        ],
      ),
    );
  }
}
