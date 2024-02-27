import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dittox/screens/additional/network_error.dart';
import 'package:dittox/screens/auth/auth_screen.dart';
import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

import '../../utils/dynamicSizing.dart';
import '../nav_drawers/navBar.dart';

class DittoxSplash extends StatefulWidget {
  String? accessToken;
  DittoxSplash({super.key, required this.accessToken});

  @override
  State<DittoxSplash> createState() => _DittoxSplashState();
}

class _DittoxSplashState extends State<DittoxSplash> {
  StreamController<bool> loginINConditionController = StreamController<bool>();

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

  Widget getHomeSplashScreen() {
    return StreamBuilder<ConnectivityResult>(
        stream: Connectivity().onConnectivityChanged,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            print(widget.accessToken);
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
                if (widget.accessToken == null) {
                  return const AuthScreen();
                } else {
                  return StreamBuilder<bool>(
                      stream: loginInConditionStream(widget.accessToken),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          if (snapshot.data == true) {
                            return ButtonNavigationBar(
                              accessToken: widget.accessToken as String,
                            );
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
        });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _navigateToHomeScreen();
  }

  void _navigateToHomeScreen() async {
    await Future.delayed(const Duration(milliseconds: 750), () {});
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (context) => getHomeSplashScreen()));
  }

  @override
  Widget build(BuildContext context) {
    double totalScreenHeight = MediaQuery.of(context).size.height;
    double totalScreenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Center(
        child: Container(
          padding: EdgeInsets.symmetric(
              // horizontal: 40,
              horizontal: calculateDynamicFontSize(
            totalScreenHeight: totalScreenHeight,
            totalScreenWidth: totalScreenWidth,
            currentFontSize: 40,
            // heightSpecific: true,
          )),
          child: Image.asset(
            "assets/image/dittox_splash_logo.png",
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
