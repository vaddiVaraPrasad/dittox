// import 'package:cloud_firestore/cloud_firestore.dart';
import "package:flutter/material.dart";
// import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';

import '../../providers/current_user.dart';
import '../../utils/color_pallets.dart';
import '../../widgets/Cart/History_item.dart';
import '../../widgets/Cart/no_items.dart';
import '../../widgets/Cart/onGoing_xerox_Item.dart';

class OrderScreen extends StatefulWidget {
  static const routeName = "orderScreen";
  const OrderScreen({super.key});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  @override
  Widget build(BuildContext context) {
    CurrentUser curUSer = Provider.of<CurrentUser>(context);

    return Scaffold(
      body: Center(
        child: Text("hsitory orde3rs"),
      ),
    );

    // return Scaffold(
    //     body: Column(
    //   // crossAxisAlignment: CrossAxisAlignment.start,
    //   children: [
    //     Container(
    //       height: 100,
    //       width: double.infinity,
    //       decoration: const BoxDecoration(
    //         color: ColorPallets.deepBlue,
    //         // borderRadius: BorderRadius.only(
    //         //   bottomLeft: Radius.circular(24),
    //         //   bottomRight: Radius.circular(24),
    //         // ),
    //       ),
    //       child: Column(
    //         mainAxisAlignment: MainAxisAlignment.center,
    //         children: [
    //           const SizedBox(
    //             height: 20,
    //           ),
    //           Row(
    //             mainAxisAlignment: MainAxisAlignment.start,
    //             crossAxisAlignment: CrossAxisAlignment.center,
    //             children: [
    //               const SizedBox(
    //                 width: 20,
    //               ),
    //               IconButton(
    //                 onPressed: () {
    //                   ZoomDrawer.of(context)!.toggle();
    //                 },
    //                 icon: const Icon(
    //                   FontAwesomeIcons.bars,
    //                   color: ColorPallets.white,
    //                 ),
    //               ),
    //               const Text(
    //                 "            History Orders",
    //                 textAlign: TextAlign.center,
    //                 style: TextStyle(color: Colors.white, fontSize: 24),
    //               ),
    //             ],
    //           ),
    //         ],
    //       ),
    //     ),
    //     Flexible(
    //       child: StreamBuilder(
    //         stream: FirebaseFirestore.instance
    //             .collection("Orders")
    //             .where("customerId", isEqualTo: curUSer.getUserId)
    //             .where("orderStatus", isEqualTo: "Collected")
    //             .snapshots(),
    //         builder: (context, snapshot) {
    //           if (snapshot.hasError) {
    //             return const Center(
    //               child: Text("something went wrong in streambuilder"),
    //             );
    //           }
    //           if (snapshot.connectionState == ConnectionState.waiting) {
    //             return const Center(
    //               child: CircularProgressIndicator(),
    //             );
    //           }
    //           if (snapshot.data!.docs.isEmpty) {
    //             return const Center(child: NoOrders());
    //           }
    //           return ListView.builder(
    //             itemCount: snapshot.data!.docs.length,
    //             itemBuilder: (context, index) {
    //               var smth = snapshot.data!.docs[index];
    //               return Container(
    //                 margin: EdgeInsets.only(bottom: 20),
    //                 child: HistoryCard(
    //                   historyXeroxItem: smth.data(),
    //                 ),
    //               );
    //             },
    //           );
    //         },
    //       ),
    //     ),
    //   ],
    // ));
  }
}
