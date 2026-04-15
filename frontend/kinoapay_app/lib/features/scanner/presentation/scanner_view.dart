import "package:flutter/material.dart";
import "package:mobile_scanner/mobile_scanner.dart";
import "package:kinoapay_app/core/constants/app_colors.dart";
import "package:kinoapay_app/features/scanner/domain/entities/scan_result.dart";

/// Vue scanner QR avec caméra réelle via mobile_scanner.
class ScannerView extends StatefulWidget {
  const ScannerView({super.key});

  @override
  State<ScannerView> createState() => _ScannerViewState();
}

class _ScannerViewState extends State<ScannerView> {
  final MobileScannerController _controller = MobileScannerController();
  bool _detected = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onDetect(BarcodeCapture capture) {
    if (_detected) return;

    final barcode = capture.barcodes.firstOrNull;
    final raw = barcode?.rawValue;
    if (raw == null) return;

    _detected = true;
    _controller.stop();

    final result = ScanResult.parse(raw);
    _showResultSheet(result);
  }

  void _showResultSheet(ScanResult result) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => _ScanResultSheet(
        result: result,
        onConfirm: () {
          Navigator.pop(context);
          Navigator.pop(context, result);
        },
        onCancel: () {
          Navigator.pop(context);
          setState(() => _detected = false);
          _controller.start();
        },
      ),
    ).whenComplete(() {
      if (mounted && _detected) {
        setState(() => _detected = false);
        _controller.start();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final topInset = MediaQuery.of(context).padding.top;
    final frameSize = size.width * 0.68;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Flux caméra réel
          MobileScanner(
            controller: _controller,
            onDetect: _onDetect,
          ),

          // Overlay avec découpe centrale
          _ScanOverlay(frameSize: frameSize, screenSize: size),

          // Header
          Positioned(
            top: topInset + 12,
            left: 16,
            right: 16,
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    padding: const EdgeInsets.all(9),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.arrow_back_ios_new_rounded,
                      size: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                const Text(
                  "Scanner un QR",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.4,
                  ),
                ),
                const Spacer(),
                // Bouton torche
                GestureDetector(
                  onTap: () => _controller.toggleTorch(),
                  child: Container(
                    padding: const EdgeInsets.all(9),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.flashlight_on_rounded,
                      size: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Instruction
          Positioned(
            bottom: size.height * 0.20,
            left: 0,
            right: 0,
            child: Column(
              children: [
                Text(
                  "Pointez vers un QR KinoaPay",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.85),
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "ou le KinoaID d'un contact",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.45),
                    fontSize: 12,
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

// ── Overlay avec découpe et coins quinoaRed ───────────────────────────────────

class _ScanOverlay extends StatelessWidget {
  final double frameSize;
  final Size screenSize;
  const _ScanOverlay({required this.frameSize, required this.screenSize});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: screenSize,
      painter: _OverlayPainter(frameSize: frameSize, screenSize: screenSize),
    );
  }
}

class _OverlayPainter extends CustomPainter {
  final double frameSize;
  final Size screenSize;
  const _OverlayPainter({required this.frameSize, required this.screenSize});

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
      ..color = KinoaColors.quinoaRed
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
  bool shouldRepaint(covariant _OverlayPainter old) =>
      old.frameSize != frameSize;
}

// ── Sheet résultat scan ───────────────────────────────────────────────────────

class _ScanResultSheet extends StatelessWidget {
  final ScanResult result;
  final VoidCallback onConfirm;
  final VoidCallback onCancel;

  const _ScanResultSheet({
    required this.result,
    required this.onConfirm,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 40),
      decoration: const BoxDecoration(
        color: KinoaColors.quinoaCream,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 36, height: 4,
            decoration: BoxDecoration(
              color: KinoaColors.quinoaDark.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 24),
          Container(
            width: 56, height: 56,
            decoration: BoxDecoration(
              color: KinoaColors.quinoaRed.withValues(alpha: 0.10),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.qr_code_scanner_rounded,
              size: 28,
              color: KinoaColors.quinoaRed,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            _title(),
            style: const TextStyle(
              color: KinoaColors.quinoaDark,
              fontSize: 18,
              fontWeight: FontWeight.w900,
              letterSpacing: -0.4,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            _subtitle(),
            textAlign: TextAlign.center,
            style: TextStyle(
              color: KinoaColors.quinoaDark.withValues(alpha: 0.5),
              fontSize: 13,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 28),
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: onCancel,
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    decoration: BoxDecoration(
                      color: KinoaColors.quinoaDark.withValues(alpha: 0.06),
                      borderRadius: BorderRadius.circular(100),
                    ),
                    alignment: Alignment.center,
                    child: const Text(
                      "Annuler",
                      style: TextStyle(
                        color: KinoaColors.quinoaDark,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: GestureDetector(
                  onTap: onConfirm,
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    decoration: BoxDecoration(
                      color: KinoaColors.quinoaDark,
                      borderRadius: BorderRadius.circular(100),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      _actionLabel(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _title() => switch (result.type) {
        ScanResultType.kinoaId => "KinoaID détecté",
        ScanResultType.paymentRequest => "Demande de paiement",
        ScanResultType.unknown => "QR non reconnu",
      };

  String _subtitle() => switch (result.type) {
        ScanResultType.kinoaId =>
          "Envoyer de l'argent à ${result.kinoaId ?? result.raw}",
        ScanResultType.paymentRequest =>
          "Payer ${result.amount?.toStringAsFixed(0) ?? "?"} ${result.currency ?? "XAF"} à ${result.kinoaId ?? ""}",
        ScanResultType.unknown =>
          "Ce QR code n'est pas reconnu par KinoaPay.",
      };

  String _actionLabel() => switch (result.type) {
        ScanResultType.kinoaId => "Envoyer",
        ScanResultType.paymentRequest => "Payer",
        ScanResultType.unknown => "OK",
      };
}
