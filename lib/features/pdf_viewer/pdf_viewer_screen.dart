// pdf viewer UI

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:sign_pdf/features/pdf_viewer/pdf_viewer_controller.dart';

class PdfViewerScreen extends StatelessWidget {

  File? pdfFile; // refers to the file that is going to be selected

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('PDF Viewer')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: () {
              pdfFile = pickPDFfile() as File?;
            },
            child: Text('Pick a File'),
          ),
        ],
      ),
    );
  }
}
