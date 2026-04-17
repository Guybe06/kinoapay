import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:intl/intl.dart";
import "package:solar_icons/solar_icons.dart";
import "package:kinoapay_app/core/constants/app_colors.dart";
import "package:kinoapay_app/core/constants/app_routes.dart";
import "package:kinoapay_app/features/send/application/bloc/send_bloc.dart";
import "package:kinoapay_app/features/send/application/bloc/send_event.dart";
import "package:kinoapay_app/features/send/application/bloc/send_state.dart";
import "package:kinoapay_app/features/send/domain/entities/transfer_quote.dart";
import "package:kinoapay_app/features/send/domain/send_strings.dart";
import "package:kinoapay_app/core/widgets/primary_button.dart";
import "package:kinoapay_app/core/navigation/presentation/widgets/app_header.dart";
import "package:kinoapay_app/features/accounts/presentation/widgets/auth_snack_bar.dart";
import "package:kinoapay_app/features/dashboard/domain/entities/payment_channel.dart";

/// Vue d'envoi : 3 étapes séquentielles — montant → destinataire → canal.
class SendView extends StatefulWidget {
  const SendView({super.key});

  @override
  State<SendView> createState() => _SendViewState();
}

enum _SendStep { amount, recipient, channel }

class _SendViewState extends State<SendView> {
  final _amountCtrl = TextEditingController(text: "0");
  final _recipientCtrl = TextEditingController();
  final _recipientFocus = FocusNode();

  _SendStep _step = _SendStep.amount;
  PaymentChannel? _selectedSourceChannel;
  PaymentChannel? _selectedDestChannel;
  List<PaymentChannel> _foundChannels = [];
  String? _recipientName;
  List<({String name, List<PaymentChannel> channels})> _foundRecipients = [];

  final List<PaymentChannel> _userAccounts = const [
    PaymentChannel(
      id: "src_mtn",
      type: "MTN Mobile Money",
      label: "MTN Money",
      value: "+237 6XX XXX XXX",
      short: "MTN",
      status: "active",
    ),
    PaymentChannel(
      id: "src_orange",
      type: "Orange Money",
      label: "Orange Money",
      value: "+237 6XX XXX XXX",
      short: "Orange",
      status: "active",
    ),
    PaymentChannel(
      id: "src_airtel",
      type: "Airtel Money",
      label: "Airtel Money",
      value: "+242 05 XX XX XX",
      short: "Airtel",
      status: "active",
    ),
    PaymentChannel(
      id: "src_visa",
      type: "Visa Card",
      label: "Visa •••• 4242",
      value: "•••• 4242",
      short: "Visa",
      status: "active",
    ),
    PaymentChannel(
      id: "src_mastercard",
      type: "Mastercard",
      label: "Mastercard •••• 8888",
      value: "•••• 8888",
      short: "MC",
      status: "active",
    ),
  ];

  @override
  void dispose() {
    _amountCtrl.dispose();
    _recipientCtrl.dispose();
    _recipientFocus.dispose();
    super.dispose();
  }

  String _rawAmount = "0";

  double get _amount => double.tryParse(_rawAmount) ?? 0;

  void _onKey(String key) {
    setState(() {
      if (key == "⌫") {
        if (_rawAmount.length > 1) {
          _rawAmount = _rawAmount.substring(0, _rawAmount.length - 1);
        } else {
          _rawAmount = "0";
        }
      } else if (key == ".") {
        if (!_rawAmount.contains(".")) _rawAmount += ".";
      } else {
        if (_rawAmount == "0") {
          _rawAmount = key;
        } else {
          _rawAmount += key;
        }
      }
      _amountCtrl.text = _rawAmount;
    });
  }

  void _confirmAmount() {
    if (_amount <= 0) {
      AuthSnackBar.showError(context, SendStrings.errorNoAmount);
      return;
    }
    setState(() => _step = _SendStep.recipient);
    Future.delayed(
      const Duration(milliseconds: 100),
      _recipientFocus.requestFocus,
    );
  }

  void _selectUser(String name, List<PaymentChannel> channels) {
    setState(() {
      _recipientName = name;
      _foundChannels = channels;
      _selectedDestChannel = null;
      _selectedSourceChannel = null;
      _step = _SendStep.channel;
    });
  }

  void _onRecipientChanged(String value) {
    final trimmed = value.trim();
    final clean = trimmed.replaceAll(" ", "");
    // Recherche auto: ID Kinoa (@ + 3+ caractères) OU numéro (3+ chiffres)
    // Le @ n'est pas compté dans les 3 caractères
    final isId = trimmed.startsWith("@") && clean.length >= 4; // @ + 3
    final isPhone = !trimmed.startsWith("@") && clean.length >= 3;
    if (isId || isPhone) {
      context.read<SendBloc>().add(SendRecipientSearched(trimmed));
    }
  }

  void _clearRecipient() {
    setState(() {
      _recipientName = null;
      _foundChannels = [];
      _foundRecipients = [];
      _selectedDestChannel = null;
      _step = _SendStep.recipient;
    });
    // Garde le texte de recherche pour permettre la modification
    Future.delayed(
      const Duration(milliseconds: 100),
      _recipientFocus.requestFocus,
    );
  }

  void _confirmTransfer() {
    if (_selectedSourceChannel == null) {
      AuthSnackBar.showError(context, "Sélectionnez un compte à débiter.");
      return;
    }
    if (_selectedDestChannel == null) {
      AuthSnackBar.showError(context, SendStrings.errorNoChannel);
      return;
    }
    context.read<SendBloc>().add(
      SendQuoteRequested(
        recipientIdentifier: _recipientCtrl.text.trim(),
        amount: _amount,
        sourceChannel: _selectedSourceChannel!.type,
        destinationChannel: _selectedDestChannel!.type,
      ),
    );
  }

  void _showSimulator() {
    if (_selectedDestChannel == null) {
      AuthSnackBar.showError(context, SendStrings.errorNoChannel);
      return;
    }
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.white,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      builder: (_) => _CalculatorSheet(
        amount: _amount,
        source: _selectedSourceChannel?.type ?? "",
        dest: _selectedDestChannel!.type,
        onConfirm: _confirmTransfer,
      ),
    );
  }

  void _goBack() {
    if (_step == _SendStep.channel) {
      setState(() {
        _step = _SendStep.recipient;
        _foundChannels = [];
        _foundRecipients = [];
        _selectedDestChannel = null;
      });
    } else if (_step == _SendStep.recipient) {
      setState(() {
        _step = _SendStep.amount;
        _recipientCtrl.clear();
        _recipientName = null;
        _foundRecipients = [];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SendBloc, SendState>(
      listener: (context, state) {
        if (state is SendRecipientFound) {
          // Affiche la liste des résultats pour sélection
          setState(() {
            _foundRecipients = state.recipients
                .map((r) => (name: r.name, channels: r.channels))
                .toList();
          });
        }
        if (state is SendSuccess) {
          Navigator.pushNamed(
            context,
            AppRoutes.receipt,
            arguments: state.transaction,
          );
          context.read<SendBloc>().add(SendReset());
          _amountCtrl.text = "0";
          _recipientCtrl.clear();
          setState(() {
            _step = _SendStep.amount;
            _foundChannels = [];
            _foundRecipients = [];
            _recipientName = null;
          });
        } else if (state is SendError) {
          AuthSnackBar.showError(context, state.exception.message);
        }
      },
      builder: (context, state) {
        if (state is SendQuoteReady) return _QuoteStep(quote: state.quote);
        if (state is SendConfirming) return const _ProcessingStep();

        return Scaffold(
          backgroundColor: AppColors.quinoaCream,
          appBar: const AppHeader(),
          body: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 20, 24, 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (_step != _SendStep.amount)
                  GestureDetector(
                    onTap: _goBack,
                    child: Container(
                      width: 36,
                      height: 36,
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: AppColors.quinoaDark.withValues(alpha: 0.07),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        SolarIconsOutline.altArrowLeft,
                        size: 18,
                      ),
                    ),
                  ),
                const Text(
                  SendStrings.pageTitle,
                  style: TextStyle(
                    color: AppColors.quinoaDark,
                    fontSize: 28,
                    fontWeight: FontWeight.w900,
                    letterSpacing: -0.8,
                    height: 1.1,
                  ),
                ),
                const SizedBox(height: 6),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 250),
                  child: Column(
                    key: ValueKey(_step),
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _step == _SendStep.amount
                            ? SendStrings.stepAmountTitle
                            : _step == _SendStep.recipient
                            ? SendStrings.stepRecipientTitle
                            : SendStrings.stepChannelTitle,
                        style: const TextStyle(
                          color: AppColors.textMuted,
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          height: 1.4,
                        ),
                      ),
                      if (_step == _SendStep.amount) ...[
                        const SizedBox(height: 2),
                        Text(
                          SendStrings.stepAmountSub,
                          style: TextStyle(
                            color: AppColors.quinoaDark.withValues(alpha: 0.4),
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 28),

                if (_step == _SendStep.amount) ...[
                  _NumpadAmountScreen(
                    rawAmount: _rawAmount,
                    onKey: _onKey,
                    onConfirm: _confirmAmount,
                  ),
                ] else ...[
                  _AmountInput(rawAmount: _rawAmount, enabled: false),
                ],

                if (_step == _SendStep.recipient ||
                    _step == _SendStep.channel) ...[
                  const SizedBox(height: 32),
                  _RecipientSearchField(
                    controller: _recipientCtrl,
                    focusNode: _recipientFocus,
                    onChanged: _onRecipientChanged,
                    onClear: _clearRecipient,
                    isLoading: state is SendLoading,
                    resolvedName: _recipientName,
                    enabled: _step == _SendStep.recipient,
                  ),
                  // Liste des résultats de recherche
                  if (_foundRecipients.isNotEmpty &&
                      _recipientName == null) ...[
                    const SizedBox(height: 16),
                    _RecipientsList(
                      recipients: _foundRecipients,
                      onSelect: (recipient) {
                        _selectUser(recipient.name, recipient.channels);
                        setState(() => _foundRecipients = []);
                      },
                    ),
                  ],
                ],

                if (_step == _SendStep.channel) ...[
                  const SizedBox(height: 28),
                  _AccountDropdown(
                    label: SendStrings.chooseSource,
                    value: _selectedSourceChannel,
                    accounts: _userAccounts,
                    onChanged: (ch) =>
                        setState(() => _selectedSourceChannel = ch),
                  ),
                  if (_foundChannels.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    _AccountDropdown(
                      label: SendStrings.chooseChannel,
                      value: _selectedDestChannel,
                      accounts: _foundChannels,
                      onChanged: (ch) =>
                          setState(() => _selectedDestChannel = ch),
                    ),
                  ],
                  const SizedBox(height: 28),
                  SizedBox(
                    width: double.infinity,
                    height: 64,
                    child: ElevatedButton.icon(
                      onPressed: _showSimulator,
                      icon: const Icon(SolarIconsOutline.chartSquare, size: 20),
                      label: const Text(
                        SendStrings.simulateBtn,
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.quinoaDark,
                        foregroundColor: AppColors.white,
                        elevation: 0,
                        splashFactory: NoSplash.splashFactory,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(24),
                            bottomLeft: Radius.circular(24),
                            bottomRight: Radius.circular(24),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}

class _AccountDropdown extends StatelessWidget {
  final String label;
  final PaymentChannel? value;
  final List<PaymentChannel> accounts;
  final ValueChanged<PaymentChannel?> onChanged;

  const _AccountDropdown({
    required this.label,
    required this.value,
    required this.accounts,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            label,
            style: TextStyle(
              color: AppColors.quinoaDark.withValues(alpha: 0.55),
              fontSize: 11,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.2,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: AppColors.quinoaDark.withValues(alpha: 0.08),
              width: 1.5,
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<PaymentChannel>(
              value: value,
              isExpanded: true,
              hint: const Text(
                "Sélectionner",
                style: TextStyle(
                  color: AppColors.textMuted,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
              icon: const Icon(
                SolarIconsOutline.altArrowDown,
                color: AppColors.quinoaDark,
                size: 20,
              ),
              borderRadius: BorderRadius.circular(20),
              items: accounts.map((ch) {
                return DropdownMenuItem<PaymentChannel>(
                  value: ch,
                  child: Row(
                    children: [
                      Container(
                        width: 32,
                        height: 32,
                        decoration: const BoxDecoration(
                          color: AppColors.stone100,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          SolarIconsOutline.card,
                          color: AppColors.stone400,
                          size: 16,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            ch.type,
                            style: const TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            ch.value,
                            style: const TextStyle(
                              color: AppColors.textMuted,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              }).toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }
}

class _RecipientSearchField extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onClear;
  final bool isLoading;
  final String? resolvedName;
  final bool enabled;

  const _RecipientSearchField({
    required this.controller,
    required this.focusNode,
    required this.isLoading,
    this.onChanged,
    this.onClear,
    this.resolvedName,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: controller,
                  focusNode: focusNode,
                  enabled: enabled,
                  onChanged: onChanged,
                  textInputAction: TextInputAction.done,
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 16,
                  ),
                  decoration: InputDecoration(
                    hintText: SendStrings.recipientHint,
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                    suffixIcon: isLoading
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: AppColors.quinoaDark,
                            ),
                          )
                        : null,
                  ),
                ),
              ),
            ],
          ),
          if (resolvedName != null) ...[
            const SizedBox(height: 12),
            const Divider(height: 1),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(
                  SolarIconsOutline.checkCircle,
                  color: AppColors.success,
                  size: 16,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    resolvedName!,
                    style: const TextStyle(
                      color: AppColors.success,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: onClear,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.quinoaDark.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      "Modifier",
                      style: TextStyle(
                        color: AppColors.quinoaDark,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

/// Liste des résultats de recherche de destinataires
class _RecipientsList extends StatelessWidget {
  final List<({String name, List<PaymentChannel> channels})> recipients;
  final void Function(({String name, List<PaymentChannel> channels})) onSelect;

  const _RecipientsList({required this.recipients, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.quinoaDark.withValues(alpha: 0.08),
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              "${recipients.length} contact${recipients.length > 1 ? 's' : ''} trouvé${recipients.length > 1 ? 's' : ''}",
              style: TextStyle(
                color: AppColors.quinoaDark.withValues(alpha: 0.6),
                fontSize: 11,
                fontWeight: FontWeight.w900,
                letterSpacing: 1,
              ),
            ),
          ),
          const Divider(height: 1),
          ...recipients.map(
            (r) => GestureDetector(
              onTap: () => onSelect(r),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: AppColors.quinoaDark.withValues(alpha: 0.06),
                      width: 1,
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: AppColors.quinoaGold.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Center(
                        child: Text(
                          r.name.substring(0, 1).toUpperCase(),
                          style: const TextStyle(
                            color: AppColors.quinoaGold,
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            r.name,
                            style: const TextStyle(
                              color: AppColors.quinoaDark,
                              fontSize: 15,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            "${r.channels.length} compte${r.channels.length > 1 ? 's' : ''}",
                            style: TextStyle(
                              color: AppColors.quinoaDark.withValues(
                                alpha: 0.5,
                              ),
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(
                      SolarIconsOutline.altArrowRight,
                      color: AppColors.quinoaGold,
                      size: 20,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CalculatorSheet extends StatelessWidget {
  final double amount;
  final String source;
  final String dest;
  final VoidCallback onConfirm;

  const _CalculatorSheet({
    required this.amount,
    required this.source,
    required this.dest,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    final fmt = NumberFormat("#,##0", "en_US");
    final kf = amount * 0.01;
    final of = amount * 0.03;

    return Padding(
      padding: EdgeInsets.fromLTRB(
        32,
        32,
        32,
        MediaQuery.of(context).padding.bottom + 32,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            "Simulation des frais",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 4),
          const Text(
            "Montants en XAF",
            style: TextStyle(
              color: AppColors.textMuted,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 24),
          _CalcRow(label: "Montant", value: fmt.format(amount)),
          _CalcRow(label: "Frais Kinoa (1%)", value: fmt.format(kf)),
          _CalcRow(label: "Frais $dest (3%)", value: fmt.format(of)),
          const Divider(height: 32),
          _CalcRow(
            label: "Total estimé",
            value: fmt.format(amount + kf + of),
            isBold: true,
          ),
          const SizedBox(height: 32),
          PrimaryButton(
            text: SendStrings.continueBtn,
            onPressed: () {
              Navigator.pop(context);
              onConfirm();
            },
          ),
          const SizedBox(height: 12),
          PrimaryButton(
            text: "Annuler",
            isSecondary: true,
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }
}

class _CalcRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isBold;
  const _CalcRow({
    required this.label,
    required this.value,
    this.isBold = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: AppColors.textMuted,
              fontWeight: isBold ? FontWeight.w800 : FontWeight.w500,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontWeight: isBold ? FontWeight.w900 : FontWeight.w700,
              fontSize: isBold ? 16 : 14,
            ),
          ),
        ],
      ),
    );
  }
}

class _AmountInput extends StatelessWidget {
  final String rawAmount;
  final bool enabled;

  const _AmountInput({required this.rawAmount, this.enabled = true});

  static final _fmt = NumberFormat("#,##0.########", "en_US");

  String get _display {
    if (rawAmount == "0" || rawAmount.isEmpty) return "0";
    final n = double.tryParse(rawAmount);
    if (n == null) return rawAmount;
    if (rawAmount.endsWith(".")) return "${_fmt.format(n)}.";
    final parts = rawAmount.split(".");
    if (parts.length == 2) {
      return "${_fmt.format(n).split(".").first}.${parts[1]}";
    }
    return _fmt.format(n);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          "MONTANT",
          style: TextStyle(
            color: AppColors.textMuted,
            fontSize: 11,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.5,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text(
              _display,
              style: TextStyle(
                color: AppColors.quinoaDark.withValues(alpha: 0.45),
                fontSize: 48,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(width: 8),
            const Text(
              "XAF",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
            ),
          ],
        ),
      ],
    );
  }
}

class _NumpadAmountScreen extends StatelessWidget {
  final String rawAmount;
  final ValueChanged<String> onKey;
  final VoidCallback onConfirm;

  const _NumpadAmountScreen({
    required this.rawAmount,
    required this.onKey,
    required this.onConfirm,
  });

  static final _displayFmt = NumberFormat("#,##0.########", "en_US");

  static const _keys = [
    ["1", "2", "3"],
    ["4", "5", "6"],
    ["7", "8", "9"],
    [".", "0", "⌫"],
  ];

  @override
  Widget build(BuildContext context) {
    String buildDisplay() {
      if (rawAmount == "0") return "0";
      final num = double.tryParse(rawAmount);
      if (num == null) return rawAmount;
      if (rawAmount.endsWith(".")) {
        return "${_displayFmt.format(num)}.";
      }
      final parts = rawAmount.split(".");
      if (parts.length == 2) {
        return "${_displayFmt.format(num).split(".").first}.${parts[1]}";
      }
      return _displayFmt.format(num);
    }

    final display = buildDisplay();

    return Column(
      children: [
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text(
              display,
              style: TextStyle(
                color: rawAmount == "0"
                    ? AppColors.quinoaDark.withValues(alpha: 0.25)
                    : AppColors.quinoaDark,
                fontSize: 52,
                fontWeight: FontWeight.w900,
                letterSpacing: -1,
              ),
            ),
            const SizedBox(width: 10),
            const Text(
              "XAF",
              style: TextStyle(
                color: AppColors.textMuted,
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
        const SizedBox(height: 32),
        ...List.generate(_keys.length, (row) {
          return Row(
            children: List.generate(_keys[row].length, (col) {
              final key = _keys[row][col];
              final isBackspace = key == "⌫";
              return Expanded(
                child: AspectRatio(
                  aspectRatio: 1.4,
                  child: GestureDetector(
                    onTap: () => onKey(key),
                    child: Container(
                      margin: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: isBackspace
                            ? AppColors.quinoaDark.withValues(alpha: 0.06)
                            : AppColors.white,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: isBackspace
                            ? const Icon(
                                SolarIconsOutline.backspace,
                                size: 18,
                                color: AppColors.quinoaDark,
                              )
                            : Text(
                                key,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.quinoaDark,
                                ),
                              ),
                      ),
                    ),
                  ),
                ),
              );
            }),
          );
        }),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6),
          child: PrimaryButton(
            text: SendStrings.continueBtn,
            onPressed: onConfirm,
          ),
        ),
      ],
    );
  }
}

class _QuoteStep extends StatelessWidget {
  final TransferQuote quote;
  const _QuoteStep({required this.quote});

  @override
  Widget build(BuildContext context) {
    final fmt = NumberFormat("#,###", "fr_FR");
    return Scaffold(
      backgroundColor: AppColors.quinoaCream,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                SendStrings.confirmTitle,
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900),
              ),
              const SizedBox(height: 32),
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(32),
                ),
                child: Column(
                  children: [
                    _InfoRow(label: "Vers", value: quote.recipientName),
                    const Divider(height: 32),
                    _InfoRow(
                      label: "Frais Kinoa",
                      value: "${fmt.format(quote.platformFee)} XAF",
                    ),
                    _InfoRow(
                      label: "Frais Opérateur",
                      value: "${fmt.format(quote.operatorFee)} XAF",
                    ),
                    const Divider(height: 32),
                    _InfoRow(
                      label: "Total",
                      value: "${fmt.format(quote.amountDebited)} XAF",
                      isBold: true,
                    ),
                  ],
                ),
              ),
              const Spacer(),
              PrimaryButton(
                text: "Confirmer",
                onPressed: () => context.read<SendBloc>().add(
                  SendConfirmRequested(quote.quoteId),
                ),
              ),
              const SizedBox(height: 12),
              PrimaryButton(
                text: "Annuler",
                isSecondary: true,
                onPressed: () => context.read<SendBloc>().add(SendReset()),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isBold;
  const _InfoRow({
    required this.label,
    required this.value,
    this.isBold = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: AppColors.textMuted,
              fontWeight: isBold ? FontWeight.w800 : FontWeight.w500,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontWeight: isBold ? FontWeight.w900 : FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _ProcessingStep extends StatelessWidget {
  const _ProcessingStep();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.quinoaCream,
      body: Center(
        child: CircularProgressIndicator(color: AppColors.quinoaGold),
      ),
    );
  }
}
