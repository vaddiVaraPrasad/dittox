import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../helpers/map_service.dart';
import "../../model/auto_complete_result.dart";
import '../../providers/current_user.dart';
import '../../providers/search_place.dart';
import '../../utils/color_pallets.dart';

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
    CurrentUser curUser = Provider.of<CurrentUser>(context);
    PlaceResult autoComple = Provider.of<PlaceResult>(context);
    double width = MediaQuery.of(context).size.width - 20;
    
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
              margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
              padding:
                  const EdgeInsets.only(left: 15, right: 5, top: 7, bottom: 7),
              child: Column(
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on_outlined,
                        size: 30,
                        color: ColorPallets.deepBlue,
                      ),
                      const SizedBox(
                        width: 15,
                      ),
                      Expanded(
                        // width: width - 120,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              widget.item.structuredFormatting!.mainText
                                  .toString(),
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: ColorPallets.deepBlue,
                                fontSize: 17,
                              ),
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            Text(
                              widget.item.structuredFormatting!.secondaryText
                                  .toString(),
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: ColorPallets.deepBlue,
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                  const Divider(
                    thickness: 2,
                  ),
                ],
              )),
    );
  }
}
