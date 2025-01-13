// MaterialApp configuration (routes, themes, etc.)

import 'package:flutter/material.dart';
import 'routes.dart';
import 'themes.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PDF Signer',
      theme: AppThemes.lightTheme,
      darkTheme: AppThemes.darkTheme,
      initialRoute: '/',
      routes: AppRoutes.routes,
    );
  }
}
