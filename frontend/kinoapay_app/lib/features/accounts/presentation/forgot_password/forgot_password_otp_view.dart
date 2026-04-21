import "dart:async";
import "package:flutter/services.dart";
import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:kinoapay_app/core/constants/app_routes.dart";
import "package:kinoapay_app/core/constants/app_colors.dart";
import "package:kinoapay_app/core/helpers/screen_size_helper.dart";
import "package:kinoapay_app/core/widgets/otp_input.dart";
import "package:kinoapay_app/core/widgets/primary_button.dart";
import "package:kinoapay_app/features/accounts/application/bloc/auth_bloc.dart";
import "package:kinoapay_app/features/accounts/application/bloc/auth_event.dart";
import "package:kinoapay_app/features/accounts/application/bloc/auth_state.dart";
import "package:kinoapay_app/features/accounts/domain/auth_strings.dart";
import "package:kinoapay_app/features/accounts/presentation/forgot_password/forgot_password_args.dart";
import "package:kinoapay_app/features/accounts/presentation/widgets/auth_screen_header.dart";
import "package:kinoapay_app/features/accounts/presentation/widgets/auth_snack_bar.dart";
import "package:kinoapay_app/features/accounts/presentation/widgets/otp_resend_row.dart";

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

  ForgotPasswordArgs get _args =>
      ModalRoute.of(context)!.settings.arguments as ForgotPasswordArgs;

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

  bool get _isLockedOut =>
      _lockedUntil != null && DateTime.now().isBefore(_lockedUntil!);

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
    final delay = _attempt < _resendDelays.length
        ? _resendDelays[_attempt]
        : _resendDelays.last;
    setState(() => _countdown = delay);
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) {
        t.cancel();
        return;
      }
      if (_countdown <= 1) {
        t.cancel();
        setState(() => _countdown = 0);
      } else {
        setState(() => _countdown--);
      }
    });
  }

  void _resend() {
    if (_isLockedOut) return;
    _attempt++;
    if (_attempt >= _maxAttempts) {
      _timer?.cancel();
      setState(() {
        _lockedUntil = DateTime.now().add(_lockoutDuration);
        _countdown = 0;
      });
      AuthSnackBar.showError(context, "${AuthStrings.resetRateLimited} 2h.");
      return;
    }
    _otpKey.currentState?.clear();
    setState(() => _hasError = false);
    _startCountdown();
    context.read<AuthBloc>().add(
      RequestPasswordResetRequested(
        contact: _args.contact,
        isEmail: _args.isEmail,
      ),
    );
  }

  void _onOtpCompleted(String code) {
    setState(() => _isVerifying = true);
    context.read<AuthBloc>().add(
      VerifyResetOtpRequested(contact: _args.contact, code: code),
    );
  }

  void _onState(BuildContext ctx, AuthState state) {
    if (state is ResetOtpVerified) {
      setState(() => _isVerifying = false);
      if (_navigating) return;
      _navigating = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) {
          _navigating = false;
          return;
        }
        Navigator.pushNamed(
          context,
          AppRoutes.forgotPasswordReset,
          arguments: state.resetToken,
        ).then((_) => _navigating = false);
      });
    } else if (state is AuthError) {
      setState(() {
        _isVerifying = false;
        _hasError = true;
      });
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
          SizedBox(
            height: ScreenSizeHelper.adaptiveValue(
              context,
              compact: 20,
              small: 24,
              medium: 28,
              large: 32,
            ),
          ),
          Text(
            AuthStrings.resetOtpTitle,
            style: TextStyle(
              color: AppColors.quinoaDark,
              fontSize: ScreenSizeHelper.adaptiveValue(
                context,
                compact: 28,
                small: 30,
                medium: 32,
                large: 32,
              ),
              fontWeight: FontWeight.w900,
              height: 1.05,
              letterSpacing: -1.2,
            ),
          ),
          SizedBox(
            height: ScreenSizeHelper.adaptiveValue(
              context,
              compact: 6,
              small: 7,
              medium: 8,
              large: 8,
            ),
          ),
          RichText(
            text: TextSpan(
              text: "${AuthStrings.resetOtpBody} ",
              style: TextStyle(
                color: AppColors.quinoaDark.withValues(alpha: 0.55),
                fontSize: 14,
                height: 1.4,
              ),
              children: [
                TextSpan(
                  text: _maskedContact,
                  style: const TextStyle(
                    color: AppColors.quinoaDark,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: ScreenSizeHelper.adaptiveValue(
              context,
              compact: 24,
              small: 28,
              medium: 32,
              large: 32,
            ),
          ),
          OtpInput(
            key: _otpKey,
            length: _otpLength,
            hasError: _hasError,
            onCompleted: _onOtpCompleted,
          ),
          SizedBox(
            height: ScreenSizeHelper.adaptiveValue(
              context,
              compact: 28,
              small: 36,
              medium: 40,
              large: 40,
            ),
          ),
          PrimaryButton(
            text: AuthStrings.otpVerifyBtn,
            isLoading: _isVerifying,
            onPressed: () {
              final code = _otpKey.currentState?.code ?? "";
              if (code.length == _otpLength) _onOtpCompleted(code);
            },
          ),
          SizedBox(
            height: ScreenSizeHelper.adaptiveValue(
              context,
              compact: 20,
              small: 24,
              medium: 28,
              large: 28,
            ),
          ),
          Center(
            child: OtpResendRow(
              countdown: _countdown,
              attempt: _attempt + 1,
              maxAttempts: _maxAttempts,
              lockedUntil: _lockedUntil,
              onResend: _resend,
            ),
          ),
          SizedBox(
            height: ScreenSizeHelper.adaptiveValue(
              context,
              compact: 20,
              small: 26,
              medium: 32,
              large: 32,
            ),
          ),
        ],
      ),
    );
  }
}
