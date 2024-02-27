import "package:flutter/material.dart";
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../providers/current_user.dart';
import '../../utils/color_pallets.dart';
import '../../utils/dynamicSizing.dart';
import '../../widgets/home/inviteCont.dart';
import '../../widgets/home/scanDoc.dart';
import '../../widgets/home/topBar.dart';
import '../../widgets/home/uploadDoc.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = "/homeScreen";
  String accessToken;

  HomeScreen({super.key, required this.accessToken});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isLoading = false;
  late SharedPreferences prefs;
  late String accessToken;

  @override
  Widget build(BuildContext context) {
    CurrentUser curUser = Provider.of(context, listen: true);

    double totalScreenHeight = MediaQuery.of(context).size.height;
    double totalScreenWidth = MediaQuery.of(context).size.width;

    // print(curUser.getUserId);

    if (curUser.getUserId == "Loading...") {
      setState(() {
        isLoading = true;
      });
      curUser.loadUserByAccessToken(widget.accessToken);
      setState(() {
        isLoading = false;
      });
    }
    return Scaffold(
      body: isLoading
          ? const CircularProgressIndicator()
          : Padding(
              padding: const EdgeInsets.only(top: 0, right: 0, left: 0),
              child: Column(
                children: [
                  Expanded(
                    flex: 1,
                    child: Container(
                      color: ColorPallets.deepBlue,
                    ),
                  ),
                  Expanded(
                      flex: 4,
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 0),
                        child: TopCont(
                          cityName: curUser.getPlaceName,
                          ctx: context,
                        ),
                      )),
                  Expanded(
                      flex: 25,
                      child: Container(
                        // margin: const EdgeInsets.symmetric(
                        //     horizontal: 20, vertical: 20),
                        margin: EdgeInsets.symmetric(
                            vertical: calculateDynamicFontSize(
                              totalScreenHeight: totalScreenHeight,
                              totalScreenWidth: totalScreenWidth,
                              currentFontSize: 30,
                              // heightSpecific: true,
                            ),
                            horizontal: calculateDynamicFontSize(
                              totalScreenHeight: totalScreenHeight,
                              totalScreenWidth: totalScreenWidth,
                              currentFontSize: 30,
                              // heightSpecific: false,
                            )),
                        child: Column(
                          children: [
                            const Expanded(flex: 4, child: InviteCont()),
                            SizedBox(
                              // height: 20,
                              height: calculateDynamicFontSize(
                                totalScreenHeight: totalScreenHeight,
                                totalScreenWidth: totalScreenWidth,
                                currentFontSize: 40,
                                // heightSpecific: true,
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                  child: Text(
                                    "Select a Option",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: ColorPallets.black,
                                        // fontSize: 28,
                                        fontSize: calculateDynamicFontSize(
                                          totalScreenHeight: totalScreenHeight,
                                          totalScreenWidth: totalScreenWidth,
                                          currentFontSize: 60,
                                          // heightSpecific: true,
                                        ),
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              // height: 20,
                              height: calculateDynamicFontSize(
                                totalScreenHeight: totalScreenHeight,
                                totalScreenWidth: totalScreenWidth,
                                currentFontSize: 20,
                                // heightSpecific: true,
                              ),
                            ),
                            Expanded(
                                flex: 3,
                                child: UploadDoc(
                                  ctx: context,
                                  accessToken: widget.accessToken,
                                )),
                            SizedBox(
                              // height: 20,
                              height: calculateDynamicFontSize(
                                totalScreenHeight: totalScreenHeight,
                                totalScreenWidth: totalScreenWidth,
                                currentFontSize: 20,
                                // heightSpecific: true,
                              ),
                            ),
                            Expanded(
                                flex: 3,
                                child: ScanDoc(
                                  ctx: context,
                                ))
                          ],
                        ),
                      ))
                ],
              ),
            ),
    );
  }
}
