import 'package:flutter/material.dart';

import '../model/pdfFile.dart';

class ListOfPDFFiles with ChangeNotifier {
  List<PdfData> pdfFilesList = [];

  void emptyPDFfile() {
    pdfFilesList = [];
    notifyListeners();
  }

  void addPDFFile(PdfData pdf) {
    pdfFilesList.add(pdf);
    notifyListeners();
  }

  PdfData getPDFFileAtIndex(int index) {
    return pdfFilesList[index];
  }

  void printPDFFile() {
    print(pdfFilesList[0].toMap);
  }

  void replacePDFAtIndex(int index, PdfData newPdfData) {
    pdfFilesList[index] = newPdfData;
    // print(pdfFilesList[0].toMap);
    notifyListeners();
  }

  List<PdfData> get allPdfList {
    print("get list pdfs is pressed");
    return pdfFilesList;
  }
}
