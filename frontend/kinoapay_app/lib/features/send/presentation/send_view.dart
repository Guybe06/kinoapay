import "package:flutter/material.dart";
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
import "package:kinoapay_app/features/send/presentation/widgets/account_dropdown.dart";
import "package:kinoapay_app/features/send/presentation/widgets/amount_display.dart";
import "package:kinoapay_app/features/send/presentation/widgets/calculator_sheet.dart";
import "package:kinoapay_app/features/send/presentation/widgets/method_choice_card.dart";
import "package:kinoapay_app/features/send/presentation/widgets/numpad_amount_screen.dart";
import "package:kinoapay_app/features/send/presentation/widgets/processing_step.dart";
import "package:kinoapay_app/features/send/presentation/widgets/quote_confirmation_step.dart";
import "package:kinoapay_app/features/send/presentation/widgets/recipient_search_field.dart";
import "package:kinoapay_app/features/send/presentation/widgets/recipients_results_list.dart";

/// Étapes séquentielles du flux d'envoi.
enum SendStep { amount, chooseMethod, recipient, channel }

/// Vue racine d'envoi d'argent : orchestre les étapes et délègue l'UI aux widgets dédiés.
class SendView extends StatefulWidget {
  const SendView({super.key});

  @override
  State<SendView> createState() => _SendViewState();
}

class _SendViewState extends State<SendView> {
  static const String _zero = "0";
  static const String _dot = ".";
  static const int _minSearchChars = 3;
  static const String _idPrefix = "@";
  static const Duration _focusDelay = Duration(milliseconds: 200);
  static const Duration _refocusDelay = Duration(milliseconds: 100);
  static final RegExp _nonQueryChars = RegExp(r"[^0-9@]");

  final TextEditingController _amountCtrl = TextEditingController(text: _zero);
  final TextEditingController _recipientCtrl = TextEditingController();
  final FocusNode _recipientFocus = FocusNode();

  SendStep _step = SendStep.amount;
  PaymentChannel? _selectedSourceChannel;
  PaymentChannel? _selectedDestChannel;
  List<PaymentChannel> _foundChannels = [];
  String? _recipientName;
  List<RecipientMatch> _foundRecipients = [];

  @override
  void dispose() {
    _amountCtrl.dispose();
    _recipientCtrl.dispose();
    _recipientFocus.dispose();
    super.dispose();
  }

  String _rawAmount = _zero;

  double get _amount => double.tryParse(_rawAmount) ?? 0;

  /// Applique une touche (chiffre, point ou backspace) au montant en cours.
  void _onKey(String key) {
    setState(() {
      if (key == SendStrings.backspaceSymbol) {
        _rawAmount = _rawAmount.length > 1
            ? _rawAmount.substring(0, _rawAmount.length - 1)
            : _zero;
      } else if (key == _dot) {
        if (!_rawAmount.contains(_dot)) _rawAmount = "$_rawAmount$_dot";
      } else {
        _rawAmount = _rawAmount == _zero ? key : "$_rawAmount$key";
      }
      _amountCtrl.text = _rawAmount;
    });
  }

  void _confirmAmount() {
    if (_amount <= 0) {
      AuthSnackBar.showError(context, SendStrings.errorNoAmount);
      return;
    }
    setState(() => _step = SendStep.chooseMethod);
  }

  void _chooseSearch() {
    setState(() => _step = SendStep.recipient);
    Future.delayed(_focusDelay, _recipientFocus.requestFocus);
  }

  Future<void> _chooseContacts() async {
    final result = await Navigator.pushNamed(
      context,
      AppRoutes.contacts,
      arguments: const {"selectionMode": true},
    );
    if (result is Contact) _applySelectedContact(result);
  }

  /// Applique un contact sélectionné : pré-remplit le champ et déclenche la recherche.
  void _applySelectedContact(Contact contact) {
    final cleanPhone = contact.phone.replaceAll(" ", "");
    _recipientCtrl.text = cleanPhone;
    setState(() => _step = SendStep.recipient);
    context.read<SendBloc>().add(SendRecipientSearched(cleanPhone));
  }

  void _selectMatch(RecipientMatch match) {
    setState(() {
      _recipientName = match.name;
      _foundChannels = match.channels;
      _selectedDestChannel = null;
      _selectedSourceChannel = null;
      _foundRecipients = [];
      _step = SendStep.channel;
    });
  }

  /// Relance la recherche après nettoyage de l'entrée ; vide les résultats si trop court.
  void _onRecipientChanged(String value) {
    final clean = value.replaceAll(_nonQueryChars, "");
    final required = clean.startsWith(_idPrefix)
        ? _minSearchChars + 1
        : _minSearchChars;
    if (clean.length < required) {
      setState(() => _foundRecipients = []);
      return;
    }
    context.read<SendBloc>().add(SendRecipientSearched(clean));
  }

  void _clearRecipient() {
    setState(() {
      _recipientName = null;
      _foundChannels = [];
      _foundRecipients = [];
      _selectedDestChannel = null;
      _step = SendStep.recipient;
    });
    Future.delayed(_refocusDelay, _recipientFocus.requestFocus);
  }

  void _confirmTransfer() {
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
    if (_selectedSourceChannel == null) {
      AuthSnackBar.showError(context, SendStrings.errorNoSourceAccount);
      return;
    }
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
      builder: (_) => CalculatorSheet(
        amount: _amount,
        source: _selectedSourceChannel!.type,
        dest: _selectedDestChannel!.type,
        onConfirm: _confirmTransfer,
      ),
    );
  }

  void _goBack() {
    if (_step == SendStep.channel) {
      setState(() {
        _step = SendStep.recipient;
        _foundChannels = [];
        _foundRecipients = [];
        _selectedDestChannel = null;
      });
    } else if (_step == SendStep.recipient) {
      setState(() {
        _step = SendStep.chooseMethod;
        _recipientCtrl.clear();
        _recipientName = null;
        _foundRecipients = [];
      });
    } else if (_step == SendStep.chooseMethod) {
      setState(() {
        _step = SendStep.amount;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SendBloc, SendState>(
      listener: (context, state) {
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
          _amountCtrl.text = _zero;
          _recipientCtrl.clear();
          setState(() {
            _step = SendStep.amount;
            _foundChannels = [];
            _foundRecipients = [];
            _recipientName = null;
          });
        } else if (state is SendError) {
          setState(() => _foundRecipients = []);
          AuthSnackBar.showError(context, state.exception.message);
        }
      },
      builder: (context, state) {
        if (state is SendQuoteReady)
          return QuoteConfirmationStep(quote: state.quote);
        if (state is SendConfirming) return const ProcessingStep();

        return Scaffold(
          backgroundColor: AppColors.quinoaCream,
          appBar: const AppHeader(),
          body: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 20, 24, 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (_step != SendStep.amount)
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
                        _step == SendStep.amount
                            ? SendStrings.stepAmountTitle
                            : _step == SendStep.chooseMethod
                            ? SendStrings.stepMethodTitle
                            : _step == SendStep.recipient
                            ? SendStrings.stepRecipientTitle
                            : SendStrings.stepChannelTitle,
                        style: const TextStyle(
                          color: AppColors.textMuted,
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          height: 1.4,
                        ),
                      ),
                      if (_step == SendStep.amount) ...[
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

                if (_step == SendStep.amount) ...[
                  NumpadAmountScreen(
                    rawAmount: _rawAmount,
                    onKey: _onKey,
                    onConfirm: _confirmAmount,
                  ),
                ] else ...[
                  AmountDisplay(rawAmount: _rawAmount),
                ],

                if (_step == SendStep.chooseMethod) ...[
                  const SizedBox(height: 32),
                  MethodChoiceCard(
                    icon: SolarIconsOutline.magnifier,
                    title: SendStrings.methodSearchTitle,
                    subtitle: SendStrings.methodSearchSubtitle,
                    onTap: _chooseSearch,
                  ),
                  const SizedBox(height: 16),
                  MethodChoiceCard(
                    icon: SolarIconsOutline.usersGroupRounded,
                    title: SendStrings.methodContactsTitle,
                    subtitle: SendStrings.methodContactsSubtitle,
                    onTap: _chooseContacts,
                  ),
                ],

                if (_step == SendStep.recipient ||
                    _step == SendStep.channel) ...[
                  const SizedBox(height: 32),
                  RecipientSearchField(
                    controller: _recipientCtrl,
                    focusNode: _recipientFocus,
                    onChanged: _onRecipientChanged,
                    onClear: _clearRecipient,
                    isLoading: state is SendLoading,
                    resolvedName: _recipientName,
                    enabled: _step == SendStep.recipient,
                  ),
                  if (_foundRecipients.isNotEmpty &&
                      _recipientName == null) ...[
                    const SizedBox(height: 16),
                    RecipientsResultsList(
                      recipients: _foundRecipients,
                      onSelect: _selectMatch,
                    ),
                  ],
                ],

                if (_step == SendStep.channel) ...[
                  const SizedBox(height: 28),
                  AccountDropdown(
                    label: SendStrings.chooseSource,
                    value: _selectedSourceChannel,
                    accounts: SourceAccountsMock.list,
                    onChanged: (ch) =>
                        setState(() => _selectedSourceChannel = ch),
                  ),
                  if (_foundChannels.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    AccountDropdown(
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
