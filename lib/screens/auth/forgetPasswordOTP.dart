import 'dart:convert';

import 'package:dittox/screens/auth/auth_screen.dart';
import 'package:dittox/screens/auth/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pinput/pinput.dart';
import 'package:http/http.dart' as http;

import '../../utils/api_endpoints.dart';
import '../../utils/color_pallets.dart';
import '../../widgets/IconButton.dart';

class PasswordOTP extends StatefulWidget {
  static const routeName = "/forgetPasswordOtp";
  const PasswordOTP({super.key});

  @override
  State<PasswordOTP> createState() => _PasswordOTPState();
}

class _PasswordOTPState extends State<PasswordOTP> {
  final pinController = TextEditingController();
  final newPasswordController = TextEditingController();
  final focusNode = FocusNode();
  bool _isLoading = false;
  bool isObsecureText = false;

  @override
  void initState() {
    // TODO: implement initState
    pinController.addListener(() => setState(() {}));
    newPasswordController.addListener(() => setState(() {}));
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    pinController.dispose();
    newPasswordController.dispose();
    focusNode.dispose();
    super.dispose();
  }

  Future<void> _resetPassword(
      String newPassword, String phoneNumber, String otp) async {
    try {
      setState(() {
        _isLoading = true;
      });

      Map<String, String> requestBody = {
        "password": newPassword,
        "otp": otp,
        "mobile": phoneNumber
      };

      var responce = await http.post(
        Uri.parse(ApiEndPoiunts.resetPasswordConfirm),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(requestBody),
      );
      var jsonResponce = jsonDecode(responce.body);
      // print(jsonResponce);
      var responseCode = jsonResponce["responseCode"].toString();
      if (responseCode == "OK") {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (ctx) => AuthScreen(),
            ),
            (route) => false);
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
          flex: 2,
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
                      // _createNewUser(userName, email, phoneNumber, password,
                      //     otp, currUser);
                    },
                    showCursor: true,
                    cursor: cursor,
                    onSubmitted: (value) {
                      // _createNewUser(userName, email, phoneNumber, password,
                      //     otp, currUser);
                    },
                  ),
                  const SizedBox(
                    height: 60,
                  ),
                  TextField(
                    controller: newPasswordController,
                    cursorHeight: 22,
                    cursorWidth: 2,
                    cursorColor: ColorPallets.deepBlue,
                    keyboardType: TextInputType.text,
                    obscureText: isObsecureText,
                    textInputAction: TextInputAction.done,
                    style: const TextStyle(
                        fontSize: 18, color: ColorPallets.deepBlue),
                    decoration: InputDecoration(
                      suffixIcon: newPasswordController.text.isEmpty
                          ? const SizedBox()
                          : Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: IconButton(
                                color: ColorPallets.white,
                                icon: isObsecureText
                                    ? const Icon(
                                        Icons.visibility,
                                        size: 22,
                                      )
                                    : const Icon(
                                        Icons.visibility_off,
                                        size: 22,
                                      ),
                                onPressed: () {
                                  setState(() {
                                    isObsecureText = !isObsecureText;
                                  });
                                },
                              ),
                            ),
                      label: const Text(
                        "New - Password",
                        style: TextStyle(color: ColorPallets.deepBlue),
                      ),
                      // border: const OutlineInputBorder(
                      //   borderSide:
                      //         BorderSide(color: ColorPallets.deepBlue)
                      // ),
                      focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: ColorPallets.deepBlue)),
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(
                          width: 2,
                          color: ColorPallets.deepBlue,
                        ),
                      ),
                      focusColor: ColorPallets.deepBlue,
                    ),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  InkWell(
                    onTap: () {
                      _resetPassword(
                          newPasswordController.text.toString().trim(),
                          phoneNumber,
                          otp);
                      // _createNewUser(userName, email, phoneNumber, password,
                      //     otp, currUser);
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
                              "Re-Set Password",
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



// TextField(
//                       controller: emailController,
//                       cursorHeight: 22,
//                       cursorWidth: 2,
//                       cursorColor: ColorPallets.deepBlue,
//                       style: const TextStyle(
//                           fontSize: 18, color: ColorPallets.deepBlue),
//                       decoration: InputDecoration(
//                           label: const Text(
//                             "email",
//                             style: TextStyle(color: ColorPallets.deepBlue),
//                           ),
//                           // border: const OutlineInputBorder(
//                           //   borderSide:
//                           //         BorderSide(color: ColorPallets.deepBlue)
//                           // ),
//                           focusedBorder: const OutlineInputBorder(
//                               borderSide:
//                                   BorderSide(color: ColorPallets.deepBlue)),
//                           enabledBorder: const OutlineInputBorder(
//                             borderSide: BorderSide(
//                               width: 2,
//                               color: ColorPallets.deepBlue,
//                             ),
//                           ),
//                           focusColor: ColorPallets.deepBlue,
//                           hintText: "vachira@xerox.com",
//                           suffixIcon: emailController.text.isEmpty
//                               ? const SizedBox()
//                               : Padding(
//                                   padding: const EdgeInsets.only(top: 0),
//                                   child: IconButton(
//                                       onPressed: () {
//                                         emailController.clear();
//                                       },
//                                       icon: const Icon(
//                                         FontAwesomeIcons.xmark,
//                                         size: 18,
//                                       )),
//                                 )),
//                     ),