import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:kinoapay_app/core/constants/kinoa_colors.dart";

/// Widget réutilisable : rangée de N cases OTP avec navigation clavier automatique.
class KinoaOtpInput extends StatefulWidget {
  final int length;
  final bool hasError;
  final ValueChanged<String> onCompleted;

  const KinoaOtpInput({
    super.key,
    this.length = 6,
    this.hasError = false,
    required this.onCompleted,
  });

  @override
  State<KinoaOtpInput> createState() => KinoaOtpInputState();
}

class KinoaOtpInputState extends State<KinoaOtpInput> {
  late final List<TextEditingController> _ctrls;
  late final List<FocusNode> _nodes;

  String get code => _ctrls.map((c) => c.text).join();

  @override
  void initState() {
    super.initState();
    _ctrls = List.generate(widget.length, (_) => TextEditingController());
    _nodes = List.generate(widget.length, (_) => FocusNode());
  }

  @override
  void dispose() {
    for (final c in _ctrls) { c.dispose(); }
    for (final n in _nodes) { n.dispose(); }
    super.dispose();
  }

  /// Vide toutes les cases et remet le focus sur la première.
  void clear() {
    for (final c in _ctrls) { c.clear(); }
    if (mounted) _nodes[0].requestFocus();
  }

  void _onChanged(int i, String v) {
    if (v.isEmpty) return;
    if (i < widget.length - 1) {
      _nodes[i + 1].requestFocus();
    } else {
      _nodes[i].unfocus();
      widget.onCompleted(code);
    }
  }

  void _onKeyEvent(int i, KeyEvent event) {
    if (event is KeyDownEvent &&
        event.logicalKey == LogicalKeyboardKey.backspace &&
        _ctrls[i].text.isEmpty &&
        i > 0) {
      _ctrls[i - 1].clear();
      _nodes[i - 1].requestFocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(widget.length, _buildBox),
    );
  }

  Widget _buildBox(int i) {
    final err = widget.hasError;
    return KeyboardListener(
      focusNode: FocusNode(),
      onKeyEvent: (e) => _onKeyEvent(i, e),
      child: SizedBox(
        width: 48,
        height: 60,
        child: TextFormField(
          controller: _ctrls[i],
          focusNode: _nodes[i],
          textAlign: TextAlign.center,
          keyboardType: TextInputType.number,
          maxLength: 1,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          onChanged: (v) => _onChanged(i, v),
          style: TextStyle(color: err ? KinoaColors.quinoaRed : KinoaColors.quinoaDark, fontSize: 22, fontWeight: FontWeight.w800),
          cursorColor: KinoaColors.quinoaGold,
          decoration: InputDecoration(
            counterText: "",
            filled: true,
            fillColor: err ? KinoaColors.quinoaRed.withValues(alpha: 0.06) : KinoaColors.white,
            contentPadding: EdgeInsets.zero,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(color: err ? KinoaColors.quinoaRed.withValues(alpha: 0.4) : KinoaColors.quinoaDark.withValues(alpha: 0.15), width: 1.5),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: KinoaColors.quinoaGold, width: 2),
            ),
          ),
        ),
      ),
    );
  }
}
