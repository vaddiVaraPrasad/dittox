import "dart:async";

import "package:flutter/material.dart";
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import "package:provider/provider.dart";

import '../../helpers/map_service.dart';
import '../../model/auto_complete_result.dart';
import '../../providers/search_place.dart';
import '../../utils/color_pallets.dart';
import '../../utils/dynamicSizing.dart';
import '../../widgets/maps/buildListTile.dart';

class LocationText extends StatefulWidget {
  static const routeName = "/locationText";
  const LocationText({super.key});

  @override
  State<LocationText> createState() => _LocationTextState();
}

class _LocationTextState extends State<LocationText> {
  var placesSearchController = TextEditingController();
  bool isLoadingTextPage = false;
  Timer? debounce;

  @override
  Widget build(BuildContext context) {
    PlaceResult PlaceProvider = Provider.of<PlaceResult>(context, listen: true);
    double totalScreenHeight = MediaQuery.of(context).size.height;
    double totalScreenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppBar(
          foregroundColor: ColorPallets.white,
          title: const Text(
            "Enter Location!",
          ),
        ),
        body: Container(
          // margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          margin: EdgeInsets.symmetric(
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
          // padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
          child: Column(
            children: [
              TextField(
                autofocus: true,
                showCursor: true,
                cursorHeight: calculateDynamicFontSize(
                  totalScreenHeight: totalScreenHeight,
                  totalScreenWidth: totalScreenWidth,
                  currentFontSize: 50,
                  // heightSpecific: true,
                ),
                cursorWidth: calculateDynamicFontSize(
                  totalScreenHeight: totalScreenHeight,
                  totalScreenWidth: totalScreenWidth,
                  currentFontSize: 5,
                  // heightSpecific: false,,
                ),
                cursorColor: ColorPallets.deepBlue,
                controller: placesSearchController,
                style: TextStyle(
                  // fontSize: 18,
                  fontSize: calculateDynamicFontSize(
                    totalScreenHeight: totalScreenHeight,
                    totalScreenWidth: totalScreenWidth,
                    currentFontSize: 40,
                    // heightSpecific: true,
                  ),
                  color: ColorPallets.deepBlue,
                ),
                decoration: InputDecoration(
                  hintText: "Search by Locality , PinCode or Area",
                  // hintStyle: TextStyle(
                  //   color: ColorPallets.deepBlue,
                  //   fontWeight: FontWeight.w500,
                  //   // fontSize: 16,
                  //   fontSize: calculateDynamicFontSize(
                  //     totalScreenHeight: totalScreenHeight,
                  //     totalScreenWidth: totalScreenWidth,
                  //     currentFontSize: 16,
                  //     // heightSpecific: true,
                  //   ),
                  // ),
                  border: InputBorder.none,
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: placesSearchController.text.isEmpty
                      ? const SizedBox(
                          width: 0,
                        )
                      : Padding(
                          padding: EdgeInsets.only(
                            // top: 10,
                            top: calculateDynamicFontSize(
                              totalScreenHeight: totalScreenHeight,
                              totalScreenWidth: totalScreenWidth,
                              currentFontSize: 40,
                              // heightSpecific: true,
                            ),
                          ),
                          child: IconButton(
                              color: ColorPallets.deepBlue,
                              onPressed: () {
                                placesSearchController.clear();
                              },
                              icon: Icon(
                                FontAwesomeIcons.xmark,
                                // size: 18,
                                size: calculateDynamicFontSize(
                                  totalScreenHeight: totalScreenHeight,
                                  totalScreenWidth: totalScreenWidth,
                                  currentFontSize: 40,
                                  // heightSpecific: true,
                                ),
                              )),
                        ),
                ),
                onChanged: (value) {
                  setState(() {});
                  if (debounce == null) {
                    debounce =
                        Timer(const Duration(milliseconds: 300), () async {
                      if (value.length > 2) {
                        List<AutoCompleteResult> searchResults =
                            await MapServices().searchPlace(value);
                        PlaceProvider.setResult(searchResults);
                      } else {
                        List<AutoCompleteResult> emptyList = [];
                        PlaceProvider.setResult(emptyList);
                      }
                    });
                  } else {
                    if (debounce!.isActive) {
                      debounce!.cancel();
                    }
                    debounce =
                        Timer(const Duration(milliseconds: 300), () async {
                      if (value.length > 2) {
                        List<AutoCompleteResult> searchResults =
                            await MapServices().searchPlace(value);
                        PlaceProvider.setResult(searchResults);
                      } else {
                        List<AutoCompleteResult> emptyList = [];
                        PlaceProvider.setResult(emptyList);
                      }
                    });
                  }
                },
              ),
              isLoadingTextPage
                  ? const Center(
                      child: CircularProgressIndicator(
                          color: ColorPallets.deepBlue),
                    )
                  : PlaceProvider.allreturnedResult.isNotEmpty
                      ? Expanded(
                          child: SizedBox(
                            child: ListView(children: [
                              ...PlaceProvider.allreturnedResult.map((e) =>
                                  buildListTile(
                                      item: e,
                                      ctx: context,
                                      isLoadingTextPage: isLoadingTextPage))
                            ]),
                          ),
                        )
                      : Expanded(
                          child: Center(
                            child: Text(
                              "No Results .... yet",
                              style: TextStyle(
                                // fontSize: 26,
                                fontSize: calculateDynamicFontSize(
                                  totalScreenHeight: totalScreenHeight,
                                  totalScreenWidth: totalScreenWidth,
                                  currentFontSize: 60,
                                  // heightSpecific: true,
                                ),
                              ),
                            ),
                          ),
                        ),
            ],
          ),
        ));
  }
}
