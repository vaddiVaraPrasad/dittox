import 'package:dittox/providers/ListOfPdfFiles.dart';
import 'package:dittox/utils/color_pallets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/singlePdf.dart';

class PDFFilters extends StatefulWidget {
  static const routeName = "/pdffilters";
  const PDFFilters({super.key});

  @override
  State<PDFFilters> createState() => _PDFFiltersState();
}

class _PDFFiltersState extends State<PDFFilters> {
  List<SinglePDfFile> pdfFilesList = [];
  late SinglePDfFile selectedPDFFile;

  List<Map<Map<String, dynamic>, SinglePDfFile>> pdfList = [];
  late Map<Map<String, dynamic>, SinglePDfFile>? SeletecPDFFileFromList;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   initializePDFFilesList();
    // });
  }

  void initializePDFFilesList() {
    ListOfPDFFiles listOfPDFFiles =
        Provider.of<ListOfPDFFiles>(context, listen: false);
    pdfFilesList = listOfPDFFiles.allPdfList;
    // pdfFilesList.forEach((eachPdf) {
    //   Map<String, dynamic> pdfData = {
    //     "name": eachPdf.pdfName,
    //     "size": eachPdf.pdfSize,
    //     "pageCount": eachPdf.pdfTotalPages,
    //   };
    //   Map<Map<String, dynamic>, SinglePDfFile> dummymap = {
    //     pdfData: eachPdf,
    //   };
    //   pdfList.add(dummymap);
    // });
    // print(pdfList);
    for (int i = 0; i < pdfFilesList.length; i++) {
      SinglePDfFile eachPdf = pdfFilesList[i];
      print("FILE NAME IN LOOP IS ${eachPdf.pdfName}");
      Map<String, dynamic> pdfData = {
        "name": eachPdf.pdfName,
        "size": eachPdf.pdfSize,
        "pageCount": eachPdf.pdfTotalPages,
      };
      Map<Map<String, dynamic>, SinglePDfFile> dummymap = {
        pdfData: eachPdf,
      };
      pdfList.add(dummymap);
    }
    print(pdfList);
    selectedPDFFile = pdfFilesList[0];
    SeletecPDFFileFromList = pdfList[0];
    print("FROM DID CHANGE DEPEDNCIES ${selectedPDFFile.pdfName}");
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Initialize the pdfFilesList when dependencies change
    initializePDFFilesList();
  }

  @override
  Widget build(BuildContext context) {
    print("LIST IS LOADDED SUCCESSFULLT , ${pdfFilesList.length}");
    return Scaffold(
      appBar: AppBar(
        foregroundColor: ColorPallets.white,
        title: const Text(
          "Filter the PDF's",
          style: TextStyle(
            color: ColorPallets.white,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 10,
        ),
        child: ListView(
          children: [
            size_of_pages(),
            // PdfDisplay("vara.pdf", "55 mb", 56),
            Text(selectedPDFFile.pdfName),
            Text(selectedPDFFile.pdfSize),
          ],
        ),
      ),
    );
  }

  Widget size_of_pages() {
    return Card(
      // color: ColorPallets.white,
      elevation: 3,
      shadowColor: ColorPallets.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0), // Adjust the radius as needed
      ),
      child: Container(
        decoration: BoxDecoration(
          color: ColorPallets.white,
          borderRadius:
              BorderRadius.circular(8.0), // Adjust the radius as needed
          border: Border.all(
            color: ColorPallets.white, // Set the border color
            width: 2.0, // Set the border width
          ),
        ),
        height: 80,
        padding: const EdgeInsets.symmetric(vertical: 1, horizontal: 8),
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
          Expanded(
            flex: 1,
            child: Container(
              margin: const EdgeInsets.only(right: 5, left: 5),
              child: const Center(
                child: FittedBox(
                  child: Text(
                    "PDF's",
                    style: TextStyle(fontSize: 22),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          Expanded(
            flex: 5,
            child: Container(
              height: 65,
              padding: const EdgeInsets.only(left: 60, top: 2, bottom: 2),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: ColorPallets.lightBlue, width: 1)),
              // child: DropdownButtonHideUnderline(
              //     child: DropdownButton<Map<String, dynamic>>(
              //   value: sheetsSize,
              //   items: sheetsSizeList.map((e) => pdfContainer(e)).toList(),
              //   onChanged: (value) => setState(() {
              //     sheetsSize = value;
              //   }),
              // )),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<Map<Map<String, dynamic>, SinglePDfFile>>(
                  value: SeletecPDFFileFromList,
                  items: pdfList.map((pdf) {
                    return DropdownMenuItem<
                        Map<Map<String, dynamic>, SinglePDfFile>>(
                      value: pdf,
                      child: Container(
                        width: 150,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              // pdf.pdfName,
                              pdf.keys.first["name"] ?? "",
                              style: const TextStyle(
                                overflow: TextOverflow.ellipsis,
                                color: ColorPallets.black,
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              "${pdf.keys.first["size"]} (${pdf.keys.first["pageCount"]} pages)",
                              style: const TextStyle(
                                  overflow: TextOverflow.fade,
                                  color: ColorPallets.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  fontStyle: FontStyle.italic),
                            )
                          ],
                        ),
                      ), // Assuming SinglePDFFile has a 'name' property
                    );
                  }).toList(),
                  onChanged: (pdf) {
                    setState(() {
                      // selectedPDFFile = pdf as SinglePDfFile;
                      SeletecPDFFileFromList = pdf;
                      selectedPDFFile = pdf!.values.first;
                    });
                  },
                ),
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
