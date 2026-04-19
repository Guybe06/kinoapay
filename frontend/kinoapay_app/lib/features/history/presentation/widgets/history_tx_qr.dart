import "dart:math" as math;
import "package:flutter/material.dart";
import "package:kinoapay_app/core/constants/app_colors.dart";

/// Peintre QR décoratif généré de façon déterministe depuis [seed].
class HistoryTxQr extends StatelessWidget {
  final String seed;

  const HistoryTxQr({super.key, required this.seed});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _QrPainter(seed: seed),
      size: const Size(160, 160),
    );
  }
}

class _QrPainter extends CustomPainter {
  final String seed;

  const _QrPainter({required this.seed});

  static const int _size = 21;
  static const int _quietZone = 2;
  static const int _total = _size + _quietZone * 2;

  @override
  void paint(Canvas canvas, Size size) {
    final cell = size.width / _total;
    final rng = _lcg(seed.codeUnits.fold(0, (a, b) => a ^ (b * 31 + a)));
    final grid = _buildGrid(rng);

    final bgPaint = Paint()..color = Colors.white;
    canvas.drawRRect(
      RRect.fromRectAndRadius(Offset.zero & size, const Radius.circular(12)),
      bgPaint,
    );

    final darkPaint = Paint()..color = AppColors.quinoaDark;

    for (var r = 0; r < _size; r++) {
      for (var c = 0; c < _size; c++) {
        if (!grid[r][c]) continue;
        final x = (c + _quietZone) * cell;
        final y = (r + _quietZone) * cell;
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            Rect.fromLTWH(x + 0.5, y + 0.5, cell - 1, cell - 1),
            Radius.circular(cell * 0.18),
          ),
          darkPaint,
        );
      }
    }
  }

  List<List<bool>> _buildGrid(int Function() rng) {
    final g = List.generate(_size, (_) => List.filled(_size, false));

    _finder(g, 0, 0);
    _finder(g, 0, _size - 7);
    _finder(g, _size - 7, 0);

    for (var i = 0; i < _size; i++) {
      if (i < 6 || i > _size - 7 - 2) continue;
      final v = i.isEven;
      g[6][i] = v;
      g[i][6] = v;
    }

    for (var r = 0; r < _size; r++) {
      for (var c = 0; c < _size; c++) {
        if (_isReserved(r, c)) continue;
        g[r][c] = rng() % 2 == 0;
      }
    }
    return g;
  }

  void _finder(List<List<bool>> g, int row, int col) {
    for (var r = 0; r < 7; r++) {
      for (var c = 0; c < 7; c++) {
        final onEdge = r == 0 || r == 6 || c == 0 || c == 6;
        final onInner = r >= 2 && r <= 4 && c >= 2 && c <= 4;
        g[row + r][col + c] = onEdge || onInner;
      }
    }
  }

  bool _isReserved(int r, int c) {
    if (r < 9 && c < 9) return true;
    if (r < 9 && c >= _size - 8) return true;
    if (r >= _size - 8 && c < 9) return true;
    if (r == 6 || c == 6) return true;
    return false;
  }

  int Function() _lcg(int seed) {
    int state = seed.abs() + 1;
    return () {
      state = (state * 1664525 + 1013904223) & 0xFFFFFFFF;
      return state;
    };
  }

  @override
  bool shouldRepaint(covariant _QrPainter old) => old.seed != seed;
}

/// Arc décoratif de coin de la fiche QR (lignes d'angle dorées).
class HistoryQrCornerAccent extends StatelessWidget {
  const HistoryQrCornerAccent({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _CornerPainter(),
      size: const Size(20, 20),
    );
  }
}

class _CornerPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.quinoaGold
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromLTWH(0, 0, size.width, size.height),
      math.pi,
      math.pi / 2,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter old) => false;
}
