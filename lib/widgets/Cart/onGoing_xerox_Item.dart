import 'package:flutter/material.dart';

class CarrOnGoingItem extends StatefulWidget {
  Map<String, dynamic> onGoingXeroxItem;
  CarrOnGoingItem({super.key, required this.onGoingXeroxItem});

  @override
  State<CarrOnGoingItem> createState() => _CarrOnGoingItemState();
}

class _CarrOnGoingItemState extends State<CarrOnGoingItem> {

  // String getDate(String data) {
  //   String dateTimeString = data;
  //   DateFormat dateFormat = DateFormat.yMMMMd();
  //   DateTime dateTime =
  //       DateFormat('EEEE, MMMM d, y - h:mm:ss a').parse(dateTimeString);
  //   String dateString = dateFormat.format(dateTime);
  //   return dateString;
  // }

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
