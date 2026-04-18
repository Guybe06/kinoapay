import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:solar_icons/solar_icons.dart";
import "package:kinoapay_app/core/constants/app_colors.dart";
import "package:kinoapay_app/core/constants/app_routes.dart";
import "package:kinoapay_app/core/navigation/presentation/widgets/app_header.dart";
import "package:kinoapay_app/features/accounts/presentation/widgets/auth_snack_bar.dart";
import "package:kinoapay_app/features/contacts/domain/entities/contact.dart"
    hide PaymentChannel;
import "package:kinoapay_app/features/dashboard/domain/entities/payment_channel.dart";
import "package:kinoapay_app/features/send/application/bloc/send_bloc.dart";
import "package:kinoapay_app/features/send/application/bloc/send_event.dart";
import "package:kinoapay_app/features/send/application/bloc/send_state.dart";
import "package:kinoapay_app/features/send/domain/entities/recipient_match.dart";
import "package:kinoapay_app/features/send/domain/send_strings.dart";
import "package:kinoapay_app/features/send/infrastructure/source_accounts_mock.dart";
import "package:kinoapay_app/features/send/presentation/widgets/processing_step.dart";
import "package:kinoapay_app/features/send/presentation/widgets/quote_confirmation_step.dart";
import "package:kinoapay_app/features/send/presentation/widgets/recipient_by_id_view.dart";
import "package:kinoapay_app/features/send/presentation/widgets/recipient_by_phone_view.dart";
import "package:kinoapay_app/features/send/presentation/widgets/recipient_compact_card.dart";

/// Étapes séquentielles du flux d'envoi : destinataire → montant → (confirm via BLoC).
enum SendStep { recipient, amount }

/// Mode de recherche du destinataire.
enum RecipientSearchMode { phone, id }

/// Vue racine d'envoi d'argent : orchestre les étapes et délègue l'UI aux widgets dédiés.
class SendView extends StatefulWidget {
  const SendView({super.key});

  @override
  State<SendView> createState() => _SendViewState();
}

class _SendViewState extends State<SendView> {
  static const String _idPrefix = "@";
  static const Duration _focusDelay = Duration(milliseconds: 200);
  static const Duration _refocusDelay = Duration(milliseconds: 100);

  final TextEditingController _phoneCtrl = TextEditingController();
  final TextEditingController _idCtrl = TextEditingController();
  final TextEditingController _amountCtrl = TextEditingController();
  final FocusNode _phoneFocus = FocusNode();
  final FocusNode _idFocus = FocusNode();
  final FocusNode _amountFocus = FocusNode();

  SendStep _step = SendStep.recipient;
  RecipientSearchMode _searchMode = RecipientSearchMode.phone;
  CountryCode _selectedCountry = RecipientByPhoneView.countryCodes.first;
  RecipientMatch? _selectedRecipient;
  PaymentChannel? _selectedSourceChannel;
  PaymentChannel? _selectedDestChannel;
  List<RecipientMatch> _foundRecipients = [];

  @override
  void initState() {
    super.initState();
    Future.delayed(_focusDelay, _phoneFocus.requestFocus);
  }

  @override
  void dispose() {
    _phoneCtrl.dispose();
    _idCtrl.dispose();
    _amountCtrl.dispose();
    _phoneFocus.dispose();
    _idFocus.dispose();
    _amountFocus.dispose();
    super.dispose();
  }

  TextEditingController get _activeCtrl =>
      _searchMode == RecipientSearchMode.phone ? _phoneCtrl : _idCtrl;

  FocusNode get _activeFocus =>
      _searchMode == RecipientSearchMode.phone ? _phoneFocus : _idFocus;

  double get _amount =>
      double.tryParse(_amountCtrl.text.replaceAll(" ", "")) ?? 0;

  // ── Recherche ───────────────────────────────────────────────────────────

  void _onPhoneChanged(String value) {
    final digits = value.replaceAll(RegExp(r"\D"), "");
    if (digits.length < RecipientByPhoneView.minPhoneDigits) {
      setState(() => _foundRecipients = []);
      return;
    }
    final fullQuery = "${_selectedCountry.dialCode}$digits";
    context.read<SendBloc>().add(SendRecipientSearched(fullQuery));
  }

  void _onIdChanged(String value) {
    final clean = value.trim();
    if (clean.length < RecipientByIdView.minIdChars) {
      setState(() => _foundRecipients = []);
      return;
    }
    context.read<SendBloc>().add(SendRecipientSearched("$_idPrefix$clean"));
  }

  void _switchSearchMode(RecipientSearchMode mode) {
    if (_searchMode == mode) return;
    setState(() {
      _searchMode = mode;
      _foundRecipients = [];
    });
    _phoneCtrl.clear();
    _idCtrl.clear();
    Future.delayed(_refocusDelay, _activeFocus.requestFocus);
  }

  // ── Sélection ───────────────────────────────────────────────────────────

  void _selectMatch(RecipientMatch match) {
    setState(() {
      _selectedRecipient = match;
      _selectedDestChannel = null;
      _selectedSourceChannel = null;
      _foundRecipients = [];
      _step = SendStep.amount;
    });
  }

  void _sendExternal() {
    final digits = _phoneCtrl.text.replaceAll(RegExp(r"\D"), "");
    if (digits.length < RecipientByPhoneView.minPhoneDigits) return;
    final fullPhone = "${_selectedCountry.dialCode} $digits";
    setState(() {
      _selectedRecipient = RecipientMatch(
        name: fullPhone,
        phone: fullPhone,
        channels: const [],
        isKinoaUser: false,
      );
      _selectedDestChannel = null;
      _selectedSourceChannel = null;
      _foundRecipients = [];
      _step = SendStep.amount;
    });
  }

  Future<void> _chooseContacts() async {
    final result = await Navigator.pushNamed(
      context,
      AppRoutes.contacts,
      arguments: const {"selectionMode": true},
    );
    if (result is Contact) _applySelectedContact(result);
  }

  void _applySelectedContact(Contact contact) {
    final cleanPhone = contact.phone.replaceAll(" ", "");
    _phoneCtrl.text = cleanPhone;
    _switchSearchMode(RecipientSearchMode.phone);
    context.read<SendBloc>().add(SendRecipientSearched(cleanPhone));
  }

  void _clearRecipient() {
    setState(() {
      _selectedRecipient = null;
      _selectedDestChannel = null;
      _selectedSourceChannel = null;
      _foundRecipients = [];
      _step = SendStep.recipient;
    });
    _phoneCtrl.clear();
    _idCtrl.clear();
    _amountCtrl.clear();
    Future.delayed(_refocusDelay, _activeFocus.requestFocus);
  }

  void _requestQuote() {
    if (_amount <= 0) {
      AuthSnackBar.showError(context, SendStrings.errorNoAmount);
      return;
    }
    if (_selectedSourceChannel == null) {
      AuthSnackBar.showError(context, SendStrings.errorNoSourceAccount);
      return;
    }
    final destType = _selectedDestChannel?.type ?? _selectedSourceChannel!.type;
    context.read<SendBloc>().add(
      SendQuoteRequested(
        recipientIdentifier: _activeCtrl.text.trim(),
        amount: _amount,
        sourceChannel: _selectedSourceChannel!.type,
        destinationChannel: destType,
      ),
    );
  }

  void _goBack() {
    if (_step == SendStep.amount) {
      setState(() {
        _step = SendStep.recipient;
        _selectedRecipient = null;
        _selectedDestChannel = null;
        _selectedSourceChannel = null;
      });
      _amountCtrl.clear();
      Future.delayed(_refocusDelay, _activeFocus.requestFocus);
    }
  }

  void _resetAll() {
    _phoneCtrl.clear();
    _idCtrl.clear();
    _amountCtrl.clear();
    setState(() {
      _step = SendStep.recipient;
      _searchMode = RecipientSearchMode.phone;
      _selectedRecipient = null;
      _foundRecipients = [];
      _selectedSourceChannel = null;
      _selectedDestChannel = null;
    });
  }

  // ── Build ───────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SendBloc, SendState>(
      listener: _onStateChanged,
      builder: (context, state) {
        if (state is SendQuoteReady) {
          return QuoteConfirmationStep(quote: state.quote);
        }
        if (state is SendConfirming) return const ProcessingStep();

        return Scaffold(
          backgroundColor: AppColors.quinoaCream,
          appBar: const AppHeader(),
          body: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 20, 24, 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildBackButton(),
                _buildHeader(),
                const SizedBox(height: 28),
                if (_step == SendStep.recipient)
                  _buildRecipientStep(state)
                else
                  _buildAmountStep(),
              ],
            ),
          ),
        );
      },
    );
  }

  void _onStateChanged(BuildContext context, SendState state) {
    if (state is SendRecipientFound) {
      setState(() => _foundRecipients = state.recipients);
    }
    if (state is SendSuccess) {
      Navigator.pushNamed(
        context,
        AppRoutes.receipt,
        arguments: state.transaction,
      );
      context.read<SendBloc>().add(SendReset());
      _resetAll();
    } else if (state is SendError) {
      setState(() => _foundRecipients = []);
      AuthSnackBar.showError(context, state.exception.message);
    }
  }

  Widget _buildBackButton() {
    if (_step == SendStep.recipient) return const SizedBox.shrink();
    return GestureDetector(
      onTap: _goBack,
      child: Container(
        width: 36,
        height: 36,
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: AppColors.quinoaDark.withValues(alpha: 0.07),
          shape: BoxShape.circle,
        ),
        child: const Icon(SolarIconsOutline.altArrowLeft, size: 18),
      ),
    );
  }

  Widget _buildHeader() {
    final isRecipient = _step == SendStep.recipient;
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 250),
      child: Column(
        key: ValueKey(_step),
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
          Text(
            isRecipient
                ? SendStrings.stepRecipientTitle
                : SendStrings.stepAmountTitle,
            style: const TextStyle(
              color: AppColors.textMuted,
              fontSize: 15,
              fontWeight: FontWeight.w500,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            isRecipient
                ? SendStrings.stepRecipientSub
                : SendStrings.stepAmountSub,
            style: TextStyle(
              color: AppColors.quinoaDark.withValues(alpha: 0.4),
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  // ── Step 1 : Destinataire ──────────────────────────────────────────────

  Widget _buildRecipientStep(SendState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSearchModeSwitcher(),
        const SizedBox(height: 16),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          child: _searchMode == RecipientSearchMode.phone
              ? RecipientByPhoneView(
                  key: const ValueKey("phone"),
                  controller: _phoneCtrl,
                  focusNode: _phoneFocus,
                  onChanged: _onPhoneChanged,
                  isLoading: state is SendLoading,
                  results: _foundRecipients,
                  onSelect: _selectMatch,
                  onSendExternal: _sendExternal,
                  onOpenContacts: _chooseContacts,
                  selectedCountry: _selectedCountry,
                  onCountryChanged: (c) => setState(() => _selectedCountry = c),
                )
              : RecipientByIdView(
                  key: const ValueKey("id"),
                  controller: _idCtrl,
                  focusNode: _idFocus,
                  onChanged: _onIdChanged,
                  isLoading: state is SendLoading,
                  results: _foundRecipients,
                  onSelect: _selectMatch,
                ),
        ),
      ],
    );
  }

  Widget _buildSearchModeSwitcher() {
    final isPhone = _searchMode == RecipientSearchMode.phone;
    return GestureDetector(
      onTap: () => _switchSearchMode(
        isPhone ? RecipientSearchMode.id : RecipientSearchMode.phone,
      ),
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: AppColors.quinoaDark.withValues(alpha: 0.06),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Stack(
          children: [
            AnimatedAlign(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut,
              alignment: isPhone ? Alignment.centerLeft : Alignment.centerRight,
              child: FractionallySizedBox(
                widthFactor: 0.5,
                child: Container(
                  height: 36,
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.quinoaDark.withValues(alpha: 0.06),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Row(
              children: [
                _buildSwitchLabel(
                  label: SendStrings.switchPhone,
                  isActive: isPhone,
                ),
                _buildSwitchLabel(
                  label: SendStrings.switchId,
                  isActive: !isPhone,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSwitchLabel({required String label, required bool isActive}) {
    return Expanded(
      child: SizedBox(
        height: 36,
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: isActive
                  ? AppColors.quinoaDark
                  : AppColors.quinoaDark.withValues(alpha: 0.35),
              fontSize: 13,
              fontWeight: isActive ? FontWeight.w800 : FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  // ── Step 2 : Montant + Canaux ──────────────────────────────────────────

  Widget _buildAmountStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (_selectedRecipient != null)
          RecipientCompactCard(
            recipient: _selectedRecipient!,
            onModify: _clearRecipient,
          ),
        const SizedBox(height: 20),
        _buildSourceSelect(),
        if (_selectedRecipient != null &&
            _selectedRecipient!.isKinoaUser &&
            _selectedRecipient!.channels.isNotEmpty) ...[
          const SizedBox(height: 16),
          _buildDestSelect(),
        ],
        const SizedBox(height: 24),
        _buildAmountInput(),
        const SizedBox(height: 32),
        _buildContinueButton(),
      ],
    );
  }

  Widget _buildSourceSelect() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          SendStrings.sourceLabel,
          style: TextStyle(
            color: AppColors.quinoaDark.withValues(alpha: 0.5),
            fontSize: 11,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.6,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: AppColors.quinoaDark.withValues(alpha: 0.10),
              width: 1,
            ),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<PaymentChannel>(
              value: _selectedSourceChannel,
              isExpanded: true,
              icon: Icon(
                SolarIconsOutline.altArrowDown,
                size: 16,
                color: AppColors.quinoaDark.withValues(alpha: 0.4),
              ),
              hint: Text(
                SendStrings.sourceLabel,
                style: TextStyle(
                  color: AppColors.quinoaDark.withValues(alpha: 0.3),
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ),
              ),
              dropdownColor: AppColors.white,
              borderRadius: BorderRadius.circular(16),
              items: SourceAccountsMock.list.map((ch) {
                return DropdownMenuItem<PaymentChannel>(
                  value: ch,
                  child: Text(
                    "${ch.label}  ${ch.value}",
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                );
              }).toList(),
              onChanged: (ch) => setState(() => _selectedSourceChannel = ch),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDestSelect() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          SendStrings.destLabel,
          style: TextStyle(
            color: AppColors.quinoaDark.withValues(alpha: 0.5),
            fontSize: 11,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.6,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: AppColors.quinoaDark.withValues(alpha: 0.10),
              width: 1,
            ),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<PaymentChannel>(
              value: _selectedDestChannel,
              isExpanded: true,
              icon: Icon(
                SolarIconsOutline.altArrowDown,
                size: 16,
                color: AppColors.quinoaDark.withValues(alpha: 0.4),
              ),
              hint: Text(
                SendStrings.destLabel,
                style: TextStyle(
                  color: AppColors.quinoaDark.withValues(alpha: 0.3),
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ),
              ),
              dropdownColor: AppColors.white,
              borderRadius: BorderRadius.circular(16),
              items: _selectedRecipient!.channels.map((ch) {
                return DropdownMenuItem<PaymentChannel>(
                  value: ch,
                  child: Text(
                    "${ch.label}  ${ch.value}",
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                );
              }).toList(),
              onChanged: (ch) => setState(() => _selectedDestChannel = ch),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAmountInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          SendStrings.amountDisplayLabel,
          style: TextStyle(
            color: AppColors.quinoaDark.withValues(alpha: 0.5),
            fontSize: 11,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.6,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: AppColors.quinoaDark.withValues(alpha: 0.10),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _amountCtrl,
                  focusNode: _amountFocus,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r"[0-9.]")),
                  ],
                  style: const TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 24,
                    color: AppColors.quinoaDark,
                  ),
                  decoration: InputDecoration(
                    hintText: SendStrings.amountHint,
                    hintStyle: TextStyle(
                      color: AppColors.quinoaDark.withValues(alpha: 0.15),
                      fontWeight: FontWeight.w900,
                      fontSize: 24,
                    ),
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ),
              Text(
                SendStrings.amountUnit,
                style: TextStyle(
                  color: AppColors.quinoaDark.withValues(alpha: 0.35),
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildContinueButton() {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: _requestQuote,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.quinoaDark,
          foregroundColor: AppColors.quinoaCream,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 0,
        ),
        child: const Text(
          SendStrings.continueBtn,
          style: TextStyle(fontWeight: FontWeight.w800, fontSize: 15),
        ),
      ),
    );
  }
}
