import "package:flutter/material.dart";
import "package:kinoapay_app/core/constants/app_colors.dart";

/// Boîte squelette animée utilisée comme placeholder de chargement.
/// L'opacité pulse entre [_minOpacity] et [_maxOpacity] en boucle.
class SkeletonBox extends StatefulWidget {
  final double width;
  final double height;
  final double borderRadius;
  final Color? color;

  const SkeletonBox({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius = 8,
    this.color,
  });

  @override
  State<SkeletonBox> createState() => _SkeletonBoxState();
}

class _SkeletonBoxState extends State<SkeletonBox>
    with SingleTickerProviderStateMixin {
  static const double _minOpacity = 0.5;
  static const double _maxOpacity = 1.0;
  static const Duration _duration = Duration(milliseconds: 900);

  late final AnimationController _ctrl;
  late final Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: _duration)
      ..repeat(reverse: true);
    _anim = Tween<double>(
      begin: _minOpacity,
      end: _maxOpacity,
    ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final baseColor =
        widget.color ?? AppColors.quinoaDark.withValues(alpha: 0.08);

    return FadeTransition(
      opacity: _anim,
      child: Container(
        width: widget.width,
        height: widget.height,
        decoration: BoxDecoration(
          color: baseColor,
          borderRadius: BorderRadius.circular(widget.borderRadius),
        ),
      ),
    );
  }
}
