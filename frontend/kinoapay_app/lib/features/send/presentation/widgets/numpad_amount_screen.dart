import "package:flutter/material.dart";
import "package:intl/intl.dart";
import "package:solar_icons/solar_icons.dart";
import "package:kinoapay_app/core/constants/app_colors.dart";
import "package:kinoapay_app/core/widgets/primary_button.dart";
import "package:kinoapay_app/features/send/domain/send_strings.dart";

/// Pavé numérique pour saisir le montant + bouton de continuation.
class NumpadAmountScreen extends StatelessWidget {
  static final NumberFormat _displayFmt = NumberFormat("#,##0.########", "en_US");
  static const String _zero = "0";
  static const String _dot = ".";

  static const List<List<String>> _keys = [
    ["1", "2", "3"],
    ["4", "5", "6"],
    ["7", "8", "9"],
    [_dot, _zero, SendStrings.backspaceSymbol],
  ];

  final String rawAmount;
  final ValueChanged<String> onKey;
  final VoidCallback onConfirm;

  const NumpadAmountScreen({
    super.key,
    required this.rawAmount,
    required this.onKey,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 8),
        _buildAmountRow(),
        const SizedBox(height: 32),
        ..._buildKeyRows(),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6),
          child: PrimaryButton(
            text: SendStrings.continueBtn,
            onPressed: onConfirm,
          ),
        ),
      ],
    );
  }

  Widget _buildAmountRow() {
    final display = _formatAmount(rawAmount);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      children: [
        Text(
          display,
          style: TextStyle(
            color: rawAmount == _zero
                ? AppColors.quinoaDark.withValues(alpha: 0.25)
                : AppColors.quinoaDark,
            fontSize: 52,
            fontWeight: FontWeight.w900,
            letterSpacing: -1,
          ),
        ),
        const SizedBox(width: 10),
        const Text(
          SendStrings.amountUnit,
          style: TextStyle(
            color: AppColors.textMuted,
            fontSize: 18,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }

  List<Widget> _buildKeyRows() {
    return List.generate(_keys.length, (row) {
      return Row(
        children: List.generate(_keys[row].length, (col) {
          final key = _keys[row][col];
          return Expanded(child: _KeyButton(value: key, onTap: () => onKey(key)));
        }),
      );
    });
  }

  /// Met en forme le montant avec séparateur tout en conservant la décimale en cours.
  String _formatAmount(String raw) {
    if (raw == _zero) return _zero;
    final n = double.tryParse(raw);
    if (n == null) return raw;
    if (raw.endsWith(_dot)) return "${_displayFmt.format(n)}.";
    final parts = raw.split(_dot);
    if (parts.length == 2) {
      return "${_displayFmt.format(n).split(_dot).first}.${parts[1]}";
    }
    return _displayFmt.format(n);
  }
}

class _KeyButton extends StatelessWidget {
  final String value;
  final VoidCallback onTap;

  const _KeyButton({required this.value, required this.onTap});

  bool get _isBackspace => value == SendStrings.backspaceSymbol;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.4,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          margin: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: _isBackspace
                ? AppColors.quinoaDark.withValues(alpha: 0.06)
                : AppColors.white,
            shape: BoxShape.circle,
          ),
          child: Center(child: _isBackspace ? _buildIcon() : _buildLabel()),
        ),
      ),
    );
  }

  Widget _buildIcon() => const Icon(
        SolarIconsOutline.backspace,
        size: 18,
        color: AppColors.quinoaDark,
      );

  Widget _buildLabel() => Text(
        value,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: AppColors.quinoaDark,
        ),
      );
}
