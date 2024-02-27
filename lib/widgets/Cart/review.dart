import 'dart:convert';

import 'package:dittox/utils/color_pallets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;

import '../../utils/dynamicSizing.dart';

class ReviewWidget extends StatefulWidget {
  String id;
  String shopId;
  String accessToken;
  ReviewWidget({
    super.key,
    required this.id,
    required this.accessToken,
    required this.shopId,
  });
  @override
  _ReviewWidgetState createState() => _ReviewWidgetState();
}

class _ReviewWidgetState extends State<ReviewWidget> {
  TextEditingController reviewController = TextEditingController();
  double rating = 1.0;

  bool _isLoading = false;
  @override
  void initState() {
    super.initState();
    reviewController.text = "";
  }

  Future<void> sendReview(
    double totalScreenHeight,
    double totalScreenWidth,
  ) async {
    try {
      setState(() {
        _isLoading = true;
      });

      final String url =
          'https://dittox.in/xerox/v1/store/addReview/${widget.shopId},${widget.id}';
      print("before request vody");
      Map<String, dynamic> requestBody = {
        "rating": rating.toInt(),
        "review": reviewController.text.toString(),
      };
      print(requestBody);
      var responce = await http.post(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
          'X-auth-token': 'bearer ${widget.accessToken}'
        },
        body: jsonEncode(requestBody),
      );

      var jsonResponce = jsonDecode(responce.body);
      print(jsonResponce);
      // print(jsonResponce);
      var responseCode = jsonResponce["responseCode"].toString();
      if (responseCode == "OK") {
        print("INSIDE OK");
        ScaffoldMessenger.of(context).clearSnackBars();

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: ColorPallets.deepBlue,
            content: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const Icon(
                  FontAwesomeIcons.triangleExclamation,
                  color: Colors.green,
                ),
                Flexible(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      "Yout Review has successfully Recored",
                      style: TextStyle(
                        // fontSize: 18,
                        fontSize: calculateDynamicFontSize(
                          totalScreenHeight: totalScreenHeight,
                          totalScreenWidth: totalScreenWidth,
                          currentFontSize: 18,
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
      } else {
        throw new Exception("Something went wrong");
      }
    } catch (e) {
      print(e);
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
                    e.toString(),
                    style: TextStyle(
                      // fontSize: 18,
                      fontSize: calculateDynamicFontSize(
                        totalScreenHeight: totalScreenHeight,
                        totalScreenWidth: totalScreenWidth,
                        currentFontSize: 18,
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
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double totalScreenHeight = MediaQuery.of(context).size.height;
    double totalScreenWidth = MediaQuery.of(context).size.width;
    return Container(
      // margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      margin: EdgeInsets.symmetric(
          vertical: calculateDynamicFontSize(
            totalScreenHeight: totalScreenHeight,
            totalScreenWidth: totalScreenWidth,
            currentFontSize: 5,
            // heightSpecific: true,
          ),
          horizontal: calculateDynamicFontSize(
            totalScreenHeight: totalScreenHeight,
            totalScreenWidth: totalScreenWidth,
            currentFontSize: 10,
            // heightSpecific: false,
          )),
      padding: EdgeInsets.all(
        // 16.0,
        calculateDynamicFontSize(
          totalScreenHeight: totalScreenHeight,
          totalScreenWidth: totalScreenWidth,
          currentFontSize: 16,
          // heightSpecific: true,
        ),
      ),
      decoration: BoxDecoration(
          border: Border.all(color: ColorPallets.deepBlue),
          borderRadius: BorderRadius.circular(
            // 12,
            calculateDynamicFontSize(
              totalScreenHeight: totalScreenHeight,
              totalScreenWidth: totalScreenWidth,
              currentFontSize: 12,
              // heightSpecific: true,
            ),
          )),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          TextField(
            controller: reviewController,
            decoration: const InputDecoration(
              hoverColor: ColorPallets.deepBlue,
              hintText: 'Write a review...',
            ),
          ),
          SizedBox(
            // height: 20.0,
            height: calculateDynamicFontSize(
              totalScreenHeight: totalScreenHeight,
              totalScreenWidth: totalScreenWidth,
              currentFontSize: 20,
              // heightSpecific: true,
            ),
          ),
          RatingBar.builder(
            initialRating: rating,
            minRating: 1,
            direction: Axis.horizontal,
            allowHalfRating: false,
            itemCount: 5,
            // itemSize: 35,
            itemSize: calculateDynamicFontSize(
              totalScreenHeight: totalScreenHeight,
              totalScreenWidth: totalScreenWidth,
              currentFontSize: 35,
              // heightSpecific: true,
            ),
            unratedColor: Colors.amber.shade100.withOpacity(.7),
            itemPadding: EdgeInsets.symmetric(
              // horizontal: 4.0,
              horizontal: calculateDynamicFontSize(
                totalScreenHeight: totalScreenHeight,
                totalScreenWidth: totalScreenWidth,
                currentFontSize: 4,
                // heightSpecific: false,
              ),
            ),
            itemBuilder: (context, _) => const Icon(
              Icons.star,
              color: Colors.amber,
            ),
            onRatingUpdate: (newRating) {
              setState(() {
                rating = newRating;
              });
            },
          ),
          SizedBox(
            // height: 10,
            height: calculateDynamicFontSize(
              totalScreenHeight: totalScreenHeight,
              totalScreenWidth: totalScreenWidth,
              currentFontSize: 10,
              // heightSpecific: true,
            ),
          ),
          ElevatedButton(
            onPressed: () {
              print('Review: ${reviewController.text}');
              print('Rating: $rating');
              sendReview(
                totalScreenHeight,
                totalScreenWidth,
              );
            },
            child: _isLoading
                ? const Center(
                    child: CircularProgressIndicator(
                      color: ColorPallets.deepBlue,
                    ),
                  )
                : Text(
                    'Submit',
                    style: TextStyle(
                      color: ColorPallets.deepBlue,
                      // fontSize: 18,
                      fontSize: calculateDynamicFontSize(
                        totalScreenHeight: totalScreenHeight,
                        totalScreenWidth: totalScreenWidth,
                        currentFontSize: 18,
                        // heightSpecific: true,
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
