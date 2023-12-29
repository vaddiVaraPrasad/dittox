import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import "../../utils/color_pallets.dart";

class RoundContinueButton extends StatelessWidget {
  final VoidCallback onPressed;
  RoundContinueButton({
    super.key,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      onPressed: onPressed,
      elevation: 2,
      fillColor: ColorPallets.deepBlue,
      splashColor: ColorPallets.darkPurple,
      padding: const EdgeInsets.all(22),
      shape: const CircleBorder(),
      // ignore: deprecated_member_use
      child: const Icon(
        FontAwesomeIcons.longArrowAltRight,
        color: ColorPallets.white,
        size: 20,
      ),
    );
  }
}
