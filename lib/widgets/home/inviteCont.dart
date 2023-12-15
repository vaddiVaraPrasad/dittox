import 'package:flutter/material.dart';

import '../../utils/color_pallets.dart';

class InviteCont extends StatelessWidget {
  const InviteCont({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
          color: ColorPallets.lightPurplishWhile.withOpacity(.4),
          borderRadius: BorderRadius.circular(14)),
      child: Row(
        children: [
          Expanded(flex: 6, child: Image.asset("assets/image/referFriend.png")),
          Expanded(
              flex: 4,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Invite your\nFriend",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: ColorPallets.deepBlue,
                        fontSize: 26,
                        fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Text(
                    "Get Reward of 50 Rs",
                    style: TextStyle(color: ColorPallets.deepBlue),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                    decoration: BoxDecoration(
                        color: ColorPallets.deepBlue,
                        borderRadius: BorderRadius.circular(8)),
                    child: const Text(
                      "INVITE NOW",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: ColorPallets.white,
                          fontSize: 20,
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
