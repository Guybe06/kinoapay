import "dart:async";
import "package:flutter/material.dart";
import "package:kinoapay_app/core/constants/app_colors.dart";
import "package:kinoapay_app/core/constants/app_routes.dart";
import "package:kinoapay_app/core/navigation/app_router.dart";
import "package:kinoapay_app/core/navigation/app_shell.dart";
import "package:kinoapay_app/core/storage/secure_storage_service.dart";
import "package:kinoapay_app/core/widgets/brand_logo_row.dart";
import "package:kinoapay_app/features/splash/application/splash_connectivity_service.dart";
import "package:kinoapay_app/features/splash/presentation/widgets/splash_status_bar.dart";

/// Écran de démarrage : anime le logo, vérifie la connexion puis redirige ou affiche une erreur réseau.
class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scaleAnim;
  late final Animation<double> _fadeAnim;

  final _connectivity = const SplashConnectivityService();

  bool _isChecking = false;
  bool _isOffline = false;
  bool _isBackOnline = false;

  Timer? _retryTimer;
  bool _autoCheckInProgress = false;

  static const Duration _animDuration = Duration(milliseconds: 900);
  static const Duration _redirectDelay = Duration(milliseconds: 300);
  static const Duration _minCheckDuration = Duration(seconds: 2);
  static const Duration _retryInterval = Duration(seconds: 3);
  static const Duration _backOnlineDelay = Duration(milliseconds: 1500);
  static const Duration _preRedirectDelay = Duration(milliseconds: 220);

  @override
  void initState() {
    super.initState();
    _initAnimations();
    _startSequence();
  }

  /// Initialise les animations de scale et fondu du logo.
  void _initAnimations() {
    _controller = AnimationController(vsync: this, duration: _animDuration);
    _scaleAnim = Tween<double>(begin: 0.7, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );
    _fadeAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.6, curve: Curves.easeIn),
      ),
    );
  }

  /// Lance l'animation du logo puis démarre la vérification internet.
  Future<void> _startSequence() async {
    await _controller.forward();
    await Future.delayed(_redirectDelay);
    if (mounted) _beginCheck();
  }

  /// Passe en état "vérification" et lance le check réseau principal.
  void _beginCheck() {
    _retryTimer?.cancel();
    setState(() {
      _isChecking = true;
      _isOffline = false;
      _isBackOnline = false;
    });
    _checkAndRedirect();
  }

  /// Vérifie la connexion puis redirige ou bascule en état hors-ligne avec détection automatique.
  /// Attend au minimum [_minCheckDuration] avant de répondre pour éviter un flash trop rapide.
  Future<void> _checkAndRedirect() async {
    final results = await Future.wait([
      _connectivity.hasInternet(),
      Future.delayed(_minCheckDuration),
    ]);
    final connected = results[0] as bool;

    if (!mounted) return;

    if (connected) {
      setState(() => _isChecking = false);
      await Future.delayed(_preRedirectDelay);
      if (!mounted) return;
      await _redirect();
    } else {
      setState(() {
        _isChecking = false;
        _isOffline = true;
      });
      _startAutoRetry();
    }
  }

  /// Démarre une vérification silencieuse périodique en arrière-plan.
  /// Le garde [_autoCheckInProgress] empêche les appels concurrents si le timer refire avant que le check DNS précédent ne soit terminé.
  void _startAutoRetry() {
    _retryTimer = Timer.periodic(_retryInterval, (_) async {
      if (!mounted || _autoCheckInProgress) return;
      _autoCheckInProgress = true;

      final connected = await _connectivity.hasInternet();
      _autoCheckInProgress = false;

      if (!mounted) return;
      if (connected) {
        _retryTimer?.cancel();
        setState(() {
          _isOffline = false;
          _isBackOnline = true;
          _isChecking = true;
        });
        await Future.delayed(_backOnlineDelay);
        if (!mounted) return;
        setState(() => _isChecking = false);
        await Future.delayed(_preRedirectDelay);
        if (mounted) await _redirect();
      }
    });
  }

  /// Résout la route initiale selon l'état d'authentification et navigue.
  Future<void> _redirect() async {
    final storage = const SecureStorageService();
    final route = await KinoaRouter.resolveInitialRoute(storage);
    if (!mounted) return;

    final Object args = switch (route) {
      KinoaRoutes.shell => const ShellArgs(fromSplash: true),
      KinoaRoutes.signin => const AuthArgs(fromSplash: true),
      _ => const WelcomeArgs(fromSplash: true),
    };
    Navigator.pushReplacementNamed(context, route, arguments: args);
  }

  @override
  void dispose() {
    _retryTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: KinoaColors.burtGradient,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Stack(
          children: [
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AnimatedBuilder(
                    animation: _controller,
                    builder: (context, child) => FadeTransition(
                      opacity: _fadeAnim,
                      child: ScaleTransition(scale: _scaleAnim, child: child),
                    ),
                    child: const Hero(
                      tag: "kinoa_brand",
                      child: KinoaBrand(
                        size: BrandSize.lg,
                        color: KinoaColors.stone900,
                        iconColor: KinoaColors.stone900,
                      ),
                    ),
                  ),
                  if (_isChecking) ...[
                    const SizedBox(height: 20),
                    const SplashProgressBar(),
                  ],
                ],
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 48,
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 350),
                child: _isBackOnline
                    ? const SplashBackOnlinePanel(key: ValueKey("back"))
                    : _isOffline
                        ? SplashOfflinePanel(key: const ValueKey("offline"), onRetry: _beginCheck)
                        : const SizedBox(key: ValueKey("empty")),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
