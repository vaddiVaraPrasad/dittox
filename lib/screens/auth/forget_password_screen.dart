import "package:flutter/material.dart";
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../utils/color_pallets.dart';

import "../../widgets/IconButton.dart";

class ForgetPasswordScreen extends StatefulWidget {
  static const routeName = "/forgetPassword";
  const ForgetPasswordScreen({super.key});

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  final emailController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    emailController.addListener(() => setState(() {}));
    super.initState();
  }

  Future<void> sendPasswordLink() async {
    // try {
    //   await FirebaseAuth.instance
    //       .sendPasswordResetEmail(email: emailController.text.trim());
    //   showDialog(
    //     context: context,
    //     builder: (context) => AlertDialog(
    //       content: const Text(
    //           "Email is sent to reset your password\ncheck your spam box"),
    //       actions: [
    //         IconButton(
    //             onPressed: () => Navigator.of(context).pop(),
    //             icon: const Icon(
    //               FontAwesomeIcons.check,
    //               size: 30,
    //             ))
    //       ],
    //     ),
    //   );
    // } on FirebaseAuthException catch (e) {
    //   var msg = e.code;
    //   ScaffoldMessenger.of(context).clearSnackBars();
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     SnackBar(
    //       backgroundColor: ColorPallets.deepBlue,
    //       content: Row(
    //         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    //         children: [
    //           const Icon(
    //             FontAwesomeIcons.triangleExclamation,
    //             color: Colors.red,
    //           ),
    //           Text(
    //             msg,
    //             style: const TextStyle(
    //               fontSize: 18,
    //               fontStyle: FontStyle.normal,
    //               color: ColorPallets.white,
    //             ),
    //           )
    //         ],
    //       ),
    //     ),
    //   );
    // }
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
              flex: 5,
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
                      "Enter Your Email\nLink will be sent to reset password",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 20, color: Color.fromARGB(255, 6, 1, 8)),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextField(
                      controller: emailController,
                      cursorHeight: 22,
                      cursorWidth: 2,
                      cursorColor: ColorPallets.deepBlue,
                      style: const TextStyle(
                          fontSize: 18, color: ColorPallets.deepBlue),
                      decoration: InputDecoration(
                          label: const Text(
                            "email",
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
                          hintText: "vachira@xerox.com",
                          suffixIcon: emailController.text.isEmpty
                              ? const SizedBox()
                              : Padding(
                                  padding: const EdgeInsets.only(top: 0),
                                  child: IconButton(
                                      onPressed: () {
                                        emailController.clear();
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
                      onTap: sendPasswordLink,
                      child: Container(
                        height: 50,
                        width: 180,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: ColorPallets.deepBlue.withOpacity(.9)),
                        child: const Text(
                          "Send Link",
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
