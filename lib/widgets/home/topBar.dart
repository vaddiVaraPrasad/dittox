import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../screens/additional/notifications.dart';
import '../../utils/color_pallets.dart';

import "../../screens/maps/setLocationMaps.dart";
import '../../utils/dynamicSizing.dart';

class TopCont extends StatelessWidget {
  final String cityName;
  final BuildContext ctx;

  const TopCont({
    super.key,
    required this.cityName,
    required this.ctx,
  });

  @override
  Widget build(BuildContext context) {
    double totalScreenHeight = MediaQuery.of(context).size.height;
    double totalScreenWidth = MediaQuery.of(context).size.width;
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: ColorPallets.deepBlue,
        // borderRadius: BorderRadius.only(
        //   bottomLeft: Radius.circular(24),
        //   bottomRight: Radius.circular(24),
        // ),
      ),
      child: Row(
        children: [
          SizedBox(
            // width: 10,
            width: calculateDynamicFontSize(
              totalScreenHeight: totalScreenHeight,
              totalScreenWidth: totalScreenWidth,
              currentFontSize: 30,
              // heightSpecific: false,
            ),
          ),
          Expanded(
            flex: 3,
            child: Padding(
              padding: EdgeInsets.only(
                // top: 9,
                // left: 0,
                top: calculateDynamicFontSize(
                  totalScreenHeight: totalScreenHeight,
                  totalScreenWidth: totalScreenWidth,
                  currentFontSize: 12,
                  // heightSpecific: true,
                ),
              ),
              child: Center(
                  child: Image.asset(
                'assets/image/dittox_home_logo.png',
                fit: BoxFit.contain,
              )),
            ),
          ),
          Expanded(
            flex: 8,
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).pushNamed(setLocationMaps.routeName);
              },
              // padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      // height: 5,
                      height: calculateDynamicFontSize(
                        totalScreenHeight: totalScreenHeight,
                        totalScreenWidth: totalScreenWidth,
                        currentFontSize: 5,
                        // heightSpecific: true,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          // width: 5,
                          width: calculateDynamicFontSize(
                            totalScreenHeight: totalScreenHeight,
                            totalScreenWidth: totalScreenWidth,
                            currentFontSize: 5,
                            // heightSpecific: false,
                          ),
                        ),
                        Text(
                          "Current Location",
                          style: TextStyle(
                            color: Colors.white60,
                            // fontSize: 16,
                            fontSize: calculateDynamicFontSize(
                              totalScreenHeight: totalScreenHeight,
                              totalScreenWidth: totalScreenWidth,
                              currentFontSize: 30,
                              // heightSpecific: true,
                            ),
                          ),
                        ),
                        SizedBox(
                          // width: 5,
                          width: calculateDynamicFontSize(
                            totalScreenHeight: totalScreenHeight,
                            totalScreenWidth: totalScreenWidth,
                            currentFontSize: 10,
                            // heightSpecific: false,
                          ),
                        ),
                        Icon(
                          FontAwesomeIcons.caretDown,
                          color: ColorPallets.white,
                          // size: 18,
                          size: calculateDynamicFontSize(
                            totalScreenHeight: totalScreenHeight,
                            totalScreenWidth: totalScreenWidth,
                            currentFontSize: 30,
                            // heightSpecific: true,
                          ),
                        )
                      ],
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
                      cityName,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: ColorPallets.white,
                        // fontSize: 18,
                        fontSize: calculateDynamicFontSize(
                          totalScreenHeight: totalScreenHeight,
                          totalScreenWidth: totalScreenWidth,
                          currentFontSize: 40,
                          // heightSpecific: true,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          SizedBox(
            width: calculateDynamicFontSize(
              totalScreenHeight: totalScreenHeight,
              totalScreenWidth: totalScreenWidth,
              currentFontSize: 40,
              // heightSpecific: true,
            ),
          ),
          Expanded(
            flex: 2,
            child: InkWell(
              onTap: () {
                Navigator.of(ctx).pushNamed(NotificationPage.routeName);
              },
              // child: CircleAvatar(
              //     backgroundColor: ColorPallets.lightBlue.withOpacity(.5),
              //     child: const Icon(
              //       FontAwesomeIcons.bell,
              //       color: ColorPallets.white,
              //     )),
              child: const SizedBox(),
            ),
          ),
          SizedBox(
            // width: 10,
            width: calculateDynamicFontSize(
              totalScreenHeight: totalScreenHeight,
              totalScreenWidth: totalScreenWidth,
              currentFontSize: 10,
              // heightSpecific: false,
            ),
          )
        ],
      ),
    );
  }
}
