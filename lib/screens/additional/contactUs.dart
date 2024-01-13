import 'package:dittox/utils/color_pallets.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactUs extends StatelessWidget {
  static const routeName = "/contactUs";
  const ContactUs({super.key});

  void launchWebsite() async {
    Uri uri = Uri.https("www.dittox.in");
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not open the map.';
    }
  }

  void launchMail() async {
    Uri uri = Uri(
      scheme: "mailto",
      path: "manjunathdr.cse@bmsce.ac.in",
    );
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not open the map.';
    }
  }

  void launchSms() async {
    final uri = Uri(
      scheme: "sms",
      path: "+919986537604",
    );
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not open the map.';
    }
  }

  void launchPhoneCall() async {
    final uri = Uri(
      scheme: "tel",
      path: "+919986537604",
    );
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not open the map.';
    }
  }

  void lauchWhatsApp() async {
    var phone = "+919986537604";
    var message = "hi";
    final uri =
        Uri.parse("whatsapp://send?phone=$phone&text=${Uri.parse(message)}");
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not open the map.';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: ColorPallets.white,
        title: const Text("Contact Us"),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "DITTOX PRIVATE LIMITED",
              textAlign: TextAlign.start,
              style: TextStyle(color: ColorPallets.deepBlue, fontSize: 24),
            ),
            const SizedBox(
              height: 5,
            ),
            const Divider(
              color: ColorPallets.deepBlue,
              thickness: 1.5,
            ),
            const SizedBox(
              height: 10,
            ),
            const Text(
              "Office Address",
              style: TextStyle(
                fontSize: 20,
                color: ColorPallets.deepBlue,
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            const Text(
              "Webspruce ,1,3rd Floor, LVR ONE, 17th Cross Rd, near Orion Mall, A Block, Milk Colony, 2nd Stage, Rajajinagar, Bengaluru, Karnataka 560010 ",
              maxLines: 5,
            ),
            TextButton.icon(
                onPressed: () {
                  MapsLauncher.launchCoordinates(13.008033, 77.554924);
                },
                icon: const Icon(
                  FontAwesomeIcons.locationArrow,
                  color: ColorPallets.deepBlue,
                ),
                label: const Text(
                  "Visit Our Office",
                  style: TextStyle(color: ColorPallets.deepBlue),
                )),
            const SizedBox(
              height: 20,
            ),
            const Text(
              "Social Media",
              style: TextStyle(
                fontSize: 20,
                color: ColorPallets.deepBlue,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                GestureDetector(
                  onTap: launchMail,
                  child: Container(
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(12)),
                    height: 30,
                    width: 30,
                    child: Image.asset(
                      "assets/image/mail.png",
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: launchPhoneCall,
                  child: Container(
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(12)),
                    height: 30,
                    width: 30,
                    child: Image.asset(
                      "assets/image/phone.png",
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: launchSms,
                  child: Container(
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(12)),
                    height: 30,
                    width: 30,
                    child: Image.asset(
                      "assets/image/text_msg.png",
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: lauchWhatsApp,
                  child: Container(
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(12)),
                    height: 40,
                    width: 40,
                    child: Image.asset(
                      "assets/image/whatsapp.png",
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: launchWebsite,
                  child: Container(
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(12)),
                    height: 40,
                    width: 40,
                    child: Image.asset(
                      "assets/image/chrome.png",
                      fit: BoxFit.cover,
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
