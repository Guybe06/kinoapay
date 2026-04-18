import "dart:math" as math;

import "package:flutter/material.dart";
import "package:kinoapay_app/core/constants/app_colors.dart";
import "package:kinoapay_app/features/send/domain/entities/recipient_match.dart";
import "package:kinoapay_app/features/send/domain/send_strings.dart";
import "package:kinoapay_app/features/send/presentation/widgets/recipients_results_list.dart";

/// Vue recherche par identifiant KinoaPay (@ID).
/// Le préfixe @ est affiché en dur dans l'input — l'utilisateur ne saisit que l'ID.
/// Recherche déclenchée à partir de 3 caractères saisis.
class RecipientByIdView extends StatelessWidget {
  static const int minIdChars = 3;

  final TextEditingController controller;
  final FocusNode focusNode;
  final ValueChanged<String> onChanged;
  final bool isLoading;
  final List<RecipientMatch> results;
  final ValueChanged<RecipientMatch> onSelect;

  const RecipientByIdView({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.onChanged,
    required this.isLoading,
    required this.results,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildInputRow(),
        if (results.isNotEmpty) ...[
          const SizedBox(height: 16),
          RecipientsResultsList(recipients: results, onSelect: onSelect),
        ],
      ],
    );
  }

  Widget _buildInputRow() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.quinoaDark.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          const Text(
            SendStrings.idPrefix,
            style: TextStyle(
              color: AppColors.quinoaDark,
              fontWeight: FontWeight.w900,
              fontSize: 16,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              controller: controller,
              focusNode: focusNode,
              onChanged: onChanged,
              textInputAction: TextInputAction.done,
              keyboardType: TextInputType.text,
              style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
              decoration: InputDecoration(
                hintText: SendStrings.idHint,
                hintStyle: TextStyle(
                  color: AppColors.quinoaDark.withValues(alpha: 0.3),
                  fontWeight: FontWeight.w500,
                ),
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
                suffixIcon: isLoading ? _buildLoadingIndicator() : null,
                suffixIconConstraints: const BoxConstraints(
                  minWidth: 16,
                  minHeight: 16,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return const Padding(
      padding: EdgeInsets.only(right: 4),
      child: _SpinningSearchIcon(),
    );
  }
}

/// Demi-cercle qui tourne en continu pour signaler une recherche en cours.
class _SpinningSearchIcon extends StatefulWidget {
  const _SpinningSearchIcon();

  @override
  State<_SpinningSearchIcon> createState() => _SpinningSearchIconState();
}

class _SpinningSearchIconState extends State<_SpinningSearchIcon>
    with SingleTickerProviderStateMixin {
  static const Duration _rotationDuration = Duration(milliseconds: 900);
  static const double _iconSize = 14;
  static const double _strokeWidth = 1.6;

  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: _rotationDuration,
  )..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RotationTransition(
      turns: _controller,
      child: CustomPaint(
        size: const Size.square(_iconSize),
        painter: _HalfCircleArcPainter(
          color: AppColors.quinoaDark.withValues(alpha: 0.65),
          strokeWidth: _strokeWidth,
        ),
      ),
    );
  }
}

class _HalfCircleArcPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;

  const _HalfCircleArcPainter({required this.color, required this.strokeWidth});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    final rect = Rect.fromLTWH(
      strokeWidth / 2,
      strokeWidth / 2,
      size.width - strokeWidth,
      size.height - strokeWidth,
    );
    canvas.drawArc(rect, -math.pi / 2, math.pi, false, paint);
  }

  @override
  bool shouldRepaint(covariant _HalfCircleArcPainter old) =>
      old.color != color || old.strokeWidth != strokeWidth;
}
