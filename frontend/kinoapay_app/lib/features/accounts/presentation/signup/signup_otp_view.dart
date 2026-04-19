import "dart:async";
import "package:flutter/services.dart";
import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:kinoapay_app/core/constants/app_routes.dart";
import "package:kinoapay_app/core/constants/app_colors.dart";
import "package:kinoapay_app/core/widgets/otp_input.dart";
import "package:kinoapay_app/core/widgets/primary_button.dart";
import "package:kinoapay_app/features/accounts/application/bloc/auth_bloc.dart";
import "package:kinoapay_app/features/accounts/application/bloc/auth_event.dart";
import "package:kinoapay_app/features/accounts/application/bloc/auth_state.dart";
import "package:kinoapay_app/features/accounts/domain/auth_strings.dart";
import "package:kinoapay_app/features/accounts/presentation/signup/signup_step1_args.dart";
import "package:kinoapay_app/features/accounts/presentation/signup/signup_step1_step_indicator.dart";
import "package:kinoapay_app/features/accounts/presentation/widgets/auth_screen_header.dart";
import "package:kinoapay_app/features/accounts/presentation/widgets/auth_snack_bar.dart";
import "package:kinoapay_app/features/accounts/presentation/widgets/otp_resend_row.dart";

const int _otpLength = 6;
const int _countdownSec = 60;

/// Écran de vérification du numéro de téléphone par code OTP.
class SignupOtpView extends StatefulWidget {
  const SignupOtpView({super.key});

  @override
  State<SignupOtpView> createState() => _SignupOtpViewState();
}

class _SignupOtpViewState extends State<SignupOtpView> {
  final _otpKey = GlobalKey<OtpInputState>();
  bool _hasError = false;
  bool _isVerifying = false;
  bool _navigating = false;
  int _countdown = _countdownSec;
  Timer? _timer;

  SignupStep1Args get _step1 =>
      ModalRoute.of(context)!.settings.arguments as SignupStep1Args;

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
      if (_countdown <= 1) {
        t.cancel();
        setState(() => _countdown = 0);
      } else {
        setState(() => _countdown--);
      }
    });
  }

  void _sendOtp() {
    context.read<AuthBloc>().add(
      SendOtpRequested(phone: _step1.phone, countryCode: _step1.countryCode),
    );
  }

  void _resend() {
    _otpKey.currentState?.clear();
    setState(() => _hasError = false);
    _startCountdown();
    _sendOtp();
  }

  void _onOtpCompleted(String code) {
    setState(() => _isVerifying = true);
    context.read<AuthBloc>().add(
      VerifyOtpRequested(
        phone: _step1.phone,
        countryCode: _step1.countryCode,
        code: code,
      ),
    );
  }

  void _onState(BuildContext ctx, AuthState state) {
    if (state is OtpVerified) {
      setState(() => _isVerifying = false);
      if (_navigating) return;
      _navigating = true;
      Navigator.pushNamed(context, AppRoutes.signupCredentials, arguments: _step1)
          .then((_) => _navigating = false);
    } else if (state is AuthError) {
      setState(() { _isVerifying = false; _hasError = true; });
      AuthSnackBar.showError(ctx, state.exception.message);
      Future.delayed(const Duration(milliseconds: 600), () {
        if (mounted) {
          _otpKey.currentState?.clear();
          setState(() => _hasError = false);
        }
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
              children: [
                const AuthScreenHeader(),
                Expanded(child: _buildBody()),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBody() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 32),
          SignupStepIndicator(currentStep: 2, totalSteps: 3, label: AuthStrings.otpStepLabel),
          const SizedBox(height: 24),
          const Text(
            AuthStrings.otpTitle,
            style: TextStyle(color: AppColors.quinoaDark, fontSize: 38, fontWeight: FontWeight.w900, height: 1.0, letterSpacing: -1.5),
          ),
          const SizedBox(height: 12),
          RichText(
            text: TextSpan(
              text: "${AuthStrings.otpBody} ",
              style: TextStyle(color: AppColors.quinoaDark.withValues(alpha: 0.55), fontSize: 15, height: 1.4),
              children: [
                TextSpan(text: _maskedPhone, style: const TextStyle(color: AppColors.quinoaDark, fontWeight: FontWeight.w700)),
              ],
            ),
          ),
          const SizedBox(height: 48),
          OtpInput(key: _otpKey, length: _otpLength, hasError: _hasError, onCompleted: _onOtpCompleted),
          const SizedBox(height: 40),
          PrimaryButton(
            text: AuthStrings.otpVerifyBtn,
            isLoading: _isVerifying,
            onPressed: () {
              final code = _otpKey.currentState?.code ?? "";
              if (code.length == _otpLength) _onOtpCompleted(code);
            },
          ),
          const SizedBox(height: 28),
          Center(
            child: OtpResendRow(
              countdown: _countdown,
              attempt: 1,
              maxAttempts: 1,
              onResend: _resend,
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}
