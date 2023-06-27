import 'package:flutter/material.dart';
import 'package:pdfx/pdfx.dart';
import 'package:performance/performance.dart';

class ViewAnalysis extends StatefulWidget {
  @override
  State<ViewAnalysis> createState() => _ViewAnalysisState();
}

class _ViewAnalysisState extends State<ViewAnalysis> {
  static const int _initialPage = 1;
  int _actualPageNumber = _initialPage, _allPagesCount = 0;
  bool isSampleDoc = true;
  late PdfControllerPinch _pdfController;

  @override
  void initState() {
    _pdfController = PdfControllerPinch(
      document: PdfDocument.openAsset('assets/monkeypox_analysis.pdf'),
      initialPage: _initialPage,
    );
    super.initState();
  }

  @override
  void dispose() {
    _pdfController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => MaterialApp(
        theme: ThemeData(primaryColor: Colors.white),
        darkTheme: ThemeData.dark(),
        home: Scaffold(
          backgroundColor: Colors.grey,
          appBar: AppBar(
            title: const Text('Data Analysis'),
            backgroundColor: Colors.green,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            actions: <Widget>[
              IconButton(
                icon: const Icon(Icons.navigate_before),
                onPressed: () {
                  _pdfController.previousPage(
                    curve: Curves.ease,
                    duration: const Duration(milliseconds: 100),
                  );
                },
              ),
              Container(
                alignment: Alignment.center,
                child: Text(
                  '$_actualPageNumber/$_allPagesCount',
                  style: const TextStyle(fontSize: 22),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.navigate_next),
                onPressed: () {
                  _pdfController.nextPage(
                    curve: Curves.ease,
                    duration: const Duration(milliseconds: 100),
                  );
                },
              ),
              IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: () {
                  if (isSampleDoc) {
                    _pdfController.loadDocument(
                        PdfDocument.openAsset('assets/monkeypox_analysis.pdf'));
                  } else {
                    _pdfController.loadDocument(
                        PdfDocument.openAsset('assets/monkeypox_analysis.pdf'));
                  }
                  isSampleDoc = !isSampleDoc;
                },
              )
            ],
          ),
          body: PdfViewPinch(
            documentLoader: const Center(child: CircularProgressIndicator()),
            pageLoader: const Center(child: CircularProgressIndicator()),
            controller: _pdfController,
            onDocumentLoaded: (document) {
              setState(() {
                _allPagesCount = document.pagesCount;
              });
            },
            onPageChanged: (page) {
              setState(() {
                _actualPageNumber = page;
              });
            },
          ),
        ),
      );
}
