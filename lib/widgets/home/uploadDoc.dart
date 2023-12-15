// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import "package:flutter/material.dart";
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// import '../../model/custom_pdf_modal.dart';
// import '../../screens/pdf/cutom_pdf_Render_Screen.dart';
import '../../utils/color_pallets.dart';

class UploadDoc extends StatefulWidget {
  final BuildContext ctx;
  const UploadDoc({
    super.key,
    required this.ctx,
  });

  @override
  State<UploadDoc> createState() => _UploadDocState();
}

class _UploadDocState extends State<UploadDoc> {
  bool isPdfLoading = false;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // onTap: () async {
        //   setState(() {
        //     isPdfLoading = true;
        //   });
        //   File? file = await CustomPDF.pickFile();
        //   if (file == null) {
        //     setState(() {
        //       isPdfLoading = false;
        //       return;
        //     });
        //   }
        //   // print("files got in cart_Screen");
        //   // int len = await file!.length();
        //   // print("lenght is $len");
        //   // print(file.path);
        //   if (file == null) {
        //     return;
        //   }
        //   openFile(context, file);
      },
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

  void openFile(BuildContext ctx, File file) {
    setState(() {
      isPdfLoading = false;
    });
    // Navigator.of(ctx).pushNamed(CustomPDFPreview.routeName, arguments: file);
    // setState(() {
    //   isPdfLoading = false;
    // });
  }
}
