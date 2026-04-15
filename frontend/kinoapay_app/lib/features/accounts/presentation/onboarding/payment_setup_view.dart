import "dart:ui";
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

/// Définition statique des canaux disponibles au MVP.
class _ChannelDef {
  final String type;
  final String label;
  final String shortLabel;
  final Color color;
  final Color textColor;
  const _ChannelDef({
    required this.type,
    required this.label,
    required this.shortLabel,
    required this.color,
    required this.textColor,
  });
}

const List<_ChannelDef> _channels = [
  _ChannelDef(
    type: "mtn_money",
    label: "MTN Mobile Money",
    shortLabel: "MTN",
    color: Color(0xFFFFCC00),
    textColor: Color(0xFF1A1400),
  ),
  _ChannelDef(
    type: "airtel_money",
    label: "Airtel Money",
    shortLabel: "Airtel",
    color: Color(0xFFE4002B),
    textColor: Colors.white,
  ),
];

/// Écran de configuration des comptes mobile money post-onboarding.
/// Affiché à chaque connexion jusqu'à configuration ou ignoré explicitement.
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
            ..._channels.map((ch) {
              final isLinked = state.linkedAccounts.any((a) => a.channelType == ch.type);
              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: _ChannelCard(
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

  void _showLinkSheet(BuildContext context, PaymentSetupReady state, _ChannelDef channel) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _LinkSheet(
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

// ── Canal card ───────────────────────────────────────────────────────────────

class _ChannelCard extends StatelessWidget {
  final _ChannelDef channel;
  final bool isLinked;
  final VoidCallback onAdd;

  const _ChannelCard({
    required this.channel,
    required this.isLinked,
    required this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surfaceCard,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isLinked ? channel.color.withValues(alpha: 0.4) : Colors.white.withValues(alpha: 0.06),
          width: 1.5,
        ),
      ),
      child: Row(
        children: [
          // Badge couleur canal
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: channel.color,
              borderRadius: BorderRadius.circular(14),
            ),
            alignment: Alignment.center,
            child: Text(
              channel.shortLabel,
              style: TextStyle(
                color: channel.textColor,
                fontSize: 11,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  channel.label,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  isLinked ? "Compte lié" : "Non configuré",
                  style: TextStyle(
                    color: isLinked ? AppColors.success : AppColors.stone500,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          if (isLinked)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.success.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(SolarIconsBold.checkCircle, size: 13, color: AppColors.success),
                  const SizedBox(width: 4),
                  Text(
                    AuthStrings.paymentSetupLinked,
                    style: const TextStyle(
                      color: AppColors.success,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            )
          else
            GestureDetector(
              onTap: onAdd,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
                ),
                child: Text(
                  AuthStrings.paymentSetupAdd,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// ── Bottom sheet de liaison ───────────────────────────────────────────────────

class _LinkSheet extends StatefulWidget {
  final _ChannelDef channel;
  final String suggestedPhone;
  final String suggestedCountryCode;
  final void Function(String phone, String countryCode) onConfirm;

  const _LinkSheet({
    required this.channel,
    required this.suggestedPhone,
    required this.suggestedCountryCode,
    required this.onConfirm,
  });

  @override
  State<_LinkSheet> createState() => _LinkSheetState();
}

class _LinkSheetState extends State<_LinkSheet> {
  late final TextEditingController _phoneCtrl;

  @override
  void initState() {
    super.initState();
    _phoneCtrl = TextEditingController(text: widget.suggestedPhone);
  }

  @override
  void dispose() {
    _phoneCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          padding: EdgeInsets.fromLTRB(24, 24, 24, 24 + bottomInset),
          decoration: BoxDecoration(
            color: AppColors.surfaceCard,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
            border: Border(
              top: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Poignée
              Center(
                child: Container(
                  width: 36,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: widget.channel.color,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      widget.channel.shortLabel,
                      style: TextStyle(
                        color: widget.channel.textColor,
                        fontSize: 10,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Text(
                    widget.channel.label,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Text(
                "Numéro de téléphone",
                style: TextStyle(
                  color: AppColors.stone400,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              // Champ numéro avec indicatif préfixé (lecture seule pour l'instant MVP)
              Container(
                decoration: BoxDecoration(
                  color: AppColors.surfaceDark,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
                ),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                      child: Text(
                        widget.suggestedCountryCode,
                        style: const TextStyle(
                          color: AppColors.stone400,
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                        ),
                      ),
                    ),
                    Container(width: 1, height: 22, color: Colors.white12),
                    Expanded(
                      child: TextField(
                        controller: _phoneCtrl,
                        keyboardType: TextInputType.phone,
                        style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w600),
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(horizontal: 16),
                          hintText: "06 XXX XX XX",
                          hintStyle: TextStyle(color: AppColors.stone500),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "Utilisez le numéro enregistré sur ce réseau.",
                style: TextStyle(color: AppColors.stone500, fontSize: 11),
              ),
              const SizedBox(height: 28),
              PrimaryButton(
                text: AuthStrings.paymentSetupConfirm,
                onPressed: () {
                  final phone = _phoneCtrl.text.trim().replaceAll(" ", "");
                  if (phone.isNotEmpty) {
                    widget.onConfirm(phone, widget.suggestedCountryCode);
                    Navigator.pop(context);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
