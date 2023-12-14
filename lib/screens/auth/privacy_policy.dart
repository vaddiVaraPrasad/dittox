import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../utils/color_pallets.dart';
import "../../widgets/IconButton.dart";
import '../../widgets/auth/customTandCText.dart';

class PrivacyPolicy extends StatelessWidget {
  static const routeName = "/privacy policy";

  const PrivacyPolicy({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        SizedBox(
          height: 90,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 10,
              horizontal: 20,
            ),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  CustomIconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      ScaffoldMessenger.of(context).clearSnackBars();
                    },
                    icon: FontAwesomeIcons.chevronLeft,
                    iconColor: ColorPallets.white,
                    backGroundColor: ColorPallets.deepBlue,
                    size: 40,
                    iconSize: 16,
                  ),
                  const Expanded(
                      child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: -100),
                        child: const Text(
                          "Privacy Policy",
                          style: TextStyle(),
                        ),
                      )
                    ],
                  ))
                ]),
          ),
        ),
        Expanded(
            child: ListView(
          children: [
            CustomTandCText(
              title: "Introduction:",
              text:
                  "Welcome to Dittox, the online printing service app. This policy explains how we collect, use, and protect your personal information.",
            ),
            CustomTandCText(
              title: "Information We Collect:",
              text:
                  "When you use our app, we collect personal information such as your name, email, phone number, uploaded documents, printing preferences, payment details, and location for delivery purposes.",
            ),
            CustomTandCText(
              title: "How We Use Your Information:",
              text:
                  "We use your information to process your orders, calculate printing prices, facilitate communication between you and vendors, handle payments, and enhance app performance.",
            ),
            CustomTandCText(
                title: "Sharing Information with Vendors:",
                text:
                    "To fulfil your printing orders, we share specific details like document content, printing preferences, and delivery location with our vendors. We do not share sensitive payment information with vendors."),
            CustomTandCText(
              title: "Data Security Measures:",
              text:
                  "Your data's security is a priority. We employ encryption, secure servers, access controls, and regular security assessments to safeguard your personal information.",
            ),
            CustomTandCText(
              title: "Vendor Payments:",
              text:
                  "Your payment information is securely processed and stored only for financial transactions related to the app's services.",
            ),
            CustomTandCText(
                title: "Your Control Over Information:",
                text:
                    "You can access, modify, or delete your personal information through your account settings. You can also opt out of promotional communications."),
            CustomTandCText(
              title: "Cookies and Analytics:",
              text:
                  "We use cookies and tracking technologies for analytics and app performance optimization. You can manage your cookie preferences through your device settings",
            ),
            CustomTandCText(
                title: "Third-Party Services:",
                text:
                    "We integrate third-party services such as payment processors for seamless transactions. Refer to their privacy policies for information on their data handling practices."),
            CustomTandCText(
              title: "Changes to Our Policy:",
              text:
                  "We may update this policy as our services evolve. You'll be notified of any changes through app notifications or email.",
            ),
            CustomTandCText(
              title: "Contact Us:",
              text:
                  "If you have questions or concerns about your privacy, please contact us at I2N Technologies, 1869, 38th A cross, 11th Main, Jayanagar, Bangalore-560041. Ph.No : 9986537604.",
            )
          ],
        ))
      ],
    ));
  }
}
