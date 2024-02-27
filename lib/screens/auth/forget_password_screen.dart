import 'dart:convert';

import 'package:dittox/screens/auth/forgetPasswordOTP.dart';
import "package:flutter/material.dart";
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import '../../utils/api_endpoints.dart';
import '../../utils/color_pallets.dart';

import '../../utils/dynamicSizing.dart';
import "../../widgets/IconButton.dart";

class ForgetPasswordScreen extends StatefulWidget {
  static const routeName = "/forgetPassword";
  const ForgetPasswordScreen({super.key});

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  final phoneNumberController = TextEditingController();

  bool _isLoading = false;
  @override
  void dispose() {
    phoneNumberController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    phoneNumberController.addListener(() => setState(() {}));
    super.initState();
  }

  Future<void> sendOtpToPhoneNumber(
      double totalScreenHeight, double totalScreenWidth) async {
    setState(() {
      _isLoading = true;
    });
    try {
      var requestBody = {
        "mobile": phoneNumberController.text.toString().trim(),
        "password": "random"
      };

      var responce = await http.post(
        Uri.parse(ApiEndPoiunts.resetPasswordOtp),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(requestBody),
      );

      var jsonResponce = jsonDecode(responce.body);
      // print(jsonResponce);
      var responseCode = jsonResponce["responseCode"].toString();
      if (responseCode == "OK") {
        String otp = jsonResponce["result"]["otp"].toString().trim();
        Map<String, String> arguments = {
          "phoneNumber": phoneNumberController.text.toString().trim(),
          "otp": otp.toString()
        };
        print(arguments);
        Navigator.of(context).pushNamed(
          PasswordOTP.routeName,
          arguments: arguments,
        );
      } else if (responseCode == "CLIENT_ERROR") {
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
                      style: TextStyle(
                        // fontSize: 18,
                        fontSize: calculateDynamicFontSize(
                          totalScreenHeight: totalScreenHeight,
                          totalScreenWidth: totalScreenWidth,
                          currentFontSize: 40,
                          // heightSpecific: true,
                        ),
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
    } catch (e) {
      print(e);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double totalScreenHeight = MediaQuery.of(context).size.height;
    double totalScreenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Column(
        children: [
          SizedBox(
            // height: 90,
            height: calculateDynamicFontSize(
              totalScreenHeight: totalScreenHeight,
              totalScreenWidth: totalScreenWidth,
              currentFontSize: 200,
              // heightSpecific: true,
            ),
            child: Padding(
              // padding: const EdgeInsets.symmetric(
              //   vertical: 10,
              //   horizontal: 20,
              // ),
              padding: EdgeInsets.symmetric(
                  vertical: calculateDynamicFontSize(
                    totalScreenHeight: totalScreenHeight,
                    totalScreenWidth: totalScreenWidth,
                    currentFontSize: 20,
                    // heightSpecific: true,
                  ),
                  horizontal: calculateDynamicFontSize(
                    totalScreenHeight: totalScreenHeight,
                    totalScreenWidth: totalScreenWidth,
                    currentFontSize: 50,
                    // heightSpecific: false,
                  )),
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
                      // size: 40,
                      size: calculateDynamicFontSize(
                        totalScreenHeight: totalScreenHeight,
                        totalScreenWidth: totalScreenWidth,
                        currentFontSize: 80,
                        // heightSpecific: true,
                      ).toInt(),
                      // iconSize: 16,
                      iconSize: calculateDynamicFontSize(
                        totalScreenHeight: totalScreenHeight,
                        totalScreenWidth: totalScreenWidth,
                        currentFontSize: 40,
                        // heightSpecific: true,
                      ).toInt(),
                    )
                  ]),
            ),
          ),
          Expanded(
              flex: 4,
              child: Image.asset(
                "assets/image/forgotPassword.png",
                fit: BoxFit.cover,
              )),
          Expanded(
            flex: 4,
            child: Padding(
              // padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
              padding: EdgeInsets.symmetric(
                  vertical: calculateDynamicFontSize(
                    totalScreenHeight: totalScreenHeight,
                    totalScreenWidth: totalScreenWidth,
                    currentFontSize: 30,
                    // heightSpecific: true,
                  ),
                  horizontal: calculateDynamicFontSize(
                    totalScreenHeight: totalScreenHeight,
                    totalScreenWidth: totalScreenWidth,
                    currentFontSize: 50,
                    // heightSpecific: false,
                  )),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Text(
                      "Enter Your PhoneNumber\nConfirm OTP to  reset password",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        // fontSize: 20,
                        fontSize: calculateDynamicFontSize(
                          totalScreenHeight: totalScreenHeight,
                          totalScreenWidth: totalScreenWidth,
                          currentFontSize: 38,
                          // heightSpecific: true,
                        ),
                        color: Color.fromARGB(255, 6, 1, 8),
                      ),
                    ),
                    SizedBox(
                      // height: 10,
                      height: calculateDynamicFontSize(
                        totalScreenHeight: totalScreenHeight,
                        totalScreenWidth: totalScreenWidth,
                        currentFontSize: 60,
                        // heightSpecific: true,
                      ),
                    ),
                    TextField(
                      controller: phoneNumberController,
                      // cursorHeight: 22,
                      cursorHeight: calculateDynamicFontSize(
                        totalScreenHeight: totalScreenHeight,
                        totalScreenWidth: totalScreenWidth,
                        currentFontSize: 50,
                        // heightSpecific: true,
                      ),
                      // cursorWidth: 2,
                      cursorWidth: calculateDynamicFontSize(
                        totalScreenHeight: totalScreenHeight,
                        totalScreenWidth: totalScreenWidth,
                        currentFontSize: 5,
                        // heightSpecific: true,
                      ),
                      cursorColor: ColorPallets.deepBlue,
                      keyboardType: TextInputType.phone,
                      style: TextStyle(
                        // fontSize: 18,
                        fontSize: calculateDynamicFontSize(
                          totalScreenHeight: totalScreenHeight,
                          totalScreenWidth: totalScreenWidth,
                          currentFontSize: 40,
                          // heightSpecific: true,
                        ),
                        color: ColorPallets.deepBlue,
                      ),
                      decoration: InputDecoration(
                          label: Text(
                            "Phone Number",
                            style: TextStyle(
                              color: ColorPallets.deepBlue,
                              fontSize: calculateDynamicFontSize(
                                totalScreenHeight: totalScreenHeight,
                                totalScreenWidth: totalScreenWidth,
                                currentFontSize: 45,
                                // heightSpecific: false,
                              ),
                            ),
                          ),
                          // border: const OutlineInputBorder(
                          //   borderSide:
                          //         BorderSide(color: ColorPallets.deepBlue)
                          // ),
                          focusedBorder: const OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: ColorPallets.deepBlue)),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              // width: 2,
                              width: calculateDynamicFontSize(
                                totalScreenHeight: totalScreenHeight,
                                totalScreenWidth: totalScreenWidth,
                                currentFontSize: 3,
                                // heightSpecific: false,
                              ),
                              color: ColorPallets.deepBlue,
                            ),
                          ),
                          focusColor: ColorPallets.deepBlue,
                          hintText: "XXX-XXX-XXXX",
                          suffixIcon: phoneNumberController.text.isEmpty
                              ? const SizedBox()
                              : Padding(
                                  padding: const EdgeInsets.only(top: 0),
                                  child: IconButton(
                                      onPressed: () {
                                        phoneNumberController.clear();
                                      },
                                      icon: Icon(
                                        FontAwesomeIcons.xmark,
                                        // size: 18,
                                        size: calculateDynamicFontSize(
                                          totalScreenHeight: totalScreenHeight,
                                          totalScreenWidth: totalScreenWidth,
                                          currentFontSize: 40,
                                          // heightSpecific: true,
                                        ),
                                      )),
                                )),
                    ),
                    SizedBox(
                      // height: 40,
                      height: calculateDynamicFontSize(
                        totalScreenHeight: totalScreenHeight,
                        totalScreenWidth: totalScreenWidth,
                        currentFontSize: 100,
                        // heightSpecific: true,
                      ),
                    ),
                    InkWell(
                      onTap: () => sendOtpToPhoneNumber(
                          totalScreenHeight, totalScreenWidth),
                      child: Container(
                        // height: 50,
                        height: calculateDynamicFontSize(
                          totalScreenHeight: totalScreenHeight,
                          totalScreenWidth: totalScreenWidth,
                          currentFontSize: 100,
                          // heightSpecific: true,
                        ),
                        // width: 180,
                        width: calculateDynamicFontSize(
                          totalScreenHeight: totalScreenHeight,
                          totalScreenWidth: totalScreenWidth,
                          currentFontSize: 300,
                          // heightSpecific: true,
                        ),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            // borderRadius: BorderRadius.circular(20),
                            borderRadius:
                                BorderRadius.circular(calculateDynamicFontSize(
                              totalScreenHeight: totalScreenHeight,
                              totalScreenWidth: totalScreenWidth,
                              currentFontSize: 45,
                              // heightSpecific: true,
                            )),
                            color: ColorPallets.deepBlue.withOpacity(.9)),
                        child: Text(
                          "Send OTP",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: ColorPallets.white,
                              // fontSize: 24,
                              fontSize: calculateDynamicFontSize(
                                totalScreenHeight: totalScreenHeight,
                                totalScreenWidth: totalScreenWidth,
                                currentFontSize: 40,
                                // heightSpecific: true,
                              ),
                              fontStyle: FontStyle.normal),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
