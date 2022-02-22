library flutter_pdf_indicator;

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:native_pdf_view/native_pdf_view.dart';

class PdfIndicator extends StatefulWidget {
  const PdfIndicator({
    Key? key,
    required this.document,
  }) : super(key: key);

  final PdfDocument document;

  @override
  State<PdfIndicator> createState() => _PdfIndicatorState();
}

class _PdfIndicatorState extends State<PdfIndicator> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: kToolbarHeight,
      alignment: Alignment.bottomCenter,
      color: Colors.grey.withOpacity(0.5),
      child: ListView.separated(
        itemCount: 10,
        scrollDirection: Axis.horizontal,
        separatorBuilder: (_, index) => const SizedBox(width: 8.0, height: 8.0),
        itemBuilder: (context, index) {
          Future<PdfPage> page = widget.document.getPage(index + (index * 10));
          return FutureBuilder<PdfPage>(
            future: page,
            builder: (context, snapshot) {
              if (snapshot.data == null) return const SizedBox.shrink();
              return _PdfPage(
                page: snapshot.data!,
                pageNumber: index + (index * 10),
                documentId: widget.document.id,
              );
            },
          );
        },
      ),
    );
  }
}

class _PdfPage extends StatefulWidget {
  const _PdfPage({
    Key? key,
    required this.page,
    required this.pageNumber,
    required this.documentId,
  }) : super(key: key);

  final PdfPage page;
  final int pageNumber;
  final String documentId;

  @override
  State<_PdfPage> createState() => _PdfPageState();
}

class _PdfPageState extends State<_PdfPage> {
  final Completer<PdfPageImage> image = Completer();

  @override
  void initState() {
    Future<PdfPageImage?> future = widget.page.render(width: widget.page.width, height: widget.page.height);
    future.then((value) => image.complete(value));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: kToolbarHeight,
      width: 32,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: PdfPageImageProvider(
            image.future,
            widget.pageNumber,
            widget.documentId,
          ),
        ),
      ),
    );
  }
}
