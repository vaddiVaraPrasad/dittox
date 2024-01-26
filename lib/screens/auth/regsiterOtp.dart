import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:pinput/pinput.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../helpers/user_location.dart';
import '../../model/user.dart';
import '../../providers/current_user.dart';
import '../../utils/api_endpoints.dart';
import '../../utils/color_pallets.dart';
import '../../widgets/IconButton.dart';
import '../nav_drawers/navBar.dart';

class RegisterOtp extends StatefulWidget {
  static const routeName = "registerOtp";
  const RegisterOtp({super.key});

  @override
  State<RegisterOtp> createState() => _registerOtpState();
}

class _registerOtpState extends State<RegisterOtp> {
  final pinController = TextEditingController();
  final focusNode = FocusNode();
  final formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  late SharedPreferences prefs;

  @override
  void initState() {
    pinController.addListener(() => setState(() {}));
    initSharePref();
    super.initState();
  }

  @override
  void dispose() {
    pinController.dispose();
    focusNode.dispose();
    super.dispose();
  }

  void initSharePref() async {
    prefs = await SharedPreferences.getInstance();
  }

  Future<void> _createNewUser(
      String userName,
      String userEmail,
      String userPhoneNumber,
      String userPassword,
      String otp,
      CurrentUser currentUser) async {
    focusNode.unfocus();
    bool isValid = true;
    // final isValid = formKey.currentState!.validate();
    if (isValid) {
      setState(() {
        _isLoading = true;
      });
      print("$userName $userEmail , $userPassword , $userPhoneNumber $otp");
      var requestBody = {
        "name": userName.toString(),
        "email": userEmail.toString(),
        "password": userPassword.toString(),
        "otp": otp.toString().trim(),
        "mobile": userPhoneNumber.toString().trim(),
      };
      // print(requestBody);
      var responce = await http.post(
        Uri.parse(ApiEndPoiunts.createUser),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(requestBody),
      );
      var jsonResponce = jsonDecode(responce.body);
      // print(jsonResponce);
      var responseCode = jsonResponce["responseCode"].toString();
      // print(jsonResponce);
      if (responseCode == "OK") {
        var accessToken = jsonResponce["result"]["access_token"].toString();
        prefs.setString("AccessToken", accessToken.toString());
        // print("ADDED ACCESS TOKEN TO SHARED PREFERENCE");
        var userId = jsonResponce["result"]["user"]["_id"].toString();
        Position userCurrentPosition = await UserLocation.getUserLatLong();
        Map<String, dynamic> userPlaceMark =
            await UserLocation.getUserPlaceMarks(
                userCurrentPosition.latitude, userCurrentPosition.longitude);

        var user = Users(
          userId: userId,
          userName: jsonResponce["result"]["user"]["name"].toString(),
          userEmail:
              jsonResponce["result"]["user"]["email"]["address"].toString(),
          userPlaceName: userPlaceMark["locality"],
          latitude: userCurrentPosition.latitude,
          longitude: userCurrentPosition.longitude,
          userPhoneNumber: jsonResponce["result"]["user"]["mobile"].toString(),
          userContryName: userPlaceMark["country"],
          userAccessToken: jsonResponce["result"]["access_token"].toString(),
        );

        currentUser.setCurrentUser(user);

        print(
            "<<<<------------------Provider Map is ------------------------>");
        print(currentUser.getCurrentUserMap);

        print("REGISTED IN SUCCESSULLY");
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (ctx) => ButtonNavigationBar(
                accessToken: accessToken,
              ),
            ),
            (route) => false);
      } else if (responseCode == "CLIENT_ERROR") {
        // show error msg there
        var errorMessage = jsonResponce["message"].toString();

        ScaffoldMessenger.of(context).clearSnackBars();

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: ColorPallets.deepBlue,
            content: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const Icon(
                  FontAwesomeIcons.triangleExclamation,
                  color: Colors.red,
                ),
                Flexible(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      errorMessage,
                      style: const TextStyle(
                        fontSize: 18,
                        fontStyle: FontStyle.normal,
                        color: ColorPallets.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    CurrentUser currUser = Provider.of<CurrentUser>(context, listen: true);
    final defaultPinTheme = PinTheme(
      width: 42,
      height: 50,
      // textStyle: GoogleFonts.poppins(
      //   fontSize: 20,
      //   color: const Color.fromRGBO(70, 69, 66, 1),
      // ),
      textStyle: const TextStyle(fontSize: 20, color: ColorPallets.deepBlue),
      // decoration: BoxDecoration(
      //   color: const Color.fromRGBO(232, 235, 241, 0.37),
      //   borderRadius: BorderRadius.circular(24),
      // ),
      decoration: BoxDecoration(
        // color: const Color.fromARGB(255, 162, 235, 238).withOpacity(.1),
        color: ColorPallets.lightBlue.withOpacity(.1),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: ColorPallets.lightBlue.withOpacity(.2)),
      ),
    );

    final cursor = Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        width: 21,
        height: 1,
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: ColorPallets.deepBlue,
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );

    Map<String, String> myMap =
        ModalRoute.of(context)?.settings.arguments as Map<String, String>;
    String email = myMap["email"].toString();
    String userName = myMap["userName"].toString();
    String password = myMap["password"].toString();
    String otp = myMap["otp"].toString();
    String phoneNumber = myMap["phoneNumber"].toString();

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
                mainAxisAlignment: MainAxisAlignment.start,
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
                  )
                ]),
          ),
        ),
        Expanded(
          flex: 3,
          child: Image.asset(
            "assets/image/otp.png",
            fit: BoxFit.cover,
          ),
        ),
        Expanded(
          flex: 4,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Text(
                    "Enter the OTP\nThat has send to +91-$phoneNumber",
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontSize: 20, color: Color.fromARGB(255, 6, 1, 8)),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Pinput(
                    length: 6,
                    controller: pinController,
                    focusNode: focusNode,
                    validator: (pin) {
                      return pin == otp ? null : "OTP is incorrect";
                    },
                    defaultPinTheme: defaultPinTheme,
                    separatorBuilder: (index) => const SizedBox(width: 5),
                    focusedPinTheme: defaultPinTheme.copyWith(
                      decoration: BoxDecoration(
                        color: ColorPallets.white,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: const [
                          BoxShadow(
                            color: Color.fromRGBO(0, 0, 0, 0.05999999865889549),
                            offset: Offset(0, 3),
                            blurRadius: 16,
                          ),
                        ],
                      ),
                    ),
                    // onClipboardFound: (value) {
                    //   debugPrint('onClipboardFound: $value');
                    //   controller.setText(value);
                    // },
                    errorPinTheme: defaultPinTheme.copyBorderWith(
                      border: Border.all(color: Colors.redAccent),
                    ),
                    onCompleted: (value) {
                      _createNewUser(userName, email, phoneNumber, password,
                          otp, currUser);
                    },
                    showCursor: true,
                    cursor: cursor,
                    onSubmitted: (value) {
                      _createNewUser(userName, email, phoneNumber, password,
                          otp, currUser);
                    },
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  InkWell(
                    onTap: () {
                      _createNewUser(userName, email, phoneNumber, password,
                          otp, currUser);
                    },
                    child: Container(
                      height: 50,
                      width: 180,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: ColorPallets.deepBlue.withOpacity(.9)),
                      child: _isLoading
                          ? const Center(
                              child: CircularProgressIndicator(
                                color: ColorPallets.white,
                              ),
                            )
                          : const Text(
                              "Verity OTP",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: ColorPallets.white,
                                  fontSize: 24,
                                  fontStyle: FontStyle.normal),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        )
      ],
    ));
  }
}
