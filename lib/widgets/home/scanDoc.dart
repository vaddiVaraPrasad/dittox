import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// import '../../screens/pdf/images_grid_file.dart';
import '../../screens/pdf/scanImageToPdf.dart';
import '../../utils/color_pallets.dart';

class ScanDoc extends StatelessWidget {
  final BuildContext ctx;
  const ScanDoc({
    super.key,
    required this.ctx,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).pushNamed(ScaneImageToPdf.routeName);
      },
      splashColor: ColorPallets.lightPurple.withOpacity(.3),
      child: Container(
        decoration: BoxDecoration(
            color: ColorPallets.lightPurple.withOpacity(.3),
            borderRadius: BorderRadius.circular(14)),
        child: Row(
          children: [
            Expanded(
                flex: 5,
                child: Image.asset(
                  "assets/image/ImageUpload2.png",
                  fit: BoxFit.cover,
                )),
            const Expanded(
              flex: 4,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text(
                    "Scan Your \nDocument",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: ColorPallets.deepBlue,
                      fontSize: 22,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Icon(
                    FontAwesomeIcons.arrowRight,
                    color: ColorPallets.deepBlue,
                    size: 28,
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
