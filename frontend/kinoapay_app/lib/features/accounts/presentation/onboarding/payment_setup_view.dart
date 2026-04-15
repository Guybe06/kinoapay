import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:solar_icons/solar_icons.dart";
import "package:kinoapay_app/core/constants/app_colors.dart";
import "package:kinoapay_app/core/constants/app_routes.dart";
import "package:kinoapay_app/core/widgets/primary_button.dart";
import "package:kinoapay_app/features/accounts/application/bloc/auth_bloc.dart";
import "package:kinoapay_app/features/accounts/application/bloc/auth_state.dart";
import "package:kinoapay_app/features/accounts/application/bloc/payment_setup_bloc.dart";
import "package:kinoapay_app/features/accounts/application/bloc/payment_setup_event.dart";
import "package:kinoapay_app/features/accounts/application/bloc/payment_setup_state.dart";
import "package:kinoapay_app/features/accounts/domain/auth_strings.dart";
import "package:kinoapay_app/features/accounts/presentation/onboarding/payment_setup_channel_card.dart";
import "package:kinoapay_app/features/accounts/presentation/onboarding/payment_setup_channel_models.dart";
import "package:kinoapay_app/features/accounts/presentation/onboarding/payment_setup_link_sheet.dart";

/// Configuration des comptes Mobile Money après onboarding.
///
/// Affichée tant qu’aucun compte n’est ignoré ou validé explicitement.
class PaymentSetupView extends StatefulWidget {
  const PaymentSetupView({super.key});

  @override
  State<PaymentSetupView> createState() => _PaymentSetupViewState();
}

class _PaymentSetupViewState extends State<PaymentSetupView> {
  @override
  void initState() {
    super.initState();
    final authState = context.read<AuthBloc>().state;
    final phone = authState is Authenticated ? (authState.user.phone ?? "") : "";
    final code = authState is Authenticated ? (authState.user.countryCode ?? "+242") : "+242";
    context.read<PaymentSetupBloc>().add(PaymentSetupStarted(
          suggestedPhone: phone,
          suggestedCountryCode: code,
        ));
  }

  void _goToShell(BuildContext context) {
    context.read<PaymentSetupBloc>().add(const PaymentSetupCompleted());
  }

  @override
  Widget build(BuildContext context) {
    final topInset = MediaQuery.of(context).padding.top;

    return BlocListener<PaymentSetupBloc, PaymentSetupState>(
      listener: (context, state) {
        if (state is PaymentSetupDone) {
          Navigator.pushNamedAndRemoveUntil(context, AppRoutes.shell, (_) => false);
        }
      },
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
        ),
        child: Scaffold(
          backgroundColor: AppColors.surfaceDark,
          body: BlocBuilder<PaymentSetupBloc, PaymentSetupState>(
            builder: (context, state) {
              if (state is! PaymentSetupReady) {
                return const Center(child: CircularProgressIndicator(color: AppColors.accent));
              }
              return _buildBody(context, state, topInset);
            },
          ),
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context, PaymentSetupReady state, double topInset) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: topInset > 0 ? 16 : 32),
            _buildHeader(),
            const SizedBox(height: 40),
            ...paymentSetupChannels.map((ch) {
              final isLinked = state.linkedAccounts.any((a) => a.channelType == ch.type);
              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: PaymentSetupChannelCard(
                  channel: ch,
                  isLinked: isLinked,
                  onAdd: () => _showLinkSheet(context, state, ch),
                ),
              );
            }),
            const Spacer(),
            PrimaryButton(
              text: AuthStrings.paymentSetupContinue,
              onPressed: () => _goToShell(context),
            ),
            const SizedBox(height: 12),
            Center(
              child: GestureDetector(
                onTap: () => _goToShell(context),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Text(
                    AuthStrings.paymentSetupSkip,
                    style: TextStyle(
                      color: AppColors.stone500,
                      fontSize: 13,
                      decoration: TextDecoration.underline,
                      decorationColor: AppColors.stone500,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Center(
              child: Text(
                AuthStrings.paymentSetupSkipNote,
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColors.stone500.withValues(alpha: 0.6), fontSize: 11),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: AppColors.quinoaGold.withValues(alpha: 0.10),
            borderRadius: BorderRadius.circular(14),
          ),
          child: const Icon(SolarIconsOutline.phone, color: AppColors.quinoaGold, size: 22),
        ),
        const SizedBox(height: 20),
        const Text(
          AuthStrings.paymentSetupTitle,
          style: TextStyle(
            color: Colors.white,
            fontSize: 32,
            fontWeight: FontWeight.w900,
            height: 1.1,
            letterSpacing: -1.2,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          AuthStrings.paymentSetupSubtitle,
          style: TextStyle(color: AppColors.stone400, fontSize: 14, height: 1.5),
        ),
      ],
    );
  }

  void _showLinkSheet(BuildContext context, PaymentSetupReady state, PaymentSetupChannelDef channel) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => PaymentSetupLinkSheet(
        channel: channel,
        suggestedPhone: state.suggestedPhone,
        suggestedCountryCode: state.suggestedCountryCode,
        onConfirm: (phone, code) {
          context.read<PaymentSetupBloc>().add(PaymentAccountAdded(
                channelType: channel.type,
                channelLabel: channel.label,
                phone: phone,
                countryCode: code,
              ));
        },
      ),
    );
  }
}
