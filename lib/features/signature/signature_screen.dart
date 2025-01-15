// UI for capturing signatures

import 'package:flutter/material.dart';
import 'signature_controller.dart';

class CreateSignature extends StatefulWidget {
  @override
  _CreateSignatureState createState() => _CreateSignatureState();
}

class _CreateSignatureState extends State<CreateSignature> {
  final SignatureController _signatureController = SignatureController(); // Instance of the controller

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
                    child: Container(color: Colors.white),
                  );
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
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
                    // Do something with the image (e.g., save or share)
                  },
                  child: Text('Save'),
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

