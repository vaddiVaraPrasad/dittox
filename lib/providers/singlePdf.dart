import 'dart:math';

import 'package:dittox/model/pdfFile.dart';
import 'package:flutter/material.dart';

class SinglePDfFile with ChangeNotifier {
  PdfData singlePdfFile = PdfData(
    name: "",
    size: "",
    totalPages: 0,
    copies: 1,
    binding: "No binding", // Sprial , Staples , Stick File ,
    paperSize: "A4",
    pdfSides: "Single side",
    pdfPrintLayout: "Portraint",
    color: "Black",
    pageRange: "",
    colorParDesciption: "",
    colorParPageNumbers: 0,
    colorParTotal: 0,
    additionDesciption: "",
    uploadID: "",
  );

  void printSinglePDFalldata(){
    print(singlePdfFile.toMap);
  }

  void setUploadId(String id) {
    singlePdfFile.uploadID = id;
    notifyListeners();
  }

  String get uploadID {
    return singlePdfFile.uploadID;
  }

  void setPdfName(String name) {
    singlePdfFile.name = name;
    notifyListeners();
  }

  String get pdfName {
    return singlePdfFile.name;
  }

  void setPdfSize(String size) {
    singlePdfFile.size = size;
    notifyListeners();
  }

  String get pdfSize {
    return singlePdfFile.size;
  }

  void setPdfTotalPages(int totalPages) {
    singlePdfFile.totalPages = totalPages;
    notifyListeners();
  }

  int get pdfTotalPages {
    return singlePdfFile.totalPages;
  }

  void setPdfTotalCopies(int totalCopies) {
    singlePdfFile.copies = totalCopies;
    notifyListeners();
  }

  int get pdfTotalCopies {
    return singlePdfFile.copies;
  }

  void setPdfBindings(String bindings) {
    singlePdfFile.binding = bindings;
    notifyListeners();
  }

  String get pdfbindings {
    return singlePdfFile.binding;
  }

  void setPdfPaperSize(String paperSize) {
    singlePdfFile.paperSize = paperSize;
    notifyListeners();
  }

  String get pdfPaperSize {
    return singlePdfFile.paperSize;
  }

  void setPdfPrintLayout(String layout) {
    singlePdfFile.pdfPrintLayout = layout;
    notifyListeners();
  }

  String get pdfPrintLayout {
    return singlePdfFile.pdfPrintLayout;
  }

  void setPDfColor(String color) {
    singlePdfFile.color = color;
    notifyListeners();
  }

  String get pdfColor {
    return singlePdfFile.color;
  }

  void setPdfPageRange(String range) {
    singlePdfFile.pageRange = range;
    notifyListeners();
  }

  String get pdfPageRange {
    return singlePdfFile.pageRange;
  }

  void setColorParDesciption(String desc) {
    singlePdfFile.colorParDesciption = desc;
    notifyListeners();
  }

  String get pdfColorParDesciption {
    return singlePdfFile.colorParDesciption;
  }

  void setColorParPageNumbers(int colorParPageNumbers) {
    singlePdfFile.colorParPageNumbers = colorParPageNumbers;
    notifyListeners();
  }

  int get pdfColorParPageNumbers {
    return singlePdfFile.colorParPageNumbers;
  }

  void setPDfColorParTotal(int colorParTotal) {
    singlePdfFile.colorParTotal = colorParTotal;
    notifyListeners();
  }

  int get pdfColorParTotal {
    return singlePdfFile.colorParTotal;
  }

  void setPdfAdditionalDescription(String descri) {
    singlePdfFile.additionDesciption = descri;
    notifyListeners();
  }

  String get pdfAdditionDesciption {
    return singlePdfFile.additionDesciption;
  }
}
