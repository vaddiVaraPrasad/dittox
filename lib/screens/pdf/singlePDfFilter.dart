import 'package:dittox/model/pdfFile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';
import 'package:syncfusion_flutter_core/theme.dart';

import '../../providers/ListOfPdfFiles.dart';
import '../../utils/color_pallets.dart';

enum PageOrientation {
  landScape,
  potrait;
}

enum PritingSides {
  singleSided,
  doubleSided,
}

enum JobTypes {
  blackAndWhite,
  fullColor,
  partialColor,
}

String getStringPageOrientations(PageOrientation orient) {
  if (orient == PageOrientation.landScape) {
    return "Landscape";
  } else {
    return "Potrait";
  }
}

String getStringPrintingSides(PritingSides side) {
  if (side == PritingSides.singleSided) {
    return "Single Side";
  }
  return "Double Side";
}

String getStringJobType(JobTypes job) {
  if (job == JobTypes.blackAndWhite) {
    return "bw";
  } else if (job == JobTypes.fullColor) {
    return "multi";
  } else {
    return "colPar";
  }
}

class SinglePageCustomization extends StatefulWidget {
  int index;
  SinglePageCustomization({super.key, required this.index});

  @override
  State<SinglePageCustomization> createState() =>
      _SinglePageCustomizationState();
}

class _SinglePageCustomizationState extends State<SinglePageCustomization> {
  final _pagesRangeController = TextEditingController();
  final _noOfCopies = TextEditingController();
  final _ColorPagesController = TextEditingController();
  final _bondPagesController = TextEditingController();
  final _instructionsController = TextEditingController();

  final sheetsSizeList = [
    "A4",
    "A5",
    "Legal",
    "Letter",
    "B5",
    "A6",
    "Post Card",
    "5*7",
    "4*6",
    "3.5*5",
  ];

  final sheetsBondList = [
    "No Binding",
    "Spiral",
    "Stick File",
    "Staples",
  ];

  bool isInit = true;

  double? contHeight;

  double? sliderContHeight;
  double? totalPrintingContainerHeight;

  double? totalBondPaperContainerHeight;
  double? BondPapersliderContHeight;

  int? totalPages = 0;

  SfRangeValues? values;
  SfRangeValues? Colorvalues;
  SfRangeValues? Bondvalues;

  bool boudSheets = false;

  bool showSlider = false;
  bool showwidgetSlider = false;

  String? sheetsSize;
  String? sheetBind;

  PageOrientation pageOri = PageOrientation.potrait;
  PritingSides pagePrint = PritingSides.singleSided;
  JobTypes printjob = JobTypes.blackAndWhite;

  // bool showColorsliderTextbox = false;
  // bool showColorWidgetSliderTextBox = false;
  bool showColorTextBox = false;
  bool showWidgetColorTextBox = false;

  // bool showBondSheetsTextBox = false;
  // bool showBondWingetSheetsTextBox = false;
  // bool showBondSheetsSliderTextBox = false;
  // bool showBondSheetWidgetsliderTextBox = false;

  @override
  void initState() {
    _pagesRangeController.addListener(() => setState(() {}));
    _noOfCopies.addListener(() => setState(() {}));
    _ColorPagesController.addListener(() => setState(() {}));
    _bondPagesController.addListener(() => setState(() {}));
    _instructionsController.addListener(() => setState(() {}));

    values = SfRangeValues(0, totalPages);
    Colorvalues = SfRangeValues(0, totalPages);
    Bondvalues = SfRangeValues(0, totalPages);

    _noOfCopies.text = "1";

    showSlider = false;
    showwidgetSlider = false;

    sheetBind = "No Binding";
    boudSheets = false;

    showColorTextBox = false;
    showWidgetColorTextBox = false;
    // showColorsliderTextbox = false;
    // showColorWidgetSliderTextBox = false;

    sheetsSize = sheetsSizeList[0];

    // showBondSheetsTextBox = false;
    // showBondWingetSheetsTextBox = false;
    // showBondSheetsSliderTextBox = false;
    // showBondSheetWidgetsliderTextBox = false;

    super.initState();
  }

  @override
  void dispose() {
    _pagesRangeController.dispose();
    _noOfCopies.dispose();
    _ColorPagesController.dispose();
    _bondPagesController.dispose();

    super.dispose();
  }

  @override
  void didChangeDependencies() {
    if (isInit) {
      ListOfPDFFiles pdffileList =
          Provider.of<ListOfPDFFiles>(context, listen: false);

      values =
          SfRangeValues(1, pdffileList.allPdfList[widget.index].totalPages);

      totalPages = pdffileList.allPdfList[widget.index].totalPages;

      values = SfRangeValues(1, totalPages);
      Colorvalues = SfRangeValues(1, totalPages);
      Bondvalues = SfRangeValues(1, totalPages);

      _pagesRangeController.text = "1-$totalPages";
      _ColorPagesController.text = "1-$totalPages";
      _bondPagesController.text = "1-$totalPages";
      _noOfCopies.text = "1";
    }

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    contHeight = showSlider ? 140 : 70;

    sliderContHeight = showColorTextBox
        ? 60 // 70
        : 0;

    totalPrintingContainerHeight = showColorTextBox ? 130 : 70;

    // BondPapersliderContHeight = showBondSheetsTextBox
    //     ? showBondSheetsSliderTextBox
    //         ? 130 // 140
    //         : 60 // 70
    //     : 0;
    // totalBondPaperContainerHeight = showBondSheetsTextBox
    //     ? showBondSheetsSliderTextBox
    //         ? 190
    //         : 120
    //     : 70;

    ListOfPDFFiles pdffileList =
        Provider.of<ListOfPDFFiles>(context, listen: false);
    bool isDisplay = false;

    return Column(
      children: [
        PDFName(
          pdffileList.allPdfList[widget.index].name,
          pdffileList.allPdfList[widget.index].size,
          pdffileList.allPdfList[widget.index].totalPages,
          context,
        ),

        //////  <<<<<<<<<<------------- PAGES RANGE SELECT --------------->>>>>>>>>>>>
        PageRange(pdffileList),

        // <<<<<<<<----------------- NO.OF COPIES -------------------->>>>>>>>>
        NoOfCopies(pdffileList),

        //// <<<<<<<<<<<<<   PRINT LAYOUT HERE >>>>>>>>>>>>>>>>>
        PrintingLayout(pdffileList),

        /// <<<<--------------------    Print Sides ------------ >>>>>
        printingSides(pdffileList),

        // <<<<<<----------------   SIZE OF PAPERS ------------>>>>>>>>
        sizeOfPages(pdffileList),

        // <<<<<<---------------     JOB Color -------------->>>>>>>>
        pritingJob(pdffileList),

        // <<<<< ----------  binding ---------->
        binding(pdffileList),

        // <<<<< bondStatus ----------->
        bondSheets(pdffileList),

        // <<<<<<< additionalInstructions ------------>
        additionalInstructions(pdffileList),

        const SizedBox(
          height: 30,
        )
      ],
    );
  }

  DropdownMenuItem<String> buildMenuItem(String item) {
    return DropdownMenuItem(
        value: item,
        child: Text(
          item,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.normal),
        ));
  }

  Widget PDFName(String name, String size, int pagecount, BuildContext ctx) {
    return Container(
        margin: const EdgeInsets.only(bottom: 15, left: 5, right: 5),
        width: MediaQuery.of(ctx).size.width * 0.95,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              // pdf.pdfName,
              name,
              style: const TextStyle(
                overflow: TextOverflow.ellipsis,
                color: ColorPallets.black,
                fontSize: 24,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              "$size ($pagecount pages)",
              style: TextStyle(
                  overflow: TextOverflow.fade,
                  color: ColorPallets.black.withOpacity(.5),
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  fontStyle: FontStyle.italic),
            ),
            const Divider(
              color: Colors.black,
              thickness: 0.5, // You can adjust the thickness of the divider
              height:
                  4, // You can adjust the height of the empty space around the divider
            ),
          ],
        ));
  }

  Widget PageRange(ListOfPDFFiles pdffileList) {
    return Card(
      elevation: 3,
      shadowColor: ColorPallets.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0), // Adjust the radius as needed
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        decoration: BoxDecoration(
          color: ColorPallets.white,
          borderRadius:
              BorderRadius.circular(8.0), // Adjust the radius as needed
          border: Border.all(
            color: ColorPallets.white, // Set the border color
            width: 2.0, // Set the border width
          ),
        ),
        child: AnimatedContainer(
          height: contHeight,
          duration: const Duration(milliseconds: 300),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    flex: 2,
                    child: Container(
                      margin: const EdgeInsets.only(left: 5, right: 5),
                      child: const Center(
                        child: FittedBox(
                          child: Text(
                            "Pages :",
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
                    child: SizedBox(
                      height: 40,
                      child: TextField(
                        cursorHeight: 25,
                        textInputAction: TextInputAction.next,
                        onChanged: (value) {
                          setState(() {
                            if (value == null || value.toString() == "") {
                              return;
                            }
                            // upade values by _noOfCopies.textß
                            _pagesRangeController.text = value.toString();
                            print(
                                "PAGERANGE CONTROLLERS ${_pagesRangeController.text}");
                            PdfData oldPdfdata =
                                pdffileList.getPDFFileAtIndex(widget.index);
                            PdfData newPDfData = PdfData(
                                bondPages: oldPdfdata.bondPages,
                                name: oldPdfdata.name,
                                size: oldPdfdata.size,
                                totalPages: oldPdfdata.totalPages,
                                copies: oldPdfdata.copies,
                                binding: oldPdfdata.binding,
                                paperSize: oldPdfdata.paperSize,
                                pdfSides: oldPdfdata.pdfSides,
                                pdfPrintLayout: oldPdfdata.pdfPrintLayout,
                                color: oldPdfdata.color,
                                pageRange: _pagesRangeController.text,
                                colorParDesciption:
                                    oldPdfdata.colorParDesciption,
                                colorParPageNumbers:
                                    oldPdfdata.colorParPageNumbers,
                                colorParTotal: oldPdfdata.colorParTotal,
                                additionDesciption:
                                    oldPdfdata.additionDesciption,
                                uploadID: oldPdfdata.uploadID);
                            pdffileList.replacePDFAtIndex(
                                widget.index, newPDfData);
                            pdffileList.printPDFFile();
                          });
                        },
                        onSubmitted: (value) {
                          setState(() {
                            if (value == null || value.toString() == "") {
                              return;
                            }
                            // upade values by _noOfCopies.text
                            _pagesRangeController.text = value.toString();
                            print(
                                "PAGERANGE CONTROLLERS ${_pagesRangeController.text}");
                            PdfData oldPdfdata =
                                pdffileList.getPDFFileAtIndex(widget.index);
                            PdfData newPDfData = PdfData(
                                bondPages: oldPdfdata.bondPages,
                                name: oldPdfdata.name,
                                size: oldPdfdata.size,
                                totalPages: oldPdfdata.totalPages,
                                copies: oldPdfdata.copies,
                                binding: oldPdfdata.binding,
                                paperSize: oldPdfdata.paperSize,
                                pdfSides: oldPdfdata.pdfSides,
                                pdfPrintLayout: oldPdfdata.pdfPrintLayout,
                                color: oldPdfdata.color,
                                pageRange: _pagesRangeController.text,
                                colorParDesciption:
                                    oldPdfdata.colorParDesciption,
                                colorParPageNumbers:
                                    oldPdfdata.colorParPageNumbers,
                                colorParTotal: oldPdfdata.colorParTotal,
                                additionDesciption:
                                    oldPdfdata.additionDesciption,
                                uploadID: oldPdfdata.uploadID);
                            pdffileList.replacePDFAtIndex(
                                widget.index, newPDfData);
                            pdffileList.printPDFFile();
                          });
                        },
                        controller: _pagesRangeController,
                        decoration: const InputDecoration(
                            floatingLabelStyle: TextStyle(fontSize: 25),
                            border: OutlineInputBorder(),
                            hintStyle: TextStyle(fontSize: 18),
                            hintText: "1-5,8,11-15"),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: InkWell(
                      onTap: () async {
                        if (showSlider == false) {
                          setState(() {
                            showSlider = true;
                          });
                          await Future.delayed(
                              const Duration(milliseconds: 300));
                          setState(() {
                            showwidgetSlider = true;
                          });
                        } else {
                          setState(() {
                            showSlider = false;
                            showwidgetSlider = false;
                          });
                        }
                      },
                      child: const Padding(
                        padding: EdgeInsets.only(
                            left: 3, right: 0, top: 5, bottom: 5),
                        child: Chip(
                          label: Text(
                            "Slider",
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                          backgroundColor: ColorPallets.deepBlue,
                        ),
                      ),
                    ),
                  )
                ],
              ),
              showwidgetSlider == true &&
                      pdffileList.getPDFFileAtIndex(widget.index).totalPages !=
                          1
                  ? SingleChildScrollView(
                      child: SizedBox(
                        height: 80,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            const SizedBox(
                              width: 10,
                            ),
                            const Text(
                              '0',
                              style: TextStyle(
                                  fontSize: 22, color: ColorPallets.deepBlue),
                            ),
                            Expanded(
                              child: SfRangeSliderTheme(
                                data: SfRangeSelectorThemeData(
                                    tooltipBackgroundColor:
                                        ColorPallets.deepBlue),
                                child: SfRangeSlider(
                                  activeColor: ColorPallets.deepBlue,
                                  inactiveColor:
                                      ColorPallets.lightBlue.withOpacity(.3),
                                  min: 1.0,
                                  max: pdffileList
                                      .allPdfList[widget.index].totalPages,
                                  enableTooltip: true,
                                  stepSize: 1,
                                  tooltipShape: const SfPaddleTooltipShape(),
                                  values: values as SfRangeValues,
                                  onChanged: (value) => setState(() {
                                    values = value;
                                    if (values!.start == values!.end) {
                                      String tempString =
                                          values!.start.toInt().toString();
                                      _pagesRangeController.text = tempString;
                                    } else {
                                      String tempString =
                                          "${values!.start.toInt()}-${values!.end.toInt()}";
                                      _pagesRangeController.text = tempString;
                                    }
                                    print(
                                        "PAGERANGE CONTROLLERS ${_pagesRangeController.text}");
                                    PdfData oldPdfdata = pdffileList
                                        .getPDFFileAtIndex(widget.index);
                                    PdfData newPDfData = PdfData(
                                        bondPages: oldPdfdata.bondPages,
                                        name: oldPdfdata.name,
                                        size: oldPdfdata.size,
                                        totalPages: oldPdfdata.totalPages,
                                        copies: oldPdfdata.copies,
                                        binding: oldPdfdata.binding,
                                        paperSize: oldPdfdata.paperSize,
                                        pdfSides: oldPdfdata.pdfSides,
                                        pdfPrintLayout:
                                            oldPdfdata.pdfPrintLayout,
                                        color: oldPdfdata.color,
                                        pageRange: _pagesRangeController.text,
                                        colorParDesciption:
                                            oldPdfdata.colorParDesciption,
                                        colorParPageNumbers:
                                            oldPdfdata.colorParPageNumbers,
                                        colorParTotal: oldPdfdata.colorParTotal,
                                        additionDesciption:
                                            oldPdfdata.additionDesciption,
                                        uploadID: oldPdfdata.uploadID);
                                    pdffileList.replacePDFAtIndex(
                                        widget.index, newPDfData);
                                    pdffileList.printPDFFile();
                                  }),
                                ),
                              ),
                            ),
                            Text(
                              totalPages.toString(),
                              style: const TextStyle(
                                  fontSize: 22, color: ColorPallets.deepBlue),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                          ],
                        ),
                      ),
                    )
                  : const SizedBox(),
            ],
          ),
        ),
      ),
    );
  }

  Widget NoOfCopies(ListOfPDFFiles pdffileList) {
    return Card(
      elevation: 3,
      shadowColor: ColorPallets.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0), // Adjust the radius as needed
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: ColorPallets.white,
          borderRadius:
              BorderRadius.circular(8.0), // Adjust the radius as needed
          border: Border.all(
            color: ColorPallets.white, // Set the border color
            width: 2.0, // Set the border width
          ),
        ),
        child: Row(
          children: [
            Expanded(
              flex: 4,
              child: Container(
                margin: const EdgeInsets.only(left: 5, right: 5),
                child: const Center(
                  child: FittedBox(
                    child: Text(
                      "no.of copies  :",
                      style: TextStyle(fontSize: 20),
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
                height: 40,
                child: TextField(
                  textInputAction: TextInputAction.done,
                  onSubmitted: (value) {
                    setState(() {
                      if (value == null || value.toString() == "") {
                        return;
                      }
                      // upade values by _noOfCopies.text
                      _noOfCopies.text = value.toString();
                      print(_noOfCopies.text);
                      PdfData oldPdfdata =
                          pdffileList.getPDFFileAtIndex(widget.index);
                      PdfData newPDfData = PdfData(
                          bondPages: oldPdfdata.bondPages,
                          name: oldPdfdata.name,
                          size: oldPdfdata.size,
                          totalPages: oldPdfdata.totalPages,
                          copies: int.parse(_noOfCopies.text),
                          binding: oldPdfdata.binding,
                          paperSize: oldPdfdata.paperSize,
                          pdfSides: oldPdfdata.pdfSides,
                          pdfPrintLayout: oldPdfdata.pdfPrintLayout,
                          color: oldPdfdata.color,
                          pageRange: oldPdfdata.pageRange,
                          colorParDesciption: oldPdfdata.colorParDesciption,
                          colorParPageNumbers: oldPdfdata.colorParPageNumbers,
                          colorParTotal: oldPdfdata.colorParTotal,
                          additionDesciption: oldPdfdata.additionDesciption,
                          uploadID: oldPdfdata.uploadID);
                      pdffileList.replacePDFAtIndex(widget.index, newPDfData);
                      pdffileList.printPDFFile();
                    });
                  },
                  onChanged: (value) {
                    setState(() {
                      if (value == null || value.toString() == "") {
                        return;
                      }
                      _noOfCopies.text = value.toString();
                      print(_noOfCopies.text);
                      PdfData oldPdfdata =
                          pdffileList.getPDFFileAtIndex(widget.index);
                      PdfData newPDfData = PdfData(
                          name: oldPdfdata.name,
                          size: oldPdfdata.size,
                          totalPages: oldPdfdata.totalPages,
                          bondPages: oldPdfdata.bondPages,
                          copies: int.parse(_noOfCopies.text),
                          binding: oldPdfdata.binding,
                          paperSize: oldPdfdata.paperSize,
                          pdfSides: oldPdfdata.pdfSides,
                          pdfPrintLayout: oldPdfdata.pdfPrintLayout,
                          color: oldPdfdata.color,
                          pageRange: oldPdfdata.pageRange,
                          colorParDesciption: oldPdfdata.colorParDesciption,
                          colorParPageNumbers: oldPdfdata.colorParPageNumbers,
                          colorParTotal: oldPdfdata.colorParTotal,
                          additionDesciption: oldPdfdata.additionDesciption,
                          uploadID: oldPdfdata.uploadID);
                      pdffileList.replacePDFAtIndex(widget.index, newPDfData);
                      pdffileList.printPDFFile();
                    });
                  },
                  cursorHeight: 25,
                  keyboardType: TextInputType.number,
                  controller: _noOfCopies,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintStyle: TextStyle(fontSize: 18),
                      hintText: "1 or 28"),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget PrintingLayout(ListOfPDFFiles pdffileList) {
    return Card(
      elevation: 3,
      shadowColor: ColorPallets.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0), // Adjust the radius as needed
      ),
      child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(
            color: ColorPallets.white,
            borderRadius:
                BorderRadius.circular(8.0), // Adjust the radius as needed
            border: Border.all(
              color: ColorPallets.white, // Set the border color
              width: 2.0, // Set the border width
            ),
          ),
          child: Row(
            children: [
              Expanded(
                flex: 4,
                child: Container(
                  margin: const EdgeInsets.only(left: 5, right: 5),
                  child: const Center(
                    child: FittedBox(
                      child: Text(
                        "Printing Layout  :",
                        style: TextStyle(fontSize: 20),
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
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(28)),
                  height: 40,
                  child: Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              pageOri = PageOrientation.potrait;

                              // update the value by pageOri or PageOrientations.potrait
                              // to get string of this getStringPageOrientations(pageOri)
                              PdfData oldPdfdata =
                                  pdffileList.getPDFFileAtIndex(widget.index);
                              PdfData newPDfData = PdfData(
                                  name: oldPdfdata.name,
                                  bondPages: oldPdfdata.bondPages,
                                  size: oldPdfdata.size,
                                  totalPages: oldPdfdata.totalPages,
                                  copies: oldPdfdata.copies,
                                  binding: oldPdfdata.binding,
                                  paperSize: oldPdfdata.paperSize,
                                  pdfSides: oldPdfdata.pdfSides,
                                  pdfPrintLayout:
                                      getStringPageOrientations(pageOri),
                                  color: oldPdfdata.color,
                                  pageRange: oldPdfdata.pageRange,
                                  colorParDesciption:
                                      oldPdfdata.colorParDesciption,
                                  colorParPageNumbers:
                                      oldPdfdata.colorParPageNumbers,
                                  colorParTotal: oldPdfdata.colorParTotal,
                                  additionDesciption:
                                      oldPdfdata.additionDesciption,
                                  uploadID: oldPdfdata.uploadID);
                              pdffileList.replacePDFAtIndex(
                                  widget.index, newPDfData);
                              pdffileList.printPDFFile();
                            });
                          },
                          child: Container(
                            height: 40,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 5, vertical: 7),
                            decoration: BoxDecoration(
                              color: pageOri == PageOrientation.potrait
                                  ? ColorPallets.lightBlue.withOpacity(.2)
                                  : null,
                              borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(22),
                                  bottomLeft: Radius.circular(22)),
                              border: Border.all(color: ColorPallets.lightBlue),
                            ),
                            child: const FittedBox(
                              child: Text(
                                " Potraint  ",
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              pageOri = PageOrientation.landScape;
                              PdfData oldPdfdata =
                                  pdffileList.getPDFFileAtIndex(widget.index);
                              PdfData newPDfData = PdfData(
                                  name: oldPdfdata.name,
                                  size: oldPdfdata.size,
                                  totalPages: oldPdfdata.totalPages,
                                  copies: oldPdfdata.copies,
                                  bondPages: oldPdfdata.bondPages,
                                  binding: oldPdfdata.binding,
                                  paperSize: oldPdfdata.paperSize,
                                  pdfSides: oldPdfdata.pdfSides,
                                  pdfPrintLayout:
                                      getStringPageOrientations(pageOri),
                                  color: oldPdfdata.color,
                                  pageRange: oldPdfdata.pageRange,
                                  colorParDesciption:
                                      oldPdfdata.colorParDesciption,
                                  colorParPageNumbers:
                                      oldPdfdata.colorParPageNumbers,
                                  colorParTotal: oldPdfdata.colorParTotal,
                                  additionDesciption:
                                      oldPdfdata.additionDesciption,
                                  uploadID: oldPdfdata.uploadID);
                              pdffileList.replacePDFAtIndex(
                                  widget.index, newPDfData);
                              pdffileList.printPDFFile();
                            });
                          },
                          child: Container(
                            height: 40,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 5, vertical: 7),
                            decoration: BoxDecoration(
                              color: pageOri == PageOrientation.landScape
                                  ? ColorPallets.lightBlue.withOpacity(.2)
                                  : null,
                              borderRadius: const BorderRadius.only(
                                  topRight: Radius.circular(22),
                                  bottomRight: Radius.circular(22)),
                              border: Border.all(color: ColorPallets.lightBlue),
                            ),
                            child: const FittedBox(
                              child: Text(
                                "LandScape",
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  // child: Text("fdf")
                ),
              ),
            ],
          )),
    );
  }

  Widget printingSides(ListOfPDFFiles pdffileList) {
    return Card(
      elevation: 3,
      shadowColor: ColorPallets.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0), // Adjust the radius as needed
      ),
      child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(
            color: ColorPallets.white,
            borderRadius:
                BorderRadius.circular(8.0), // Adjust the radius as needed
            border: Border.all(
              color: ColorPallets.white, // Set the border color
              width: 2.0, // Set the border width
            ),
          ),
          child: Row(
            children: [
              Expanded(
                flex: 4,
                child: Container(
                  margin: EdgeInsets.only(left: 5, right: 5),
                  child: const Center(
                    child: FittedBox(
                      child: Text(
                        "Priting  Side  :",
                        style: TextStyle(fontSize: 20),
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
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(28)),
                  height: 40,
                  child: Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              pagePrint = PritingSides.singleSided;

                              // get the string type as getStringPrintingSides(pagePrint)

                              PdfData oldPdfdata =
                                  pdffileList.getPDFFileAtIndex(widget.index);
                              PdfData newPDfData = PdfData(
                                  name: oldPdfdata.name,
                                  size: oldPdfdata.size,
                                  totalPages: oldPdfdata.totalPages,
                                  copies: oldPdfdata.copies,
                                  binding: oldPdfdata.binding,
                                  paperSize: oldPdfdata.paperSize,
                                  pdfSides: getStringPrintingSides(pagePrint),
                                  pdfPrintLayout: oldPdfdata.pdfPrintLayout,
                                  color: oldPdfdata.color,
                                  pageRange: oldPdfdata.pageRange,
                                  colorParDesciption:
                                      oldPdfdata.colorParDesciption,
                                  colorParPageNumbers:
                                      oldPdfdata.colorParPageNumbers,
                                  bondPages: oldPdfdata.bondPages,
                                  colorParTotal: oldPdfdata.colorParTotal,
                                  additionDesciption:
                                      oldPdfdata.additionDesciption,
                                  uploadID: oldPdfdata.uploadID);
                              pdffileList.replacePDFAtIndex(
                                  widget.index, newPDfData);
                              pdffileList.printPDFFile();
                            });
                          },
                          child: Container(
                            height: 40,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 7),
                            decoration: BoxDecoration(
                              color: pagePrint == PritingSides.singleSided
                                  ? ColorPallets.lightBlue.withOpacity(.2)
                                  : null,
                              borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(22),
                                  bottomLeft: Radius.circular(22)),
                              border: Border.all(color: ColorPallets.lightBlue),
                            ),
                            child: const FittedBox(
                              child: Text(
                                "Single side",
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              pagePrint = PritingSides.doubleSided;
                              // get the string type as getStringPrintingSides(pagePrint)

                              PdfData oldPdfdata =
                                  pdffileList.getPDFFileAtIndex(widget.index);
                              PdfData newPDfData = PdfData(
                                  name: oldPdfdata.name,
                                  size: oldPdfdata.size,
                                  totalPages: oldPdfdata.totalPages,
                                  bondPages: oldPdfdata.bondPages,
                                  copies: oldPdfdata.copies,
                                  binding: oldPdfdata.binding,
                                  paperSize: oldPdfdata.paperSize,
                                  pdfSides: getStringPrintingSides(pagePrint),
                                  pdfPrintLayout: oldPdfdata.pdfPrintLayout,
                                  color: oldPdfdata.color,
                                  pageRange: oldPdfdata.pageRange,
                                  colorParDesciption:
                                      oldPdfdata.colorParDesciption,
                                  colorParPageNumbers:
                                      oldPdfdata.colorParPageNumbers,
                                  colorParTotal: oldPdfdata.colorParTotal,
                                  additionDesciption:
                                      oldPdfdata.additionDesciption,
                                  uploadID: oldPdfdata.uploadID);
                              pdffileList.replacePDFAtIndex(
                                  widget.index, newPDfData);
                              pdffileList.printPDFFile();
                            });
                          },
                          child: Container(
                            height: 40,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 5, vertical: 7),
                            decoration: BoxDecoration(
                              color: pagePrint == PritingSides.doubleSided
                                  ? ColorPallets.lightBlue.withOpacity(.2)
                                  : null,
                              borderRadius: const BorderRadius.only(
                                  topRight: Radius.circular(22),
                                  bottomRight: Radius.circular(22)),
                              border: Border.all(color: ColorPallets.lightBlue),
                            ),
                            child: const FittedBox(
                              child: Text(
                                "double side",
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  // child: Text("fdf")
                ),
              ),
            ],
          )),
    );
  }

  Widget sizeOfPages(ListOfPDFFiles pdffileList) {
    return Card(
      elevation: 3,
      shadowColor: ColorPallets.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0), // Adjust the radius as needed
      ),
      child: Container(
        height: 60,
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        decoration: BoxDecoration(
          color: ColorPallets.white,
          borderRadius:
              BorderRadius.circular(8.0), // Adjust the radius as needed
          border: Border.all(
            color: ColorPallets.white, // Set the border color
            width: 2.0, // Set the border width
          ),
        ),
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
          Expanded(
            flex: 4,
            child: Container(
              margin: const EdgeInsets.only(right: 5, left: 5),
              child: const Center(
                child: FittedBox(
                  child: Text(
                    "Size of pages :",
                    style: TextStyle(fontSize: 20),
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
              height: 40,
              padding: const EdgeInsets.only(left: 40, top: 2, bottom: 2),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: ColorPallets.lightBlue, width: 1)),
              child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                value: sheetsSize,
                items: sheetsSizeList.map((e) => buildMenuItem(e)).toList(),
                onChanged: (value) => setState(() {
                  sheetsSize = value;

                  // update the value as value.toString()

                  PdfData oldPdfdata =
                      pdffileList.getPDFFileAtIndex(widget.index);
                  PdfData newPDfData = PdfData(
                      bondPages: oldPdfdata.bondPages,
                      name: oldPdfdata.name,
                      size: oldPdfdata.size,
                      totalPages: oldPdfdata.totalPages,
                      copies: oldPdfdata.copies,
                      binding: oldPdfdata.binding,
                      paperSize: value.toString(),
                      pdfSides: oldPdfdata.pdfSides,
                      pdfPrintLayout: oldPdfdata.pdfPrintLayout,
                      color: oldPdfdata.color,
                      pageRange: oldPdfdata.pageRange,
                      colorParDesciption: oldPdfdata.colorParDesciption,
                      colorParPageNumbers: oldPdfdata.colorParPageNumbers,
                      colorParTotal: oldPdfdata.colorParTotal,
                      additionDesciption: oldPdfdata.additionDesciption,
                      uploadID: oldPdfdata.uploadID);
                  pdffileList.replacePDFAtIndex(widget.index, newPDfData);
                  pdffileList.printPDFFile();
                }),
              )),
            ),
          ),
        ]),
      ),
    );
  }

  Widget pritingJob(ListOfPDFFiles pdffilesList) {
    return Card(
      elevation: 3,
      shadowColor: ColorPallets.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0), // Adjust the radius as needed
      ),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        height: totalPrintingContainerHeight,
        decoration: BoxDecoration(
          color: ColorPallets.white,
          borderRadius:
              BorderRadius.circular(8.0), // Adjust the radius as needed
          border: Border.all(
            color: ColorPallets.white, // Set the border color
            width: 2.0, // Set the border width
          ),
        ),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  flex: 4,
                  child: Container(
                    margin: const EdgeInsets.only(left: 5, right: 5),
                    child: const Center(
                      child: FittedBox(
                        child: Text(
                          "Printing Job :",
                          style: TextStyle(fontSize: 20),
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
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(28)),
                    height: 40,
                    child: Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                printjob = JobTypes.blackAndWhite;
                                showColorTextBox = false;
                                showWidgetColorTextBox = false;
                                // showColorsliderTextbox = false;
                                // showColorWidgetSliderTextBox = false;

                                // update the values as getStringJobType(prinyjob) JobTypes.blackAndWhite
                                PdfData oldPdfdata = pdffilesList
                                    .getPDFFileAtIndex(widget.index);
                                PdfData newPDfData = PdfData(
                                    name: oldPdfdata.name,
                                    size: oldPdfdata.size,
                                    totalPages: oldPdfdata.totalPages,
                                    bondPages: oldPdfdata.bondPages,
                                    copies: oldPdfdata.copies,
                                    binding: oldPdfdata.binding,
                                    paperSize: oldPdfdata.paperSize,
                                    pdfSides: oldPdfdata.pdfSides,
                                    pdfPrintLayout: oldPdfdata.pdfPrintLayout,
                                    color: getStringJobType(printjob),
                                    pageRange: oldPdfdata.pageRange,
                                    colorParDesciption:
                                        oldPdfdata.colorParDesciption,
                                    colorParPageNumbers:
                                        oldPdfdata.colorParPageNumbers,
                                    colorParTotal: oldPdfdata.colorParTotal,
                                    additionDesciption:
                                        oldPdfdata.additionDesciption,
                                    uploadID: oldPdfdata.uploadID);
                                pdffilesList.replacePDFAtIndex(
                                    widget.index, newPDfData);
                                pdffilesList.printPDFFile();
                              });
                            },
                            child: Container(
                              height: 40,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 7),
                              decoration: BoxDecoration(
                                color: printjob == JobTypes.blackAndWhite
                                    ? ColorPallets.lightBlue.withOpacity(.2)
                                    : null,
                                borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(22),
                                    bottomLeft: Radius.circular(22)),
                                border:
                                    Border.all(color: ColorPallets.lightBlue),
                              ),
                              child: const FittedBox(
                                child: Text("B&W"),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                printjob = JobTypes.fullColor;
                                showColorTextBox = false;
                                showWidgetColorTextBox = false;
                                // showColorsliderTextbox = false;
                                // showColorWidgetSliderTextBox = false;

                                // update the values as getStringJobType(prinyjob) // JobTypes.fullColor

                                PdfData oldPdfdata = pdffilesList
                                    .getPDFFileAtIndex(widget.index);
                                PdfData newPDfData = PdfData(
                                    name: oldPdfdata.name,
                                    size: oldPdfdata.size,
                                    totalPages: oldPdfdata.totalPages,
                                    bondPages: oldPdfdata.bondPages,
                                    copies: oldPdfdata.copies,
                                    binding: oldPdfdata.binding,
                                    paperSize: oldPdfdata.paperSize,
                                    pdfSides: oldPdfdata.pdfSides,
                                    pdfPrintLayout: oldPdfdata.pdfPrintLayout,
                                    color: getStringJobType(printjob),
                                    pageRange: oldPdfdata.pageRange,
                                    colorParDesciption:
                                        oldPdfdata.colorParDesciption,
                                    colorParPageNumbers:
                                        oldPdfdata.colorParPageNumbers,
                                    colorParTotal: oldPdfdata.colorParTotal,
                                    additionDesciption:
                                        oldPdfdata.additionDesciption,
                                    uploadID: oldPdfdata.uploadID);
                                pdffilesList.replacePDFAtIndex(
                                    widget.index, newPDfData);
                                pdffilesList.printPDFFile();
                              });
                            },
                            child: Container(
                              height: 40,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 7, vertical: 7),
                              decoration: BoxDecoration(
                                color: printjob == JobTypes.fullColor
                                    ? ColorPallets.lightBlue.withOpacity(.2)
                                    : null,
                                // borderRadius: const BorderRadius.only(
                                //     topRight: Radius.circular(22),
                                //     bottomRight: Radius.circular(22)),
                                border:
                                    Border.all(color: ColorPallets.lightBlue),
                              ),
                              child: const FittedBox(
                                child: Text("Color"),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: InkWell(
                            onTap: () async {
                              setState(() {
                                printjob = JobTypes.partialColor;

                                PdfData oldPdfdata = pdffilesList
                                    .getPDFFileAtIndex(widget.index);
                                PdfData newPDfData = PdfData(
                                    name: oldPdfdata.name,
                                    size: oldPdfdata.size,
                                    totalPages: oldPdfdata.totalPages,
                                    bondPages: oldPdfdata.bondPages,
                                    copies: oldPdfdata.copies,
                                    binding: oldPdfdata.binding,
                                    paperSize: oldPdfdata.paperSize,
                                    pdfSides: oldPdfdata.pdfSides,
                                    pdfPrintLayout: oldPdfdata.pdfPrintLayout,
                                    color: getStringJobType(printjob),
                                    pageRange: oldPdfdata.pageRange,
                                    colorParDesciption:
                                        oldPdfdata.colorParDesciption,
                                    colorParPageNumbers:
                                        oldPdfdata.colorParPageNumbers,
                                    colorParTotal: oldPdfdata.colorParTotal,
                                    additionDesciption:
                                        oldPdfdata.additionDesciption,
                                    uploadID: oldPdfdata.uploadID);
                                pdffilesList.replacePDFAtIndex(
                                    widget.index, newPDfData);
                                pdffilesList.printPDFFile();
                              });
                              if (showColorTextBox == false) {
                                setState(() {
                                  showColorTextBox = true;
                                });
                                await Future.delayed(
                                    const Duration(milliseconds: 300));
                                setState(() {
                                  showWidgetColorTextBox = true;
                                });
                              } else {
                                setState(() {
                                  showColorTextBox = false;
                                  showWidgetColorTextBox = false;
                                });
                              }
                              print("expanded the widege !!!");
                            },
                            child: Container(
                              height: 40,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 3, vertical: 7),
                              decoration: BoxDecoration(
                                color: printjob == JobTypes.partialColor
                                    ? ColorPallets.lightBlue.withOpacity(.2)
                                    : null,
                                borderRadius: const BorderRadius.only(
                                    topRight: Radius.circular(22),
                                    bottomRight: Radius.circular(22)),
                                border:
                                    Border.all(color: ColorPallets.lightBlue),
                              ),
                              child: const FittedBox(
                                child: Text("ColPar"),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    // child: Text("fdf")
                  ),
                ),
              ],
            ),
            showWidgetColorTextBox == true
                ? AnimatedContainer(
                    padding: const EdgeInsets.only(top: 20),
                    height: sliderContHeight,
                    duration: const Duration(milliseconds: 300),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Expanded(
                              flex: 3,
                              child: Container(
                                margin:
                                    const EdgeInsets.only(left: 5, right: 5),
                                child: const Center(
                                  child: FittedBox(
                                    child: Text(
                                      "Color Pages :",
                                      style: TextStyle(fontSize: 20),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              flex: 3,
                              child: Container(
                                height: 40,
                                padding: const EdgeInsets.all(0),
                                child: TextField(
                                  onChanged: (value) {
                                    setState(() {
                                      if (value == null ||
                                          value.toString() == "") {
                                        return;
                                      }
                                      // upade values by _noOfCopies.textß
                                      _ColorPagesController.text =
                                          value.toString();
                                      print(
                                          "COLOR PAGERANGE CONTROLLERS ${_ColorPagesController.text}");
                                      PdfData oldPdfdata = pdffilesList
                                          .getPDFFileAtIndex(widget.index);
                                      PdfData newPDfData = PdfData(
                                          name: oldPdfdata.name,
                                          size: oldPdfdata.size,
                                          totalPages: oldPdfdata.totalPages,
                                          bondPages: oldPdfdata.bondPages,
                                          copies: oldPdfdata.copies,
                                          binding: oldPdfdata.binding,
                                          paperSize: oldPdfdata.paperSize,
                                          pdfSides: oldPdfdata.pdfSides,
                                          pdfPrintLayout:
                                              oldPdfdata.pdfPrintLayout,
                                          color: getStringJobType(
                                              JobTypes.partialColor),
                                          pageRange: oldPdfdata.pageRange,
                                          colorParDesciption:
                                              oldPdfdata.colorParDesciption,
                                          colorParPageNumbers:
                                              _ColorPagesController.text,
                                          colorParTotal:
                                              oldPdfdata.colorParTotal,
                                          additionDesciption:
                                              oldPdfdata.additionDesciption,
                                          uploadID: oldPdfdata.uploadID);
                                      pdffilesList.replacePDFAtIndex(
                                          widget.index, newPDfData);
                                      pdffilesList.printPDFFile();
                                    });
                                  },
                                  onSubmitted: (value) {
                                    setState(() {
                                      // update the values with _ColorPagesController.text and getStringjobtype(JobTypes.partialColor);
                                      if (value == null ||
                                          value.toString() == "") {
                                        return;
                                      }
                                      // upade values by _noOfCopies.textß
                                      _ColorPagesController.text =
                                          value.toString();
                                      print(
                                          "COLOR PAGERANGE CONTROLLERS ${_ColorPagesController.text}");
                                      PdfData oldPdfdata = pdffilesList
                                          .getPDFFileAtIndex(widget.index);
                                      PdfData newPDfData = PdfData(
                                          name: oldPdfdata.name,
                                          size: oldPdfdata.size,
                                          totalPages: oldPdfdata.totalPages,
                                          bondPages: oldPdfdata.bondPages,
                                          copies: oldPdfdata.copies,
                                          binding: oldPdfdata.binding,
                                          paperSize: oldPdfdata.paperSize,
                                          pdfSides: oldPdfdata.pdfSides,
                                          pdfPrintLayout:
                                              oldPdfdata.pdfPrintLayout,
                                          color: getStringJobType(
                                              JobTypes.partialColor),
                                          pageRange: oldPdfdata.pageRange,
                                          colorParDesciption:
                                              oldPdfdata.colorParDesciption,
                                          colorParPageNumbers:
                                              _ColorPagesController.text,
                                          colorParTotal:
                                              oldPdfdata.colorParTotal,
                                          additionDesciption:
                                              oldPdfdata.additionDesciption,
                                          uploadID: oldPdfdata.uploadID);
                                      pdffilesList.replacePDFAtIndex(
                                          widget.index, newPDfData);
                                      pdffilesList.printPDFFile();
                                    });
                                  },
                                  controller: _ColorPagesController,
                                  cursorHeight: 25,
                                  decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                      hintStyle: TextStyle(fontSize: 18),
                                      hintText: "1,2,4,5,8"),
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            // Expanded(
                            //   flex: 2,
                            //   child: InkWell(
                            //     onTap: () async {
                            //       if (showColorsliderTextbox == false) {
                            //         setState(() {
                            //           showColorsliderTextbox = true;
                            //         });
                            //         await Future.delayed(
                            //             const Duration(milliseconds: 300));
                            //         setState(() {
                            //           showColorWidgetSliderTextBox = true;
                            //         });
                            //       } else {
                            //         setState(() {
                            //           showColorsliderTextbox = false;
                            //           showColorWidgetSliderTextBox = false;
                            //         });
                            //       }
                            //     },
                            //     child: Container(
                            //       // padding: EdgeInsets.only(
                            //       //   left: 10,
                            //       // ),
                            //       child: const Chip(
                            //         label: FittedBox(
                            //           fit: BoxFit.contain,
                            //           child: Text(
                            //             "Slider",
                            //             style: TextStyle(
                            //                 color: Colors.white, fontSize: 16),
                            //           ),
                            //         ),
                            //         backgroundColor: ColorPallets.deepBlue,
                            //       ),
                            //     ),
                            //   ),
                            // )
                          ],
                        ),
                        // showColorWidgetSliderTextBox == true
                        //     ? SingleChildScrollView(
                        //         child: SizedBox(
                        //           height: 70,
                        //           child: Row(
                        //             mainAxisAlignment:
                        //                 MainAxisAlignment.spaceEvenly,
                        //             children: [
                        //               const SizedBox(
                        //                 width: 10,
                        //               ),
                        //               const Text(
                        //                 '0',
                        //                 style: TextStyle(
                        //                     fontSize: 22,
                        //                     color: ColorPallets.deepBlue),
                        //               ),
                        //               Expanded(
                        //                 child: SfRangeSliderTheme(
                        //                   data: SfRangeSelectorThemeData(
                        //                     tooltipBackgroundColor:
                        //                         ColorPallets.deepBlue,
                        //                   ),
                        //                   child: SfRangeSlider(
                        //                       activeColor:
                        //                           ColorPallets.deepBlue,
                        //                       inactiveColor: ColorPallets
                        //                           .lightBlue
                        //                           .withOpacity(.3),
                        //                       key: const ValueKey(
                        //                           "colorpagesClider"),
                        //                       min: 1,
                        //                       max: totalPages!.toDouble(),
                        //                       enableTooltip: true,
                        //                       stepSize: 1,
                        //                       tooltipShape:
                        //                           const SfPaddleTooltipShape(),
                        //                       values:
                        //                           Colorvalues as SfRangeValues,
                        //                       onChanged: (value) {
                        //                         setState(() {
                        //                           Colorvalues = value;
                        //                           if (Colorvalues!.start ==
                        //                               Colorvalues!.end) {
                        //                             String tempString =
                        //                                 "${Colorvalues!.start.toInt()}";
                        //                             _ColorPagesController.text =
                        //                                 tempString;
                        //                           } else {
                        //                             String tempString =
                        //                                 "${Colorvalues!.start.toInt()}-${Colorvalues!.end.toInt()}";
                        //                             _ColorPagesController.text =
                        //                                 tempString;
                        //                           }

                        //                           PdfData oldPdfdata =
                        //                               pdffilesList
                        //                                   .getPDFFileAtIndex(
                        //                                       widget.index);
                        //                           PdfData newPDfData = PdfData(
                        //                               name: oldPdfdata.name,
                        //                               size: oldPdfdata.size,
                        //                               totalPages:
                        //                                   oldPdfdata.totalPages,
                        //                               bondPages:
                        //                                   oldPdfdata.bondPages,
                        //                               copies: oldPdfdata.copies,
                        //                               binding:
                        //                                   oldPdfdata.binding,
                        //                               paperSize:
                        //                                   oldPdfdata.paperSize,
                        //                               pdfSides:
                        //                                   oldPdfdata.pdfSides,
                        //                               pdfPrintLayout: oldPdfdata
                        //                                   .pdfPrintLayout,
                        //                               color: getStringJobType(
                        //                                   JobTypes
                        //                                       .partialColor),
                        //                               pageRange:
                        //                                   oldPdfdata.pageRange,
                        //                               colorParDesciption:
                        //                                   oldPdfdata
                        //                                       .colorParDesciption,
                        //                               colorParPageNumbers:
                        //                                   _ColorPagesController
                        //                                       .text,
                        //                               colorParTotal: oldPdfdata
                        //                                   .colorParTotal,
                        //                               additionDesciption:
                        //                                   oldPdfdata
                        //                                       .additionDesciption,
                        //                               uploadID:
                        //                                   oldPdfdata.uploadID);
                        //                           pdffilesList
                        //                               .replacePDFAtIndex(
                        //                                   widget.index,
                        //                                   newPDfData);
                        //                           pdffilesList.printPDFFile();
                        //                         });
                        //                       }),
                        //                 ),
                        //               ),
                        //               Text(
                        //                 totalPages.toString(),
                        //                 style: const TextStyle(
                        //                     fontSize: 22,
                        //                     color: ColorPallets.deepBlue),
                        //               ),
                        //               const SizedBox(
                        //                 width: 10,
                        //               )
                        //             ],
                        //           ),
                        //         ),
                        //       )
                        //     : SizedBox(),
                      ],
                    ),
                  )
                : SizedBox()
          ],
        ),
      ),
    );
  }

  Widget binding(ListOfPDFFiles pdffilesList) {
    return Card(
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
        height: 60,
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
          Expanded(
            flex: 4,
            child: Container(
              margin: const EdgeInsets.only(left: 5, right: 5),
              child: const Center(
                child: FittedBox(
                  child: Text(
                    "Binding :",
                    style: TextStyle(fontSize: 20),
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
              height: 40,
              padding: const EdgeInsets.only(left: 20, top: 2, bottom: 2),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: ColorPallets.lightBlue, width: 1)),
              child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                value: sheetBind,
                items: sheetsBondList.map((e) => buildMenuItem(e)).toList(),
                onChanged: (value) => setState(() {
                  sheetBind = value;
                  // update values by  value.toString(),
                  print("PRESSED !!!`");
                  PdfData oldPdfdata =
                      pdffilesList.getPDFFileAtIndex(widget.index);
                  PdfData newPDfData = PdfData(
                      name: oldPdfdata.name,
                      size: oldPdfdata.size,
                      totalPages: oldPdfdata.totalPages,
                      bondPages: oldPdfdata.bondPages,
                      copies: oldPdfdata.copies,
                      binding: value.toString(),
                      paperSize: oldPdfdata.paperSize,
                      pdfSides: oldPdfdata.pdfSides,
                      pdfPrintLayout: oldPdfdata.pdfPrintLayout,
                      color: oldPdfdata.color,
                      pageRange: oldPdfdata.pageRange,
                      colorParDesciption: oldPdfdata.colorParDesciption,
                      colorParPageNumbers: oldPdfdata.colorParPageNumbers,
                      colorParTotal: oldPdfdata.colorParTotal,
                      additionDesciption: oldPdfdata.additionDesciption,
                      uploadID: oldPdfdata.uploadID);
                  pdffilesList.replacePDFAtIndex(widget.index, newPDfData);
                  pdffilesList.printPDFFile();
                }),
              )),
            ),
          ),
          // const SizedBox(width: 20),
        ]),
      ),
    );
  }

  Widget bondSheets(ListOfPDFFiles pdffilesList) {
    return Card(
      elevation: 3,
      shadowColor: ColorPallets.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0), // Adjust the radius as needed
      ),
      child: AnimatedContainer(
        decoration: BoxDecoration(
          color: ColorPallets.white,
          borderRadius:
              BorderRadius.circular(8.0), // Adjust the radius as needed
          border: Border.all(
            color: ColorPallets.white, // Set the border color
            width: 2.0, // Set the border width
          ),
        ),
        duration: const Duration(milliseconds: 300),
        height: totalBondPaperContainerHeight,
        padding:
            const EdgeInsets.only(left: 20, right: 20, top: 13, bottom: 13),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  flex: 4,
                  child: Container(
                    margin: const EdgeInsets.only(left: 5, right: 5),
                    child: const Center(
                      child: FittedBox(
                        child: Text(
                          "BondPaper :",
                          style: TextStyle(fontSize: 20),
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
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(28)),

                    height: 40,
                    child: Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                boudSheets = false;
                                PdfData oldPdfdata = pdffilesList
                                    .getPDFFileAtIndex(widget.index);
                                PdfData newPDfData = PdfData(
                                    name: oldPdfdata.name,
                                    size: oldPdfdata.size,
                                    totalPages: oldPdfdata.totalPages,
                                    bondPages: false,
                                    copies: oldPdfdata.copies,
                                    binding: oldPdfdata.binding,
                                    paperSize: oldPdfdata.paperSize,
                                    pdfSides: oldPdfdata.pdfSides,
                                    pdfPrintLayout: oldPdfdata.pdfPrintLayout,
                                    color: oldPdfdata.color,
                                    pageRange: oldPdfdata.pageRange,
                                    colorParDesciption:
                                        oldPdfdata.colorParDesciption,
                                    colorParPageNumbers:
                                        oldPdfdata.colorParPageNumbers,
                                    colorParTotal: oldPdfdata.colorParTotal,
                                    additionDesciption:
                                        oldPdfdata.additionDesciption,
                                    uploadID: oldPdfdata.uploadID);
                                pdffilesList.replacePDFAtIndex(
                                    widget.index, newPDfData);
                                pdffilesList.printPDFFile();

                                // showBondSheetsTextBox = false;
                                // showBondWingetSheetsTextBox = false;
                                // showBondSheetsSliderTextBox = false;
                                // showBondSheetWidgetsliderTextBox = false;

                                // update isBondpaper as false
                                // currentPdfModal = PdfFiltersModal(
                                //     pagesRange: currentPdfModal!.pagesRange,
                                //     noOfCopies: currentPdfModal!.noOfCopies,
                                //     pageOrient: currentPdfModal!.pageOrient,
                                //     pagePrintSide:
                                //         currentPdfModal!.pagePrintSide,
                                //     pageSize: currentPdfModal!.pageSize,
                                //     printJobType: currentPdfModal!.printJobType,
                                //     colorPagesRange:
                                //         currentPdfModal!.colorPagesRange,
                                //     bindingType: currentPdfModal!.bindingType,
                                //     isBondPaperNeeded: false,
                                //     bondPaperRange: "",
                                //     isTransparentSheetNeed:
                                //         currentPdfModal!.isTransparentSheetNeed,
                                //     transparentSheetColor:
                                //         currentPdfModal!.transparentSheetColor,
                                //     seletedShop: currentPdfModal!.seletedShop);
                                // totalPrice = currentPdfModal!.getCostOfXerox();
                              });
                            },
                            child: Container(
                              height: 40,
                              // padding: const EdgeInsets.symmetric(
                              //     horizontal: 10, vertical: 10),
                              decoration: BoxDecoration(
                                color: boudSheets == false
                                    ? ColorPallets.lightBlue.withOpacity(.2)
                                    : null,
                                borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(22),
                                    bottomLeft: Radius.circular(22)),
                                border:
                                    Border.all(color: ColorPallets.lightBlue),
                              ),
                              child: const Center(
                                child: Text(
                                  "No",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 20),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: InkWell(
                            onTap: () async {
                              setState(() {
                                boudSheets = true;
                                PdfData oldPdfdata = pdffilesList
                                    .getPDFFileAtIndex(widget.index);
                                PdfData newPDfData = PdfData(
                                    name: oldPdfdata.name,
                                    size: oldPdfdata.size,
                                    totalPages: oldPdfdata.totalPages,
                                    bondPages: true,
                                    copies: oldPdfdata.copies,
                                    binding: oldPdfdata.binding,
                                    paperSize: oldPdfdata.paperSize,
                                    pdfSides: oldPdfdata.pdfSides,
                                    pdfPrintLayout: oldPdfdata.pdfPrintLayout,
                                    color: oldPdfdata.color,
                                    pageRange: oldPdfdata.pageRange,
                                    colorParDesciption:
                                        oldPdfdata.colorParDesciption,
                                    colorParPageNumbers:
                                        oldPdfdata.colorParPageNumbers,
                                    colorParTotal: oldPdfdata.colorParTotal,
                                    additionDesciption:
                                        oldPdfdata.additionDesciption,
                                    uploadID: oldPdfdata.uploadID);
                                pdffilesList.replacePDFAtIndex(
                                    widget.index, newPDfData);
                                pdffilesList.printPDFFile();
                              });
                              // update isbondpaper is true
                              // currentPdfModal = PdfFiltersModal(
                              //     pagesRange: currentPdfModal!.pagesRange,
                              //     noOfCopies: currentPdfModal!.noOfCopies,
                              //     pageOrient: currentPdfModal!.pageOrient,
                              //     pagePrintSide: currentPdfModal!.pagePrintSide,
                              //     pageSize: currentPdfModal!.pageSize,
                              //     printJobType: currentPdfModal!.printJobType,
                              //     colorPagesRange:
                              //         currentPdfModal!.colorPagesRange,
                              //     bindingType: currentPdfModal!.bindingType,
                              //     isBondPaperNeeded: true,
                              //     bondPaperRange: _bondPagesController.text,
                              //     isTransparentSheetNeed:
                              //         currentPdfModal!.isTransparentSheetNeed,
                              //     transparentSheetColor:
                              //         currentPdfModal!.transparentSheetColor,
                              //     seletedShop: currentPdfModal!.seletedShop);
                              // totalPrice = currentPdfModal!.getCostOfXerox();
                              // if (showBondSheetsTextBox == false) {
                              //   setState(() {
                              //     showBondSheetsTextBox = true;
                              //   });
                              //   await Future.delayed(
                              //       const Duration(milliseconds: 300));
                              //   setState(() {
                              //     showBondWingetSheetsTextBox = true;
                              //   });
                              // } else {
                              //   setState(() {
                              //     showBondSheetsTextBox = false;
                              //     showBondWingetSheetsTextBox = false;
                              //   });
                              // }
                              print("expanded the widege !!!");
                            },
                            child: Container(
                              height: 40,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 5, vertical: 10),
                              decoration: BoxDecoration(
                                color: boudSheets == true
                                    ? ColorPallets.lightBlue.withOpacity(.2)
                                    : null,
                                borderRadius: const BorderRadius.only(
                                    topRight: Radius.circular(22),
                                    bottomRight: Radius.circular(22)),
                                border:
                                    Border.all(color: ColorPallets.lightBlue),
                              ),
                              child: const Center(
                                child: Text(
                                  "Yes",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 20),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    // child: Text("fdf")
                  ),
                ),
              ],
            ),
            // showBondWingetSheetsTextBox == true
            //     ? AnimatedContainer(
            //         padding: const EdgeInsets.only(top: 7),
            //         height: BondPapersliderContHeight,
            //         duration: const Duration(milliseconds: 300),
            //         child: Column(
            //           children: [
            //             Row(
            //               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            //               children: [
            //                 Expanded(
            //                   flex: 3,
            //                   child: Container(
            //                     margin:
            //                         const EdgeInsets.only(left: 5, right: 5),
            //                     child: const Center(
            //                       child: FittedBox(
            //                         child: Text(
            //                           "Bond Pages :",
            //                           style: TextStyle(fontSize: 20),
            //                         ),
            //                       ),
            //                     ),
            //                   ),
            //                 ),
            //                 const SizedBox(
            //                   width: 10,
            //                 ),
            //                 Expanded(
            //                   flex: 3,
            //                   child: Container(
            //                     height: 40,
            //                     padding: const EdgeInsets.all(0),
            //                     child: TextField(
            //                       onSubmitted: (value) {
            //                         setState(() {
            //                           // update isBondpaper true , bondpaperrange is _bondPagesController.text,

            //                           // currentPdfModal = PdfFiltersModal(
            //                           //     pagesRange:
            //                           //         currentPdfModal!.pagesRange,
            //                           //     noOfCopies:
            //                           //         currentPdfModal!.noOfCopies,
            //                           //     pageOrient:
            //                           //         currentPdfModal!.pageOrient,
            //                           //     pagePrintSide:
            //                           //         currentPdfModal!.pagePrintSide,
            //                           //     pageSize: currentPdfModal!.pageSize,
            //                           //     printJobType:
            //                           //         currentPdfModal!.printJobType,
            //                           //     colorPagesRange:
            //                           //         _ColorPagesController.text,
            //                           //     bindingType:
            //                           //         currentPdfModal!.bindingType,
            //                           //     isBondPaperNeeded: true,
            //                           //     bondPaperRange:
            //                           //         _bondPagesController.text,
            //                           //     isTransparentSheetNeed:
            //                           //         currentPdfModal!
            //                           //             .isTransparentSheetNeed,
            //                           //     transparentSheetColor:
            //                           //         currentPdfModal!
            //                           //             .transparentSheetColor,
            //                           //     seletedShop:
            //                           //         currentPdfModal!.seletedShop);
            //                           // totalPrice =
            //                           //     currentPdfModal!.getCostOfXerox();
            //                         });
            //                       },
            //                       cursorHeight: 25,
            //                       controller: _bondPagesController,
            //                       decoration: const InputDecoration(
            //                           border: OutlineInputBorder(),
            //                           hintStyle: TextStyle(fontSize: 18),
            //                           hintText: "1-5,8"),
            //                     ),
            //                   ),
            //                 ),
            //                 const SizedBox(
            //                   width: 10,
            //                 ),
            //                 Expanded(
            //                   flex: 2,
            //                   child: InkWell(
            //                     onTap: () async {
            //                       if (showBondSheetsSliderTextBox == false) {
            //                         setState(() {
            //                           showBondSheetsSliderTextBox = true;
            //                         });
            //                         await Future.delayed(
            //                             const Duration(milliseconds: 300));
            //                         setState(() {
            //                           showBondSheetWidgetsliderTextBox = true;
            //                         });
            //                       } else {
            //                         setState(() {
            //                           showBondSheetsSliderTextBox = false;
            //                           showBondSheetWidgetsliderTextBox = false;
            //                         });
            //                       }
            //                     },
            //                     child: Container(
            //                       // padding: EdgeInsets.symmetric(
            //                       //     horizontal: 10, vertical: 5),
            //                       child: const Chip(
            //                         label: FittedBox(
            //                           fit: BoxFit.contain,
            //                           child: Text(
            //                             "Slider",
            //                             style: TextStyle(
            //                                 color: Colors.white, fontSize: 16),
            //                           ),
            //                         ),
            //                         backgroundColor: ColorPallets.deepBlue,
            //                       ),
            //                     ),
            //                   ),
            //                 )
            //               ],
            //             ),
            //             showBondSheetWidgetsliderTextBox == true
            //                 ? SingleChildScrollView(
            //                     child: SizedBox(
            //                       height: 70,
            //                       child: Row(
            //                         mainAxisAlignment:
            //                             MainAxisAlignment.spaceEvenly,
            //                         children: [
            //                           const SizedBox(
            //                             width: 10,
            //                           ),
            //                           const Text(
            //                             '0',
            //                             style: TextStyle(
            //                                 fontSize: 22,
            //                                 color: ColorPallets.deepBlue),
            //                           ),
            //                           Expanded(
            //                             child: SfRangeSliderTheme(
            //                               data: SfRangeSelectorThemeData(
            //                                   tooltipBackgroundColor:
            //                                       ColorPallets.deepBlue),
            //                               child: SfRangeSlider(
            //                                 activeColor: ColorPallets.deepBlue,
            //                                 inactiveColor: ColorPallets
            //                                     .lightBlue
            //                                     .withOpacity(.3),
            //                                 min: 1,
            //                                 max: totalPages!.toDouble(),
            //                                 enableTooltip: true,
            //                                 stepSize: 1,
            //                                 tooltipShape:
            //                                     const SfPaddleTooltipShape(),
            //                                 values: Bondvalues as SfRangeValues,
            //                                 onChanged: (value) {
            //                                   setState(
            //                                     () {
            //                                       Bondvalues = value;
            //                                       if (Bondvalues!.start ==
            //                                           Bondvalues!.end) {
            //                                         String tempString =
            //                                             "${Bondvalues!.start.toInt()}";
            //                                         _bondPagesController.text =
            //                                             tempString;
            //                                       } else {
            //                                         String tempString =
            //                                             "${Bondvalues!.start.toInt()}-${Bondvalues!.end.toInt()}";
            //                                         _bondPagesController.text =
            //                                             tempString;
            //                                       }
            //                                     },
            //                                   );
            //                                   setState(() {
            //                                     // is bondpaper is true , bondpaperrange is _bondPagesController.text
            //                                     // currentPdfModal = PdfFiltersModal(
            //                                     //     pagesRange: currentPdfModal!
            //                                     //         .pagesRange,
            //                                     //     noOfCopies: currentPdfModal!
            //                                     //         .noOfCopies,
            //                                     //     pageOrient: currentPdfModal!
            //                                     //         .pageOrient,
            //                                     //     pagePrintSide: currentPdfModal!
            //                                     //         .pagePrintSide,
            //                                     //     pageSize: currentPdfModal!
            //                                     //         .pageSize,
            //                                     //     printJobType:
            //                                     //         currentPdfModal!
            //                                     //             .printJobType,
            //                                     //     colorPagesRange:
            //                                     //         currentPdfModal!
            //                                     //             .colorPagesRange,
            //                                     //     bindingType:
            //                                     //         currentPdfModal!
            //                                     //             .bindingType,
            //                                     //     isBondPaperNeeded: true,
            //                                     //     bondPaperRange:
            //                                     //         _bondPagesController
            //                                     //             .text,
            //                                     //     isTransparentSheetNeed:
            //                                     //         currentPdfModal!
            //                                     //             .isTransparentSheetNeed,
            //                                     //     transparentSheetColor:
            //                                     //         currentPdfModal!
            //                                     //             .transparentSheetColor,
            //                                     //     seletedShop:
            //                                     //         currentPdfModal!
            //                                     //             .seletedShop);
            //                                     // totalPrice = currentPdfModal!
            //                                     //     .getCostOfXerox();
            //                                   });
            //                                 },
            //                               ),
            //                             ),
            //                           ),
            //                           Text(
            //                             totalPages.toString(),
            //                             style: const TextStyle(
            //                                 fontSize: 22,
            //                                 color: ColorPallets.deepBlue),
            //                           ),
            //                           const SizedBox(
            //                             width: 10,
            //                           ),
            //                         ],
            //                       ),
            //                     ),
            //                   )
            //                 : SizedBox(),
            //           ],
            //         ),
            //       )
            //     : SizedBox()
          ],
        ),
      ),
    );
  }

  Widget additionalInstructions(ListOfPDFFiles pdffilesList) {
    return Card(
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
        // height: 60,
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const FittedBox(
              fit: BoxFit.contain,
              child: Text(
                'Additional Instructions',
                style: TextStyle(
                  fontSize: 20,
                  // fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 8),
            TextField(
              controller: _instructionsController,
              maxLines: 3,
              decoration: const InputDecoration(
                hintText: 'Enter additional instructions...',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  if (value == null || value.toString() == "") {
                    return;
                  }
                  _instructionsController.text = value.toString();
                  PdfData oldPdfdata =
                      pdffilesList.getPDFFileAtIndex(widget.index);
                  PdfData newPDfData = PdfData(
                      name: oldPdfdata.name,
                      size: oldPdfdata.size,
                      totalPages: oldPdfdata.totalPages,
                      bondPages: oldPdfdata.bondPages,
                      copies: oldPdfdata.copies,
                      binding: oldPdfdata.binding,
                      paperSize: oldPdfdata.paperSize,
                      pdfSides: oldPdfdata.pdfSides,
                      pdfPrintLayout: oldPdfdata.pdfPrintLayout,
                      color: oldPdfdata.color,
                      pageRange: oldPdfdata.pageRange,
                      colorParDesciption: oldPdfdata.colorParDesciption,
                      colorParPageNumbers: oldPdfdata.colorParPageNumbers,
                      colorParTotal: oldPdfdata.colorParTotal,
                      additionDesciption: _instructionsController.text,
                      uploadID: oldPdfdata.uploadID);
                  pdffilesList.replacePDFAtIndex(widget.index, newPDfData);
                  pdffilesList.printPDFFile();
                });
              },
              onSubmitted: (value) {
                setState(() {
                  // update the valye here
                  if (value == null || value.toString() == "") {
                    return;
                  }
                  _instructionsController.text = value.toString();
                  PdfData oldPdfdata =
                      pdffilesList.getPDFFileAtIndex(widget.index);
                  PdfData newPDfData = PdfData(
                      name: oldPdfdata.name,
                      size: oldPdfdata.size,
                      totalPages: oldPdfdata.totalPages,
                      bondPages: oldPdfdata.bondPages,
                      copies: oldPdfdata.copies,
                      binding: oldPdfdata.binding,
                      paperSize: oldPdfdata.paperSize,
                      pdfSides: oldPdfdata.pdfSides,
                      pdfPrintLayout: oldPdfdata.pdfPrintLayout,
                      color: oldPdfdata.color,
                      pageRange: oldPdfdata.pageRange,
                      colorParDesciption: oldPdfdata.colorParDesciption,
                      colorParPageNumbers: oldPdfdata.colorParPageNumbers,
                      colorParTotal: oldPdfdata.colorParTotal,
                      additionDesciption: _instructionsController.text,
                      uploadID: oldPdfdata.uploadID);
                  pdffilesList.replacePDFAtIndex(widget.index, newPDfData);
                  pdffilesList.printPDFFile();
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
