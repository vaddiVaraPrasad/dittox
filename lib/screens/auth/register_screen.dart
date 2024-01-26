import 'dart:convert';

import 'package:dittox/screens/auth/regsiterOtp.dart';
import "package:flutter/material.dart";
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../utils/api_endpoints.dart';
import "../../utils/color_pallets.dart";
import 'package:http/http.dart' as http;
import "../../widgets/auth/sing_in_up_bar.dart";

class RegisterScreen extends StatefulWidget {
  final VoidCallback callLoginScreen;
  const RegisterScreen({
    super.key,
    required this.callLoginScreen,
  });

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final formKeyRegister = GlobalKey<FormState>();
  bool _isLoading = false;

  final emailController = TextEditingController();
  final userNameController = TextEditingController();
  final passwordController = TextEditingController();
  final addressController = TextEditingController();
  final phonenumberController = TextEditingController();
  final dobcontroller = TextEditingController();

  bool isObsecureText = true;

  @override
  void initState() {
    emailController.addListener(() => setState(() {}));
    userNameController.addListener(() => setState(() {}));
    passwordController.addListener(() => setState(() {}));
    // addressController.addListener(() => setState(() {}));
    phonenumberController.addListener(() => setState(() {}));
    // dobcontroller.addListener(() => setState(() {}));
    super.initState();
  }

  @override
  void dispose() {
    emailController.dispose();
    userNameController.dispose();
    passwordController.dispose();
    // addressController.dispose();
    phonenumberController.dispose();
    // dobcontroller.dispose();
    super.dispose();
  }

  Future<void> registerUser(BuildContext ctx) async {
    var msg = "Invalid Credentials !!!";
    final isValid = formKeyRegister.currentState!.validate();

    if (isValid) {
      formKeyRegister.currentState!.save();
      print("FORM IS VALID");
      Map<String, String> _userDetails = {
        "email": emailController.text,
        "password": passwordController.text,
        "userName": userNameController.text,
        "phoneNumber": phonenumberController.text,
        // "bod": "",
        // "address": ""
      };
      emailController.text = "";
      phonenumberController.text = "";
      userNameController.text = "";
      phonenumberController.text = "";

      setState(() {
        _isLoading = true;
      });
      var requestBody = {
        "name": _userDetails["userName"].toString().trim(),
        "email": _userDetails["email"].toString().trim(),
        "mobile": _userDetails["phoneNumber"].toString().trim()
      };

      var responce = await http.post(
        Uri.parse(ApiEndPoiunts.registerForOtp),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(requestBody),
      );

      var jsonResponce = jsonDecode(responce.body);
      // print(jsonResponce);
      var responseCode = jsonResponce["responseCode"].toString();
      if (responseCode == "OK") {
        _userDetails["otp"] = jsonResponce["result"]["otp"].toString().trim();

        print(_userDetails["otp"]);
        Navigator.of(context).pushNamed(
          RegisterOtp.routeName,
          arguments: _userDetails,
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

      setState(() {
        _isLoading = false;
      });
    } else {
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
              Text(
                msg,
                style: const TextStyle(
                  fontSize: 18,
                  fontStyle: FontStyle.normal,
                  color: ColorPallets.white,
                ),
              )
            ],
          ),
        ),
      );
    }
  }

  // Future<void> registerUser(CurrentUser currUser, BuildContext ctx) async {
  //   var msg = "Invalid Credentials !!!";
  //   var ProfilePicUrl = "";

  //   final isvalid = formKeyRegister.currentState!.validate();
  //   // emailController.clear();
  //   // passwordController.clear();
  //   // userNameController.clear();
  //   if (isvalid) {
  //     formKeyRegister.currentState!.save();
  //     if (_userProfilePic != null) {
  //       setState(() {
  //         _isLoading = true;
  //       });
  //       try {
  //         final credential =
  //             await FirebaseAuth.instance.createUserWithEmailAndPassword(
  //           email: _userDetails["email"] as String,
  //           password: _userDetails["password"] as String,
  //         );
  //         print("PROILE is added to auth");
  //         final refPath = FirebaseStorage.instance
  //             .ref()
  //             .child("user")
  //             .child(credential.user!.uid)
  //             .child("${credential.user!.uid}.png");

  //         await refPath.putFile(_userProfilePic as File).whenComplete(() {});
  //         ProfilePicUrl = await refPath.getDownloadURL();
  //         print("PROILE PI URL ISSSS");
  //         print(ProfilePicUrl);
  //         await FirebaseFirestore.instance
  //             .collection('Users')
  //             .doc(credential.user!.uid)
  //             .set({
  //           "userId": credential.user!.uid,
  //           "email": credential.user!.email,
  //           "profilePicUrl": ProfilePicUrl,
  //           "userName": _userDetails["userName"],
  //           "createdAt": Timestamp.now()
  //         });
  //         Position userCurrentPosition = await UserLocation.getUserLatLong();
  //         Map<String, dynamic> userPlaceMark =
  //             await UserLocation.getUserPlaceMarks(
  //                 userCurrentPosition.latitude, userCurrentPosition.longitude);
  //         print("use is register to firestore ");
  //         var users = Users(
  //           userId: credential.user!.uid,
  //           userName: _userDetails["userName"] as String,
  //           userEmail: credential.user!.email as String,
  //           userPlaceName: userPlaceMark["locality"],
  //           latitude: userCurrentPosition.latitude,
  //           longitude: userCurrentPosition.longitude,
  //           userProfileUrl: ProfilePicUrl,
  //           userContryName: userPlaceMark["country"],
  //         );
  //         currUser.setCurrentUser(users);
  //         print(
  //             "<<<<------------------Provider Map is ------------------------>");
  //         print(currUser.getCurrentUserMap);
  //         print("REGISTER SUCCESULLY");
  //       } on FirebaseAuthException catch (e) {
  //         emailController.clear();
  //         passwordController.clear();
  //         userNameController.clear();
  //         if (e.code == 'weak-password') {
  //           msg = 'The password provided is too weak.';
  //         } else if (e.code == 'email-already-in-use') {
  //           msg = 'The account already exists for that email';
  //         }
  //         ScaffoldMessenger.of(context).clearSnackBars();

  //         ScaffoldMessenger.of(context).showSnackBar(
  //           SnackBar(
  //             backgroundColor: ColorPallets.deepBlue,
  //             content: Row(
  //               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //               children: [
  //                 const Icon(
  //                   FontAwesomeIcons.triangleExclamation,
  //                   color: Colors.red,
  //                 ),
  //                 Text(
  //                   msg,
  //                   style: const TextStyle(
  //                     fontSize: 18,
  //                     fontStyle: FontStyle.normal,
  //                     color: ColorPallets.white,
  //                   ),
  //                 )
  //               ],
  //             ),
  //           ),
  //         );
  //         setState(
  //           () {
  //             _isLoading = false;
  //           },
  //         );
  //       }
  //       // setState(() {
  //       //   _isLoading = false;
  //       // });
  //     } else {
  //       ScaffoldMessenger.of(context).clearSnackBars();
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(
  //           backgroundColor: ColorPallets.deepBlue,
  //           content: Row(
  //             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //             children: const [
  //               Icon(
  //                 FontAwesomeIcons.triangleExclamation,
  //                 color: Colors.red,
  //               ),
  //               Text(
  //                 "add profile picture to register !!",
  //                 style: TextStyle(
  //                   fontSize: 18,
  //                   fontStyle: FontStyle.normal,
  //                   color: ColorPallets.white,
  //                 ),
  //               )
  //             ],
  //           ),
  //         ),
  //       );
  //     }
  //   }
  // }

  // Future<void> pickProfilePic() async {
  //   // ignore: deprecated_member_use
  //   final pickedFile = await ImagePicker().getImage(
  //     source: ImageSource.gallery,
  //     imageQuality: 50,
  //   );
  //   if (pickedFile == null) {
  //     return;
  //   }

  //   setState(() {
  //     _userProfilePic = File(pickedFile.path);
  //   });
  // }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      // barrierColor: ColorPallets.deepBlue,
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (picked != null && picked != DateTime.now()) {
      // Format the selected date as needed
      String formattedDate = "${picked.day}-${picked.month}-${picked.year}";
      dobcontroller.text = formattedDate;
    }
  }

  @override
  Widget build(BuildContext context) {
    // var currentUser = Provider.of<CurrentUser>(context, listen: true);
    return Container(
      padding: const EdgeInsets.all(32),
      child: Column(
        children: [
          Expanded(
              flex: 2,
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Create\nAccount",
                  textAlign: TextAlign.start,
                  style: TextStyle(
                      fontSize: 40,
                      color: ColorPallets.white,
                      fontWeight: FontWeight.w600,
                      fontFamily: GoogleFonts.audiowide().fontFamily),
                ),
              )),
          Expanded(
              flex: 7,
              child: Container(
                constraints: const BoxConstraints(minWidth: 220),
                child: Form(
                  key: formKeyRegister,
                  child: ListView(
                    children: [
                      // CircleAvatar(
                      //   radius: 70,
                      //   backgroundImage: _userProfilePic != null
                      //       ? FileImage(_userProfilePic as File)
                      //       : null,
                      //   backgroundColor:
                      //       ColorPallets.lightPurplishWhile.withOpacity(.7),
                      //   child: _userProfilePic == null
                      //       ? InkWell(
                      //           onTap: pickProfilePic,
                      //           child: Image.asset(
                      //             "assets/image/add_profile_border.png",
                      //             color: ColorPallets.deepBlue,
                      //             height: 60,
                      //             width: 60,
                      //           ),
                      //         )
                      //       : null,
                      // ),

                      const SizedBox(
                        height: 10,
                      ),

                      // email form text filed
                      TextFormField(
                        controller: emailController,
                        key: const ValueKey("mail"),
                        cursorHeight: 22,
                        cursorWidth: 2,
                        cursorColor: ColorPallets.white,
                        style: const TextStyle(
                          fontSize: 18,
                          color: ColorPallets.white,
                        ),
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          suffixIcon: emailController.text.isEmpty
                              ? const SizedBox()
                              : Padding(
                                  padding: const EdgeInsets.only(top: 10),
                                  child: IconButton(
                                      color: ColorPallets.white,
                                      onPressed: () {
                                        emailController.clear();
                                      },
                                      icon: const Icon(
                                        FontAwesomeIcons.xmark,
                                        size: 18,
                                      ))),
                          errorStyle: const TextStyle(
                              // color: ColorPallets.pinkinshShadedPurple,
                              color: Colors.red),
                          focusedBorder: const UnderlineInputBorder(
                              borderSide:
                                  BorderSide(color: ColorPallets.white)),
                          enabledBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(
                              width: 2,
                              color: ColorPallets.white,
                            ),
                          ),
                          focusColor: ColorPallets.white,
                          label: const Text(
                            "E-mail",
                            style: TextStyle(color: ColorPallets.white),
                          ),
                        ),
                        validator: (newMailId) {
                          if (newMailId!.isEmpty || !newMailId.contains('@')) {
                            return "Invalid EmailId";
                          }
                          return null;
                        },
                        onSaved: (newMailId) {
                          emailController.text = newMailId.toString().trim();
                        },
                      ),

                      // username
                      TextFormField(
                        key: const ValueKey("userName"),
                        controller: userNameController,
                        cursorHeight: 22,
                        cursorWidth: 2,
                        cursorColor: ColorPallets.white,
                        style: const TextStyle(
                          fontSize: 18,
                          color: ColorPallets.white,
                        ),
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          suffixIcon: userNameController.text.isEmpty
                              ? const SizedBox()
                              : Padding(
                                  padding: const EdgeInsets.only(top: 10),
                                  child: IconButton(
                                      color: ColorPallets.white,
                                      onPressed: () {
                                        userNameController.clear();
                                      },
                                      icon: const Icon(
                                        FontAwesomeIcons.xmark,
                                        size: 18,
                                      ))),
                          focusedBorder: const UnderlineInputBorder(
                              borderSide:
                                  BorderSide(color: ColorPallets.white)),
                          enabledBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(
                              width: 2,
                              color: ColorPallets.white,
                            ),
                          ),
                          focusColor: ColorPallets.white,
                          label: const Text(
                            "UserName",
                            style: TextStyle(color: ColorPallets.white),
                          ),
                          // errorStyle: const TextStyle(
                          //     color: ColorPallets.pinkinshShadedPurple)),
                          errorStyle: const TextStyle(
                              // color: ColorPallets.pinkinshShadedPurple,
                              color: Colors.red),
                        ),
                        validator: (newUserName) {
                          if (newUserName!.isEmpty) {
                            return "InValid password";
                          }
                          return null;
                        },
                        onSaved: (newUserName) {
                          userNameController.text =
                              newUserName.toString().trim();
                        },
                      ),

                      // password
                      TextFormField(
                        key: const ValueKey("passWoRd"),
                        controller: passwordController,
                        cursorHeight: 22,
                        cursorWidth: 2,
                        cursorColor: ColorPallets.white,
                        style: const TextStyle(
                          fontSize: 18,
                          color: ColorPallets.white,
                        ),
                        keyboardType: TextInputType.text,
                        obscureText: isObsecureText,
                        textInputAction: TextInputAction.done,
                        decoration: InputDecoration(
                          suffixIcon: passwordController.text.isEmpty
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
                          // errorStyle: const TextStyle(
                          //     color: ColorPallets.pinkinshShadedPurple),
                          errorStyle: const TextStyle(
                              // color: ColorPallets.pinkinshShadedPurple,
                              color: Colors.red),
                          focusedBorder: const UnderlineInputBorder(
                              borderSide:
                                  BorderSide(color: ColorPallets.white)),
                          enabledBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(
                              width: 2,
                              color: ColorPallets.white,
                            ),
                          ),
                          focusColor: ColorPallets.white,
                          label: const Text(
                            "Password",
                            style: TextStyle(color: ColorPallets.white),
                          ),
                        ),
                        validator: (newPassword) {
                          if (newPassword!.isEmpty || newPassword.length < 6) {
                            return "password min of 6 char";
                          }
                          return null;
                        },
                        onSaved: (newPassword) {
                          passwordController.text =
                              newPassword.toString().trim();
                        },
                      ),

                      // phonenumber
                      TextFormField(
                        controller: phonenumberController,
                        key: const ValueKey("phonenumber"),
                        cursorHeight: 22,
                        cursorWidth: 2,
                        cursorColor: ColorPallets.white,
                        style: const TextStyle(
                          fontSize: 18,
                          color: ColorPallets.white,
                        ),
                        keyboardType: TextInputType.phone,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          suffixIcon: phonenumberController.text.isEmpty
                              ? const SizedBox()
                              : Padding(
                                  padding: const EdgeInsets.only(top: 10),
                                  child: IconButton(
                                      color: ColorPallets.white,
                                      onPressed: () {
                                        phonenumberController.clear();
                                      },
                                      icon: const Icon(
                                        FontAwesomeIcons.xmark,
                                        size: 18,
                                      ))),
                          errorStyle: const TextStyle(
                              // color: ColorPallets.pinkinshShadedPurple,
                              color: Colors.red),
                          focusedBorder: const UnderlineInputBorder(
                              borderSide:
                                  BorderSide(color: ColorPallets.white)),
                          enabledBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(
                              width: 2,
                              color: ColorPallets.white,
                            ),
                          ),
                          focusColor: ColorPallets.white,
                          label: const Text(
                            "Mobile number",
                            style: TextStyle(color: ColorPallets.white),
                          ),
                        ),
                        validator: (newMobilenumber) {
                          if (newMobilenumber!.isEmpty ||
                              newMobilenumber.length != 10) {
                            return "Invalid PhoneNumber";
                          }
                          return null;
                        },
                        onSaved: (newMobilenumber) {
                          phonenumberController.text =
                              newMobilenumber.toString().trim();
                        },
                      ),

                      // date of birth

                      // TextFormField(
                      //   controller: dobcontroller,
                      //   key: const ValueKey("dob"),
                      //   cursorHeight: 22,
                      //   cursorWidth: 2,
                      //   cursorColor: Colors.white,
                      //   style: const TextStyle(
                      //     fontSize: 18,
                      //     color: Colors.white,
                      //   ),
                      //   keyboardType: TextInputType.text,
                      //   textInputAction: TextInputAction.next,
                      //   decoration: InputDecoration(
                      //     suffixIcon: dobcontroller.text.isEmpty
                      //         ? const SizedBox()
                      //         : Padding(
                      //             padding: const EdgeInsets.only(top: 10),
                      //             child: IconButton(
                      //               onPressed: () {
                      //                 dobcontroller.clear();
                      //               },
                      //               icon: const Icon(
                      //                 Icons.clear,
                      //                 size: 18,
                      //               ),
                      //             ),
                      //           ),
                      //     errorStyle: const TextStyle(color: Colors.pink),
                      //     focusedBorder: const UnderlineInputBorder(
                      //       borderSide: BorderSide(color: Colors.white),
                      //     ),
                      //     enabledBorder: const UnderlineInputBorder(
                      //       borderSide: BorderSide(
                      //         width: 2,
                      //         color: Colors.white,
                      //       ),
                      //     ),
                      //     focusColor: Colors.white,
                      //     label: const Text(
                      //       "Date of Birth",
                      //       style: TextStyle(color: Colors.white),
                      //     ),
                      //   ),
                      //   onTap: () => _selectDate(context),
                      //   validator: (dob) {
                      //     // Implement validation for date of birth if needed
                      //     return null;
                      //   },
                      //   onSaved: (dob) {
                      //     _userDetails["dob"] = dobcontroller.text.trim();
                      //   },
                      // ),

                      const SizedBox(
                        height: 40,
                      ),

                      // signUp pages
                      SignUpBar(
                        isLoading: _isLoading,
                        label: "Register",
                        onPressed: () => registerUser(context),
                      ),
                      // nav from register to login
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 15, horizontal: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            const Text(
                              "I'm a member  !!",
                              style: TextStyle(fontSize: 18),
                            ),
                            InkWell(
                              onTap: () {
                                if (widget.callLoginScreen != null) {
                                  widget.callLoginScreen();
                                }
                              },
                              child: const Text(
                                "Login",
                                style: TextStyle(
                                    color: ColorPallets.pinkinshShadedPurple,
                                    fontSize: 18),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ))
        ],
      ),
    );
  }
}
