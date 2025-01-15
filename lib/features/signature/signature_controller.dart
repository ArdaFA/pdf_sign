// logic for handling signature input

import 'dart:io';
import 'dart:ui' as dart_ui;
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class SignatureController extends ChangeNotifier {
  List<Offset?> _points = []; // List to store signature points

  List<Offset?> get points => _points;

  void addPoint(Offset? point) {
    _points.add(point);
    notifyListeners(); // Notify UI to rebuild
  }

  void clear() {
    _points.clear();
    notifyListeners(); // Notify UI to clear
  }

  Future<dart_ui.Image> getSignatureImage(Size canvasSize) async {
    final recorder = dart_ui.PictureRecorder();
    final canvas = Canvas(recorder);
    final paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 3.0
      ..strokeCap = StrokeCap.round;

    for (int i = 0; i < _points.length - 1; i++) {
      if (_points[i] != null && _points[i + 1] != null) {
        canvas.drawLine(_points[i]!, _points[i + 1]!, paint);
      }
    }

    final picture = recorder.endRecording();
    final image = await picture.toImage(
      canvasSize.width.toInt(),
      canvasSize.height.toInt(),
    );
    return image;
  }
}
