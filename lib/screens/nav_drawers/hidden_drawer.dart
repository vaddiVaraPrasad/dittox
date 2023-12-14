// import "package:dittox/screens/nav_drawers/drawers_screen.dart";
// import "package:flutter/material.dart";
// import 'package:flutter_zoom_drawer/config.dart';
// import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
// import "package:provider/provider.dart";

// import "../../providers/current_user.dart";
// import "../../utils/color_pallets.dart";
// import "./drawer_screen.dart";

// import "../drawer_Screens/ContactUs.dart";
// import "../drawer_Screens/about_us_Screen.dart";
// import '../drawer_Screens/history_order_screen.dart';

// import "./navBar.dart";

// class HiddenSideZoomDrawer extends StatefulWidget {
//   static const routeName = "hiddenZoomDrawer";

//   const HiddenSideZoomDrawer({
//     super.key,
//   });

//   @override
//   State<HiddenSideZoomDrawer> createState() => _HiddenSideZoomDrawerState();
// }

// class _HiddenSideZoomDrawerState extends State<HiddenSideZoomDrawer> {
//   var currentItem = MenuItems.home;
//   bool isLoading = false;
//   @override
//   Widget build(BuildContext context) {
//     var curUser = Provider.of<CurrentUser>(context, listen: true);
//     print(curUser.getPlaceName);
//     if (curUser.getPlaceName == "Loading...") {
//       setState(() {
//         isLoading = true;
//       });
//       // curUser.loadUserByID(FirebaseAuth.instance.currentUser!.uid);
//       setState(() {
//         isLoading = false;
//       });
//     }
//     return Scaffold(
//       body: ZoomDrawer(
//         menuBackgroundColor: ColorPallets.lightPurplishWhile.withOpacity(.7),
//         borderRadius: 28,
//         style: DrawerStyle.defaultStyle,
//         angle: -10,
//         openCurve: Curves.fastOutSlowIn,
//         closeCurve: Curves.linearToEaseOut,
//         slideWidth: MediaQuery.of(context).size.width * 0.6,
//         mainScreen: getScreen(),
//         menuScreen: Builder(builder: (context) {
//           return isLoading
//               ? const CircularProgressIndicator()
//               : DrawerScreen(
//                   currentItem: currentItem,
//                   userName: curUser.getUserName,
//                   // userProfileUrl: curUser.getUserProfileUrl,
//                   onSelectedItems: (item) {
//                     setState(() {
//                       currentItem = item;
//                       // ZoomDrawer.of(context)!.close();
//                     });
//                   },
//                 );
//         }),
//       ),
//     );
//   }

//   Widget getScreen() {
//     if (currentItem == MenuItems.home) {
//       return const ButtonNavigationBar();
//     } else if (currentItem == MenuItems.orders) {
//       return const OrderScreen();
//     } else if (currentItem == MenuItems.contactUs) {
//       return const ContactUs();
//     } else {
//       return const AboutUs();
//     }
//   }
// }
