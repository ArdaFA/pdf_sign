// UI for capturing signatures

import 'dart:io';
import 'dart:ui' as dart_ui;
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'signature_controller.dart';

class CreateSignature extends StatefulWidget {
  @override
  _CreateSignatureState createState() => _CreateSignatureState();
}

class _CreateSignatureState extends State<CreateSignature> {
  final SignatureController _signatureController = SignatureController(); // Instance of the controller


  Future<String> saveSignatureAsPNG(dart_ui.Image image) async {
    final byteData = await image.toByteData(format: dart_ui.ImageByteFormat.png);
    final buffer = byteData!.buffer.asUint8List();

    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/signature.png');
    await file.writeAsBytes(buffer);

    return file.path; // Return the path to the saved file
  }
  @override
  void dispose() {
    _signatureController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Create Signature')),
      body: Column(
        children: [
          Expanded(
            child: GestureDetector(
              onPanUpdate: (details) {
                // Capture touch movements and update the controller
                final RenderBox renderBox = context.findRenderObject() as RenderBox;
                final localPosition = renderBox.globalToLocal(details.localPosition);
                _signatureController.addPoint(localPosition);
              },
              onPanEnd: (_) {
                // Add a null point to indicate the end of a line segment
                _signatureController.addPoint(null);
              },
              child: AnimatedBuilder(
                animation: _signatureController,
                builder: (context, child) {
                  return CustomPaint(
                    painter: SignaturePainter(_signatureController.points),
                    child: Container(color: Colors.transparent), // Has to be transparent, otherwise it comes over and blocks the signature
                  );
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Row(mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        // how to use this generated signature?
                        /*
                        *  1. Save like normal
                        *  2. reach the sign via path
                        *  3. paste it on the current pdf file
                        *
                        * */
                      },
                      child: Text('Use this Signature'),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 110.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          _signatureController.clear();
                        },
                        child: Text('Clear'),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          final canvasSize = MediaQuery.of(context).size;
                          final image = await _signatureController.getSignatureImage(canvasSize);

                          // Save the image as PNG
                          final filePath = await saveSignatureAsPNG(image);

                          // Optionally, you can show a dialog or confirmation
                          showDialog(
                            context: context,
                            builder: (_) => AlertDialog(
                              title: Text('Signature Saved'),
                              content: Text('Signature saved to $filePath'),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text('OK'),
                                ),
                              ],
                            ),
                          );
                        },
                        child: Text('Save'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class SignaturePainter extends CustomPainter {
  final List<Offset?> points;

  SignaturePainter(this.points);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 3.0
      ..strokeCap = StrokeCap.round;

    for (int i = 0; i < points.length - 1; i++) {
      if (points[i] != null && points[i + 1] != null) {
        canvas.drawLine(points[i]!, points[i + 1]!, paint);
      }
    }
  }

  @override
  bool shouldRepaint(SignaturePainter oldDelegate) => true;
}

