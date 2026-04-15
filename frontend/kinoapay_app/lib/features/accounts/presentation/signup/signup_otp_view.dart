import "dart:async";
import "package:flutter/services.dart";
import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:solar_icons/solar_icons.dart";
import "package:kinoapay_app/core/constants/app_colors.dart";
import "package:kinoapay_app/core/constants/app_routes.dart";
import "package:kinoapay_app/core/widgets/brand_logo_row.dart";
import "package:kinoapay_app/core/widgets/otp_input.dart";
import "package:kinoapay_app/core/widgets/primary_button.dart";
import "package:kinoapay_app/features/accounts/application/bloc/auth_bloc.dart";
import "package:kinoapay_app/features/accounts/application/bloc/auth_event.dart";
import "package:kinoapay_app/features/accounts/application/bloc/auth_state.dart";
import "package:kinoapay_app/features/accounts/domain/auth_strings.dart";
import "package:kinoapay_app/features/accounts/presentation/signup/signup_step1_view.dart";
import "package:kinoapay_app/features/accounts/presentation/widgets/auth_snack_bar.dart";

const int _otpLength = 6;
const int _countdownSec = 60;

/// Écran de vérification du numéro de téléphone par code OTP.
class SignupOtpView extends StatefulWidget {
  const SignupOtpView({super.key});

  @override
  State<SignupOtpView> createState() => _SignupOtpViewState();
}

class _SignupOtpViewState extends State<SignupOtpView> {
  final _otpKey = GlobalKey<KinoaOtpInputState>();
  bool _hasError = false;
  bool _isVerifying = false;
  bool _navigating = false;
  int _countdown = _countdownSec;
  Timer? _timer;

  SignupStep1Args get _step1 => ModalRoute.of(context)!.settings.arguments as SignupStep1Args;

  String get _maskedPhone {
    final digits = _step1.phone.replaceAll(RegExp(r"\D"), "");
    if (digits.length < 4) return "${_step1.countryCode} ${_step1.phone}";
    return "${_step1.countryCode} ${digits.substring(0, 2)} ••• •• ${digits.substring(digits.length - 2)}";
  }

  @override
  void initState() {
    super.initState();
    _startCountdown();
    WidgetsBinding.instance.addPostFrameCallback((_) => _sendOtp());
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startCountdown() {
    _timer?.cancel();
    setState(() => _countdown = _countdownSec);
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) { t.cancel(); return; }
      if (_countdown <= 1) { t.cancel(); setState(() => _countdown = 0); } else { setState(() => _countdown--); }
    });
  }

  void _sendOtp() {
    context.read<AuthBloc>().add(SendOtpRequested(phone: _step1.phone, countryCode: _step1.countryCode));
  }

  void _resend() {
    _otpKey.currentState?.clear();
    setState(() => _hasError = false);
    _startCountdown();
    _sendOtp();
  }

  void _onOtpCompleted(String code) {
    setState(() => _isVerifying = true);
    context.read<AuthBloc>().add(VerifyOtpRequested(phone: _step1.phone, countryCode: _step1.countryCode, code: code));
  }

  void _onState(BuildContext ctx, AuthState state) {
    if (state is OtpVerified) {
      setState(() => _isVerifying = false);
      if (_navigating) return;
      _navigating = true;
      Navigator.pushNamed(context, KinoaRoutes.signupCredentials, arguments: _step1).then((_) => _navigating = false);
    } else if (state is AuthError) {
      setState(() { _isVerifying = false; _hasError = true; });
      AuthSnackBar.showError(ctx, state.exception.message);
      Future.delayed(const Duration(milliseconds: 600), () {
        if (mounted) { _otpKey.currentState?.clear(); setState(() => _hasError = false); }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: KinoaColors.quinoaCream,
        body: SafeArea(
          child: BlocConsumer<AuthBloc, AuthState>(
            listener: _onState,
            builder: (context, state) => Column(
              children: [_buildHeader(context), Expanded(child: _buildBody())],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(children: [
        IconButton(icon: const Icon(SolarIconsOutline.altArrowLeft, color: KinoaColors.quinoaDark), onPressed: () => Navigator.pop(context)),
        const Spacer(),
        const KinoaBrand(size: BrandSize.sm, color: KinoaColors.quinoaDark, iconColor: KinoaColors.quinoaGold),
        const Spacer(flex: 2),
      ]),
    );
  }

  Widget _buildBody() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 28),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const SizedBox(height: 32),
        _buildStepIndicator(),
        const SizedBox(height: 24),
        const Text(AuthStrings.otpTitle, style: TextStyle(color: KinoaColors.quinoaDark, fontSize: 38, fontWeight: FontWeight.w900, height: 1.0, letterSpacing: -1.5)),
        const SizedBox(height: 12),
        RichText(text: TextSpan(
          text: "${AuthStrings.otpBody} ",
          style: TextStyle(color: KinoaColors.quinoaDark.withValues(alpha: 0.55), fontSize: 15, height: 1.4),
          children: [TextSpan(text: _maskedPhone, style: const TextStyle(color: KinoaColors.quinoaDark, fontWeight: FontWeight.w700))],
        )),
        const SizedBox(height: 48),
        KinoaOtpInput(key: _otpKey, length: _otpLength, hasError: _hasError, onCompleted: _onOtpCompleted),
        const SizedBox(height: 40),
        KinoaPrimaryButton(text: "Vérifier", isLoading: _isVerifying, onPressed: () {
          final code = _otpKey.currentState?.code ?? "";
          if (code.length == _otpLength) _onOtpCompleted(code);
        }),
        const SizedBox(height: 28),
        Center(child: _buildResendRow()),
        const SizedBox(height: 32),
      ]),
    );
  }

  Widget _buildStepIndicator() {
    return Row(children: [
      _dot(filled: true), const SizedBox(width: 6),
      _dot(filled: true), const SizedBox(width: 6),
      _dot(filled: false), const SizedBox(width: 10),
      Text("Vérification", style: TextStyle(color: KinoaColors.quinoaDark.withValues(alpha: 0.4), fontSize: 13, fontWeight: FontWeight.w500)),
    ]);
  }

  Widget _dot({required bool filled}) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250), width: 8, height: 8,
      decoration: BoxDecoration(color: filled ? KinoaColors.quinoaGold : KinoaColors.quinoaDark.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(4)),
    );
  }

  Widget _buildResendRow() {
    if (_countdown > 0) {
      return Text.rich(TextSpan(
        text: "${AuthStrings.otpResendIn} ",
        style: TextStyle(color: KinoaColors.quinoaDark.withValues(alpha: 0.4), fontSize: 14),
        children: [TextSpan(text: "${_countdown}s", style: const TextStyle(color: KinoaColors.quinoaDark, fontWeight: FontWeight.w700))],
      ));
    }
    return TextButton(
      onPressed: _resend,
      child: const Text(AuthStrings.otpResend, style: TextStyle(color: KinoaColors.quinoaDark, fontSize: 14, fontWeight: FontWeight.w700)),
    );
  }
}
