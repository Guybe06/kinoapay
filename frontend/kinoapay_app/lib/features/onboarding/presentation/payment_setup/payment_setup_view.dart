import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:solar_icons/solar_icons.dart";
import "package:kinoapay_app/core/constants/app_colors.dart";
import "package:kinoapay_app/core/constants/app_routes.dart";
import "package:kinoapay_app/core/widgets/primary_button.dart";
import "package:kinoapay_app/features/accounts/application/bloc/auth_bloc.dart";
import "package:kinoapay_app/features/accounts/application/bloc/auth_state.dart";
import "package:kinoapay_app/features/onboarding/application/bloc/payment_setup_bloc.dart";
import "package:kinoapay_app/features/onboarding/application/bloc/payment_setup_event.dart";
import "package:kinoapay_app/features/onboarding/application/bloc/payment_setup_state.dart";
import "package:kinoapay_app/features/onboarding/domain/onboarding_strings.dart";
import "package:kinoapay_app/features/onboarding/presentation/payment_setup/payment_setup_account_tile.dart";
import "package:kinoapay_app/features/onboarding/presentation/payment_setup/payment_setup_link_sheet.dart";

/// Configuration des comptes Mobile Money après onboarding.
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
    context.read<PaymentSetupBloc>().add(
          PaymentSetupStarted(suggestedPhone: phone, suggestedCountryCode: code),
        );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<PaymentSetupBloc, PaymentSetupState>(
      listener: (context, state) {
        if (state is PaymentSetupDone) {
          Navigator.pushNamedAndRemoveUntil(context, AppRoutes.shell, (_) => false);
        }
      },
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.dark,
        child: Scaffold(
          backgroundColor: AppColors.quinoaCream,
          body: SafeArea(
            child: BlocBuilder<PaymentSetupBloc, PaymentSetupState>(
              builder: (context, state) {
                if (state is! PaymentSetupReady) {
                  return const Center(child: CircularProgressIndicator(color: AppColors.quinoaGold));
                }
                return _buildBody(context, state);
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context, PaymentSetupReady state) {
    final hasAccounts = state.linkedAccounts.isNotEmpty;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 32),
          _buildHeader(),
          const SizedBox(height: 36),
          Expanded(child: _buildAccountList(context, state)),
          const SizedBox(height: 16),
          _buildAddButton(context, state),
          const SizedBox(height: 20),
          PrimaryButton(
            text: OnboardingStrings.paymentSetupContinue,
            onPressed: () => context.read<PaymentSetupBloc>().add(const PaymentSetupCompleted()),
            enabled: hasAccounts,
          ),
          const SizedBox(height: 32),
        ],
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
            color: AppColors.quinoaGold.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(14),
          ),
          child: const Icon(SolarIconsOutline.phone, color: AppColors.quinoaGold, size: 22),
        ),
        const SizedBox(height: 20),
        const Text(
          OnboardingStrings.paymentSetupTitle,
          style: TextStyle(
            color: AppColors.quinoaDark,
            fontSize: 36,
            fontWeight: FontWeight.w900,
            height: 1.05,
            letterSpacing: -1.5,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          OnboardingStrings.paymentSetupSubtitle,
          style: TextStyle(color: AppColors.quinoaDark.withValues(alpha: 0.55), fontSize: 15, height: 1.5),
        ),
      ],
    );
  }

  Widget _buildAccountList(BuildContext context, PaymentSetupReady state) {
    if (state.linkedAccounts.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            OnboardingStrings.paymentSetupEmpty,
            textAlign: TextAlign.center,
            style: TextStyle(color: AppColors.quinoaDark.withValues(alpha: 0.35), fontSize: 14, height: 1.6),
          ),
        ),
      );
    }

    return ListView.separated(
      itemCount: state.linkedAccounts.length,
      separatorBuilder: (_, _) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final account = state.linkedAccounts[index];
        return PaymentSetupAccountTile(
          account: account,
          onRemove: () => context.read<PaymentSetupBloc>().add(
                PaymentAccountRemoved(accountId: account.id),
              ),
        );
      },
    );
  }

  Widget _buildAddButton(BuildContext context, PaymentSetupReady state) {
    return GestureDetector(
      onTap: () => _showLinkSheet(context, state),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 18),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: const BorderRadius.only(
            topRight: Radius.circular(20),
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
          border: Border.all(color: AppColors.quinoaDark.withValues(alpha: 0.12)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(SolarIconsOutline.addCircle, color: AppColors.quinoaDark.withValues(alpha: 0.6), size: 20),
            const SizedBox(width: 10),
            Text(
              OnboardingStrings.paymentSetupAdd,
              style: TextStyle(
                color: AppColors.quinoaDark,
                fontSize: 15,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showLinkSheet(BuildContext context, PaymentSetupReady state) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => PaymentSetupLinkSheet(
        suggestedPhone: state.suggestedPhone,
        suggestedCountryCode: state.suggestedCountryCode,
        onConfirm: (channel, phone, code) {
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
