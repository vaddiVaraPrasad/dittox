import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../screens/additional/notifications.dart';
import '../../utils/color_pallets.dart';

import "../../screens/maps/setLocationMaps.dart";

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
          const SizedBox(
            width: 10,
          ),
          Expanded(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.only(top: 9, left: 0),
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
                    const SizedBox(
                      height: 5,
                    ),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          "Current Location",
                          style: TextStyle(color: Colors.white60, fontSize: 16),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Icon(
                          FontAwesomeIcons.caretDown,
                          color: ColorPallets.white,
                          size: 18,
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      cityName,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: ColorPallets.white,
                        fontSize: 18,
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: InkWell(
              onTap: () {
                Navigator.of(ctx).pushNamed(NotificationPage.routeName);
              },
              child: CircleAvatar(
                  backgroundColor: ColorPallets.lightBlue.withOpacity(.5),
                  child: const Icon(
                    FontAwesomeIcons.bell,
                    color: ColorPallets.white,
                  )),
            ),
          ),
          const SizedBox(
            width: 10,
          )
        ],
      ),
    );
  }
}
