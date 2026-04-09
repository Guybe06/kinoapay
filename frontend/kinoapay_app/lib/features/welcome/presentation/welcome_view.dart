import "dart:async";
import "package:flutter/material.dart";
import "package:lucide_icons/lucide_icons.dart";
import "package:kinoapay_app/core/constants/kinoa_strings.dart";
import "package:kinoapay_app/features/welcome/domain/welcome_slide.dart";
import "package:kinoapay_app/core/widgets/kinoa_brand.dart";
import "package:kinoapay_app/features/welcome/presentation/widgets/welcome_actions.dart";
import "package:kinoapay_app/features/welcome/presentation/widgets/welcome_background.dart";
import "package:kinoapay_app/features/welcome/presentation/widgets/welcome_dots.dart";
import "package:kinoapay_app/features/welcome/presentation/widgets/welcome_slider.dart";
import "package:kinoapay_app/features/welcome/presentation/widgets/welcome_trust_label.dart";

/// Point d'entrée de la fonctionnalité Welcome orchestrant le carrousel de marque.
class WelcomeView extends StatefulWidget {
  const WelcomeView({super.key});

  @override
  State<WelcomeView> createState() => _WelcomeViewState();
}

class _WelcomeViewState extends State<WelcomeView> {
  static const List<WelcomeSlide> _slides = [
    WelcomeSlide(
      icon: LucideIcons.zap,
      title: KinoaStrings.welcomeSlide1Title,
      desc: KinoaStrings.welcomeSlide1Desc,
    ),
    WelcomeSlide(
      icon: LucideIcons.layers,
      title: KinoaStrings.welcomeSlide2Title,
      desc: KinoaStrings.welcomeSlide2Desc,
    ),
    WelcomeSlide(
      icon: LucideIcons.lock,
      title: KinoaStrings.welcomeSlide3Title,
      desc: KinoaStrings.welcomeSlide3Desc,
    ),
    WelcomeSlide(
      icon: LucideIcons.shieldCheck,
      title: KinoaStrings.welcomeSlide4Title,
      desc: KinoaStrings.welcomeSlide4Desc,
    ),
  ];

  final PageController _pageController = PageController();
  int _activePage = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  /// Initialise et gère le défilement automatique des diapositives.
  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (_pageController.hasClients) {
        int next = (_activePage + 1) % _slides.length;
        _pageController.animateToPage(
          next,
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  /// Met à jour l'index de la page active lors d'un changement de diapositive.
  void _onPageChanged(int index) {
    setState(() {
      _activePage = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 40),
          child: Column(
            children: [
              const KinoaBrand(size: BrandSize.lg),
              const Spacer(),
              WelcomeSlider(
                controller: _pageController,
                slides: _slides,
                onPageChanged: _onPageChanged,
              ),
              const SizedBox(height: 40),
              WelcomeDots(
                activeIndex: _activePage,
                slides: _slides,
              ),
              const Spacer(),
              const WelcomeActions(),
              const SizedBox(height: 24),
              const WelcomeTrustLabel(),
            ],
          ),
        ),
      ),
    );
  }
}
