import 'dart:convert';

import 'package:dittox/screens/auth/forgetPasswordOTP.dart';
import "package:flutter/material.dart";
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import '../../utils/api_endpoints.dart';
import '../../utils/color_pallets.dart';

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

  Future<void> sendOtpToPhoneNumber() async {
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
              flex: 4,
              child: Image.asset(
                "assets/image/forgotPassword.png",
                fit: BoxFit.cover,
              )),
          Expanded(
            flex: 4,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const Text(
                      "Enter Your PhoneNumber\nConfirm OTP to  reset password",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 20, color: Color.fromARGB(255, 6, 1, 8)),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextField(
                      controller: phoneNumberController,
                      cursorHeight: 22,
                      cursorWidth: 2,
                      cursorColor: ColorPallets.deepBlue,
                      keyboardType: TextInputType.phone,
                      style: const TextStyle(
                          fontSize: 18, color: ColorPallets.deepBlue),
                      decoration: InputDecoration(
                          label: const Text(
                            "Phone Number",
                            style: TextStyle(color: ColorPallets.deepBlue),
                          ),
                          // border: const OutlineInputBorder(
                          //   borderSide:
                          //         BorderSide(color: ColorPallets.deepBlue)
                          // ),
                          focusedBorder: const OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: ColorPallets.deepBlue)),
                          enabledBorder: const OutlineInputBorder(
                            borderSide: BorderSide(
                              width: 2,
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
                                      icon: const Icon(
                                        FontAwesomeIcons.xmark,
                                        size: 18,
                                      )),
                                )),
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    InkWell(
                      onTap: sendOtpToPhoneNumber,
                      child: Container(
                        height: 50,
                        width: 180,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: ColorPallets.deepBlue.withOpacity(.9)),
                        child: const Text(
                          "Send OTP",
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
          ),
        ],
      ),
    );
  }
}
