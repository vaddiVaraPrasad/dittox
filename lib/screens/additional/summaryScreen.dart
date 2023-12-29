import 'package:flutter/material.dart';

class SummaryScreen extends StatefulWidget {
  static const routeName = "/summary";
  const SummaryScreen({super.key});

  @override
  State<SummaryScreen> createState() => _SummaryScreenState();
}

class _SummaryScreenState extends State<SummaryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("summary screen"),
      ),
    );
  }
}
