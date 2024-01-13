import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../utils/color_pallets.dart';
import "../../widgets/IconButton.dart";
import '../../widgets/auth/customTandCText.dart';

class PrivacyPolicy extends StatelessWidget {
  static const routeName = "/privacy policy";

  const PrivacyPolicy({super.key});

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
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        foregroundColor: ColorPallets.white,
        title: Text("Privacy Policy"),
      ),
      body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
          child: ListView(
            children: [
              KeyValueLong(
                "Introduction:",
                "Welcome to Dittox, the online printing service app. This policy explains how we collect, use, and protect your personal information.",
              ),
              KeyValueLong(
                "Information We Collect:",
                "When you use our app, we collect personal information such as your name, email, phone number, uploaded documents, printing preferences, payment details, and location for delivery purposes.",
              ),
              KeyValueLong(
                "How We Use Your Information:",
                "We use your information to process your orders, calculate printing prices, facilitate communication between you and vendors, handle payments, and enhance app performance.",
              ),
              KeyValueLong("Sharing Information with Vendors:",
                  "To fulfil your printing orders, we share specific details like document content, printing preferences, and delivery location with our vendors. We do not share sensitive payment information with vendors."),
              KeyValueLong(
                "Data Security Measures:",
                "Your data's security is a priority. We employ encryption, secure servers, access controls, and regular security assessments to safeguard your personal information.",
              ),
              KeyValueLong(
                "Vendor Payments:",
                "Your payment information is securely processed and stored only for financial transactions related to the app's services.",
              ),
              KeyValueLong("Your Control Over Information:",
                  "You can access, modify, or delete your personal information through your account settings. You can also opt out of promotional communications."),
              KeyValueLong(
                "Cookies and Analytics:",
                "We use cookies and tracking technologies for analytics and app performance optimization. You can manage your cookie preferences through your device settings",
              ),
              KeyValueLong("Third-Party Services:",
                  "We integrate third-party services such as payment processors for seamless transactions. Refer to their privacy policies for information on their data handling practices."),
              KeyValueLong(
                "Changes to Our Policy:",
                "We may update this policy as our services evolve. You'll be notified of any changes through app notifications or email.",
              ),
              KeyValueLong(
                "Contact Us:",
                "If you have questions or concerns about your privacy, please contact us at I2N Technologies, 1869, 38th A cross, 11th Main, Jayanagar, Bangalore-560041. Ph.No : 9986537604.",
              )
            ],
          )),
    );
  }
}
