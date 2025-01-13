// Centralized route definitions

import 'package:flutter/material.dart';
import '../features/home/home_screen.dart';
import '../features/pdf_viewer/pdf_viewer_screen.dart';
import '../features/signature/signature_screen.dart';

class AppRoutes {
  static final routes = {
    '/': (context) => HomeScreen(),
    '/pdf_viewer': (context) => PdfViewerScreen(),
    '/create_signature': (context) => CreateSignature(),
  };
}
