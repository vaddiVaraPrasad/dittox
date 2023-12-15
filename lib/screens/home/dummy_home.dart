import 'package:dittox/screens/auth/auth_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DummyHome extends StatefulWidget {
  static const routeName = "/dummyHome";
  const DummyHome({super.key});

  @override
  State<DummyHome> createState() => _DummyHomeState();
}

class _DummyHomeState extends State<DummyHome> {
  late SharedPreferences prefs;
  bool isLoading = false;
  void initState() {
    initSharePref();
    super.initState();
  }

  void initSharePref() async {
    prefs = await SharedPreferences.getInstance();
  }

  Future<void> _performLogout() async {}

  void logout(BuildContext ctx) async {
    print("logout button is pressed");
    setState(() {
      isLoading = true;
    });
    try {
      var result = await prefs.remove("AccessToken");
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (ctx) => const AuthScreen(),
          ),
          (route) => false);
      if (result) {
        print("SUCCESSFULLY LOGOUT !!");
      } else {
        print("UNALBE TO LOGOUT");
      }
    } catch (e) {
      print("error during logout");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: isLoading
            ? const CircularProgressIndicator()
            : TextButton(
                child: Text("FUCK OFF !! BITCH"),
                onPressed: () => logout(context),
              ),
      ),
    );
  }
}
