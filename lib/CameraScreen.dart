import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter/services.dart';

class CameraScreen extends StatefulWidget {
  final CameraController cameraController;

  CameraScreen({required this.cameraController});

  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  final Map<String, List<Offset>> loc = {
    '화료 패': [
      Offset(1, 0),
      Offset(100, 0),
      Offset(100, 100),
      Offset(1, 100),
    ],
    '도라': [
      Offset(100, 0),
      Offset(600, 0),
      Offset(600, 100),
      Offset(100, 100),
    ],
    '손패': [
      Offset(1, 100),
      Offset(600, 100),
      Offset(600, 200),
      Offset(1, 200),
    ],
    '후로': [
      Offset(1, 200),
      Offset(600, 200),
      Offset(600, 300),
      Offset(1, 300),
    ],
  };

  @override
  void initState() {
    super.initState();
    // 화면이 가로로 고정되도록 설정
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

  @override
  void dispose() {
    // 화면 방향 설정 초기화
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: CameraPreview(widget.cameraController),
          ),
          ...loc.entries.map((entry) => CustomPaint(
            painter: LinePainter(entry.value, entry.key),
            child: Container(),
          )),
          Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: FloatingActionButton(
                onPressed: () async {
                  try {
                    XFile imageFile = await widget.cameraController.takePicture();
                    Navigator.pop(context, imageFile);
                  } catch (e) {
                    print(e);
                  }
                },
                child: Icon(Icons.camera_alt),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class LinePainter extends CustomPainter {
  final List<Offset> points;
  final String label;

  LinePainter(this.points, this.label);

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.red
      ..strokeWidth = 4.0
      ..strokeCap = StrokeCap.round;

    // 원본 좌표를 화면 크기에 맞게 변환하여 그립니다.
    List<Offset> scaledPoints = points.map((point) {
      return Offset(point.dx * size.width / 600, point.dy * size.height / 300);
    }).toList();

    for (int i = 0; i < scaledPoints.length - 1; i++) {
      if (scaledPoints[i] != Offset.zero && scaledPoints[i + 1] != Offset.zero) {
        canvas.drawLine(scaledPoints[i], scaledPoints[i + 1], paint);
      }
    }

    // 텍스트 그리기
    if (scaledPoints.isNotEmpty) {
      final textPainter = TextPainter(
        text: TextSpan(
          text: label,
          style: TextStyle(
            color: Colors.cyanAccent,
            fontSize: 20,
            backgroundColor: Colors.black.withOpacity(0),
          ),
        ),
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();

      // 첫 번째 좌표의 중앙에 텍스트를 배치합니다.
      Offset textOffset = Offset(scaledPoints[0].dx + 5, scaledPoints[0].dy + 5);
      textPainter.paint(canvas, textOffset);
    }
  }

  @override
  bool shouldRepaint(LinePainter oldDelegate) {
    return oldDelegate.points != points || oldDelegate.label != label;
  }
}