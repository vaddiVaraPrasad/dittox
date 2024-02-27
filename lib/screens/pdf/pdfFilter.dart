import 'package:dittox/model/pdfFile.dart';
import 'package:dittox/screens/pdf/singlePDfFilter.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../../providers/ListOfPdfFiles.dart';
import '../../providers/ListOfShops.dart';
import '../../utils/color_pallets.dart';
import '../../utils/dynamicSizing.dart';
import '../maps/selectShops.dart';

class PDFFilters extends StatefulWidget {
  static const routeName = "/pdffilters";
  const PDFFilters({super.key});

  @override
  State<PDFFilters> createState() => _PDFFiltersState();
}

class _PDFFiltersState extends State<PDFFilters> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    double totalScreenHeight = MediaQuery.of(context).size.height;
    double totalScreenWidth = MediaQuery.of(context).size.width;
    NearestShop shopsList = Provider.of<NearestShop>(context);
    ListOfPDFFiles pdffileList =
        Provider.of<ListOfPDFFiles>(context, listen: true);
    return Scaffold(
      appBar: AppBar(
          foregroundColor: ColorPallets.white,
          title: const Text(
            "Filter the PDf",
            style: TextStyle(color: ColorPallets.white),
          )),
      body: Container(
        // padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        padding: EdgeInsets.symmetric(
            vertical: calculateDynamicFontSize(
              totalScreenHeight: totalScreenHeight,
              totalScreenWidth: totalScreenWidth,
              currentFontSize: 20,
              // heightSpecific: true,
            ),
            horizontal: calculateDynamicFontSize(
              totalScreenHeight: totalScreenHeight,
              totalScreenWidth: totalScreenWidth,
              currentFontSize: 20,
              // heightSpecific: false,
            )),
        margin: EdgeInsets.only(
          // bottom: 40,
          bottom: calculateDynamicFontSize(
            totalScreenHeight: totalScreenHeight,
            totalScreenWidth: totalScreenWidth,
            currentFontSize: 80,
            // heightSpecific: true,
          ),
        ),
        child: ListView.builder(
          itemCount: pdffileList.allPdfList.length,
          itemBuilder: (BuildContext context, int index) {
            // return pagesExpanded();
            // return EachPDfCustomizations(
            //     pdffileList.allPdfList[index], context, index);
            return SinglePageCustomization(
              index: index,
            );
          },
        ),
      ),
      bottomSheet: Container(
        height: 100,
        // padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        padding: EdgeInsets.symmetric(
            vertical: calculateDynamicFontSize(
              totalScreenHeight: totalScreenHeight,
              totalScreenWidth: totalScreenWidth,
              currentFontSize: 20,
              // heightSpecific: true,
            ),
            horizontal: calculateDynamicFontSize(
              totalScreenHeight: totalScreenHeight,
              totalScreenWidth: totalScreenWidth,
              currentFontSize: 10,
              // heightSpecific: false,
            )),
        decoration: BoxDecoration(
            color: ColorPallets.lightBlue.withOpacity(.1),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(
                // 22,
                calculateDynamicFontSize(
                  totalScreenHeight: totalScreenHeight,
                  totalScreenWidth: totalScreenWidth,
                  currentFontSize: 40,
                  // heightSpecific: true,
                ),
              ),
              topRight: Radius.circular(
                // 22,
                calculateDynamicFontSize(
                  totalScreenHeight: totalScreenHeight,
                  totalScreenWidth: totalScreenWidth,
                  currentFontSize: 40,
                  // heightSpecific: true,
                ),
              ),
            ),
            boxShadow: [
              BoxShadow(
                color: ColorPallets.lightBlue.withOpacity(.1),
                blurRadius: 40,
              )
            ]),
        child: InkWell(
          onTap: () {
            shopsList.emptyList();
            Navigator.of(context).pushReplacementNamed(SelectShops.routeName);
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              FittedBox(
                child: Text(
                  "Procede to select shop",
                  style: TextStyle(
                    // fontSize: 26,
                    fontSize: calculateDynamicFontSize(
                      totalScreenHeight: totalScreenHeight,
                      totalScreenWidth: totalScreenWidth,
                      currentFontSize: 50,
                      // heightSpecific: true,
                    ),
                    color: ColorPallets.deepBlue,
                  ),
                ),
              ),
              SizedBox(
                // width: 15,
                width: calculateDynamicFontSize(
                  totalScreenHeight: totalScreenHeight,
                  totalScreenWidth: totalScreenWidth,
                  currentFontSize: 30,
                  // heightSpecific: false,
                ),
              ),
              const Icon(
                FontAwesomeIcons.arrowRight,
                color: ColorPallets.deepBlue,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
