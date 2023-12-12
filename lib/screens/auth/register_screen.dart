import "dart:io";
import "package:flutter/material.dart";
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../providers/current_user.dart';
import '../../helpers/user_location.dart';
import '../../model/user.dart';
import "../../utils/color_pallets.dart";

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

  bool isObsecureText = true;

  Map<String, String> _userDetails = {
    "email": "",
    "password": "",
    "userName": ""
  };

  @override
  void initState() {
    emailController.addListener(() => setState(() {}));
    userNameController.addListener(() => setState(() {}));
    passwordController.addListener(() => setState(() {}));
    super.initState();
  }

  @override
  void dispose() {
    emailController.dispose();
    userNameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> registerUser(CurrentUser currUser, BuildContext ctx) async{

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

  @override
  Widget build(BuildContext context) {
    var currentUser = Provider.of<CurrentUser>(context, listen: true);
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
              flex: 5,
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
                                      onPressed: () {
                                        emailController.clear();
                                      },
                                      icon: const Icon(
                                        FontAwesomeIcons.xmark,
                                        size: 18,
                                      ))),
                          errorStyle: const TextStyle(
                              color: ColorPallets.pinkinshShadedPurple),
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
                          _userDetails["email"] = newMailId.toString().trim();
                        },
                      ),
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
                            errorStyle: const TextStyle(
                                color: ColorPallets.pinkinshShadedPurple)),
                        validator: (newUserName) {
                          if (newUserName!.isEmpty) {
                            return "InValid password";
                          }
                          return null;
                        },
                        onSaved: (newUserName) {
                          _userDetails["userName"] =
                              newUserName.toString().trim();
                        },
                      ),
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
                          errorStyle: const TextStyle(
                              color: ColorPallets.pinkinshShadedPurple),
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
                          _userDetails["password"] =
                              newPassword.toString().trim();
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),

                      // signUp pages
                      SignUpBar(
                        isLoading: _isLoading,
                        label: "Register",
                        onPressed: () => registerUser(currentUser, context),
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
