import "dart:convert";

import "package:dittox/screens/home/dummy_home.dart";
import "package:flutter/material.dart";
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import "package:geolocator/geolocator.dart";
import 'package:google_fonts/google_fonts.dart';
import "package:provider/provider.dart";
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import "../../helpers/sqlLite.dart";
import "../../helpers/user_location.dart";

import "../../providers/current_user.dart";
import "../../utils/api_endpoints.dart";
import "../../utils/color_pallets.dart";

import "../../utils/dynamicSizing.dart";
import "../nav_drawers/navBar.dart";
import "./forget_password_Screen.dart";

import "../../widgets/auth/sing_in_up_bar.dart";

import "../../model/user.dart";
import "privacy_policy.dart";
import "termsandcondictions.dart";

class LoginScreen extends StatefulWidget {
  final VoidCallback callRegisterScreen;
  const LoginScreen({
    super.key,
    required this.callRegisterScreen,
  });

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  final focusNode = FocusNode();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool isObsureText = true;

  late SharedPreferences prefs;

  Map<String, String> _userDetails = {
    "email": "",
    "password": "",
  };
  @override
  void initState() {
    emailController.addListener(() => setState(() {}));
    passwordController.addListener(() => setState(() {}));
    initSharePref();
    super.initState();
  }

  void initSharePref() async {
    prefs = await SharedPreferences.getInstance();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    focusNode.dispose();
    super.dispose();
  }

  Future<void> submitSinginform(
    BuildContext ctx,
    CurrentUser currentUser,
    double totalScreenHeight,
    double totalScreenWidth,
  ) async {
    focusNode.unfocus();
    var isValid = formKey.currentState!.validate();
    if (isValid) {
      formKey.currentState!.save();
      // now create the user with this gmail and password !!!
      setState(() {
        _isLoading = true;
      });

      var requestBody = {
        "email": _userDetails["email"].toString().trim(),
        "password": _userDetails["password"].toString().trim()
      };

      var responce = await http.post(
        Uri.parse(ApiEndPoiunts.loginEndpoint),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(requestBody),
      );

      var jsonResponce = jsonDecode(responce.body);
      // print(jsonResponce);
      var responseCode = jsonResponce["responseCode"].toString();

      print(responseCode);
      if (responseCode == "OK") {
        print("inside the ok !!!");
        // user is logged in here
        var accessToken = jsonResponce["result"]["access_token"].toString();
        prefs.setString("AccessToken", accessToken.toString());
        print("ADDED ACCESS TOKEN TO SHARED PREFERENCE");
        var userId = jsonResponce["result"]["user"]["_id"].toString();
        bool isUserNotPresnt = await SQLHelpers.checkUserPresent(userId);
        // if (isUserNotPresnt) {
        print("user is not present so get new data");
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
        // } else {
        //   // while init user , need to update the user location tooo , so calulate here

        //   Position userCurrentPosition = await UserLocation.getUserLatLong();

        //   currentUser.initCurrentUser(
        //       userId, jsonResponce["result"]["access_token"].toString(),userCurrentPosition.latitude,userCurrentPosition.longitude);
        //   print("OLD USER WITH NEW ACCESS TOKEN IS LOADED");
        // }
        print("singined IN SUCCESSULLY");

        // Navigator.of(context).pushNamed(ButtonNavigationBar.routeName);
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
      setState(() {
        _isLoading = false;
      });
    }
  }
  // Future<void> submitSinginform(
  //     BuildContext ctx, CurrentUser currentUser) async {
  //   var isValid = formKey.currentState!.validate();

  //   if (isValid) {
  //     formKey.currentState!.save();
  //     // now create the user with this gmail and password !!!
  //     setState(() {
  //       _isLoading = true;
  //     });
  //     try {
  //       final cred = await FirebaseAuth.instance.signInWithEmailAndPassword(
  //           email: _userDetails["email"].toString().trim(),
  //           password: _userDetails["password"].toString().trim());
  //       print(cred.user!.uid);
  //       bool isUserNotPresnt =
  //           await SQLHelpers.checkUserPresent(cred.user!.uid);
  //       if (isUserNotPresnt) {
  //         Position userCurrentPosition = await UserLocation.getUserLatLong();
  //         Map<String, dynamic> userPlaceMark =
  //             await UserLocation.getUserPlaceMarks(
  //                 userCurrentPosition.latitude, userCurrentPosition.longitude);
  //         final docRef = FirebaseFirestore.instance
  //             .collection("Users")
  //             .doc(cred.user!.uid);
  //         docRef.get().then(
  //           (DocumentSnapshot doc) {
  //             final data = doc.data() as Map<String, dynamic>;
  //             var users = Users(
  //               userId: data["userId"],
  //               userName:
  //                   data["userName"] as String,
  //               userEmail: data["email"] as String,
  //               userPlaceName: userPlaceMark["locality"],
  //               latitude: userCurrentPosition.latitude,
  //               longitude: userCurrentPosition.longitude,
  //               userProfileUrl:
  //                   data["profilePicUrl"],
  //               userContryName: userPlaceMark["country"],
  //             );
  //             currentUser.setCurrentUser(users);
  //             print(
  //                 "<<<<------------------Provider Map is ------------------------>");
  //             print(currentUser.getCurrentUserMap);
  //           },
  //           onError: (e) => print("ERROR in getting documets $e"),
  //         );
  //       } else {
  //         currentUser.initCurrentUser(cred.user!.uid);
  //       }
  //       print("singined IN SUCCESSULLY");

  //       // Navigator.of(context).pushReplacementNamed(HomeScreen.routeName);
  //     } on FirebaseAuthException catch (e) {
  //       emailController.clear();
  //       passwordController.clear();
  //       var msg = "user credentials are improper ";
  //       if (e.code == 'user-not-found') {
  //         msg = "No user found with that email";
  //         // print('No user found for that email.');
  //       } else if (e.code == 'wrong-password') {
  //         msg = "Wrong password. Try again";
  //         // print('Wrong password provided for that user.');
  //       }
  //       ScaffoldMessenger.of(context).clearSnackBars();

  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(
  //           backgroundColor: ColorPallets.deepBlue,
  //           content: Row(
  //             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //             children: [
  //               const Icon(
  //                 FontAwesomeIcons.triangleExclamation,
  //                 color: Colors.red,
  //               ),
  //               Text(
  //                 msg,
  //                 style: const TextStyle(
  //                   fontSize: 18,
  //                   fontStyle: FontStyle.normal,
  //                   color: ColorPallets.white,
  //                 ),
  //               )
  //             ],
  //           ),
  //         ),
  //       );
  //     } catch (e) {
  //       ScaffoldMessenger.of(context).clearSnackBars();

  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(
  //           backgroundColor: ColorPallets.deepBlue,
  //           content: Row(
  //             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //             children: [
  //               const Icon(
  //                 FontAwesomeIcons.triangleExclamation,
  //                 color: Colors.red,
  //               ),
  //               Text(
  //                 e.toString(),
  //                 style: const TextStyle(
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
  //     setState(() {
  //       _isLoading = false;
  //     });
  //   }
  // }

  // Future<void> signInUpWithGoogle(
  //     CurrentUser currUser, BuildContext ctx) async {
  //   setState(() {
  //     _isLoading = true;
  //   });

  //   final googleSignIn = GoogleSignIn(scopes: ["email"]);

  //   try {
  //     final googleSignInAccount = await googleSignIn.signIn();

  //     if (googleSignInAccount == null) {
  //       setState(() {
  //         _isLoading = false;
  //       });
  //       return;
  //     }

  //     final googleSignInAuthentication =
  //         await googleSignInAccount.authentication;

  //     final credential = GoogleAuthProvider.credential(
  //       accessToken: googleSignInAuthentication.accessToken,
  //       idToken: googleSignInAuthentication.idToken,
  //     );

  //     await FirebaseAuth.instance.signInWithCredential(credential);

  //     Text("LOGed in succefully  BY GOOGLE ");
  //     print("before loading in to firestroe");

  //     Position userCurrentPosition = await UserLocation.getUserLatLong();
  //     Map<String, dynamic> userPlaceMark = await UserLocation.getUserPlaceMarks(
  //         userCurrentPosition.latitude, userCurrentPosition.longitude);

  //     await FirebaseFirestore.instance
  //         .collection('Users')
  //         .doc(
  //           FirebaseAuth.instance.currentUser!.uid,
  //         )
  //         .set({
  //       "userId": FirebaseAuth.instance.currentUser!.uid,
  //       "email": FirebaseAuth.instance.currentUser!.email,
  //       "profilePicUrl": FirebaseAuth.instance.currentUser!.photoURL,
  //       "userName": FirebaseAuth.instance.currentUser!.displayName,
  //       "createdAt": Timestamp.now(),
  //     });
  //     var users = Users(
  //       userId: FirebaseAuth.instance.currentUser!.uid,
  //       userName: FirebaseAuth.instance.currentUser!.displayName as String,
  //       userEmail: FirebaseAuth.instance.currentUser!.email as String,
  //       userPlaceName: userPlaceMark["locality"],
  //       latitude: userCurrentPosition.latitude,
  //       longitude: userCurrentPosition.longitude,
  //       userProfileUrl: FirebaseAuth.instance.currentUser!.photoURL as String,
  //       userContryName: userPlaceMark["country"],
  //     );
  //     currUser.setCurrentUser(users);
  //     print("<<<<------------------Provider Map is ------------------------>");
  //     print(currUser.getCurrentUserMap);
  //     setState(() {});

  //     Text("LOGed in succefully  BY GOOGLE ");
  //     // Navigator.of(context).pushReplacementNamed(HomeScreen.routeName);
  //   } on FirebaseAuthException catch (e) {
  //     print("ERROR ERROR ERROR EROOR ERROR ERRROR ERROR");
  //     var msg = "";
  //     switch (e.code) {
  //       case 'account-exists-with-different-credential':
  //         msg = "this account exists with a different sing in provider";
  //         break;
  //       case 'invalid-credential':
  //         msg = "Unknow error has occured ";
  //         break;
  //       case "operation-not-allowed":
  //         msg = "this operation is not allowed";
  //         break;
  //       case 'user-disabled':
  //         msg = 'this user you tried to log into is disabled';
  //         break;
  //     }
  //     showDialog(
  //       context: ctx,
  //       builder: (context) => AlertDialog(
  //         title: const Text("log in google fail!!!"),
  //         content: Text(msg),
  //         actions: [
  //           TextButton(
  //               onPressed: () {
  //                 Navigator.of(context).pop();
  //               },
  //               child: const Text("OK!!"))
  //         ],
  //       ),
  //     );
  //   } catch (e) {
  //     print("ERROR ERROR ERROR EROOR ERROR ERRROR ERROR");
  //     print(e.toString());
  //     // showDialog(
  //     //   context: ctx,
  //     //   builder: (context) => AlertDialog(
  //     //     title: const Text("Another Error !"),
  //     //     content: Text(e.toString()),
  //     //     actions: [
  //     //       TextButton(
  //     //           onPressed: () {
  //     //             Navigator.of(context).pop();
  //     //             setState(() {
  //     //               _isLoading = false;
  //     //             });
  //     //           },
  //     //           child: const Text("OK!!"))
  //     //     ],
  //     //   ),
  //     // );
  //   } finally {
  //     // setState(() {
  //     //   _isLoading = false;
  //     // });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    double totalScreenHeight = MediaQuery.of(context).size.height;
    double totalScreenWidth = MediaQuery.of(context).size.width;
    CurrentUser currUser = Provider.of<CurrentUser>(context, listen: true);
    return Container(
      padding: EdgeInsets.all(
        // 32,
        calculateDynamicFontSize(
          totalScreenHeight: totalScreenHeight,
          totalScreenWidth: totalScreenWidth,
          currentFontSize: 60,
          // heightSpecific: true,
        ),
      ),
      child: Column(
        children: [
          Expanded(
              flex: 4,
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Welcome\nBack",
                  textAlign: TextAlign.start,
                  style: TextStyle(
                      // fontSize: 40,
                      fontSize: calculateDynamicFontSize(
                        totalScreenHeight: totalScreenHeight,
                        totalScreenWidth: totalScreenWidth,
                        currentFontSize: 100,
                        // heightSpecific: true,
                      ),
                      color: ColorPallets.white,
                      // fontWeight: FontWeight.w600,
                      fontFamily: GoogleFonts.audiowide().fontFamily),
                ),
              )),
          Expanded(
              flex: 6,
              child: Container(
                constraints: BoxConstraints(
                  // minWidth: 220,
                  minWidth: calculateDynamicFontSize(
                    totalScreenHeight: totalScreenHeight,
                    totalScreenWidth: totalScreenWidth,
                    currentFontSize: 220,
                    // heightSpecific: true,
                  ),
                ),
                child: Form(
                  key: formKey,
                  child: ListView(
                    children: [
                      // email text form
                      TextFormField(
                        controller: emailController,
                        key: const ValueKey("E-mail"),
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
                          // heightSpecific: false,,
                        ),
                        cursorColor: ColorPallets.deepBlue,
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
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                            fillColor: ColorPallets.deepBlue,
                            filled: false,
                            hoverColor: ColorPallets.deepBlue,
                            suffixIcon: emailController.text.isEmpty
                                ? const SizedBox(
                                    width: 0,
                                  )
                                : Padding(
                                    padding: EdgeInsets.only(
                                      // top: 10,
                                      top: calculateDynamicFontSize(
                                        totalScreenHeight: totalScreenHeight,
                                        totalScreenWidth: totalScreenWidth,
                                        currentFontSize: 40,
                                        // heightSpecific: true,
                                      ),
                                    ),
                                    child: IconButton(
                                        color: ColorPallets.deepBlue,
                                        onPressed: () {
                                          emailController.clear();
                                        },
                                        icon: Icon(
                                          FontAwesomeIcons.xmark,
                                          // size: 18,
                                          size: calculateDynamicFontSize(
                                            totalScreenHeight:
                                                totalScreenHeight,
                                            totalScreenWidth: totalScreenWidth,
                                            currentFontSize: 40,
                                            // heightSpecific: true,
                                          ),
                                        )),
                                  ),
                            focusColor: ColorPallets.deepBlue,
                            focusedBorder: const UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: ColorPallets.deepBlue)),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                // width: 2,
                                width: calculateDynamicFontSize(
                                  totalScreenHeight: totalScreenHeight,
                                  totalScreenWidth: totalScreenWidth,
                                  currentFontSize: 2,
                                  // heightSpecific: false,
                                ),
                                color: ColorPallets.deepBlue,
                              ),
                            ),
                            label: Text(
                              "E-mail",
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
                            hintText: "xxxxxxx@xxxx.xxx"),
                        validator: (newMailId) {
                          if (newMailId!.isEmpty || !newMailId.contains('@')) {
                            return "Invalid EmailId";
                          }
                          return null;
                        },
                        onSaved: (newMailId) {
                          _userDetails["email"] = newMailId as String;
                        },
                      ),
                      // password test form
                      TextFormField(
                        obscureText: isObsureText,
                        key: const ValueKey("Password"),
                        // cursorHeight: 22,
                        controller: passwordController,
                        // cursorWidth: 2,
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
                          // heightSpecific: false,
                        ),
                        cursorColor: ColorPallets.deepBlue,
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
                        keyboardType: TextInputType.visiblePassword,
                        textInputAction: TextInputAction.done,
                        decoration: InputDecoration(
                          suffixIcon: passwordController.text.isEmpty
                              ? const SizedBox()
                              : Padding(
                                  padding: EdgeInsets.only(
                                    // top: 10,
                                    top: calculateDynamicFontSize(
                                      totalScreenHeight: totalScreenHeight,
                                      totalScreenWidth: totalScreenWidth,
                                      currentFontSize: 40,
                                      // heightSpecific: true,
                                    ),
                                  ),
                                  child: IconButton(
                                    color: ColorPallets.deepBlue,
                                    icon: isObsureText
                                        ? Icon(
                                            Icons.visibility,
                                            size: calculateDynamicFontSize(
                                              totalScreenHeight:
                                                  totalScreenHeight,
                                              totalScreenWidth:
                                                  totalScreenWidth,
                                              currentFontSize: 40,
                                              // heightSpecific: true,
                                            ),
                                          )
                                        : Icon(
                                            Icons.visibility_off,
                                            size: calculateDynamicFontSize(
                                              totalScreenHeight:
                                                  totalScreenHeight,
                                              totalScreenWidth:
                                                  totalScreenWidth,
                                              currentFontSize: 40,
                                              // heightSpecific: true,
                                            ),
                                          ),
                                    onPressed: () {
                                      setState(() {
                                        isObsureText = !isObsureText;
                                      });
                                    },
                                  ),
                                ),
                          focusColor: ColorPallets.deepBlue,
                          focusedBorder: const UnderlineInputBorder(
                              borderSide:
                                  BorderSide(color: ColorPallets.deepBlue)),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              // width: 2,
                              width: calculateDynamicFontSize(
                                totalScreenHeight: totalScreenHeight,
                                totalScreenWidth: totalScreenWidth,
                                currentFontSize: 2,
                                // heightSpecific: false,
                              ),
                              color: ColorPallets.deepBlue,
                            ),
                          ),
                          label: Text(
                            "Password",
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
                        ),
                        validator: (newPassword) {
                          if (newPassword!.isEmpty || newPassword.length < 6) {
                            return "password min of 6 char";
                          }
                          return null;
                        },
                        onSaved: (newPassword) {
                          _userDetails["password"] = newPassword as String;
                        },
                      ),
                      //forget password Test form
                      Padding(
                        // padding: const EdgeInsets.symmetric(
                        //   vertical: 15,
                        //   horizontal: 8,
                        // ),
                        padding: EdgeInsets.symmetric(
                            vertical: calculateDynamicFontSize(
                              totalScreenHeight: totalScreenHeight,
                              totalScreenWidth: totalScreenWidth,
                              currentFontSize: 50,
                              // heightSpecific: true,
                            ),
                            horizontal: calculateDynamicFontSize(
                              totalScreenHeight: totalScreenHeight,
                              totalScreenWidth: totalScreenWidth,
                              currentFontSize: 15,
                              // heightSpecific: false,
                            )),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            InkWell(
                              onTap: () {
                                Navigator.of(context)
                                    .pushNamed(ForgetPasswordScreen.routeName);
                              },
                              child: Text(
                                "Forget Password ?",
                                style: TextStyle(
                                  color: ColorPallets.pinkinshShadedPurple,
                                  // fontSize: 16,
                                  fontSize: calculateDynamicFontSize(
                                    totalScreenHeight: totalScreenHeight,
                                    totalScreenWidth: totalScreenWidth,
                                    currentFontSize: 35,
                                    // heightSpecific: true,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // signIn bar
                      SignInBar(
                        isLoading: _isLoading,
                        label: "Sign In",
                        onPressed: () => submitSinginform(
                          context,
                          currUser,
                          totalScreenHeight,
                          totalScreenWidth,
                        ),
                      ),

                      // nav b/w login and register screen
                      Padding(
                        // padding: const EdgeInsets.symmetric(
                        //   vertical: 15,
                        //   horizontal: 8,
                        // ),
                        padding: EdgeInsets.symmetric(
                            vertical: calculateDynamicFontSize(
                              totalScreenHeight: totalScreenHeight,
                              totalScreenWidth: totalScreenWidth,
                              currentFontSize: 40,
                              // heightSpecific: true,
                            ),
                            horizontal: calculateDynamicFontSize(
                              totalScreenHeight: totalScreenHeight,
                              totalScreenWidth: totalScreenWidth,
                              currentFontSize: 16,
                              // heightSpecific: false,
                            )),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              "Create a Account !!",
                              style: TextStyle(
                                // fontSize: 18,
                                fontSize: calculateDynamicFontSize(
                                  totalScreenHeight: totalScreenHeight,
                                  totalScreenWidth: totalScreenWidth,
                                  currentFontSize: 40,
                                  // heightSpecific: true,
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                if (widget.callRegisterScreen != null) {
                                  widget.callRegisterScreen();
                                }
                              },
                              child: Text(
                                "Register",
                                style: TextStyle(
                                  color: ColorPallets.pinkinshShadedPurple,
                                  // fontSize: 20,
                                  fontSize: calculateDynamicFontSize(
                                    totalScreenHeight: totalScreenHeight,
                                    totalScreenWidth: totalScreenWidth,
                                    currentFontSize: 40,
                                    // heightSpecific: true,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(
                        // height: 10,
                        height: calculateDynamicFontSize(
                          totalScreenHeight: totalScreenHeight,
                          totalScreenWidth: totalScreenWidth,
                          currentFontSize: 30,
                          // heightSpecific: true,
                        ),
                      ),

                      // google sign in up
                      // InkWell(
                      //   onTap: () => signInUpWithGoogle(currUser, context),
                      //   child: Container(
                      //     height: 60,
                      //     width: 130,
                      //     padding: const EdgeInsets.symmetric(
                      //       vertical: 1,
                      //       horizontal: 2,
                      //     ),
                      //     decoration: BoxDecoration(
                      //         border: Border.all(
                      //           color: ColorPallets.deepBlue,
                      //           width: 2,
                      //         ),
                      //         borderRadius: BorderRadius.circular(18)),
                      //     child: Row(
                      //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      //       children: [
                      //         Image.asset(
                      //           "assets/image/google.png",
                      //           fit: BoxFit.cover,
                      //         ),
                      //         const Text(
                      //           "Sign In With Google",
                      //           textAlign: TextAlign.start,
                      //           style: TextStyle(
                      //             fontSize: 22,
                      //             color: ColorPallets.black,
                      //             fontWeight: FontWeight.w500,
                      //           ),
                      //         )
                      //       ],
                      //     ),
                      //   ),
                      // )
                      Padding(
                        // padding: const EdgeInsets.symmetric(
                        //     vertical: 15, horizontal: 8),
                        padding: EdgeInsets.symmetric(
                            vertical: calculateDynamicFontSize(
                              totalScreenHeight: totalScreenHeight,
                              totalScreenWidth: totalScreenWidth,
                              currentFontSize: 15,
                              // heightSpecific: true,
                            ),
                            horizontal: calculateDynamicFontSize(
                              totalScreenHeight: totalScreenHeight,
                              totalScreenWidth: totalScreenWidth,
                              currentFontSize: 8,
                              // heightSpecific: false,
                            )),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            InkWell(
                              onTap: () {
                                Navigator.of(context)
                                    .pushNamed(PrivacyPolicy.routeName);
                              },
                              child: Text(
                                "Privacy policy",
                                style: TextStyle(
                                  color: ColorPallets.pinkinshShadedPurple,
                                  // fontSize: 14,
                                  fontSize: calculateDynamicFontSize(
                                    totalScreenHeight: totalScreenHeight,
                                    totalScreenWidth: totalScreenWidth,
                                    currentFontSize: 30,
                                    // heightSpecific: true,
                                  ),
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.of(context)
                                    .pushNamed(TermsAndCond.routeName);
                              },
                              child: Text(
                                "Terms & conditions",
                                style: TextStyle(
                                  color: ColorPallets.pinkinshShadedPurple,
                                  // fontSize: 16,
                                  fontSize: calculateDynamicFontSize(
                                    totalScreenHeight: totalScreenHeight,
                                    totalScreenWidth: totalScreenWidth,
                                    currentFontSize: 30,
                                    // heightSpecific: true,
                                  ),
                                ),
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
