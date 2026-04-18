import "dart:math" as math;

import "package:flutter/material.dart";
import "package:solar_icons/solar_icons.dart";
import "package:kinoapay_app/core/constants/app_colors.dart";
import "package:kinoapay_app/features/send/domain/send_strings.dart";
import "package:kinoapay_app/features/send/presentation/widgets/phone_search_formatter.dart";

/// Champ de recherche du destinataire : saisie + indicateur de chargement + nom résolu.
class RecipientSearchField extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onClear;
  final bool isLoading;
  final String? resolvedName;
  final bool enabled;

  const RecipientSearchField({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.isLoading,
    this.onChanged,
    this.onClear,
    this.resolvedName,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTextField(),
          if (resolvedName != null) _buildResolvedRow(),
        ],
      ),
    );
  }

  Widget _buildTextField() {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: controller,
            focusNode: focusNode,
            enabled: enabled,
            onChanged: onChanged,
            textInputAction: TextInputAction.done,
            keyboardType: TextInputType.phone,
            inputFormatters: [PhoneSearchFormatter()],
            style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
            decoration: InputDecoration(
              hintText: SendStrings.recipientHint,
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
    );
  }

  Widget _buildLoadingIndicator() {
    return const Padding(
      padding: EdgeInsets.only(right: 4),
      child: _SpinningSearchIcon(),
    );
  }

  Widget _buildResolvedRow() {
    return Column(
      children: [
        const SizedBox(height: 12),
        const Divider(height: 1),
        const SizedBox(height: 12),
        Row(
          children: [
            const Icon(
              SolarIconsOutline.checkCircle,
              color: AppColors.success,
              size: 16,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                resolvedName!,
                style: const TextStyle(
                  color: AppColors.success,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            GestureDetector(
              onTap: onClear,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: AppColors.quinoaDark.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  SendStrings.modifyBtn,
                  style: TextStyle(
                    color: AppColors.quinoaDark,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
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

/// Peint un arc de 180° (demi-cercle) centré dans la zone disponible.
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
