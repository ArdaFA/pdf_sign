// pdf viewer UI
// pdf_viewer_screen.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'pdf_viewer_controller.dart';  // Import the controller
import 'dart:io';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:image/image.dart' as img;

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

  Future<void> signPdf(Uint8List signatureBytes) async {
    // 1. Pick a PDF file
    FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: ['pdf']);

    if (result == null) return;

    File pdfFile = File(result.files.single.path!);
    final Uint8List pdfBytes = await pdfFile.readAsBytes();

    // 2. Load PDF
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Stack(
            children: [
              pw.Image(pw.MemoryImage(pdfBytes)), // Load existing PDF
              pw.Positioned(
                left: 100, // Adjust X coordinate
                bottom: 50, // Adjust Y coordinate
                child: pw.Image(pw.MemoryImage(signatureBytes), width: 150, height: 50),
              ),
            ],
          );
        },
      ),
    );

    // 3. Save the new PDF
    Directory directory = await getApplicationDocumentsDirectory();
    String outputPath = "${directory.path}/signed_document.pdf";

    final signedPdf = File(outputPath);
    await signedPdf.writeAsBytes(await pdf.save());

    print("Signed PDF saved at: $outputPath");
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
                    // i dont know what to do :(
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
