import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_plugin_pdf_viewer/flutter_plugin_pdf_viewer.dart';

class DisplayPdfPage extends StatefulWidget {
  String userId;
  String token;
  String pdf;
  String title;
  DisplayPdfPage(this.token, this.userId, this.pdf, this.title);
  @override
  _DisplayPdfPageState createState() => _DisplayPdfPageState();
}

class _DisplayPdfPageState extends State<DisplayPdfPage> {
  bool _isLoading = true;
  PDFDocument document;

  @override
  void initState() {
    super.initState();
    loadDocument();
  }

  loadDocument() async {
    document = await PDFDocument.fromURL(widget.pdf);
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Color(0xFF78A2CC),
        appBar: AppBar(
          backgroundColor: Color(0xFF78A2CC),
          title: Text(widget.title),
        ),
        body: Center(
          child: _isLoading
              ? Center(child: CircularProgressIndicator())
              : Container(
                  child: PDFViewer(
                    document: document,
                    indicatorBackground: Color(0xFF78A2CC),
                  ),
                ),
        ),
      ),
    );
  }
}
