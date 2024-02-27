import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../helpers/map_service.dart';
import "../../model/auto_complete_result.dart";
import '../../providers/current_user.dart';
import '../../providers/search_place.dart';
import '../../utils/color_pallets.dart';
import '../../utils/dynamicSizing.dart';

class buildListTile extends StatefulWidget {
  AutoCompleteResult item;
  BuildContext ctx;
  bool isLoadingTextPage;
  buildListTile(
      {super.key,
      required this.item,
      required this.ctx,
      required this.isLoadingTextPage});

  @override
  State<buildListTile> createState() => _buildListTileState();
}

class _buildListTileState extends State<buildListTile> {
  @override
  Widget build(BuildContext context) {
    double totalScreenHeight = MediaQuery.of(context).size.height;
    double totalScreenWidth = MediaQuery.of(context).size.width;
    CurrentUser curUser = Provider.of<CurrentUser>(context);
    PlaceResult autoComple = Provider.of<PlaceResult>(context);

    return GestureDetector(
      onTap: () async {
        setState(() {
          widget.isLoadingTextPage = true;
        });
        FocusScope.of(context).unfocus();
        var res =
            await MapServices().getPlaceDetails(widget.item.placeId.toString());
        curUser.setUserLatitudeLogitude(res["geometry"]["location"]["lat"],
            res["geometry"]["location"]["lng"]);
        curUser.setUserPlaceName(
            widget.item.structuredFormatting!.mainText.toString());
        curUser.setUserContryName("India");
        setState(() {
          widget.isLoadingTextPage = false;
        });
        List<AutoCompleteResult> emptyList = [];
        autoComple.setResult(emptyList);
        // Navigator.of(context)
        //     .popUntil(ModalRoute.withName(setLocationMaps.routeName));
        while (Navigator.canPop(context)) {
          Navigator.of(context).pop();
        }
        autoComple.allreturnedResult = [];
      },
      child: Container(
          margin: EdgeInsets.symmetric(
              // vertical: 5,
              // horizontal: 5,
              vertical: calculateDynamicFontSize(
                totalScreenHeight: totalScreenHeight,
                totalScreenWidth: totalScreenWidth,
                currentFontSize: 10,
                // heightSpecific: true,
              ),
              horizontal: calculateDynamicFontSize(
                totalScreenHeight: totalScreenHeight,
                totalScreenWidth: totalScreenWidth,
                currentFontSize: 5,
                // heightSpecific: false,
              )),
          padding: EdgeInsets.only(
              // left: 15,
              // right: 5,
              // top: 7,
              // bottom: 7,
              bottom: calculateDynamicFontSize(
                totalScreenHeight: totalScreenHeight,
                totalScreenWidth: totalScreenWidth,
                currentFontSize: 15,
                // heightSpecific: true,
              ),
              right: calculateDynamicFontSize(
                totalScreenHeight: totalScreenHeight,
                totalScreenWidth: totalScreenWidth,
                currentFontSize: 10,
                // heightSpecific: false,
              ),
              top: calculateDynamicFontSize(
                totalScreenHeight: totalScreenHeight,
                totalScreenWidth: totalScreenWidth,
                currentFontSize: 15,
                // heightSpecific: true,
              ),
              left: calculateDynamicFontSize(
                totalScreenHeight: totalScreenHeight,
                totalScreenWidth: totalScreenWidth,
                currentFontSize: 30,
                // heightSpecific: false,
              )),
          child: Column(
            children: [
              Row(
                children: [
                  Icon(
                    Icons.location_on_outlined,
                    // size: 30,
                    size: calculateDynamicFontSize(
                      totalScreenHeight: totalScreenHeight,
                      totalScreenWidth: totalScreenWidth,
                      currentFontSize: 40,
                      // heightSpecific: true,
                    ),
                    color: ColorPallets.deepBlue,
                  ),
                  SizedBox(
                    // width: 15,
                    width: calculateDynamicFontSize(
                      totalScreenHeight: totalScreenHeight,
                      totalScreenWidth: totalScreenWidth,
                      currentFontSize: 50,
                      // heightSpecific: false,
                    ),
                  ),
                  Expanded(
                    // width: width - 120,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          widget.item.structuredFormatting!.mainText.toString(),
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              color: ColorPallets.deepBlue,
                              // fontSize: 17,
                              fontSize: calculateDynamicFontSize(
                                totalScreenHeight: totalScreenHeight,
                                totalScreenWidth: totalScreenWidth,
                                currentFontSize: 35,
                                // heightSpecific: true,
                              )),
                        ),
                        SizedBox(
                          // height: 8,
                          height: calculateDynamicFontSize(
                            totalScreenHeight: totalScreenHeight,
                            totalScreenWidth: totalScreenWidth,
                            currentFontSize: 8,
                            // heightSpecific: true,
                          ),
                        ),
                        Text(
                          widget.item.structuredFormatting!.secondaryText
                              .toString(),
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: ColorPallets.deepBlue,
                            fontSize: calculateDynamicFontSize(
                              totalScreenHeight: totalScreenHeight,
                              totalScreenWidth: totalScreenWidth,
                              currentFontSize: 27,
                              // heightSpecific: true,
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
              Divider(
                // thickness: 2,
                thickness: calculateDynamicFontSize(
                  totalScreenHeight: totalScreenHeight,
                  totalScreenWidth: totalScreenWidth,
                  currentFontSize: 2,
                  // heightSpecific: true,
                ),
              ),
            ],
          )),
    );
  }
}
