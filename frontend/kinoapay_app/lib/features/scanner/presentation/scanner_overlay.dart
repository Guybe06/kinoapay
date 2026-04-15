import "package:flutter/material.dart";
import "package:kinoapay_app/core/constants/app_colors.dart";

/// Assombrissement plein écran avec fenêtre de scan au centre et coins marqués.
class ScannerViewfinderOverlay extends StatelessWidget {
  final double frameSize;
  final Size screenSize;

  const ScannerViewfinderOverlay({
    super.key,
    required this.frameSize,
    required this.screenSize,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: screenSize,
      painter: ScannerViewfinderPainter(frameSize: frameSize, screenSize: screenSize),
    );
  }
}

class ScannerViewfinderPainter extends CustomPainter {
  final double frameSize;
  final Size screenSize;

  const ScannerViewfinderPainter({required this.frameSize, required this.screenSize});

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    final half = frameSize / 2;
    const r = 16.0;

    final bgPaint = Paint()..color = Colors.black.withValues(alpha: 0.70);
    final fullRect = Rect.fromLTWH(0, 0, size.width, size.height);
    final frameRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(cx - half, cy - half, frameSize, frameSize),
      const Radius.circular(r),
    );
    final path = Path()
      ..addRect(fullRect)
      ..addRRect(frameRect)
      ..fillType = PathFillType.evenOdd;
    canvas.drawPath(path, bgPaint);

    final cornerPaint = Paint()
      ..color = AppColors.quinoaRed
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;

    const len = 24.0;
    final x0 = cx - half;
    final y0 = cy - half;
    final x1 = cx + half;
    final y1 = cy + half;

    canvas.drawLine(Offset(x0, y0 + len), Offset(x0, y0 + r), cornerPaint);
    canvas.drawArc(Rect.fromLTWH(x0, y0, r * 2, r * 2), 3.14, -1.57, false, cornerPaint);
    canvas.drawLine(Offset(x0 + r, y0), Offset(x0 + len, y0), cornerPaint);

    canvas.drawLine(Offset(x1 - len, y0), Offset(x1 - r, y0), cornerPaint);
    canvas.drawArc(Rect.fromLTWH(x1 - r * 2, y0, r * 2, r * 2), -1.57, -1.57, false, cornerPaint);
    canvas.drawLine(Offset(x1, y0 + r), Offset(x1, y0 + len), cornerPaint);

    canvas.drawLine(Offset(x1, y1 - len), Offset(x1, y1 - r), cornerPaint);
    canvas.drawArc(Rect.fromLTWH(x1 - r * 2, y1 - r * 2, r * 2, r * 2), 0, 1.57, false, cornerPaint);
    canvas.drawLine(Offset(x1 - r, y1), Offset(x1 - len, y1), cornerPaint);

    canvas.drawLine(Offset(x0 + len, y1), Offset(x0 + r, y1), cornerPaint);
    canvas.drawArc(Rect.fromLTWH(x0, y1 - r * 2, r * 2, r * 2), 1.57, 1.57, false, cornerPaint);
    canvas.drawLine(Offset(x0, y1 - r), Offset(x0, y1 - len), cornerPaint);
  }

  @override
  bool shouldRepaint(covariant ScannerViewfinderPainter old) =>
      old.frameSize != frameSize || old.screenSize != screenSize;
}
