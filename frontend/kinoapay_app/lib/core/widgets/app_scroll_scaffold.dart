import "package:flutter/material.dart";
import "package:kinoapay_app/core/constants/app_colors.dart";

/// Scaffold partagé pour toutes les pages avec header scroll-hide.
///
/// Gère automatiquement : [ScrollController], animation d'opacité du
/// [header] flottant, et détection de fin de liste pour la pagination.
/// Le [builder] reçoit le [ScrollController] à lier au défilement.
class AppScrollScaffold extends StatefulWidget {
  /// Header flottant positionné en haut : disparaît au scroll vers le bas,
  /// réapparaît en remontant ou au retour au sommet.
  final Widget header;

  /// Constructeur du corps de la page.
  /// Reçoit le [ScrollController] géré par ce scaffold.
  final Widget Function(BuildContext context, ScrollController ctrl) builder;

  /// Couleur de fond du scaffold.
  final Color backgroundColor;

  /// Rappelé quand le scroll approche de la fin (pagination infinie).
  final VoidCallback? onNearBottom;

  /// Seuil en pixels avant la fin pour déclencher [onNearBottom].
  final double nearBottomThreshold;

  const AppScrollScaffold({
    super.key,
    required this.header,
    required this.builder,
    this.backgroundColor = AppColors.quinoaCream,
    this.onNearBottom,
    this.nearBottomThreshold = 200,
  });

  @override
  State<AppScrollScaffold> createState() => _AppScrollScaffoldState();
}

class _AppScrollScaffoldState extends State<AppScrollScaffold> {
  final _ctrl = ScrollController();
  bool _headerVisible = true;
  double _lastOffset = 0;

  @override
  void initState() {
    super.initState();
    _ctrl.addListener(_onScroll);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _onScroll() {
    final offset = _ctrl.offset;

    if (offset <= 0) {
      if (!_headerVisible) setState(() => _headerVisible = true);
      _lastOffset = offset;
      return;
    }

    final delta = offset - _lastOffset;
    _lastOffset = offset;

    if (delta > 4 && _headerVisible) {
      setState(() => _headerVisible = false);
    } else if (delta < -4 && !_headerVisible) {
      setState(() => _headerVisible = true);
    }

    if (widget.onNearBottom != null) {
      final pos = _ctrl.position;
      if (pos.pixels >= pos.maxScrollExtent - widget.nearBottomThreshold) {
        widget.onNearBottom!();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.backgroundColor,
      body: Stack(
        clipBehavior: Clip.hardEdge,
        children: [
          SafeArea(child: widget.builder(context, _ctrl)),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            // AnimatedOpacity : la taille du header reste constante, seule
            // l'opacité change — aucun saut de layout lors de la transition.
            child: IgnorePointer(
              ignoring: !_headerVisible,
              child: AnimatedOpacity(
                opacity: _headerVisible ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 180),
                child: widget.header,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
