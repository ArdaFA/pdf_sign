// pdf viewer UI
// pdf_viewer_screen.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'pdf_viewer_controller.dart';  // Import the controller

class PdfViewerScreen extends StatefulWidget {
  @override
  _PdfViewerScreenState createState() => _PdfViewerScreenState();
}

class _PdfViewerScreenState extends State<PdfViewerScreen> {
  File? pdfFile; // The selected PDF file
  final PdfViewerController _controller = PdfViewerController(); // Controller instance

  bool isAnyFilePicked = false;

  // Method to pick a PDF file
  Future<void> pickPDFfile() async {
    // Use the controller to pick a file
    File? file = await _controller.pickPDFfile();

    if (file != null) {
      setState(() {
        pdfFile = file; // Update the state with the selected file
        isAnyFilePicked = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('PDF Viewer')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: pickPDFfile,
              child: Text('Pick a File'),
            ),
            SizedBox(height: 12),
            // If a file is selected, display the PDF viewer
            if (pdfFile != null)
              Expanded(
                child: PDFView(
                  filePath: pdfFile!.path,
                ),
              ),
            const SizedBox(height: 12),
            if (pdfFile != null)
              Row( mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(onPressed: pickPDFfile, child: Text('Pick Again')),
                  ElevatedButton(onPressed: () {
                    Navigator.pushNamed(context, '/create_signature');
                  }, child: Text('Sign')),
                ],
              ),
            const SizedBox(height: 12,)
          ],
        ),
      ),
    );
  }
}
