import 'dart:io';

import 'package:flutter/material.dart';

import '../../utils/color_pallets.dart';

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

  // void addFileToLisFromEdgeDet() async {
  //   final tempimagePath = (await EdgeDetection.detectEdge);
  //   if (tempimagePath == null) {
  //     return;
  //   }
  //   print("temp image path is $tempimagePath");
  //   File tempfile = File(tempimagePath);
  //   if (tempfile == null) {
  //     return;
  //   }
  //   setState(() {
  //     listfiles.add(tempfile);
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: ColorPallets.white,
        title: const Text("preview images"),
        actions: [
          listfiles.isNotEmpty
              ? IconButton(
                  // onPressed: () => showGetFileName(context),
                  onPressed: () {},
                  icon: const Icon(Icons.save),
                )
              : const SizedBox(),
          IconButton(
            // onPressed: addFileToLisFromEdgeDet,
            onPressed: () {},
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
