import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// import '../../screens/pdf/images_grid_file.dart';
import '../../screens/pdf/scanImageToPdf.dart';
import '../../utils/color_pallets.dart';
import '../../utils/dynamicSizing.dart';

class ScanDoc extends StatelessWidget {
  final BuildContext ctx;
  const ScanDoc({
    super.key,
    required this.ctx,
  });

  @override
  Widget build(BuildContext context) {
    double totalScreenHeight = MediaQuery.of(context).size.height;
    double totalScreenWidth = MediaQuery.of(context).size.width;
    return InkWell(
      onTap: () {
        Navigator.of(context).pushNamed(ScaneImageToPdf.routeName);
      },
      splashColor: ColorPallets.lightPurple.withOpacity(.3),
      child: Container(
        decoration: BoxDecoration(
            color: ColorPallets.lightPurple.withOpacity(.3),
            borderRadius: BorderRadius.circular(
              // 14,
              calculateDynamicFontSize(
                totalScreenHeight: totalScreenHeight,
                totalScreenWidth: totalScreenWidth,
                currentFontSize: 14,
                // heightSpecific: true,
              ),
            )),
        child: Row(
          children: [
            Expanded(
                flex: 5,
                child: Image.asset(
                  "assets/image/ImageUpload2.png",
                  fit: BoxFit.cover,
                )),
            Expanded(
              flex: 4,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Scan Your \nDocument",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: ColorPallets.deepBlue,
                      // fontSize: 22,
                      fontSize: calculateDynamicFontSize(
                        totalScreenHeight: totalScreenHeight,
                        totalScreenWidth: totalScreenWidth,
                        currentFontSize: 40,
                        // heightSpecific: true,
                      ),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(
                    // height: 10,
                    height: calculateDynamicFontSize(
                      totalScreenHeight: totalScreenHeight,
                      totalScreenWidth: totalScreenWidth,
                      currentFontSize: 10,
                      // heightSpecific: true,
                    ),
                  ),
                  Icon(
                    FontAwesomeIcons.arrowRight,
                    color: ColorPallets.deepBlue,
                    // size: 28,
                    size: calculateDynamicFontSize(
                      totalScreenHeight: totalScreenHeight,
                      totalScreenWidth: totalScreenWidth,
                      currentFontSize: 60,
                      // heightSpecific: true,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
