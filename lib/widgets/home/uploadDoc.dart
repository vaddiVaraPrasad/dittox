// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:io';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:advance_pdf_viewer_fork/advance_pdf_viewer_fork.dart';
import 'package:file_picker/file_picker.dart';
import "package:flutter/material.dart";
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

// import '../../model/custom_pdf_modal.dart';
// import '../../screens/pdf/cutom_pdf_Render_Screen.dart';
import '../../model/pdfFile.dart';
import '../../providers/ListOfPdfFiles.dart';
import '../../screens/pdf/pdfFilter.dart';
import '../../utils/color_pallets.dart';

class UploadDoc extends StatefulWidget {
  final BuildContext ctx;
  String accessToken;

  UploadDoc({
    super.key,
    required this.ctx,
    required this.accessToken,
  });

  @override
  State<UploadDoc> createState() => _UploadDocState();
}

class _UploadDocState extends State<UploadDoc> {
  bool isPdfLoading = false;

  String bytesToMB(int bytes) {
    const int bytesInKB = 1024;
    const int bytesInMB = bytesInKB * 1024;

    if (bytes >= bytesInMB) {
      double sizeInMB = bytes / bytesInMB;
      return '${sizeInMB.toStringAsFixed(2)} MB';
    } else {
      double sizeInKB = bytes / bytesInKB;
      return '${sizeInKB.toStringAsFixed(2)} KB';

      // File 1:
      // Name: Notfn_ Group-II_2023 with Syllabus_112023_07122023 (1).pdf
      // Size : 279.59 KB
      // Page Count: 11
    }
  }

  Future<String?> uploadFileGetDownloadUrl(
      File pdffile, String fileName, String filePath) async {
    try {
      final url = Uri.parse(
          "https://dittox.in/xerox/v1/cloud-services/file/getSignedUrl");
      final headers = {"X-auth-token": "bearer ${widget.accessToken}"};
      // print("Filename is ${fileName}");
      final params = {"fileName": fileName};

      var url_get = Uri.https(url.authority, url.path, params);
      var response = await http.get(url_get, headers: headers);
      final signed = json.decode(response.body);
      // print(signed);
      if (signed["responseCode"] == "OK") {
        final filePath = signed["result"]["filePath"];
        final signedUrl = signed["result"]["signedUrl"];
        // print("signed url is $signedUrl");
        // print("filepath is $filePath");

        final headersUploadUrl = {
          "Content-Type": "multipart/form-data",
          "X-auth-token": "bearer ${widget.accessToken}"
        };

        // final file = File("/content/2310.03046.pdf");
        final responseUpload = await http.put(Uri.parse(signedUrl),
            body: await pdffile.readAsBytes(), headers: headersUploadUrl);

        if (responseUpload.statusCode == 200) {
          // Print the status code
          // print("Status Code: ${responseUpload.statusCode}");
          // Print the content of the response
          // print("Content: ${responseUpload.body}");
          final url_download = Uri.parse(
              "https://dittox.in/xerox/v1/cloud-services/file/getDownloadableUrl");
          final paramsDownloadUrl = {"filePath": filePath};
          final url_download_get = Uri.http(
              url_download.authority, url_download.path, paramsDownloadUrl);
          final responseDownloadUrl =
              await http.get(url_download_get, headers: headers);
          if (responseDownloadUrl.statusCode == 200) {
            final responseDownloadUrlJson =
                json.decode(responseDownloadUrl.body);

            if (responseDownloadUrlJson["responseCode"] == "OK") {
              // print(responseDownloadUrlJson);
              return responseDownloadUrlJson["result"];
            } else {
              throw Exception(responseDownloadUrlJson["message"]);
            }
          } else {
            throw Exception(
                "Error: Try uploading again. Sorry for the inconvenience.");
          }
        } else {
          throw Exception(
              "Error: Try uploading again. Sorry for the inconvenience.");
        }
      } else {
        throw Exception(signed["message"]);
      }
    } catch (e) {
      print("Caught an exception: $e");
      throw Exception(e);
    }
  }

  Future<bool> pickFiles(
      BuildContext ctx, ListOfPDFFiles listofpdffiles) async {
    String endpoint = "https://dittox.in/xerox/v1/fileUpload/create";

    // Set the headers with the X-auth-token
    Map<String, String> headers = {
      "X-auth-token": "bearer ${widget.accessToken}",
    };

    final result = await FilePicker.platform.pickFiles(
        allowMultiple: true, type: FileType.custom, allowedExtensions: ["pdf"]);
    if (result == null) {
      return false;
    }

    listofpdffiles.emptyPDFfile();
    for (int i = 0; i < result.count; i++) {
      final pdfFile = File(result.files[i].path as String);
      // Count pages
      final pdfDocument = await PDFDocument.fromFile(pdfFile);
      final pageCount = pdfDocument.count;
      print("<<<<<---- pages ${i + 1}------>");
      print(result.names[i]);
      print(result.paths[i]);
      print(pdfFile);
      try {
        final downloadDocumentUrl = await uploadFileGetDownloadUrl(
            pdfFile, result.names[i].toString(), result.paths[i].toString());
        print(downloadDocumentUrl);
        print("befrore true");
        print("after true");
        PdfData pdf = PdfData(
          name: result.files[i].name,
          bondPages: false,
          size: bytesToMB(result.files[i].size),
          totalPages: pageCount as int,
          copies: 1,
          binding: "No binding",
          paperSize: "A4",
          pdfSides: "Single side",
          pdfPrintLayout: "Portraint",
          color: "Black & White",
          pageRange: "1 - $pageCount",
          colorParDesciption: "",
          colorParPageNumbers: "",
          colorParTotal: 0,
          additionDesciption: "",
          documents: downloadDocumentUrl.toString(),
        );
        print("------ ${pdf.name}");
        listofpdffiles.addPDFFile(pdf);
      } catch (e) {
        print(e);
      }

      // if (response.statusCode == 200) {
      //   print("File uploaded successfully.");
      //   var responseData = await response.stream.toBytes();
      //   var responseString = utf8.decode(responseData);
      //   // print(responseString);
      //   Map<String, dynamic> responseMap = json.decode(responseString);
      //   String id = responseMap["result"][0]["_id"];
      //   PdfData pdf = PdfData(
      //     name: result.files[i].name,
      //     bondPages: false,
      //     size: bytesToMB(result.files[i].size),
      //     totalPages: pageCount as int,
      //     copies: 1,
      //     binding: "No binding",
      //     paperSize: "A4",
      //     pdfSides: "Single side",
      //     pdfPrintLayout: "Portraint",
      //     color: "bw",
      //     pageRange: "1 - $pageCount",
      //     colorParDesciption: "",
      //     colorParPageNumbers: "",
      //     colorParTotal: 0,
      //     additionDesciption: "",
      //     documents: id,
      //   );
      //   print("------ ${pdf.name}");
      //   listofpdffiles.addPDFFile(pdf);
      // } else {
      //   print("Error uploading file. Status code: ${response.statusCode}");
      //   throw Exception(
      //       "Error uploading file. Pls Try Again after a while !\nif LARGE FILES  try upload them individually");
      // }
    }
    listofpdffiles.pdfFilesList.forEach((ele) {
      print("FOR LOOP VALUES ${ele.name}");
    });
    print(listofpdffiles.pdfFilesList);
    return true;
  }

  @override
  Widget build(BuildContext context) {
    ListOfPDFFiles listofpdffiles =
        Provider.of<ListOfPDFFiles>(context, listen: true);
    return InkWell(
      onTap: () async {
        print("on tap is pressed");
        setState(() {
          isPdfLoading = true;
        });
        try {
          var fileIsPicked = await pickFiles(context, listofpdffiles);
          if (fileIsPicked) {
            // await Future.delayed(const Duration(seconds: 2));
            Navigator.of(context).pushNamed(PDFFilters.routeName);
          }
        } catch (e) {
          // Display alert dialog on error
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text(
                  "Error",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                content: const Text(
                  "Error while uploading file. Pls Try Again after!\nIf LARGE FILES  try upload them individually",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      // Navigator.of(context).pushNamed(PDFFilters.routeName);
                    },
                    child: const Text(
                      "OK",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ],
              );
            },
          );
        } finally {
          setState(() {
            isPdfLoading = false;
          });
        }
      },
      // openFile(context, file);

      splashColor: ColorPallets.pinkinshShadedPurple.withOpacity(.2),
      child: Container(
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
            color: ColorPallets.pinkinshShadedPurple.withOpacity(.2),
            borderRadius: BorderRadius.circular(14)),
        child: Row(
          children: [
            Expanded(
                flex: 5,
                child: Image.asset(
                  "assets/image/documentUpload.png",
                  fit: BoxFit.cover,
                )),
            Expanded(
              flex: 4,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Upload Your \nDocument",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: ColorPallets.deepBlue,
                      fontSize: 22,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  isPdfLoading
                      ? const CircularProgressIndicator()
                      : const Icon(
                          FontAwesomeIcons.arrowRight,
                          color: ColorPallets.deepBlue,
                          size: 28,
                        ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  // void openFile(BuildContext ctx, File file) {
  //   setState(() {
  //     isPdfLoading = false;
  //   });
  //   // Navigator.of(ctx).pushNamed(CustomPDFPreview.routeName, arguments: file);
  //   // setState(() {
  //   //   isPdfLoading = false;
  //   // });
  // }
}
