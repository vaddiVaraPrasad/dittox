import 'package:flutter/material.dart';

class CustomTandCText extends StatelessWidget {
  String title = "title";
  String text = "text";
  CustomTandCText({super.key, required title, required text});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(this.title),
        Text(this.text),
      ],
    );
  }
}
