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
          const SizedBox(
            height: 20,
          ),
          Container(
            padding: const EdgeInsets.only(
              top: 10,
              bottom: 20,
              left: 5,
              right: 10,
            ),
            margin: const EdgeInsets.only(left: 10, right: 10, bottom: 20),
            decoration: BoxDecoration(
                color: ColorPallets.lightPurplishWhile.withOpacity(.2),
                borderRadius: BorderRadius.circular(14)),
            child: Row(
              children: [
                Expanded(
                    flex: 3,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          curUser.getUserName,
                          style: const TextStyle(
                            color: ColorPallets.deepBlue,
                            fontSize: 35,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(
                          height: 10,
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
                const SizedBox(
                  width: 10,
                )
              ],
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          const Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                width: 20,
              ),
              Text(
                "Your Information",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: ColorPallets.black,
                    fontSize: 24,
                    fontWeight: FontWeight.w500),
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Expanded(
              child: ListView(
            children: [
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 10),
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                decoration: BoxDecoration(
                    color: ColorPallets.lightPurplishWhile.withOpacity(.2),
                    borderRadius: BorderRadius.circular(14)),
                child: ListTile(
                  onTap: () {
                    Navigator.of(context).pushNamed(PayLater.routeName);
                  },
                  title: const Text(
                    "PayLater Orders",
                    style:
                        TextStyle(color: ColorPallets.deepBlue, fontSize: 18),
                  ),
                  subtitle: const Text(
                    "Make payment for Saved Orders",
                    style: TextStyle(fontSize: 12),
                  ),
                  trailing: const Icon(
                    FontAwesomeIcons.arrowRight,
                    color: ColorPallets.deepBlue,
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 10),
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                decoration: BoxDecoration(
                    color: ColorPallets.lightPurplishWhile.withOpacity(.2),
                    borderRadius: BorderRadius.circular(14)),
                child: ListTile(
                  onTap: () {
                    Navigator.of(context).pushNamed(HistoryOrders.routeName);
                  },
                  title: const Text(
                    "History Orders",
                    style:
                        TextStyle(color: ColorPallets.deepBlue, fontSize: 18),
                  ),
                  subtitle: const Text(
                    "Find the completed Orders",
                    style: TextStyle(fontSize: 12),
                  ),
                  trailing: const Icon(
                    FontAwesomeIcons.arrowRight,
                    color: ColorPallets.deepBlue,
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 10),
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                decoration: BoxDecoration(
                    color: ColorPallets.lightPurplishWhile.withOpacity(.2),
                    borderRadius: BorderRadius.circular(14)),
                child: ListTile(
                  onTap: () {
                    // AppSettings.openBluetoothSettings();
                    // OpenSettings.openNotificationSetting();
                  },
                  title: const Text(
                    "Notifications",
                    style:
                        TextStyle(color: ColorPallets.deepBlue, fontSize: 18),
                  ),
                  subtitle: const Text(
                    "Change the notification setting",
                    style: TextStyle(fontSize: 12),
                  ),
                  trailing: const Icon(
                    FontAwesomeIcons.arrowRight,
                    color: ColorPallets.deepBlue,
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 10),
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                decoration: BoxDecoration(
                    color: ColorPallets.lightPurplishWhile.withOpacity(.2),
                    borderRadius: BorderRadius.circular(14)),
                child: ListTile(
                  onTap: () {
                    Navigator.of(context).pushNamed(ContactUs.routeName);
                  },
                  title: const Text(
                    "Contact Us",
                    style:
                        TextStyle(color: ColorPallets.deepBlue, fontSize: 18),
                  ),
                  subtitle: const Text(
                    "Share your experience , Complaints , Queries about Xerox app",
                    maxLines: 3,
                    style: TextStyle(fontSize: 12),
                  ),
                  trailing: const Icon(
                    FontAwesomeIcons.arrowRight,
                    color: ColorPallets.deepBlue,
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 10),
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                decoration: BoxDecoration(
                    color: ColorPallets.lightPurplishWhile.withOpacity(.2),
                    borderRadius: BorderRadius.circular(14)),
                child: ListTile(
                  onTap: () {
                    Navigator.of(context).pushNamed(AboutUs.routeName);
                  },
                  title: const Text(
                    "About Us",
                    style:
                        TextStyle(color: ColorPallets.deepBlue, fontSize: 18),
                  ),
                  subtitle: const Text(
                    "Know about Xerox App ",
                    maxLines: 3,
                    style: TextStyle(fontSize: 12),
                  ),
                  trailing: const Icon(
                    FontAwesomeIcons.arrowRight,
                    color: ColorPallets.deepBlue,
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 10),
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                decoration: BoxDecoration(
                    color: ColorPallets.lightPurplishWhile.withOpacity(.2),
                    borderRadius: BorderRadius.circular(14)),
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
                  title: const Text(
                    "Logout",
                    style:
                        TextStyle(color: ColorPallets.deepBlue, fontSize: 18),
                  ),
                  subtitle: const Text(
                    "Logout from device",
                    maxLines: 3,
                    style: TextStyle(fontSize: 12),
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
