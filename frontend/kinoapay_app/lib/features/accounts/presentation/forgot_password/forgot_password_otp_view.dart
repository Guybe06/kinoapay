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
import "package:kinoapay_app/features/accounts/presentation/forgot_password/forgot_password_view.dart";
import "package:kinoapay_app/features/accounts/presentation/widgets/auth_snack_bar.dart";

const int _otpLength = 6;
const List<int> _resendDelays = [30, 60, 120, 120, 120];
const int _maxAttempts = 5;
const Duration _lockoutDuration = Duration(hours: 2);

/// Écran 2 : saisie du code OTP avec rate limiting progressif.
class ForgotPasswordOtpView extends StatefulWidget {
  const ForgotPasswordOtpView({super.key});

  @override
  State<ForgotPasswordOtpView> createState() => _ForgotPasswordOtpViewState();
}

class _ForgotPasswordOtpViewState extends State<ForgotPasswordOtpView> {
  final _otpKey = GlobalKey<OtpInputState>();
  bool _hasError = false;
  bool _isVerifying = false;
  bool _navigating = false;
  int _countdown = _resendDelays[0];
  int _attempt = 0;
  Timer? _timer;
  DateTime? _lockedUntil;

  ForgotPasswordArgs get _args => ModalRoute.of(context)!.settings.arguments as ForgotPasswordArgs;

  String get _maskedContact {
    final c = _args.contact;
    if (_args.isEmail) {
      final parts = c.split("@");
      if (parts.length != 2 || parts[0].length < 2) return c;
      return "${parts[0][0]}${"•" * (parts[0].length - 1)}@${parts[1]}";
    }
    final digits = c.replaceAll(RegExp(r"\D"), "");
    if (digits.length < 4) return c;
    return "${digits.substring(0, 2)} ••• •• ${digits.substring(digits.length - 2)}";
  }

  bool get _isLockedOut => _lockedUntil != null && DateTime.now().isBefore(_lockedUntil!);

  @override
  void initState() {
    super.initState();
    _startCountdown();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startCountdown() {
    _timer?.cancel();
    final delay = _attempt < _resendDelays.length ? _resendDelays[_attempt] : _resendDelays.last;
    setState(() => _countdown = delay);
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) { t.cancel(); return; }
      if (_countdown <= 1) { t.cancel(); setState(() => _countdown = 0); } else { setState(() => _countdown--); }
    });
  }

  void _resend() {
    if (_isLockedOut) return;
    _attempt++;
    if (_attempt >= _maxAttempts) {
      _timer?.cancel();
      setState(() { _lockedUntil = DateTime.now().add(_lockoutDuration); _countdown = 0; });
      AuthSnackBar.showError(context, "${AuthStrings.resetRateLimited} 2h.");
      return;
    }
    _otpKey.currentState?.clear();
    setState(() => _hasError = false);
    _startCountdown();
    context.read<AuthBloc>().add(RequestPasswordResetRequested(contact: _args.contact, isEmail: _args.isEmail));
  }

  void _onOtpCompleted(String code) {
    setState(() => _isVerifying = true);
    context.read<AuthBloc>().add(VerifyResetOtpRequested(contact: _args.contact, code: code));
  }

  void _onState(BuildContext ctx, AuthState state) {
    if (state is ResetOtpVerified) {
      setState(() => _isVerifying = false);
      if (_navigating) return;
      _navigating = true;
      Navigator.pushNamed(context, AppRoutes.forgotPasswordReset, arguments: state.resetToken).then((_) => _navigating = false);
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
        backgroundColor: AppColors.quinoaCream,
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
        IconButton(icon: const Icon(SolarIconsOutline.altArrowLeft, color: AppColors.quinoaDark), onPressed: () => Navigator.pop(context)),
        const Spacer(),
        const BrandLogoRow(size: BrandSize.sm, color: AppColors.quinoaDark, iconColor: AppColors.quinoaGold),
        const Spacer(flex: 2),
      ]),
    );
  }

  Widget _buildBody() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 28),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const SizedBox(height: 32),
        const Text(AuthStrings.resetOtpTitle, style: TextStyle(color: AppColors.quinoaDark, fontSize: 38, fontWeight: FontWeight.w900, height: 1.0, letterSpacing: -1.5)),
        const SizedBox(height: 12),
        RichText(text: TextSpan(
          text: "${AuthStrings.resetOtpBody} ",
          style: TextStyle(color: AppColors.quinoaDark.withValues(alpha: 0.55), fontSize: 15, height: 1.4),
          children: [TextSpan(text: _maskedContact, style: const TextStyle(color: AppColors.quinoaDark, fontWeight: FontWeight.w700))],
        )),
        const SizedBox(height: 48),
        OtpInput(key: _otpKey, length: _otpLength, hasError: _hasError, onCompleted: _onOtpCompleted),
        const SizedBox(height: 40),
        PrimaryButton(text: "Vérifier", isLoading: _isVerifying, onPressed: () {
          final code = _otpKey.currentState?.code ?? "";
          if (code.length == _otpLength) _onOtpCompleted(code);
        }),
        const SizedBox(height: 28),
        Center(child: _buildResendRow()),
        const SizedBox(height: 32),
      ]),
    );
  }

  Widget _buildResendRow() {
    if (_isLockedOut) {
      final r = _lockedUntil!.difference(DateTime.now());
      return Text("${AuthStrings.resetRateLimited} ${r.inHours}h${r.inMinutes.remainder(60).toString().padLeft(2, "0")}",
        style: TextStyle(color: AppColors.quinoaRed.withValues(alpha: 0.7), fontSize: 14, fontWeight: FontWeight.w600));
    }
    if (_countdown > 0) {
      return Text.rich(TextSpan(
        text: "${AuthStrings.otpResendIn} ",
        style: TextStyle(color: AppColors.quinoaDark.withValues(alpha: 0.4), fontSize: 14),
        children: [TextSpan(text: "${_countdown}s", style: const TextStyle(color: AppColors.quinoaDark, fontWeight: FontWeight.w700))],
      ));
    }
    return TextButton(
      onPressed: _resend,
      child: Text("${AuthStrings.otpResend} (${_attempt + 1}/$_maxAttempts)", style: const TextStyle(color: AppColors.quinoaDark, fontSize: 14, fontWeight: FontWeight.w700)),
    );
  }
}
