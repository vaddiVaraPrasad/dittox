// import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/material.dart";
import "package:font_awesome_flutter/font_awesome_flutter.dart";
import "package:provider/provider.dart";
import "package:shared_preferences/shared_preferences.dart";
import "package:url_launcher/url_launcher.dart";
// import 'package:app_settings/app_settings.dart';
// import 'package:open_settings/open_settings.dart';

import "../../providers/current_user.dart";
import "../../utils/color_pallets.dart";
import "../../utils/dynamicSizing.dart";
import "../Orders/historyOrders.dart";
import "../Orders/paylaterOrders.dart";
import "../additional/aboutUs.dart";
import "../additional/contactUs.dart";
import "../auth/auth_screen.dart";

class ProfilePage extends StatefulWidget {
  static const routeName = "/profileScreen";
  String accessToken;
  ProfilePage({super.key, required this.accessToken});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  double value = 3;
  late SharedPreferences prefs;
  bool isLoading = false;

  void initState() {
    initSharePref();
    super.initState();
  }

  void initSharePref() async {
    prefs = await SharedPreferences.getInstance();
  }

  void logout(BuildContext ctx) async {
    print("logout button is pressed");
    setState(() {
      isLoading = true;
    });
    try {
      var result = await prefs.remove("AccessToken");
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (ctx) => const AuthScreen(),
          ),
          (route) => false);
      if (result) {
        print("SUCCESSFULLY LOGOUT !!");
      } else {
        print("UNALBE TO LOGOUT");
      }
    } catch (e) {
      print("error during logout");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    CurrentUser curUser = Provider.of<CurrentUser>(context);
    double totalScreenHeight = MediaQuery.of(context).size.height;
    double totalScreenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        foregroundColor: ColorPallets.white,
        title: const Text(
          "User Profile",
          textAlign: TextAlign.center,
        ),
      ),
      body: Column(
        children: [
          SizedBox(
            // height: 20,
            height: calculateDynamicFontSize(
              totalScreenHeight: totalScreenHeight,
              totalScreenWidth: totalScreenWidth,
              currentFontSize: 50,
              // heightSpecific: true,
            ),
          ),
          Container(
            padding: EdgeInsets.only(
              // top: 10,
              // bottom: 20,
              // left: 5,
              // right: 10,
              top: calculateDynamicFontSize(
                totalScreenHeight: totalScreenHeight,
                totalScreenWidth: totalScreenWidth,
                currentFontSize: 20,
                // heightSpecific: true,
              ),
              bottom: calculateDynamicFontSize(
                totalScreenHeight: totalScreenHeight,
                totalScreenWidth: totalScreenWidth,
                currentFontSize: 40,
                // heightSpecific: true,
              ),
              left: calculateDynamicFontSize(
                totalScreenHeight: totalScreenHeight,
                totalScreenWidth: totalScreenWidth,
                currentFontSize: 10,
                // heightSpecific: false,
              ),
              right: calculateDynamicFontSize(
                totalScreenHeight: totalScreenHeight,
                totalScreenWidth: totalScreenWidth,
                currentFontSize: 20,
                // heightSpecific: false,
              ),
            ),
            margin: EdgeInsets.only(
              // left: 10,
              // right: 10,
              // bottom: 20,
              bottom: calculateDynamicFontSize(
                totalScreenHeight: totalScreenHeight,
                totalScreenWidth: totalScreenWidth,
                currentFontSize: 20,
                // heightSpecific: true,
              ),
              left: calculateDynamicFontSize(
                totalScreenHeight: totalScreenHeight,
                totalScreenWidth: totalScreenWidth,
                currentFontSize: 20,
                // heightSpecific: false,
              ),
              right: calculateDynamicFontSize(
                totalScreenHeight: totalScreenHeight,
                totalScreenWidth: totalScreenWidth,
                currentFontSize: 20,
                // heightSpecific: false,
              ),
            ),
            decoration: BoxDecoration(
                color: ColorPallets.lightPurplishWhile.withOpacity(.2),
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
                    flex: 3,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          curUser.getUserName,
                          style: TextStyle(
                            color: ColorPallets.deepBlue,
                            // fontSize: 35,
                            fontSize: calculateDynamicFontSize(
                              totalScreenHeight: totalScreenHeight,
                              totalScreenWidth: totalScreenWidth,
                              currentFontSize: 60,
                              // heightSpecific: true,
                            ),
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(
                          // height: 10,
                          height: calculateDynamicFontSize(
                            totalScreenHeight: totalScreenHeight,
                            totalScreenWidth: totalScreenWidth,
                            currentFontSize: 15,
                            // heightSpecific: true,
                          ),
                        ),
                        Text(
                          curUser.getUserEmail,
                          overflow: TextOverflow.ellipsis,
                        )
                      ],
                    )),
                const Expanded(
                  flex: 2,
                  child: SizedBox(),
                  // child: CircleAvatar(
                  //   radius: 70,
                  //   // backgroundImage: NetworkImage(curUser.getUserProfileUrl),
                  //   backgroundColor:
                  //       ColorPallets.lightPurplishWhile.withOpacity(.2),
                  // ),
                ),
                // SizedBox(
                //   // width: 10,
                //   width: calculateDynamicFontSize(
                //     totalScreenHeight: totalScreenHeight,
                //     totalScreenWidth: totalScreenWidth,
                //     currentFontSize: 30,
                //     // heightSpecific: false,
                //   ),
                // )
              ],
            ),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                // width: 20,
                width: calculateDynamicFontSize(
                  totalScreenHeight: totalScreenHeight,
                  totalScreenWidth: totalScreenWidth,
                  currentFontSize: 30,
                  // heightSpecific: false,
                ),
              ),
              Text(
                "Your Information",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: ColorPallets.black,
                    // fontSize: 24,
                    fontSize: calculateDynamicFontSize(
                      totalScreenHeight: totalScreenHeight,
                      totalScreenWidth: totalScreenWidth,
                      currentFontSize: 45,
                      // heightSpecific: true,
                    ),
                    fontWeight: FontWeight.w500),
              ),
            ],
          ),
          SizedBox(
            // height: 10,
            height: calculateDynamicFontSize(
              totalScreenHeight: totalScreenHeight,
              totalScreenWidth: totalScreenWidth,
              currentFontSize: 30,
              // heightSpecific: true,
            ),
          ),
          Expanded(
              child: ListView(
            children: [
              Container(
                margin: EdgeInsets.symmetric(
                  // horizontal: 10,
                  horizontal: calculateDynamicFontSize(
                    totalScreenHeight: totalScreenHeight,
                    totalScreenWidth: totalScreenWidth,
                    currentFontSize: 20,
                    // heightSpecific: false,
                  ),
                ),
                // padding:
                //     const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
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
                decoration: BoxDecoration(
                    color: ColorPallets.lightPurplishWhile.withOpacity(.2),
                    borderRadius: BorderRadius.circular(
                      // 14,
                      calculateDynamicFontSize(
                        totalScreenHeight: totalScreenHeight,
                        totalScreenWidth: totalScreenWidth,
                        currentFontSize: 20,
                        // heightSpecific: true,
                      ),
                    )),
                child: ListTile(
                  onTap: () {
                    Navigator.of(context).pushNamed(PayLater.routeName);
                  },
                  title: Text(
                    "PayLater Orders",
                    style: TextStyle(
                      color: ColorPallets.deepBlue,
                      // fontSize: 18,
                      fontSize: calculateDynamicFontSize(
                        totalScreenHeight: totalScreenHeight,
                        totalScreenWidth: totalScreenWidth,
                        currentFontSize: 40,
                        // heightSpecific: true,
                      ),
                    ),
                  ),
                  subtitle: Text(
                    "Make payment for Saved Orders",
                    style: TextStyle(
                      // fontSize: 12,
                      fontSize: calculateDynamicFontSize(
                        totalScreenHeight: totalScreenHeight,
                        totalScreenWidth: totalScreenWidth,
                        currentFontSize: 25,
                        // heightSpecific: true,
                      ),
                    ),
                  ),
                  trailing: const Icon(
                    FontAwesomeIcons.arrowRight,
                    color: ColorPallets.deepBlue,
                  ),
                ),
              ),
              SizedBox(
                // height: 10,
                height: calculateDynamicFontSize(
                  totalScreenHeight: totalScreenHeight,
                  totalScreenWidth: totalScreenWidth,
                  currentFontSize: 20,
                  // heightSpecific: true,
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(
                  // horizontal: 10,
                  horizontal: calculateDynamicFontSize(
                    totalScreenHeight: totalScreenHeight,
                    totalScreenWidth: totalScreenWidth,
                    currentFontSize: 20,
                    // heightSpecific: false,
                  ),
                ),
                // padding:
                //     const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
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
                decoration: BoxDecoration(
                    color: ColorPallets.lightPurplishWhile.withOpacity(.2),
                    borderRadius: BorderRadius.circular(
                      // 14,
                      calculateDynamicFontSize(
                        totalScreenHeight: totalScreenHeight,
                        totalScreenWidth: totalScreenWidth,
                        currentFontSize: 20,
                        // heightSpecific: true,
                      ),
                    )),
                child: ListTile(
                  onTap: () {
                    Navigator.of(context).pushNamed(HistoryOrders.routeName);
                  },
                  title: Text(
                    "History Orders",
                    style: TextStyle(
                      color: ColorPallets.deepBlue,
                      // fontSize: 18,
                      fontSize: calculateDynamicFontSize(
                        totalScreenHeight: totalScreenHeight,
                        totalScreenWidth: totalScreenWidth,
                        currentFontSize: 40,
                        // heightSpecific: true,
                      ),
                    ),
                  ),
                  subtitle: Text(
                    "Find the completed Orders",
                    style: TextStyle(
                      // fontSize: 12,
                      fontSize: calculateDynamicFontSize(
                        totalScreenHeight: totalScreenHeight,
                        totalScreenWidth: totalScreenWidth,
                        currentFontSize: 25,
                        // heightSpecific: true,
                      ),
                    ),
                  ),
                  trailing: const Icon(
                    FontAwesomeIcons.arrowRight,
                    color: ColorPallets.deepBlue,
                  ),
                ),
              ),
              SizedBox(
                // height: 10,
                height: calculateDynamicFontSize(
                  totalScreenHeight: totalScreenHeight,
                  totalScreenWidth: totalScreenWidth,
                  currentFontSize: 20,
                  // heightSpecific: true,
                ),
              ),
              // Container(
              //   margin: EdgeInsets.symmetric(
              //     // horizontal: 10,
              //     horizontal: calculateDynamicFontSize(
              //       totalScreenHeight: totalScreenHeight,
              //       totalScreenWidth: totalScreenWidth,
              //       currentFontSize: 20,
              //       // heightSpecific: false,
              //     ),
              //   ),
              //   // padding:
              //   //     const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              //   padding: EdgeInsets.symmetric(
              //       vertical: calculateDynamicFontSize(
              //         totalScreenHeight: totalScreenHeight,
              //         totalScreenWidth: totalScreenWidth,
              //         currentFontSize: 20,
              //         // heightSpecific: true,
              //       ),
              //       horizontal: calculateDynamicFontSize(
              //         totalScreenHeight: totalScreenHeight,
              //         totalScreenWidth: totalScreenWidth,
              //         currentFontSize: 20,
              //         // heightSpecific: false,
              //       )),
              //   decoration: BoxDecoration(
              //       color: ColorPallets.lightPurplishWhile.withOpacity(.2),
              //       borderRadius: BorderRadius.circular(
              //         // 14,
              //         calculateDynamicFontSize(
              //           totalScreenHeight: totalScreenHeight,
              //           totalScreenWidth: totalScreenWidth,
              //           currentFontSize: 20,
              //           // heightSpecific: true,
              //         ),
              //       )),
              //   child: ListTile(
              //     onTap: () {
              //       // AppSettings.openBluetoothSettings();
              //       // OpenSettings.openNotificationSetting();
              //     },
              //     title: Text(
              //       "Notifications",
              //       style: TextStyle(
              //         color: ColorPallets.deepBlue,
              //         // fontSize: 18,
              //         fontSize: calculateDynamicFontSize(
              //           totalScreenHeight: totalScreenHeight,
              //           totalScreenWidth: totalScreenWidth,
              //           currentFontSize: 40,
              //           // heightSpecific: true,
              //         ),
              //       ),
              //     ),
              //     subtitle: Text(
              //       "Change the notification setting",
              //       style: TextStyle(
              //         // fontSize: 12,
              //         fontSize: calculateDynamicFontSize(
              //           totalScreenHeight: totalScreenHeight,
              //           totalScreenWidth: totalScreenWidth,
              //           currentFontSize: 30,
              //           // heightSpecific: true,
              //         ),
              //       ),
              //     ),
              //     trailing: const Icon(
              //       FontAwesomeIcons.arrowRight,
              //       color: ColorPallets.deepBlue,
              //     ),
              //   ),
              // ),
              SizedBox(
                // height: 10,
                height: calculateDynamicFontSize(
                  totalScreenHeight: totalScreenHeight,
                  totalScreenWidth: totalScreenWidth,
                  currentFontSize: 10,
                  // heightSpecific: true,
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(
                  // horizontal: 10,
                  horizontal: calculateDynamicFontSize(
                    totalScreenHeight: totalScreenHeight,
                    totalScreenWidth: totalScreenWidth,
                    currentFontSize: 20,
                    // heightSpecific: false,
                  ),
                ),
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
                decoration: BoxDecoration(
                    color: ColorPallets.lightPurplishWhile.withOpacity(.2),
                    borderRadius: BorderRadius.circular(
                      // 14,
                      calculateDynamicFontSize(
                        totalScreenHeight: totalScreenHeight,
                        totalScreenWidth: totalScreenWidth,
                        currentFontSize: 20,
                        // heightSpecific: true,
                      ),
                    )),
                child: ListTile(
                  onTap: () {
                    Navigator.of(context).pushNamed(ContactUs.routeName);
                  },
                  title: Text(
                    "Contact Us",
                    style: TextStyle(
                      color: ColorPallets.deepBlue,
                      // fontSize: 18,
                      fontSize: calculateDynamicFontSize(
                        totalScreenHeight: totalScreenHeight,
                        totalScreenWidth: totalScreenWidth,
                        currentFontSize: 40,
                        // heightSpecific: true,
                      ),
                    ),
                  ),
                  subtitle: Text(
                    "Share your experience , Complaints , Queries about Xerox app",
                    maxLines: 3,
                    style: TextStyle(
                      // fontSize: 12,
                      fontSize: calculateDynamicFontSize(
                        totalScreenHeight: totalScreenHeight,
                        totalScreenWidth: totalScreenWidth,
                        currentFontSize: 25,
                        // heightSpecific: true,
                      ),
                    ),
                  ),
                  trailing: const Icon(
                    FontAwesomeIcons.arrowRight,
                    color: ColorPallets.deepBlue,
                  ),
                ),
              ),
              SizedBox(
                // height: 10,
                height: calculateDynamicFontSize(
                  totalScreenHeight: totalScreenHeight,
                  totalScreenWidth: totalScreenWidth,
                  currentFontSize: 20,
                  // heightSpecific: true,
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(
                  // horizontal: 10,
                  horizontal: calculateDynamicFontSize(
                    totalScreenHeight: totalScreenHeight,
                    totalScreenWidth: totalScreenWidth,
                    currentFontSize: 20,
                    // heightSpecific: false,
                  ),
                ),
                // padding:
                //     const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
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
                decoration: BoxDecoration(
                    color: ColorPallets.lightPurplishWhile.withOpacity(.2),
                    borderRadius: BorderRadius.circular(
                        // 14,
                        calculateDynamicFontSize(
                      totalScreenHeight: totalScreenHeight,
                      totalScreenWidth: totalScreenWidth,
                      currentFontSize: 20,
                      // heightSpecific: true,
                    ))),
                child: ListTile(
                  onTap: () {
                    Navigator.of(context).pushNamed(AboutUs.routeName);
                  },
                  title: Text(
                    "About Us",
                    style: TextStyle(
                        color: ColorPallets.deepBlue,
                        // fontSize: 18,
                        fontSize: calculateDynamicFontSize(
                          totalScreenHeight: totalScreenHeight,
                          totalScreenWidth: totalScreenWidth,
                          currentFontSize: 40,
                          // heightSpecific: true,
                        )),
                  ),
                  subtitle: Text(
                    "Know about Xerox App ",
                    maxLines: 3,
                    style: TextStyle(
                        // fontSize: 12,
                        fontSize: calculateDynamicFontSize(
                      totalScreenHeight: totalScreenHeight,
                      totalScreenWidth: totalScreenWidth,
                      currentFontSize: 25,
                      // heightSpecific: true,
                    )),
                  ),
                  trailing: const Icon(
                    FontAwesomeIcons.arrowRight,
                    color: ColorPallets.deepBlue,
                  ),
                ),
              ),
              SizedBox(
                // height: 10,
                height: calculateDynamicFontSize(
                  totalScreenHeight: totalScreenHeight,
                  totalScreenWidth: totalScreenWidth,
                  currentFontSize: 20,
                  // heightSpecific: true,
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(
                    // horizontal: 10,
                    horizontal: calculateDynamicFontSize(
                  totalScreenHeight: totalScreenHeight,
                  totalScreenWidth: totalScreenWidth,
                  currentFontSize: 20,
                  // heightSpecific: true,
                )),
                // padding:
                //     const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
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
                decoration: BoxDecoration(
                    color: ColorPallets.lightPurplishWhile.withOpacity(.2),
                    borderRadius: BorderRadius.circular(
                        // 14,
                        calculateDynamicFontSize(
                      totalScreenHeight: totalScreenHeight,
                      totalScreenWidth: totalScreenWidth,
                      currentFontSize: 20,
                      // heightSpecific: true,
                    ))),
                child: ListTile(
                  onTap: () {
                    setState(() {
                      isLoading = true;
                    });
                    logout(context);
                    setState(() {
                      isLoading = false;
                    });
                  },
                  title: Text(
                    "Logout",
                    style: TextStyle(
                        color: ColorPallets.deepBlue,
                        // fontSize: 18,
                        fontSize: calculateDynamicFontSize(
                          totalScreenHeight: totalScreenHeight,
                          totalScreenWidth: totalScreenWidth,
                          currentFontSize: 40,
                          // heightSpecific: true,
                        )),
                  ),
                  subtitle: Text(
                    "Logout from device",
                    maxLines: 3,
                    style: TextStyle(
                        // fontSize: 12,
                        fontSize: calculateDynamicFontSize(
                      totalScreenHeight: totalScreenHeight,
                      totalScreenWidth: totalScreenWidth,
                      currentFontSize: 25,
                      // heightSpecific: true,
                    )),
                  ),
                  trailing: isLoading
                      ? const CircularProgressIndicator(
                          color: ColorPallets.deepBlue,
                        )
                      : const Icon(
                          FontAwesomeIcons.signOut,
                          color: ColorPallets.deepBlue,
                        ),
                ),
              ),
            ],
          ))
        ],
      ),
    );
  }
}
