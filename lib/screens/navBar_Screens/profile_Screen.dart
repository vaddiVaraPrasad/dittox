// import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/material.dart";
import "package:font_awesome_flutter/font_awesome_flutter.dart";
import "package:provider/provider.dart";
// import "package:url_launcher/url_launcher.dart";
// import 'package:app_settings/app_settings.dart';
// import 'package:open_settings/open_settings.dart';

import "../../providers/current_user.dart";
import "../../utils/color_pallets.dart";

class ProfilePage extends StatefulWidget {
  static const routeName = "/profileScreen";
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  double value = 3;

  // void launchWebsite() async {
  //   Uri uri = Uri.https("www.bmsce.ac.in");
  //   if (await canLaunchUrl(uri)) {
  //     await launchUrl(uri);
  //   } else {
  //     throw 'Could not open the map.';
  //   }
  // }

  // void launchMail() async {
  //   Uri uri = Uri(
  //     scheme: "mailto",
  //     path: "varaprasadvaddi04@gmail.com",
  //   );
  //   if (await canLaunchUrl(uri)) {
  //     await launchUrl(uri);
  //   } else {
  //     throw 'Could not open the map.';
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    CurrentUser curUser = Provider.of<CurrentUser>(context);

    return Scaffold(
      body: Center(
        child: Text("profile screen"),
      ),
    );
    // return Scaffold(
    //   appBar: AppBar(
    //     title: const Text(
    //       "User Profile",
    //       textAlign: TextAlign.center,
    //     ),
    //   ),
    //   body: Column(
    //     children: [
    //       const SizedBox(
    //         height: 20,
    //       ),
    //       Container(
    //         padding: const EdgeInsets.only(
    //           top: 10,
    //           bottom: 10,
    //           left: 5,
    //           right: 10,
    //         ),
    //         margin: const EdgeInsets.symmetric(horizontal: 10),
    //         decoration: BoxDecoration(
    //             color: ColorPallets.lightPurplishWhile.withOpacity(.2),
    //             borderRadius: BorderRadius.circular(14)),
    //         child: Row(
    //           children: [
    //             Expanded(
    //                 flex: 3,
    //                 child: Column(
    //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //                   children: [
    //                     Text(
    //                       curUser.getUserName,
    //                       style: const TextStyle(
    //                         color: ColorPallets.deepBlue,
    //                         fontSize: 35,
    //                       ),
    //                       overflow: TextOverflow.ellipsis,
    //                     ),
    //                     const SizedBox(
    //                       height: 30,
    //                     ),
    //                     Text(
    //                       curUser.getUserEmail,
    //                       overflow: TextOverflow.ellipsis,
    //                     )
    //                   ],
    //                 )),
    //             Expanded(
    //                 flex: 2,
    //                 child: CircleAvatar(
    //                   radius: 70,
    //                   backgroundImage: NetworkImage(curUser.getUserProfileUrl),
    //                   backgroundColor:
    //                       ColorPallets.lightPurplishWhile.withOpacity(.2),
    //                 )),
    //             const SizedBox(
    //               width: 10,
    //             )
    //           ],
    //         ),
    //       ),
    //       const SizedBox(
    //         height: 20,
    //       ),
    //       Row(
    //         mainAxisAlignment: MainAxisAlignment.start,
    //         children: const [
    //           SizedBox(
    //             width: 20,
    //           ),
    //           Text(
    //             "Your Information",
    //             textAlign: TextAlign.center,
    //             style: TextStyle(
    //                 color: ColorPallets.black,
    //                 fontSize: 24,
    //                 fontWeight: FontWeight.w500),
    //           ),
    //         ],
    //       ),
    //       const SizedBox(
    //         height: 10,
    //       ),
    //       Expanded(
    //           child: ListView(
    //         children: [
    //           Container(
    //             margin: const EdgeInsets.symmetric(horizontal: 10),
    //             padding:
    //                 const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
    //             decoration: BoxDecoration(
    //                 color: ColorPallets.lightPurplishWhile.withOpacity(.2),
    //                 borderRadius: BorderRadius.circular(14)),
    //             child: ListTile(
    //               onTap: () {
    //                 // AppSettings.openBluetoothSettings();
    //                 // OpenSettings.openNotificationSetting();
    //               },
    //               title: const Text(
    //                 "Notifications",
    //                 style:
    //                     TextStyle(color: ColorPallets.deepBlue, fontSize: 18),
    //               ),
    //               subtitle: const Text(
    //                 "Change the notification setting",
    //                 style: TextStyle(fontSize: 12),
    //               ),
    //               trailing: const Icon(
    //                 FontAwesomeIcons.arrowRight,
    //                 color: ColorPallets.deepBlue,
    //               ),
    //             ),
    //           ),
    //           const SizedBox(
    //             height: 10,
    //           ),
    //           Container(
    //             margin: const EdgeInsets.symmetric(horizontal: 10),
    //             padding:
    //                 const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
    //             decoration: BoxDecoration(
    //                 color: ColorPallets.lightPurplishWhile.withOpacity(.2),
    //                 borderRadius: BorderRadius.circular(14)),
    //             child: ListTile(
    //               onTap: launchMail,
    //               title: const Text(
    //                 "Contact Us",
    //                 style:
    //                     TextStyle(color: ColorPallets.deepBlue, fontSize: 18),
    //               ),
    //               subtitle: const Text(
    //                 "Share your experience , Complaints , Queries about Xerox app",
    //                 maxLines: 3,
    //                 style: TextStyle(fontSize: 12),
    //               ),
    //               trailing: const Icon(
    //                 FontAwesomeIcons.arrowRight,
    //                 color: ColorPallets.deepBlue,
    //               ),
    //             ),
    //           ),
    //           const SizedBox(
    //             height: 10,
    //           ),
    //           Container(
    //             margin: const EdgeInsets.symmetric(horizontal: 10),
    //             padding:
    //                 const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
    //             decoration: BoxDecoration(
    //                 color: ColorPallets.lightPurplishWhile.withOpacity(.2),
    //                 borderRadius: BorderRadius.circular(14)),
    //             child: ListTile(
    //               onTap: () {
    //                 launchWebsite();
    //               },
    //               title: const Text(
    //                 "About Us",
    //                 style:
    //                     TextStyle(color: ColorPallets.deepBlue, fontSize: 18),
    //               ),
    //               subtitle: const Text(
    //                 "Know about Xerox App ",
    //                 maxLines: 3,
    //                 style: TextStyle(fontSize: 12),
    //               ),
    //               trailing: const Icon(
    //                 FontAwesomeIcons.arrowRight,
    //                 color: ColorPallets.deepBlue,
    //               ),
    //             ),
    //           ),
    //           const SizedBox(
    //             height: 10,
    //           ),
    //           Container(
    //             margin: const EdgeInsets.symmetric(horizontal: 10),
    //             padding:
    //                 const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
    //             decoration: BoxDecoration(
    //                 color: ColorPallets.lightPurplishWhile.withOpacity(.2),
    //                 borderRadius: BorderRadius.circular(14)),
    //             child: ListTile(
    //               onTap: () async {
    //                 await FirebaseAuth.instance.signOut();
    //               },
    //               title: const Text(
    //                 "Logout",
    //                 style:
    //                     TextStyle(color: ColorPallets.deepBlue, fontSize: 18),
    //               ),
    //               subtitle: const Text(
    //                 "Logout from device",
    //                 maxLines: 3,
    //                 style: TextStyle(fontSize: 12),
    //               ),
    //               trailing: const Icon(
    //                 FontAwesomeIcons.signOut,
    //                 color: ColorPallets.deepBlue,
    //               ),
    //             ),
    //           ),
    //         ],
    //       ))
    //     ],
    //   ),
    // );
  }
}
