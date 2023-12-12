import 'package:flutter/material.dart';
import "package:connectivity_plus/connectivity_plus.dart";
import "package:provider/provider.dart";
import 'package:google_fonts/google_fonts.dart';

import "./helpers/sqlLite.dart";

import "./utils/color_pallets.dart";

import "./providers/current_user.dart";

import "./screens/additional/network_error.dart";
import "./screens/auth/auth_screen.dart";
import "screens/auth/forget_password_screen.dart";

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SQLHelpers.getDatabase;
  runApp(dittox());
}

class dittox extends StatefulWidget {
  const dittox({super.key});

  @override
  State<dittox> createState() => _dittoxState();
}

class _dittoxState extends State<dittox> {
  final Stream<ConnectivityResult> connectivityStream =
      Connectivity().onConnectivityChanged;

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
        title: "Xerox",
        debugShowCheckedModeBanner: false,
        // googlefonts.istokweb is for heading  .. when ever in need use there ..
        // googlefonts.lora is for body ..... so we defing the lora as global text theme
        theme: ThemeData(
          // canvasColor: ColorPallets.yellowShadedPurple,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          textTheme: GoogleFonts.ubuntuTextTheme(),
          colorScheme: ColorScheme.fromSwatch().copyWith(
            secondary: ColorPallets.deepBlue,
            primary: ColorPallets.deepBlue,
          ),
          appBarTheme: const AppBarTheme(
            color: ColorPallets.deepBlue,
            // systemOverlayStyle: SystemUiOverlayStyle.light,
          ),
        ),
        home: StreamBuilder<ConnectivityResult>(
            stream: Connectivity().onConnectivityChanged,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                switch (snapshot.data!) {
                  case ConnectivityResult.wifi:
                  case ConnectivityResult.mobile:
                    return AuthScreen();
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
