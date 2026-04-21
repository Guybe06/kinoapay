import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:qr_flutter/qr_flutter.dart";
import "package:share_plus/share_plus.dart";
import "package:solar_icons/solar_icons.dart";
import "package:kinoapay_app/core/constants/app_colors.dart";
import "package:kinoapay_app/core/helpers/screen_size_helper.dart";
import "package:kinoapay_app/core/navigation/presentation/widgets/app_back_header.dart";
import "package:kinoapay_app/core/widgets/app_scroll_scaffold.dart";
import "package:kinoapay_app/core/widgets/app_snack_bar.dart";
import "package:kinoapay_app/core/widgets/app_page_title.dart";
import "package:kinoapay_app/features/accounts/application/bloc/auth_bloc.dart";
import "package:kinoapay_app/features/accounts/application/bloc/auth_state.dart";
import "package:kinoapay_app/features/dashboard/domain/entities/payment_channel.dart";
import "package:kinoapay_app/features/request/domain/request_strings.dart";
import "package:kinoapay_app/features/send/infrastructure/source_accounts_mock.dart";

/// Écran de demande de paiement : QR code + lien partageable via share sheet natif.
/// Le montant est optionnel. Le canal de réception est sélectionnable.
class RequestView extends StatefulWidget {
  const RequestView({super.key});

  @override
  State<RequestView> createState() => _RequestViewState();
}

class _RequestViewState extends State<RequestView> {
  final _amountCtrl = TextEditingController();
  double? _amount;
  PaymentChannel? _selectedChannel;

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

  /// Ouvre le share sheet natif (WhatsApp, Messages, Mail, etc.).
  Future<void> _shareLink(String handle) async {
    final message = RequestStrings.shareMessage(
      handle,
      _amount,
      _selectedChannel?.type,
    );
    final link = RequestStrings.payLink(
      handle,
      _amount,
      _selectedChannel?.type,
    );
    await SharePlus.instance.share(
      ShareParams(
        text: message,
        uri: Uri.parse(link),
        subject: RequestStrings.shareSubject,
      ),
    );
  }

  Future<void> _copyLink(String handle) async {
    final link = RequestStrings.payLink(
      handle,
      _amount,
      _selectedChannel?.type,
    );
    await Clipboard.setData(ClipboardData(text: link));
    if (!mounted) return;
    AppSnackBar.showSuccess(context, RequestStrings.linkCopied);
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
      builder: (_, ctrl) {
        final compact = ScreenSizeHelper.isCompact(context);
        return SingleChildScrollView(
          controller: ctrl,
          padding: EdgeInsets.fromLTRB(
            24,
            72,
            24,
            ScreenSizeHelper.adaptiveValue(
              context,
              compact: 100,
              small: 110,
              medium: 115,
              large: 120,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: compact ? 4 : 8),
              const AppPageTitle(
                title: RequestStrings.pageTitle,
                subtitle: RequestStrings.pageSubtitle,
              ),
              SizedBox(height: compact ? 28 : 36),
              _AmountField(controller: _amountCtrl, compact: compact),
              SizedBox(height: compact ? 12 : 16),
              _ChannelSelector(
                selected: _selectedChannel,
                onChanged: (ch) => setState(() => _selectedChannel = ch),
                compact: compact,
              ),
              SizedBox(height: compact ? 32 : 40),
              if (handle != null) ...[
                _QrCard(
                  handle: handle,
                  amount: _amount,
                  onCopyId: () => _copyId(handle),
                  compact: compact,
                ),
                SizedBox(height: compact ? 24 : 28),
                _ShareButton(onTap: () => _shareLink(handle), compact: compact),
                SizedBox(height: compact ? 10 : 12),
                _CopyLinkButton(onTap: () => _copyLink(handle)),
              ] else
                const _NoHandleState(),
            ],
          ),
        );
      },
    );
  }
}

/// Sélecteur du canal de réception souhaité (MTN, Airtel…).
class _ChannelSelector extends StatelessWidget {
  final PaymentChannel? selected;
  final ValueChanged<PaymentChannel?> onChanged;
  final bool compact;

  const _ChannelSelector({
    required this.selected,
    required this.onChanged,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showSheet(context),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: AppColors.quinoaDark.withValues(alpha: 0.08),
          ),
        ),
        child: Row(
          children: [
            Icon(
              SolarIconsOutline.cardReceive,
              size: 18,
              color: AppColors.quinoaDark.withValues(alpha: 0.45),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                selected?.label ?? RequestStrings.channelHint,
                style: TextStyle(
                  color: selected != null
                      ? AppColors.quinoaDark
                      : AppColors.quinoaDark.withValues(alpha: 0.35),
                  fontSize: 15,
                  fontWeight: selected != null
                      ? FontWeight.w700
                      : FontWeight.w400,
                ),
              ),
            ),
            Icon(
              SolarIconsOutline.altArrowDown,
              size: 16,
              color: AppColors.quinoaDark.withValues(alpha: 0.3),
            ),
          ],
        ),
      ),
    );
  }

  void _showSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(24, compact ? 16 : 20, 24, 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                RequestStrings.channelLabel,
                style: TextStyle(
                  color: AppColors.quinoaDark.withValues(alpha: 0.45),
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.8,
                ),
              ),
              SizedBox(height: compact ? 10 : 16),
              ...SourceAccountsMock.list.map((ch) {
                final isSelected = ch == selected;
                return GestureDetector(
                  onTap: () {
                    onChanged(ch);
                    Navigator.pop(context);
                  },
                  child: Container(
                    margin: EdgeInsets.only(bottom: compact ? 6 : 8),
                    padding: EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: compact ? 10 : 14,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.quinoaDark.withValues(alpha: 0.06)
                          : AppColors.stone50,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                ch.label,
                                style: TextStyle(
                                  color: AppColors.quinoaDark,
                                  fontSize: 14,
                                  fontWeight: isSelected
                                      ? FontWeight.w700
                                      : FontWeight.w500,
                                ),
                              ),
                              Text(
                                ch.value,
                                style: TextStyle(
                                  color: AppColors.quinoaDark.withValues(
                                    alpha: 0.4,
                                  ),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (isSelected)
                          const Icon(
                            SolarIconsOutline.checkCircle,
                            size: 18,
                            color: AppColors.quinoaGold,
                          ),
                      ],
                    ),
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}

/// Champ de saisie du montant demandé (optionnel).
class _AmountField extends StatelessWidget {
  final TextEditingController controller;
  final bool compact;

  const _AmountField({required this.controller, this.compact = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.quinoaDark.withValues(alpha: 0.08)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              style: TextStyle(
                color: AppColors.quinoaDark,
                fontSize: compact ? 18 : 20,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.3,
              ),
              cursorColor: AppColors.quinoaGold,
              decoration: InputDecoration(
                hintText: RequestStrings.amountHint,
                hintStyle: TextStyle(
                  color: AppColors.quinoaDark.withValues(alpha: 0.25),
                  fontSize: compact ? 14 : 16,
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
              fontSize: compact ? 13 : 14,
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
  final bool compact;

  const _QrCard({
    required this.handle,
    required this.amount,
    required this.onCopyId,
    this.compact = false,
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
            size: compact ? 180 : 220,
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
        SizedBox(height: compact ? 16 : 20),
        GestureDetector(
          onTap: onCopyId,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                handle,
                style: TextStyle(
                  color: AppColors.quinoaDark,
                  fontSize: compact ? 18 : 20,
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
            fontSize: compact ? 11 : 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

/// Bouton principal : ouvre le share sheet natif (WhatsApp, Messages, Mail…).
class _ShareButton extends StatelessWidget {
  final VoidCallback onTap;
  final bool compact;

  const _ShareButton({required this.onTap, this.compact = false});

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
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              SolarIconsOutline.shareCircle,
              color: AppColors.white,
              size: 18,
            ),
            const SizedBox(width: 10),
            const Text(
              RequestStrings.shareBtn,
              style: TextStyle(
                color: AppColors.white,
                fontSize: 15,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Bouton secondaire : copie le lien brut dans le presse-papier.
class _CopyLinkButton extends StatelessWidget {
  final VoidCallback onTap;

  const _CopyLinkButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: AppColors.quinoaDark.withValues(alpha: 0.06),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.copy_rounded,
              size: 16,
              color: AppColors.quinoaDark.withValues(alpha: 0.6),
            ),
            const SizedBox(width: 8),
            Text(
              RequestStrings.copyLinkBtn,
              style: TextStyle(
                color: AppColors.quinoaDark.withValues(alpha: 0.7),
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
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
