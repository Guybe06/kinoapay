import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:qr_flutter/qr_flutter.dart";
import "package:kinoapay_app/core/constants/app_colors.dart";
import "package:kinoapay_app/core/navigation/presentation/widgets/app_back_header.dart";
import "package:kinoapay_app/core/widgets/app_scroll_scaffold.dart";
import "package:kinoapay_app/core/widgets/app_snack_bar.dart";
import "package:kinoapay_app/core/widgets/app_page_title.dart";
import "package:kinoapay_app/features/accounts/application/bloc/auth_bloc.dart";
import "package:kinoapay_app/features/accounts/application/bloc/auth_state.dart";
import "package:kinoapay_app/features/request/domain/request_strings.dart";

/// Écran de demande de paiement : génère un QR code et un lien copiable.
/// Le montant est optionnel : sans montant, le QR contient uniquement le KinoaID.
/// Avec montant, le QR encode une demande de paiement complète.
class RequestView extends StatefulWidget {
  const RequestView({super.key});

  @override
  State<RequestView> createState() => _RequestViewState();
}

class _RequestViewState extends State<RequestView> {
  final _amountCtrl = TextEditingController();
  double? _amount;

  @override
  void initState() {
    super.initState();
    _amountCtrl.addListener(_onAmountChanged);
  }

  @override
  void dispose() {
    _amountCtrl.dispose();
    super.dispose();
  }

  void _onAmountChanged() {
    final raw = _amountCtrl.text.replaceAll(RegExp(r"[^\d]"), "");
    final value = raw.isEmpty ? null : double.tryParse(raw);
    if (value != _amount) setState(() => _amount = value);
  }

  Future<void> _copyId(String handle) async {
    await Clipboard.setData(ClipboardData(text: handle));
    if (!mounted) return;
    AppSnackBar.showInfo(context, RequestStrings.idCopied);
  }

  Future<void> _copyLink(String handle) async {
    final text = RequestStrings.shareMessage(handle, _amount);
    await Clipboard.setData(ClipboardData(text: text));
    if (!mounted) return;
    AppSnackBar.showSuccess(context, RequestStrings.shareCopied);
  }

  @override
  Widget build(BuildContext context) {
    final authState = context.watch<AuthBloc>().state;
    final handle = authState is Authenticated
        ? authState.user.publicHandle
        : null;

    return AppScrollScaffold(
      header: AppBackHeader(
        onBack: () => Navigator.pop(context),
        backLabel: RequestStrings.backLabel,
        title: RequestStrings.title,
        subtitle: RequestStrings.headerSubtitle,
      ),
      builder: (_, ctrl) => SingleChildScrollView(
        controller: ctrl,
        padding: const EdgeInsets.fromLTRB(24, 72, 24, 120),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 8),
            const AppPageTitle(
              title: RequestStrings.pageTitle,
              subtitle: RequestStrings.pageSubtitle,
            ),
            const SizedBox(height: 36),
            _AmountField(controller: _amountCtrl),
            const SizedBox(height: 40),
            if (handle != null) ...[
              _QrCard(
                handle: handle,
                amount: _amount,
                onCopyId: () => _copyId(handle),
              ),
              const SizedBox(height: 32),
              _ShareButton(onTap: () => _copyLink(handle)),
            ] else
              const _NoHandleState(),
          ],
        ),
      ),
    );
  }
}

/// Champ de saisie du montant demandé (optionnel).
class _AmountField extends StatelessWidget {
  final TextEditingController controller;

  const _AmountField({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: AppColors.quinoaDark.withValues(alpha: 0.08),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              style: const TextStyle(
                color: AppColors.quinoaDark,
                fontSize: 20,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.3,
              ),
              cursorColor: AppColors.quinoaGold,
              decoration: InputDecoration(
                hintText: RequestStrings.amountHint,
                hintStyle: TextStyle(
                  color: AppColors.quinoaDark.withValues(alpha: 0.25),
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
                border: InputBorder.none,
              ),
            ),
          ),
          Text(
            RequestStrings.amountUnit,
            style: TextStyle(
              color: AppColors.quinoaDark.withValues(alpha: 0.35),
              fontSize: 14,
              fontWeight: FontWeight.w700,
              letterSpacing: 1,
            ),
          ),
        ],
      ),
    );
  }
}

/// Carte QR code avec KinoaID copiable en dessous.
class _QrCard extends StatelessWidget {
  final String handle;
  final double? amount;
  final VoidCallback onCopyId;

  const _QrCard({
    required this.handle,
    required this.amount,
    required this.onCopyId,
  });

  @override
  Widget build(BuildContext context) {
    final payload = RequestStrings.qrPayload(handle, amount);

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: AppColors.quinoaDark.withValues(alpha: 0.07),
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.quinoaDark.withValues(alpha: 0.06),
                blurRadius: 24,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: QrImageView(
            data: payload,
            version: QrVersions.auto,
            size: 220,
            backgroundColor: AppColors.white,
            eyeStyle: const QrEyeStyle(
              eyeShape: QrEyeShape.square,
              color: AppColors.quinoaDark,
            ),
            dataModuleStyle: const QrDataModuleStyle(
              dataModuleShape: QrDataModuleShape.square,
              color: AppColors.quinoaDark,
            ),
          ),
        ),
        const SizedBox(height: 20),
        // KinoaID copiable sous le QR.
        GestureDetector(
          onTap: onCopyId,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                handle,
                style: const TextStyle(
                  color: AppColors.quinoaDark,
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(width: 8),
              Icon(
                Icons.copy_rounded,
                size: 16,
                color: AppColors.quinoaDark.withValues(alpha: 0.3),
              ),
            ],
          ),
        ),
        const SizedBox(height: 4),
        Text(
          RequestStrings.qrIdLabel,
          style: TextStyle(
            color: AppColors.quinoaDark.withValues(alpha: 0.35),
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

/// Bouton principal de partage du lien de paiement.
class _ShareButton extends StatelessWidget {
  final VoidCallback onTap;

  const _ShareButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 18),
        decoration: BoxDecoration(
          color: AppColors.quinoaDark,
          borderRadius: BorderRadius.circular(18),
        ),
        child: const Text(
          RequestStrings.shareBtn,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: AppColors.white,
            fontSize: 15,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }
}

/// État affiché si le KinoaID n'est pas encore disponible sur le compte.
class _NoHandleState extends StatelessWidget {
  const _NoHandleState();

  @override
  Widget build(BuildContext context) {
    return Text(
      RequestStrings.noHandle,
      style: TextStyle(
        color: AppColors.quinoaDark.withValues(alpha: 0.35),
        fontSize: 14,
      ),
    );
  }
}
