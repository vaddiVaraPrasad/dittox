import "package:flutter/material.dart";
import "package:provider/provider.dart";

// import "../../widgets/Cart/no_items.dart";
import "../../providers/current_user.dart";
import "../../widgets/Cart/no_items.dart";
import "../../widgets/Cart/onGoing_xerox_Item.dart";

class CartScreen extends StatefulWidget {
  static const routeName = "/cartScreen";
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  bool isPdfLoading = false;

  @override
  Widget build(BuildContext context) {
    CurrentUser curUSer = Provider.of<CurrentUser>(context);
    print(curUSer.getUserId);
    return Scaffold(
      appBar: AppBar(
        title: const Text("On-Going Xerox"),
      ),
      // body: SafeArea(
      //     child: Container(
      //         padding: EdgeInsets.symmetric(horizontal: 3, vertical: 15),
      //         child: Column(
      //           mainAxisAlignment: MainAxisAlignment.start,
      //           children: [
      //             // const Text(
      //             //   "On-Going Xerox",
      //             //   style: TextStyle(
      //             //       fontSize: 28,
      //             //       letterSpacing: 1.5,
      //             //       color: ColorPallets.deepBlue),
      //             //   textAlign: TextAlign.start,
      //             // ),
      //             // const Divider(
      //             //   color: ColorPallets.deepBlue,
      //             //   thickness: 2,
      //             // ),
      //             Flexible(
      //               // child: ListView(
      //               //   children: [],
      //               // ),
      //               child: StreamBuilder(
      //                 stream: FirebaseFirestore.instance
      //                     .collection("Orders")
      //                     .where("customerId", isEqualTo: curUSer.getUserId)
      //                     .where("orderStatus", isNotEqualTo: "Collected")
      //                     .snapshots(),
      //                 builder: (context, snapshot) {
      //                   if (snapshot.hasError) {
      //                     return const Center(
      //                       child:
      //                           Text("something went wrong in streambuilder"),
      //                     );
      //                   }
      //                   if (snapshot.connectionState ==
      //                       ConnectionState.waiting) {
      //                     return const Center(
      //                       child: CircularProgressIndicator(),
      //                     );
      //                   }
      //                   if (snapshot.data!.docs.isEmpty) {
      //                     return const Center(child: NoOrders());
      //                   }
      //                   return ListView.builder(
      //                     itemCount: snapshot.data!.docs.length,
      //                     itemBuilder: (context, index) {
      //                       var smth = snapshot.data!.docs[index];

      //                       return CartItem(
      //                         onGoingXeroxItem: smth.data(),
      //                       );
      //                     },
      //                   );
      //                 },
      //               ),
      //             ),
      //           ],
      //         ))),
      body: const Center(
        child: Text("this is on-going order screen"),
      ),
    );
  }
}
