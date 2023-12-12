import 'package:animations/animations.dart';
import "package:flutter/material.dart";
import 'package:get/state_manager.dart';

import "./backgroundpaint_screen.dart";
import "./login_Screen.dart";
import "./register_screen.dart";

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  ValueNotifier<bool> showSignInPage = ValueNotifier<bool>(true);

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SizedBox.expand(
            child: CustomPaint(
                painter:
                    BackGroundPainter(animation: _animationController.view)),
          ),
          // Center(
          //   child: ConstrainedBox(
          //     constraints: const BoxConstraints(maxWidth: 800),
          //     child: ValueListenableBuilder<bool>(
          //       valueListenable: showSignInPage,
          //       builder: (context, value, child) {
          //         return PageTransitionSwitcher(
          //           reverse: !value,
          //           duration: const Duration(milliseconds: 800),
          //           transitionBuilder:
          //               (child, primaryAnimation, secondaryAnimation) {
          //             return SharedAxisTransition(
          //               animation: _animationController,
          //               secondaryAnimation: secondaryAnimation,
          //               transitionType: SharedAxisTransitionType.vertical,
          //               fillColor: Color.fromARGB(255, 255, 250, 250),
          //               child: child,
          //             );
          //           },
          //           child: value
          //               ? LoginScreen(callRegisterScreen: () {
          //                   showSignInPage.value = false;
          //                   _animationController.forward();
          //                 })
          //               : RegisterScreen(callLoginScreen: () {
          //                   showSignInPage.value = true;
          //                   _animationController.reverse();
          //                 }),
          //         );
          //       },
          //     ),
          //   ),
          // )

          ValueListenableBuilder(
            valueListenable: showSignInPage,
            builder: (BuildContext context, dynamic value, Widget? child) {
              return value
                  ? LoginScreen(callRegisterScreen: () {
                      showSignInPage.value = false;
                      _animationController.forward();
                    })
                  : RegisterScreen(callLoginScreen: () {
                      showSignInPage.value = true;
                      _animationController.reverse();
                    });
            },
          ),

          // RegisterScreen()
        ],
      ),
    );
  }
}
