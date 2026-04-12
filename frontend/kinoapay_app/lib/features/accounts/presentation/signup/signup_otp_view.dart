import "dart:async";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:lucide_icons/lucide_icons.dart";
import "package:kinoapay_app/core/constants/kinoa_colors.dart";
import "package:kinoapay_app/core/constants/kinoa_routes.dart";
import "package:kinoapay_app/core/widgets/kinoa_brand.dart";
import "package:kinoapay_app/core/widgets/kinoa_primary_button.dart";
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
  final List<TextEditingController> _ctrls = List.generate(_otpLength, (_) => TextEditingController());
  final List<FocusNode> _nodes = List.generate(_otpLength, (_) => FocusNode());

  bool _hasError = false;
  bool _isVerifying = false;
  int _countdown = _countdownSec;
  Timer? _timer;

  SignupStep1Args get _step1 => ModalRoute.of(context)!.settings.arguments as SignupStep1Args;

  String get _maskedPhone {
    final digits = _step1.phone.replaceAll(RegExp(r"\D"), "");
    if (digits.length < 4) return "${_step1.countryCode} ${_step1.phone}";
    final start = digits.substring(0, 2);
    final end = digits.substring(digits.length - 2);
    return "${_step1.countryCode} $start ••• •• $end";
  }

  @override
  void initState() {
    super.initState();
    _startCountdown();
    // Déclenche l'envoi OTP dès l'arrivée sur l'écran
    WidgetsBinding.instance.addPostFrameCallback((_) => _sendOtp());
  }

  @override
  void dispose() {
    _timer?.cancel();
    for (final c in _ctrls) { c.dispose(); }
    for (final n in _nodes) { n.dispose(); }
    super.dispose();
  }

  void _startCountdown() {
    _timer?.cancel();
    setState(() => _countdown = _countdownSec);
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) { t.cancel(); return; }
      if (_countdown <= 1) {
        t.cancel();
        setState(() => _countdown = 0);
      } else {
        setState(() => _countdown--);
      }
    });
  }

  void _sendOtp() {
    context.read<AuthBloc>().add(SendOtpRequested(phone: _step1.phone, countryCode: _step1.countryCode));
  }

  void _resend() {
    _clearFields();
    _startCountdown();
    _sendOtp();
  }

  void _clearFields() {
    for (final c in _ctrls) { c.clear(); }
    setState(() => _hasError = false);
    _nodes[0].requestFocus();
  }

  String get _currentCode => _ctrls.map((c) => c.text).join();

  void _onDigitEntered(int index, String value) {
    if (value.isEmpty) return;
    setState(() => _hasError = false);
    if (index < _otpLength - 1) {
      _nodes[index + 1].requestFocus();
    } else {
      _nodes[index].unfocus();
      _submit();
    }
  }

  void _onKeyEvent(int index, KeyEvent event) {
    if (event is KeyDownEvent &&
        event.logicalKey == LogicalKeyboardKey.backspace &&
        _ctrls[index].text.isEmpty &&
        index > 0) {
      _ctrls[index - 1].clear();
      _nodes[index - 1].requestFocus();
    }
  }

  void _submit() {
    final code = _currentCode;
    if (code.length < _otpLength) return;
    setState(() => _isVerifying = true);
    context.read<AuthBloc>().add(
      VerifyOtpRequested(phone: _step1.phone, countryCode: _step1.countryCode, code: code),
    );
  }

  void _onState(BuildContext ctx, AuthState state) {
    if (state is OtpVerified) {
      setState(() => _isVerifying = false);
      Navigator.pushNamed(context, KinoaRoutes.signupCredentials, arguments: _step1);
      return;
    }
    if (state is AuthError) {
      setState(() { _isVerifying = false; _hasError = true; });
      _shakeAndClear();
      AuthSnackBar.showError(ctx, state.exception.message);
      return;
    }
    // OtpSent, AuthLoading — silencieux, le countdown et isLoading gèrent le feedback
  }

  Future<void> _shakeAndClear() async {
    await Future.delayed(const Duration(milliseconds: 600));
    if (mounted) _clearFields();
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
              children: [
                _buildHeader(context),
                Expanded(child: _buildBody(state)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(LucideIcons.arrowLeft, color: KinoaColors.quinoaDark),
            onPressed: () => Navigator.pop(context),
          ),
          const Spacer(),
          const KinoaBrand(size: BrandSize.sm, color: KinoaColors.quinoaDark, iconColor: KinoaColors.quinoaGold),
          const Spacer(flex: 2),
        ],
      ),
    );
  }

  Widget _buildBody(AuthState state) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 32),
          _buildStepIndicator(),
          const SizedBox(height: 24),
          const Text(
            AuthStrings.otpTitle,
            style: TextStyle(color: KinoaColors.quinoaDark, fontSize: 38, fontWeight: FontWeight.w900, height: 1.0, letterSpacing: -1.5),
          ),
          const SizedBox(height: 12),
          RichText(
            text: TextSpan(
              text: "${AuthStrings.otpBody} ",
              style: TextStyle(color: KinoaColors.quinoaDark.withValues(alpha: 0.55), fontSize: 15, height: 1.4),
              children: [
                TextSpan(
                  text: _maskedPhone,
                  style: const TextStyle(color: KinoaColors.quinoaDark, fontWeight: FontWeight.w700),
                ),
              ],
            ),
          ),
          const SizedBox(height: 48),
          _buildOtpBoxes(),
          const SizedBox(height: 40),
          KinoaPrimaryButton(
            text: "Vérifier",
            isLoading: _isVerifying,
            onPressed: _currentCode.length == _otpLength ? _submit : () {},
          ),
          const SizedBox(height: 28),
          Center(child: _buildResendRow()),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildStepIndicator() {
    return Row(
      children: [
        _dot(filled: true),
        const SizedBox(width: 6),
        _dot(filled: true),
        const SizedBox(width: 6),
        _dot(filled: false),
        const SizedBox(width: 10),
        Text(
          "Vérification",
          style: TextStyle(color: KinoaColors.quinoaDark.withValues(alpha: 0.4), fontSize: 13, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }

  Widget _dot({required bool filled}) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      width: filled ? 8 : 8,
      height: 8,
      decoration: BoxDecoration(
        color: filled ? KinoaColors.quinoaGold : KinoaColors.quinoaDark.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }

  Widget _buildOtpBoxes() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(_otpLength, (i) => _buildBox(i)),
    );
  }

  Widget _buildBox(int i) {
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
          onChanged: (v) => _onDigitEntered(i, v),
          style: TextStyle(
            color: _hasError ? KinoaColors.quinoaRed : KinoaColors.quinoaDark,
            fontSize: 22,
            fontWeight: FontWeight.w800,
          ),
          cursorColor: KinoaColors.quinoaGold,
          decoration: InputDecoration(
            counterText: "",
            filled: true,
            fillColor: _hasError
                ? KinoaColors.quinoaRed.withValues(alpha: 0.06)
                : KinoaColors.white,
            contentPadding: EdgeInsets.zero,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(
                color: _hasError
                    ? KinoaColors.quinoaRed.withValues(alpha: 0.4)
                    : KinoaColors.quinoaDark.withValues(alpha: 0.15),
                width: 1.5,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: KinoaColors.quinoaGold, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(color: KinoaColors.quinoaRed.withValues(alpha: 0.5), width: 1.5),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: KinoaColors.quinoaRed, width: 2),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildResendRow() {
    if (_countdown > 0) {
      return Text.rich(
        TextSpan(
          text: "${AuthStrings.otpResendIn} ",
          style: TextStyle(color: KinoaColors.quinoaDark.withValues(alpha: 0.4), fontSize: 14),
          children: [
            TextSpan(
              text: "${_countdown}s",
              style: const TextStyle(color: KinoaColors.quinoaDark, fontWeight: FontWeight.w700),
            ),
          ],
        ),
      );
    }
    return TextButton(
      onPressed: _resend,
      child: const Text(
        AuthStrings.otpResend,
        style: TextStyle(color: KinoaColors.quinoaDark, fontSize: 14, fontWeight: FontWeight.w700),
      ),
    );
  }
}
