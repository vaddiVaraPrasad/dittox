import "package:flutter/material.dart";
import 'package:provider/provider.dart';

import '../../providers/current_user.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = "/homeScreen";

  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    CurrentUser curUser = Provider.of(context, listen: true);
    print(curUser.getPlaceName);
    return Scaffold(
      body: Center(
        child: Text("Home screen"),
      ),
    );
    // if (curUser.getPlaceName == "Loading...") {
    //   setState(() {
    //     isLoading = true;
    //   });
    //   curUser.loadUserByID(FirebaseAuth.instance.currentUser!.uid);
    //   setState(() {
    //     isLoading = false;
    //   });
    // }
    // return Scaffold(
    //   body: isLoading
    //       ? const CircularProgressIndicator()
    //       : Padding(
    //           padding: const EdgeInsets.only(top: 0, right: 0, left: 0),
    //           child: Column(
    //             children: [
    //               Expanded(
    //                 flex: 1,
    //                 child: Container(
    //                   color: ColorPallets.deepBlue,
    //                 ),
    //               ),
    //               Expanded(
    //                   flex: 4,
    //                   child: Container(
    //                     margin: const EdgeInsets.only(bottom: 0),
    //                     child: TopCont(
    //                       cityName: curUser.getPlaceName,
    //                       ctx: context,
    //                     ),
    //                   )),
    //               Expanded(
    //                   flex: 25,
    //                   child: Container(
    //                     margin: const EdgeInsets.symmetric(
    //                         horizontal: 20, vertical: 20),
    //                     child: Column(
    //                       children: [
    //                         const Expanded(flex: 4, child: InviteCont()),
    //                         const SizedBox(
    //                           height: 20,
    //                         ),
    //                         Row(
    //                           mainAxisAlignment: MainAxisAlignment.start,
    //                           children: [
    //                             Container(
    //                               child: const Text(
    //                                 "Select  Option",
    //                                 textAlign: TextAlign.center,
    //                                 style: TextStyle(
    //                                     color: ColorPallets.black,
    //                                     fontSize: 28,
    //                                     fontWeight: FontWeight.w500),
    //                               ),
    //                             ),
    //                           ],
    //                         ),
    //                         const SizedBox(
    //                           height: 20,
    //                         ),
    //                         Expanded(
    //                             flex: 3,
    //                             child: UploadDoc(
    //                               ctx: context,
    //                             )),
    //                         const SizedBox(
    //                           height: 20,
    //                         ),
    //                         Expanded(
    //                             flex: 3,
    //                             child: ScanDoc(
    //                               ctx: context,
    //                             ))
    //                       ],
    //                     ),
    //                   ))
    //             ],
    //           ),
    //         ),
    // );
  }
}
