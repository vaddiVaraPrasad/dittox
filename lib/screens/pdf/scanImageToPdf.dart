import 'dart:io';
import 'package:flutter/services.dart' show ByteData, rootBundle;
import 'package:edge_detection/edge_detection.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:permission_handler/permission_handler.dart';

import '../../utils/color_pallets.dart';
import 'scannedPdfRender.dart';

class ScaneImageToPdf extends StatefulWidget {
  static const routeName = "/scaneToPdf";
  const ScaneImageToPdf({super.key});

  @override
  State<ScaneImageToPdf> createState() => _ScaneImageToPdfState();
}

class _ScaneImageToPdfState extends State<ScaneImageToPdf> {
  String? fileName;
  bool isLoading = false;
  final formKey = GlobalKey<FormState>();
  List<File> listfiles = [];

  Future<void> getImageFromCamera() async {
    bool isCameraGranted = await Permission.camera.request().isGranted;
    if (!isCameraGranted) {
      isCameraGranted =
          await Permission.camera.request() == PermissionStatus.granted;
    }

    if (!isCameraGranted) {
      // Have not permission to camera
      return;
    }

    // Generate filepath for saving
    String imagePath = join((await getApplicationSupportDirectory()).path,
        "${(DateTime.now().millisecondsSinceEpoch / 1000).round()}.jpeg");

    bool success = false;

    try {
      //Make sure to await the call to detectEdge.
      success = await EdgeDetection.detectEdge(
        imagePath,
        canUseGallery: true,
        androidScanTitle: 'Scanning', // use custom localizations for android
        androidCropTitle: 'Crop',
        androidCropBlackWhiteTitle: 'Black White',
        androidCropReset: 'Reset',
      );
      print("success: $success");
    } catch (e) {
      print(e);
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      if (success) {
        File tempfile = File(imagePath);
        listfiles.add(tempfile);
      }
    });
  }

  Future<File> generatePdf(List<File> files, String filename) async {
    final pdf = pw.Document();

    for (var file in files) {
      final imageBytes = await file.readAsBytes();
      final image = pw.MemoryImage(imageBytes);

      pdf.addPage(
        pw.Page(
          build: (context) {
            return pw.Center(
              child: pw.Image(image),
            );
          },
        ),
      );
    }

    final output = await getTemporaryDirectory();
    final outputFile = File("${output.path}/$filename.pdf");

    await outputFile.writeAsBytes(await pdf.save());

    return outputFile;
  }

  void showGetFileName(BuildContext ctx) async {
    //get the name
    showDialog(
      context: ctx,
      builder: (context) => AlertDialog(
        title: const Text(
          "Enter the FileName ",
          textAlign: TextAlign.center,
          style: TextStyle(color: ColorPallets.deepBlue),
        ),
        titlePadding: const EdgeInsets.only(
          top: 20,
        ),
        contentPadding: const EdgeInsets.only(bottom: 0, left: 10, right: 10),
        content: Form(
          key: formKey,
          child: Padding(
            padding: const EdgeInsets.only(top: 10),
            child: TextFormField(
              cursorColor: ColorPallets.deepBlue,
              decoration: const InputDecoration(
                  hintText: "FileName", fillColor: ColorPallets.deepBlue),
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.done,
              validator: (filename) {
                if (filename!.isEmpty) {
                  return "invalid file name";
                }
                return null;
              },
              onSaved: (filename) {
                if (filename != null) {
                  fileName = filename;
                }
              },
              onFieldSubmitted: (value) async {
                final file = await onSaveNameSendFilePreviw(ctx);
                if (file == null) {
                  return;
                }
                openPreview(ctx, file);
              },
            ),
          ),
        ),
        actions: [
          TextButton(
              onPressed: () async {
                final file = await onSaveNameSendFilePreviw(ctx);
                if (file == null) {
                  return;
                }
                openPreview(ctx, file);
              },
              child: const Text(
                "Get Preview !",
                style: TextStyle(
                  color: ColorPallets.deepBlue,
                ),
              ))
        ],
      ),
    );
  }

  Future<File?> onSaveNameSendFilePreviw(BuildContext ctx) async {
    final isvalid = formKey.currentState!.validate();
    if (isvalid) {
      formKey.currentState!.save();
    }
    Navigator.of(ctx).pop();
    setState(() {
      isLoading = true;
    });
    // print("before calling generate pdfs");
    // File? resultFile = await CustomPDF()
    //     .generateImagesPdfFromMultiImages(fileName as String, listfiles);
    File? resultFile = await generatePdf(listfiles, fileName.toString());
    // print("pdf is generated succefully");
    setState(() {
      isLoading = false;
    });
    return resultFile;
    // setState(() {
    //   isLoading = false;
    // });
    // Navigator.of(ctx)
    //     .pushNamed(CustomPDFPreview.routeName, arguments: resultFile);
    // and then preview it by previews screen
  }

  void openPreview(BuildContext ctx, File resultFile) {
    setState(() {
      isLoading = false;
    });
    print(resultFile.path);
    print(resultFile);
    Navigator.of(ctx).pushNamed(ScanPicrender.routeName, arguments: resultFile);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: ColorPallets.white,
        title: const Text("preview images"),
        actions: [
          listfiles.isNotEmpty
              ? IconButton(
                  onPressed: () => showGetFileName(context),
                  // onPressed: () {},
                  icon: const Icon(Icons.save),
                )
              : const SizedBox(),
          IconButton(
            onPressed: getImageFromCamera,
            // onPressed: () {},
            icon: const Icon(Icons.add_a_photo),
          ),
          const SizedBox(
            width: 10,
          )
          // IconButton(
          //   onPressed: addFileToList,
          //   icon: const Icon(Icons.add_a_photo),
          // )
        ],
      ),
      body: listfiles.isEmpty
          ? const Center(
              child: Text(
              "Add files by clicking on top right button!!",
              style: TextStyle(fontSize: 25),
              textAlign: TextAlign.center,
            ))
          : Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 3 / 2,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 20,
                ),
                itemCount: listfiles.length,
                itemBuilder: (context, index) => ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: GridTile(
                    footer: SizedBox(
                      height: 40,
                      child: GridTileBar(
                          backgroundColor: Colors.black54,
                          title: IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              setState(() {
                                listfiles.removeAt(index);
                              });
                            },
                          )),
                    ),
                    child: Image.file(
                      listfiles[index],
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}
