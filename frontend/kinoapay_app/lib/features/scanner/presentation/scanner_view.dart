import "package:flutter/material.dart";
import "package:mobile_scanner/mobile_scanner.dart";
import "package:kinoapay_app/core/constants/app_colors.dart";
import "package:kinoapay_app/core/helpers/screen_size_helper.dart";
import "package:kinoapay_app/core/widgets/app_snack_bar.dart";
import "package:kinoapay_app/features/scanner/domain/entities/scan_result.dart";
import "package:kinoapay_app/features/scanner/domain/scanner_strings.dart";
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

  /// Ouvre un bottom sheet avec un champ texte pour saisir un lien manuellement.
  void _showLinkInput() {
    final ctrl = TextEditingController();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        final compact = ScreenSizeHelper.isSmallOrLess(ctx);
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(ctx).viewInsets.bottom,
          ),
          child: Container(
            padding: EdgeInsets.fromLTRB(
              24,
              compact ? 16 : 20,
              24,
              ScreenSizeHelper.adaptiveValue(
                ctx,
                compact: 24,
                small: 28,
                medium: 32,
                large: 36,
              ),
            ),
            decoration: const BoxDecoration(
              color: AppColors.quinoaCream,
              borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 36,
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppColors.quinoaDark.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                SizedBox(height: compact ? 16 : 20),
              TextField(
                controller: ctrl,
                autofocus: true,
                keyboardType: TextInputType.url,
                style: const TextStyle(
                  color: AppColors.quinoaDark,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
                cursorColor: AppColors.quinoaGold,
                decoration: InputDecoration(
                  hintText: ScannerStrings.linkFallbackHint,
                  hintStyle: TextStyle(
                    color: AppColors.quinoaDark.withValues(alpha: 0.30),
                    fontSize: 14,
                  ),
                  filled: true,
                  fillColor: AppColors.quinoaDark.withValues(alpha: 0.05),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: GestureDetector(
                  onTap: () {
                    final raw = ctrl.text.trim();
                    final result = ScanResult.parse(raw);
                    if (result.type == ScanResultType.unknown) {
                      AppSnackBar.showInfo(
                        ctx,
                        ScannerStrings.linkFallbackError,
                      );
                      return;
                    }
                    Navigator.pop(ctx);
                    _showResultSheet(result);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      color: AppColors.quinoaDark,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    alignment: Alignment.center,
                    child: const Text(
                      ScannerStrings.linkFallbackOpen,
                      style: TextStyle(
                        color: AppColors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
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
          MobileScanner(controller: _controller, onDetect: _onDetect),
          ScannerViewfinderOverlay(frameSize: frameSize, screenSize: size),
          _ScanLine(frameSize: frameSize, screenSize: size),
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
                  ScannerStrings.title,
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
            top: (size.height + frameSize) / 2 + 24,
            left: 0,
            right: 0,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.10),
                    borderRadius: BorderRadius.circular(100),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.15),
                      width: 0.5,
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        ScannerStrings.hintLine1,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.85),
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        ScannerStrings.hintLine2,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.45),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: _showLinkInput,
                  child: Text(
                    ScannerStrings.linkFallbackBtn,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.45),
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      decoration: TextDecoration.underline,
                      decorationColor: Colors.white.withValues(alpha: 0.25),
                    ),
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

/// Ligne de scan animée qui se déplace verticalement dans le cadre du viewfinder.
class _ScanLine extends StatefulWidget {
  final double frameSize;
  final Size screenSize;

  const _ScanLine({required this.frameSize, required this.screenSize});

  @override
  State<_ScanLine> createState() => _ScanLineState();
}

class _ScanLineState extends State<_ScanLine>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _pos;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat(reverse: true);
    _pos = CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cx = widget.screenSize.width / 2;
    final cy = widget.screenSize.height / 2;
    final half = widget.frameSize / 2;
    final frameTop = cy - half;
    final frameLeft = cx - half;

    return AnimatedBuilder(
      animation: _pos,
      builder: (_, __) => Positioned(
        top: frameTop + 8 + (_pos.value * (widget.frameSize - 16)),
        left: frameLeft + 12,
        right: widget.screenSize.width - frameLeft - widget.frameSize + 12,
        height: 2,
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors.quinoaRed.withValues(alpha: 0),
                AppColors.quinoaRed.withValues(alpha: 0.85),
                AppColors.quinoaRed.withValues(alpha: 0),
              ],
            ),
            borderRadius: BorderRadius.circular(1),
          ),
        ),
      ),
    );
  }
}
