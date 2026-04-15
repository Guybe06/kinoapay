import "package:flutter/material.dart";
import "package:mobile_scanner/mobile_scanner.dart";
import "package:kinoapay_app/features/scanner/domain/entities/scan_result.dart";
import "package:kinoapay_app/features/scanner/presentation/scanner_overlay.dart";
import "package:kinoapay_app/features/scanner/presentation/scanner_result_sheet.dart";

/// Écran caméra + cadre de scan ; renvoie un [ScanResult] au pop si confirmé.
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
      builder: (_) => ScannerResultBottomSheet(
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
          MobileScanner(
            controller: _controller,
            onDetect: _onDetect,
          ),
          ScannerViewfinderOverlay(frameSize: frameSize, screenSize: size),
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
          Positioned(
            bottom: size.height * 0.20,
            left: 0,
            right: 0,
            child: Column(
              children: [
                Text(
                  "Pointez vers un QR kinoaPay",
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
