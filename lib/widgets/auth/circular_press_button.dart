import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import "../../utils/color_pallets.dart";
import '../../utils/dynamicSizing.dart';

class RoundContinueButton extends StatelessWidget {
  final VoidCallback onPressed;
  RoundContinueButton({
    super.key,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    double totalScreenHeight = MediaQuery.of(context).size.height;
    double totalScreenWidth = MediaQuery.of(context).size.width;
    return RawMaterialButton(
      onPressed: onPressed,
      elevation: 2,
      fillColor: ColorPallets.deepBlue,
      splashColor: ColorPallets.darkPurple,
      padding: EdgeInsets.all(
        // 22,
        calculateDynamicFontSize(
          totalScreenHeight: totalScreenHeight,
          totalScreenWidth: totalScreenWidth,
          currentFontSize: 38,
          // heightSpecific: true,
        ),
      ),
      shape: const CircleBorder(),
      // ignore: deprecated_member_use
      child: Icon(
        FontAwesomeIcons.longArrowAltRight,
        color: ColorPallets.white,
        // size: 20,
        size: calculateDynamicFontSize(
          totalScreenHeight: totalScreenHeight,
          totalScreenWidth: totalScreenWidth,
          currentFontSize: 42,
          // heightSpecific: true,
        ),
      ),
    );
  }
}
