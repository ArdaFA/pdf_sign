// pdf viewer UI

import 'package:flutter/material.dart';

class PdfViewerScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('PDF Viewer')),
      body: Center(
        child: Text('PDF'),
      ),
    );
  }
}
