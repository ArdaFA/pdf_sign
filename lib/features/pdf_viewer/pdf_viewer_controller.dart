// logic for handling pdf interactions

import 'package:file_picker/file_picker.dart';
import 'dart:io';

/// Controller to manage the PDF picking logic.
class PdfViewerController {
  /// Picks a PDF file from the user's device.
  /// Returns a [File] object representing the selected PDF file, or `null` if the user cancels the selection.
  Future<File?> pickPDFfile() async {
    try {
      // Open the file picker with custom type set to 'pdf'
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );

      // Check if the user picked a file
      if (result != null && result.files.single.path != null) {
        return File(result.files.single.path!); // Return the selected file
      } else {
        // User canceled the file picker dialog
        print("File selection was canceled.");
        return null;
      }
    } catch (e) {
      // Handle any errors that occur
      print("Error picking PDF file: $e");
      return null;
    }
  }
}
