import "dart:async";

import "package:dittox/screens/nav_drawers/navBar.dart";
import 'package:flutter/material.dart';
import "package:connectivity_plus/connectivity_plus.dart";
import "package:provider/provider.dart";
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/services.dart';
import "package:shared_preferences/shared_preferences.dart";
import 'package:jwt_decoder/jwt_decoder.dart';

import "./helpers/sqlLite.dart";

import "./utils/color_pallets.dart";

import "./providers/current_user.dart";

import "./screens/additional/network_error.dart";
import "./screens/auth/auth_screen.dart";
import "screens/auth/forget_password_screen.dart";
import "screens/auth/privacy_policy.dart";
import "screens/auth/termsandcondictions.dart";
import "screens/home/dummy_home.dart";

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SQLHelpers.getDatabase;
  SharedPreferences prefs = await SharedPreferences.getInstance();
  runApp(dittox(
    accessToken: prefs.getString("AccessToken"),
  ));
}

class dittox extends StatelessWidget {
  final accessToken;
  StreamController<bool> loginINConditionController = StreamController<bool>();
  dittox({
    super.key,
    required this.accessToken,
  });

  final Stream<ConnectivityResult> connectivityStream =
      Connectivity().onConnectivityChanged;

  Stream<bool> loginInConditionStream(String? accessToken) async* {
    var result = (accessToken == null)
        ? false
        : (JwtDecoder.isExpired(accessToken) == false)
            ? true
            : false;
    print("RESULT FROM STREAMS ${result}");
    yield result;
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => CurrentUser(),
        ),
        // ChangeNotifierProvider(
        //   create: (context) => PlaceResult(),
        // ),
        // ChangeNotifierProvider(
        //   create: (context) => NearestShopProvider(),
        // ),
        // ChangeNotifierProvider(
        //   create: (context) => SelectedShop(),
        // ),
        // ChangeNotifierProvider(
        //   create: (context) => CurrentOrder(),
        // )
      ],
      child: MaterialApp(
        title: "Dittox",
        debugShowCheckedModeBanner: false,
        // googlefonts.istokweb is for heading  .. when ever in need use there ..
        // googlefonts.lora is for body ..... so we defing the lora as global text theme
        theme: ThemeData(
          // canvasColor: ColorPallets.yellowShadedPurple,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          textTheme: GoogleFonts.ubuntuTextTheme(),
          // colorScheme: ColorScheme.fromSwatch().copyWith(
          //   // secondary: ColorPallets.deepBlue,
          //   // primary: ColorPallets.deepBlue,
          // ),
          appBarTheme: const AppBarTheme(
            color: ColorPallets.deepBlue,
            // systemOverlayStyle: SystemUiOverlayStyle.light,
            systemOverlayStyle: SystemUiOverlayStyle.light,
          ),
        ),
        home: StreamBuilder<ConnectivityResult>(
            stream: Connectivity().onConnectivityChanged,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                print(accessToken);
                switch (snapshot.data!) {
                  case ConnectivityResult.wifi:
                  case ConnectivityResult.mobile:
                    // return ((accessToken == null) ||
                    //         (JwtDecoder.isExpired(accessToken) == ))
                    //     ? const AuthScreen()
                    //     : const DummyHome();
                    // return accessToken == null
                    //     ? AuthScreen()
                    //     : (JwtDecoder.isExpired(accessToken) == false)
                    //         ? DummyHome()
                    //         : AuthScreen();
                    if (accessToken == null) {
                      return const AuthScreen();
                    } else {
                      return StreamBuilder<bool>(
                          stream: loginInConditionStream(accessToken),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              if (snapshot.data == true) {
                                return const ButtonNavigationBar();
                              } else {
                                return const AuthScreen();
                              }
                            } else if (snapshot.hasError) {
                              return Text('Error: ${snapshot.error}');
                            } else {
                              return const CircularProgressIndicator();
                            }
                          });
                    }
                  default:
                    return const NetworkError();
                }
              } else {
                return const CircularProgressIndicator();
              }
            }),
        routes: {
          ForgetPasswordScreen.routeName: (context) =>
              const ForgetPasswordScreen(),
          TermsAndCond.routeName: (context) => const TermsAndCond(),
          PrivacyPolicy.routeName: (context) => const PrivacyPolicy(),
          DummyHome.routeName: (context) => const DummyHome(),
          ButtonNavigationBar.routeName: (context) =>
              const ButtonNavigationBar(),
          // AboutUs.routeName: (context) => const AboutDialog(),
          // CartScreen.routeName: (context) => const CartScreen(),
          // ContactUs.routeName: (context) => const ContactUs(),
          // HomeScreen.routeName: (context) => const HomeScreen(),
          // OrderScreen.routeName: (context) => const OrderScreen(),
          // ProfilePage.routeName: (context) => const ProfilePage(),
          // OrderPreviewScreen.routeName: (context) => const OrderPreviewScreen(),
          // CustomPDFPreview.routeName: (context) => const CustomPDFPreview(),
          // PdfImagesRender.routeName: (context) => const PdfImagesRender(),
          // PdfFilters.routeName: (context) => const PdfFilters(),
          // NotificationPage.routeName: (context) => const NotificationPage(),
          // DummyShops.routeName: (context) => const DummyShops(),
          // ButtonNavigationBar.routeName: (context) =>
          //     const ButtonNavigationBar(),
          // setLocationMaps.routeName: (context) => const setLocationMaps(),
          // LocationText.routeName: (context) => const LocationText(),
          // HiddenSideZoomDrawer.routeName: (context) => const HiddenSideZoomDrawer()
        },
      ),
    );
  }
}
