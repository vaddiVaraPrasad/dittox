import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../utils/color_pallets.dart';
import '../../widgets/IconButton.dart';
import '../../widgets/auth/customTandCText.dart';

class TermsAndCond extends StatelessWidget {
  static const routeName = "/tersmandcond";
  const TermsAndCond({super.key});

  Widget KeyValueOfFeature(String key, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 12),
      child: Row(
        children: [
          Expanded(
            child: Text(
              maxLines: 2,
              key,
              style: const TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 18,
                  color: ColorPallets.deepBlue),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          const Text(
            ":",
            style: TextStyle(
              fontSize: 18,
              color: ColorPallets.deepBlue,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(
            width: 20,
          ),
          Expanded(
            child: Text(
              maxLines: 8,
              value,
              style: const TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 18,
                  color: Colors.black54),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget KeyValueLong(String key, String value) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 12),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                maxLines: 2,
                key,
                style: const TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 18,
                    color: ColorPallets.deepBlue),
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(
                width: 10,
              ),
              const Text(":",
                  style: TextStyle(
                    fontSize: 18,
                    color: ColorPallets.deepBlue,
                    fontWeight: FontWeight.w600,
                  ))
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            value,
            maxLines: 10,
            style: const TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 18,
                color: Colors.black54),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Terms & Conditions"),
          foregroundColor: ColorPallets.white,
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
          child: ListView(
            children: [
              KeyValueLong(
                "Acceptance of Terms",
                "By accessing and using Dittox, you acknowledge and agree to the following terms and conditions, which constitute a legally binding agreement between you and I2N Technologies. If you do not agree to these terms, please refrain from using our services.",
              ),
              KeyValueLong(
                "Service Ordering:",
                "Through our app, users can avail online printing services by uploading documents, configuring print options, and viewing pricing from various partnering stores listed on the app.",
              ),
              KeyValueLong("Payment:",
                  "Users are responsible for making prompt and accurate payments for their orders using the payment methods provided within the app"),
              KeyValueLong("Order Pickup:",
                  "Users must ensure timely pickup of their orders from the designated store location after receiving a notification confirming the completion of the printing job."),
              KeyValueLong(
                "User Responsibilities:",
                "Users are obligated to provide accurate and complete information when uploading documents and configuring print options. Users must also adhere to the policies and guidelines of the chosen store and acknowledge that any violation of these policies may affect their order.",
              ),
              KeyValueLong(
                "Intellectual Property:",
                "Users retain ownership of the content they upload through the app for printing purposes. Users understand and agree that they are solely responsible for the content they submit.",
              ),
              KeyValueLong("Limitation of Liability:",
                  "I2N Technologies shall not be held liable for any direct, indirect, incidental, special, or consequential damages arising out of or in connection with the use or inability to use our services."),
              KeyValueLong(
                "Governing Law and Dispute Resolution:",
                "These terms and conditions shall be governed by and construed in accordance with the laws of India. Any dispute arising under or in connection with these terms shall be subject to the exclusive jurisdiction of the courts located in laws of India.",
              ),
              KeyValueLong("Changes to Terms and Conditions",
                  "I2N Technologies reserves the right to update, modify, or change these terms and conditions at any time. Users will be notified of such changes and the revised terms will be accessible within the app."),
            ],
          ),
        ));
  }
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //       body: Column(
  //     children: [
  //       SizedBox(
  //         height: 90,
  //         child: Padding(
  //           padding: const EdgeInsets.symmetric(
  //             vertical: 10,
  //             horizontal: 20,
  //           ),
  //           child: Row(
  //               mainAxisAlignment: MainAxisAlignment.start,
  //               crossAxisAlignment: CrossAxisAlignment.end,
  //               children: [
  //                 CustomIconButton(
  //                   onPressed: () {
  //                     Navigator.of(context).pop();
  //                     ScaffoldMessenger.of(context).clearSnackBars();
  //                   },
  //                   icon: FontAwesomeIcons.chevronLeft,
  //                   iconColor: ColorPallets.white,
  //                   backGroundColor: ColorPallets.deepBlue,
  //                   size: 40,
  //                   iconSize: 16,
  //                 ),
  //                 const Text("Terms and Conditions"),
  //               ]),
  //         ),
  //       ),
  //       Expanded(
  //           child: ListView(
  //         children: [
  //           CustomTandCText(
  //             title: "Acceptance of Terms",
  //             text:
  //                 "By accessing and using Dittox, you acknowledge and agree to the following terms and conditions, which constitute a legally binding agreement between you and I2N Technologies. If you do not agree to these terms, please refrain from using our services.",
  //           ),
  //           CustomTandCText(
  //             title: "Service Ordering:",
  //             text:
  //                 "Through our app, users can avail online printing services by uploading documents, configuring print options, and viewing pricing from various partnering stores listed on the app.",
  //           ),
  //           CustomTandCText(
  //               title: "Payment:",
  //               text:
  //                   "Users are responsible for making prompt and accurate payments for their orders using the payment methods provided within the app"),
  //           CustomTandCText(
  //               title: "Order Pickup:",
  //               text:
  //                   "Users must ensure timely pickup of their orders from the designated store location after receiving a notification confirming the completion of the printing job."),
  //           CustomTandCText(
  //             title: "User Responsibilities:",
  //             text:
  //                 "Users are obligated to provide accurate and complete information when uploading documents and configuring print options. Users must also adhere to the policies and guidelines of the chosen store and acknowledge that any violation of these policies may affect their order.",
  //           ),
  //           CustomTandCText(
  //             title: "Intellectual Property:",
  //             text:
  //                 "Users retain ownership of the content they upload through the app for printing purposes. Users understand and agree that they are solely responsible for the content they submit.",
  //           ),
  //           CustomTandCText(
  //               title: "Limitation of Liability:",
  //               text:
  //                   "I2N Technologies shall not be held liable for any direct, indirect, incidental, special, or consequential damages arising out of or in connection with the use or inability to use our services."),
  //           CustomTandCText(
  //             title: "Governing Law and Dispute Resolution:",
  //             text:
  //                 "These terms and conditions shall be governed by and construed in accordance with the laws of India. Any dispute arising under or in connection with these terms shall be subject to the exclusive jurisdiction of the courts located in laws of India.",
  //           ),
  //           CustomTandCText(
  //               title: "Changes to Terms and Conditions",
  //               text:
  //                   "I2N Technologies reserves the right to update, modify, or change these terms and conditions at any time. Users will be notified of such changes and the revised terms will be accessible within the app."),
  //         ],
  //       ))
  //     ],
  //   ));
  // }
}
