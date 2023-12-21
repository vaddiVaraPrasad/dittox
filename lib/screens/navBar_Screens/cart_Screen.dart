import "dart:io";
import 'dart:convert';
import "package:dittox/helpers/sqlLite.dart";
import "package:dittox/providers/ListOfPdfFiles.dart";
import "package:flutter/material.dart";
import "package:provider/provider.dart";
import 'package:http/http.dart' as http;
import 'package:file_picker/file_picker.dart';
import '../../helpers/fileUpload.dart';

// import "../../widgets/Cart/no_items.dart";
import "../../providers/current_user.dart";
import "../../utils/color_pallets.dart";
// import "../../widgets/Cart/no_items.dart";
// import "../../widgets/Cart/onGoing_xerox_Item.dart";

class CartScreen extends StatefulWidget {
  static const routeName = "/cartScreen";
  String accessToken;
  CartScreen({super.key, required this.accessToken});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  void getAllTableData() {
    SQLHelpers.getAllTableData("users");
  }

  bool isLoading = false;

  Future<void> uploadFile() async {
    // Set the API endpoint
    String endpoint = "https://dittox.in/xerox/v1/fileUpload/create";

    // Set the headers with the X-auth-token
    Map<String, String> headers = {
      "X-auth-token": "bearer ${widget.accessToken}",
    };

    // Pick a file using file_picker
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      File file = File(result.files.single.path!);
      print("BEFRORE ________>>>>>>>");
      print(result.files.single.path!);
      // Create a multipart request
      var request = http.MultipartRequest('POST', Uri.parse(endpoint))
        ..headers.addAll(headers)
        ..files.add(http.MultipartFile(
          'files',
          file.readAsBytes().asStream(),
          file.lengthSync(),
          filename: result.files.single.name,
        ));

      try {
        // Send the request
        var response = await request.send();
        var responseData = await response.stream.toBytes();
        var responseString = utf8.decode(responseData);

        print(responseString);

        // Check the response
        if (response.statusCode == 200) {
          print("File uploaded successfully.");
        } else {
          print("Error uploading file. Status code: ${response.statusCode}");
          print(responseString);
        }
      } catch (error) {
        print("Error uploading file: $error");
      }
    } else {
      print("No file picked.");
    }
  }

  @override
  Widget build(BuildContext context) {
    CurrentUser curUSer = Provider.of<CurrentUser>(context);
    ListOfPDFFiles listfiles =
        Provider.of<ListOfPDFFiles>(context, listen: true);
    return Scaffold(
      appBar: AppBar(
        foregroundColor: ColorPallets.white,
        title: const Text("On-Going Xerox"),
      ),
      // body: SafeArea(
      //     child: Container(
      //         padding: EdgeInsets.symmetric(horizontal: 3, vertical: 15),
      //         child: Column(
      //           mainAxisAlignment: MainAxisAlignment.start,
      //           children: [
      //             // const Text(
      //             //   "On-Going Xerox",
      //             //   style: TextStyle(
      //             //       fontSize: 28,
      //             //       letterSpacing: 1.5,
      //             //       color: ColorPallets.deepBlue),
      //             //   textAlign: TextAlign.start,
      //             // ),
      //             // const Divider(
      //             //   color: ColorPallets.deepBlue,
      //             //   thickness: 2,
      //             // ),
      //             Flexible(
      //               // child: ListView(
      //               //   children: [],
      //               // ),
      //               child: StreamBuilder(
      //                 stream: FirebaseFirestore.instance
      //                     .collection("Orders")
      //                     .where("customerId", isEqualTo: curUSer.getUserId)
      //                     .where("orderStatus", isNotEqualTo: "Collected")
      //                     .snapshots(),
      //                 builder: (context, snapshot) {
      //                   if (snapshot.hasError) {
      //                     return const Center(
      //                       child:
      //                           Text("something went wrong in streambuilder"),
      //                     );
      //                   }
      //                   if (snapshot.connectionState ==
      //                       ConnectionState.waiting) {
      //                     return const Center(
      //                       child: CircularProgressIndicator(),
      //                     );
      //                   }
      //                   if (snapshot.data!.docs.isEmpty) {
      //                     return const Center(child: NoOrders());
      //                   }
      //                   return ListView.builder(
      //                     itemCount: snapshot.data!.docs.length,
      //                     itemBuilder: (context, index) {
      //                       var smth = snapshot.data!.docs[index];

      //                       return CartItem(
      //                         onGoingXeroxItem: smth.data(),
      //                       );
      //                     },
      //                   );
      //                 },
      //               ),
      //             ),
      //           ],
      //         ))),
      body: Center(
        child: isLoading
            ? CircularProgressIndicator()
            : TextButton(
                onPressed: () async {
                  setState(() {
                    isLoading = true;
                  });
                  // fileUpload.pickFiles(context);
                  // uploadFile();
                  listfiles.allPdfList.forEach((e) {
                    print(e.pdfName);
                  });
                  setState(() {
                    isLoading = false;
                  });
                },
                child: const Text("Press here to get responce")),
      ),
    );
  }
}
