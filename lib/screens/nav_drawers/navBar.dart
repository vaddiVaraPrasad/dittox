import "package:dittox/screens/home/dummy_home.dart";
import "package:flutter/material.dart";
import "package:google_nav_bar/google_nav_bar.dart";
import "package:line_icons/line_icons.dart";

import "../../utils/color_pallets.dart";

import "../../utils/dynamicSizing.dart";
import "../navBar_Screens/cart_Screen.dart";
import "../navBar_Screens/home_screen.dart";
import "../navBar_Screens/profile_Screen.dart";

class ButtonNavigationBar extends StatefulWidget {
  static const routeName = "/buttomNavBar";
  String accessToken;
  ButtonNavigationBar({super.key, required this.accessToken});

  @override
  State<ButtonNavigationBar> createState() => _ButtonNavigationBarState();
}

class _ButtonNavigationBarState extends State<ButtonNavigationBar> {
  int _seletedIndex = 0;

  late List<Widget> _screens;

  @override
  void initState() {
    _screens = [
      HomeScreen(
        accessToken: widget.accessToken,
      ),
      // SearchShop(),
      CartScreen(
        accessToken: widget.accessToken,
      ),
      // ProfilePage()
      ProfilePage(
        accessToken: widget.accessToken,
      )
    ];
    // TODO: implement initState
    super.initState();
  }

  // static const List<Widget> _widgetOptions = <Widget>[
  //   Text(
  //     'Home',
  //     style: optionStyle,
  //   ),
  //   Text(
  //     'Likes',
  //     style: optionStyle,
  //   ),
  //   Text(
  //     'Search',
  //     style: optionStyle,
  //   ),
  //   Text(
  //     'Profile',
  //     style: optionStyle,
  //   ),
  // ];
  @override
  Widget build(BuildContext context) {
    double totalScreenHeight = MediaQuery.of(context).size.height;
    double totalScreenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: _screens[_seletedIndex],
      bottomNavigationBar: Container(
        padding: EdgeInsets.symmetric(
          // vertical: 3,
          vertical: calculateDynamicFontSize(
            totalScreenHeight: totalScreenHeight,
            totalScreenWidth: totalScreenWidth,
            currentFontSize: 10,
            // heightSpecific: true,
          ),
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              // blurRadius: 20,
              blurRadius: calculateDynamicFontSize(
                totalScreenHeight: totalScreenHeight,
                totalScreenWidth: totalScreenWidth,
                currentFontSize: 20,
                // heightSpecific: true,
              ),
              color: Colors.black.withOpacity(.1),
            )
          ],
        ),
        child: SafeArea(
          child: Padding(
            // padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
            padding: EdgeInsets.symmetric(
                vertical: calculateDynamicFontSize(
                  totalScreenHeight: totalScreenHeight,
                  totalScreenWidth: totalScreenWidth,
                  currentFontSize: 24,
                  // heightSpecific: true,
                ),
                horizontal: calculateDynamicFontSize(
                  totalScreenHeight: totalScreenHeight,
                  totalScreenWidth: totalScreenWidth,
                  currentFontSize: 30,
                  // heightSpecific: false,
                )),
            child: GNav(
              rippleColor: ColorPallets.lightPurplishWhile,
              hoverColor: ColorPallets.lightPurplishWhile,
              // gap : 8
              gap: calculateDynamicFontSize(
                totalScreenHeight: totalScreenHeight,
                totalScreenWidth: totalScreenWidth,
                currentFontSize: 20,
                // heightSpecific: false,
              ),
              // iconSize: 24,
              iconSize: calculateDynamicFontSize(
                totalScreenHeight: totalScreenHeight,
                totalScreenWidth: totalScreenWidth,
                currentFontSize: 50,
                // heightSpecific: true,
              ),
              // padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              padding: EdgeInsets.symmetric(
                  vertical: calculateDynamicFontSize(
                    totalScreenHeight: totalScreenHeight,
                    totalScreenWidth: totalScreenWidth,
                    currentFontSize: 30,
                    // heightSpecific: true,
                  ),
                  horizontal: calculateDynamicFontSize(
                    totalScreenHeight: totalScreenHeight,
                    totalScreenWidth: totalScreenWidth,
                    currentFontSize: 40,
                    // heightSpecific: false,
                  )),
              duration: const Duration(milliseconds: 400),
              tabBackgroundColor: Colors.grey[100]!,
              color: Colors.black,
              tabs: [
                GButton(
                  icon: LineIcons.home,
                  text: 'Home',
                  textColor: Colors.purple,
                  backgroundGradient: LinearGradient(colors: [
                    ColorPallets.lightPurple.withOpacity(.9),
                    ColorPallets.lightPurple.withOpacity(.3)
                  ]),
                  iconActiveColor: Colors.purple,
                ),
                // GButton(
                //   icon: LineIcons.search,
                //   textColor: const Color.fromARGB(220, 193, 49, 102),
                //   backgroundGradient: LinearGradient(colors: [
                //     ColorPallets.pinkinshShadedPurple.withOpacity(.7),
                //     ColorPallets.pinkinshShadedPurple.withOpacity(.2)
                //   ]),
                //   iconActiveColor: const Color.fromARGB(220, 193, 49, 102),
                //   text: 'Search',
                // ),
                GButton(
                  icon: LineIcons.shoppingBag,
                  textColor: ColorPallets.deepBlue,
                  iconActiveColor: ColorPallets.deepBlue,
                  backgroundGradient: LinearGradient(colors: [
                    ColorPallets.lightBlue.withOpacity(.6),
                    ColorPallets.lightBlue.withOpacity(.1)
                  ]),
                  text: 'Cart',
                ),
                GButton(
                  icon: LineIcons.user,
                  text: 'Profile',
                  textColor: const Color.fromARGB(220, 193, 49, 102),
                  iconActiveColor: const Color.fromARGB(220, 193, 49, 102),
                  backgroundGradient: LinearGradient(colors: [
                    ColorPallets.pinkinshShadedPurple.withOpacity(.7),
                    ColorPallets.pinkinshShadedPurple.withOpacity(.2)
                  ]),
                ),
              ],
              selectedIndex: _seletedIndex,
              onTabChange: (index) {
                setState(() {
                  _seletedIndex = index;
                });
              },
            ),
          ),
        ),
      ),
    );
  }
}
