import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_pdf_indicator/flutter_pdf_indicator.dart';
import 'package:native_pdf_view/native_pdf_view.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final PdfController controller;
  Completer<PdfDocument> document = Completer();

  @override
  void initState() {
    controller = PdfController(document: PdfDocument.openAsset('assets/analysis_options.pdf'));
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Stack(
        children: [
          PdfView(
            controller: controller,
            onDocumentLoaded: (doc) {
              document.complete(doc);
            },
          ),
          FutureBuilder<PdfDocument>(
            future: document.future,
            builder: (context, snapshot) {
              if (snapshot.data == null) return const SizedBox.shrink();
              return PdfIndicator(
                document: snapshot.data!,
              );
            },
          ),
        ],
      ),
    );
  }
}
