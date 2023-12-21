import 'package:dittox/providers/singlePdf.dart';
import 'package:flutter/material.dart';

class ListOfPDFFiles with ChangeNotifier {
  List<SinglePDfFile> pdfFilesList = [];

  void emptyPDFfile() {
    pdfFilesList = [];
    notifyListeners();
  }

  void addPDFFile(SinglePDfFile pdf) {
    pdfFilesList.add(pdf);
    notifyListeners();
  }

  List<SinglePDfFile> get allPdfList {
    return pdfFilesList;
  }
}
