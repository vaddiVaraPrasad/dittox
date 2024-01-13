import "package:flutter/material.dart";
// import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:line_icons/line_icons.dart';

import '../../utils/color_pallets.dart';

class AboutUs extends StatelessWidget {
  static const routeName = "/abouUs";
  const AboutUs({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          AppBar(foregroundColor: ColorPallets.white, title: Text("About Us")),
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 25),
        child: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "DITTOX PRIVATE LIMITED",
              textAlign: TextAlign.start,
              style: TextStyle(color: ColorPallets.deepBlue, fontSize: 24),
            ),
            Divider(
              color: ColorPallets.deepBlue,
              thickness: 1.5,
            ),
            SizedBox(
              height: 10,
            ),
            Text(
                "Zomato was founded as FoodieBay in 2008 by Deepinder Goyal and Pankaj Chaddah who worked for Bain & Company. The website started as a restaurant listing and recommendation portal. They renamed the company Zomato in 2010 as they were unsure if they would "),
          ],
        ),
      ),
    );
  }
}
