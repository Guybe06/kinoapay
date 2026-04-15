import "package:flutter/material.dart";
import "package:kinoapay_app/core/navigation/route_observer.dart";

/// Animation d'entrée staggerée : chaque élément « tombe » en place avec un léger décalage.
/// Rejoue automatiquement quand l'utilisateur revient sur la page (pop).
class StaggeredEntrance extends StatefulWidget {
  final Widget child;
  final int index;
  final Duration baseDelay;
  final Duration duration;
  final double offsetY;

  const StaggeredEntrance({
    super.key,
    required this.child,
    this.index = 0,
    this.baseDelay = const Duration(milliseconds: 60),
    this.duration = const Duration(milliseconds: 500),
    this.offsetY = 24,
  });

  @override
  State<StaggeredEntrance> createState() => _StaggeredEntranceState();
}

class _StaggeredEntranceState extends State<StaggeredEntrance>
    with SingleTickerProviderStateMixin, RouteAware {
  late final AnimationController _controller;
  late final Animation<double> _opacity;
  late final Animation<Offset> _slide;
  bool _skipFade = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);

    _opacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.35, curve: Curves.easeOut),
      ),
    );

    _slide = Tween<Offset>(begin: Offset(0, widget.offsetY), end: Offset.zero)
        .animate(
          CurvedAnimation(parent: _controller, curve: const _CustomDropCurve()),
        );

    _playAfterDelay();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final route = ModalRoute.of(context);
    if (route is ModalRoute<void>) {
      appRouteObserver.subscribe(this, route);
    }
  }

  @override
  void dispose() {
    appRouteObserver.unsubscribe(this);
    _controller.dispose();
    super.dispose();
  }

  /// Au retour (pop) : rejoue le slide staggeré sans fade car la page est déjà visible.
  /// @return void
  @override
  void didPopNext() {
    _skipFade = true;
    _controller.reset();
    _playAfterDelay();
  }

  void _playAfterDelay() {
    Future.delayed(widget.baseDelay * widget.index, () {
      if (mounted) _controller.forward();
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (_, child) => Opacity(
        opacity: _skipFade ? 1.0 : _opacity.value,
        child: Transform.translate(offset: _slide.value, child: child),
      ),
      child: widget.child,
    );
  }
}

/// Cubic bézier (0.16, 1, 0.3, 1) : départ rapide, décélération longue et douce.
class _CustomDropCurve extends Curve {
  const _CustomDropCurve();

  @override
  double transformInternal(double t) {
    return Cubic(0.16, 1, 0.3, 1).transformInternal(t);
  }
}
