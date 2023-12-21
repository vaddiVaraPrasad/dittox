class PdfData {
  String uploadID;
  String name;
  String size;
  int totalPages;
  int copies;
  String binding;
  String paperSize;
  String pdfSides;
  String pdfPrintLayout;
  String color;
  String pageRange;
  int colorParPageNumbers;
  String colorParDesciption;
  int colorParTotal;
  String additionDesciption;

  PdfData({
    required this.name,
    required this.size,
    required this.totalPages,
    required this.copies,
    required this.binding,
    required this.paperSize,
    required this.pdfSides,
    required this.pdfPrintLayout,
    required this.color,
    required this.pageRange,
    required this.colorParDesciption,
    required this.colorParPageNumbers,
    required this.colorParTotal,
    required this.additionDesciption,
    required this.uploadID,
  });

  Map<String, dynamic> get toMap {
    return {
      "name": name,
      "size": size,
      "totalPages": totalPages,
      "copies": copies,
      "binding": binding,
      "paperSize": paperSize,
      "pdfSides": pdfSides,
      "pdfPrintLayout": pdfPrintLayout,
      "color": color,
      "pageRange": pageRange,
      "colorParDesciption": colorParDesciption,
      "colorParPageNumbers": colorParPageNumbers,
      "colorParTotal": colorParTotal,
      "uploadID": uploadID
    };
  }
}
