// reusable widget for navigating pages

import 'package:flutter/material.dart';

class PdfNavigationBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        IconButton(icon: Icon(Icons.arrow_back), onPressed: () {}),
        Text('Page 1 of 10'),
        IconButton(icon: Icon(Icons.arrow_forward), onPressed: () {}),
      ],
    );
  }
}
