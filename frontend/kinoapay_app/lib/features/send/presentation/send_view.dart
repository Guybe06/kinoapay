import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:flutter_local_notifications/flutter_local_notifications.dart";
import "package:solar_icons/solar_icons.dart";
import "package:kinoapay_app/core/constants/app_colors.dart";
import "package:kinoapay_app/core/constants/app_routes.dart";
import "package:kinoapay_app/core/navigation/presentation/widgets/app_header.dart";
import "package:kinoapay_app/features/accounts/presentation/widgets/auth_snack_bar.dart";
import "package:kinoapay_app/features/contacts/domain/contacts_args.dart";
import "package:kinoapay_app/features/contacts/domain/entities/contact.dart"
    hide PaymentChannel;
import "package:kinoapay_app/features/dashboard/domain/entities/payment_channel.dart";
import "package:kinoapay_app/features/send/application/bloc/send_bloc.dart";
import "package:kinoapay_app/features/send/application/bloc/send_event.dart";
import "package:kinoapay_app/features/send/application/bloc/send_state.dart";
import "package:kinoapay_app/features/send/domain/entities/recipient_match.dart";
import "package:kinoapay_app/features/send/domain/send_strings.dart";
import "package:kinoapay_app/features/send/presentation/widgets/processing_step.dart";
import "package:kinoapay_app/features/send/presentation/widgets/quote_confirmation_step.dart";
import "package:kinoapay_app/features/send/presentation/widgets/recipient_by_id_view.dart";
import "package:kinoapay_app/features/send/presentation/widgets/recipient_by_phone_view.dart";
import "package:kinoapay_app/features/send/presentation/widgets/search_mode_switcher.dart";
import "package:kinoapay_app/features/send/presentation/widgets/send_amount_step.dart";
import "package:kinoapay_app/features/send/presentation/widgets/send_success_step.dart";
import "package:kinoapay_app/features/send/presentation/widgets/ussd_validation_step.dart";

enum SendStep { recipient, amount }

enum RecipientSearchMode { phone, id }

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
  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  SendStep _step = SendStep.recipient;
  RecipientSearchMode _searchMode = RecipientSearchMode.phone;
  CountryCode _selectedCountry = RecipientByPhoneView.countryCodes.first;
  RecipientMatch? _selectedRecipient;
  PaymentChannel? _selectedSourceChannel;
  PaymentChannel? _selectedDestChannel;
  List<RecipientMatch> _foundRecipients = [];
  String? _externalRecipientName;

  @override
  void initState() {
    super.initState();
    _initializeNotifications();
    Future.delayed(_focusDelay, _phoneFocus.requestFocus);
  }

  Future<void> _initializeNotifications() async {
    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );
    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );
    await _notificationsPlugin.initialize(initSettings);

    await _notificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.requestNotificationsPermission();
  }

  Future<void> _showNotification() async {
    if (!mounted) return;
    const androidDetails = AndroidNotificationDetails(
      'kinoapay_channel',
      'KinoaPay Notifications',
      channelDescription: 'Notifications pour les transactions KinoaPay',
      importance: Importance.high,
      priority: Priority.high,
    );
    const iosDetails = DarwinNotificationDetails();
    const notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );
    await _notificationsPlugin.show(
      0,
      'Envoi confirmé',
      'Votre envoi a été confirmé avec succès',
      notificationDetails,
    );
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

  FocusNode get _activeFocus =>
      _searchMode == RecipientSearchMode.phone ? _phoneFocus : _idFocus;

  TextEditingController get _activeCtrl =>
      _searchMode == RecipientSearchMode.phone ? _phoneCtrl : _idCtrl;

  double get _amount =>
      double.tryParse(_amountCtrl.text.replaceAll(RegExp(r"[^\d.]"), "")) ?? 0;

  // ── Recherche ───────────────────────────────────────────────────────────

  void _onPhoneChanged(String value) {
    final digits = value.replaceAll(RegExp(r"\D"), "");
    if (digits.length < RecipientByPhoneView.minPhoneDigits) {
      setState(() => _foundRecipients = []);
      return;
    }
    context.read<SendBloc>().add(
      SendRecipientSearched("${_selectedCountry.dialCode}$digits"),
    );
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
    _selectMatch(
      RecipientMatch(
        name: fullPhone,
        phone: fullPhone,
        channels: const [],
        isKinoaUser: false,
      ),
    );
  }

  Future<void> _chooseContacts() async {
    final result = await Navigator.pushNamed(
      context,
      AppRoutes.contacts,
      arguments: const ContactsArgs(selectionMode: true),
    );
    if (result is Contact) {
      if (result.dialCode.isEmpty) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(SendStrings.errorUnsupportedCountry)),
        );
        return;
      }
      final match = RecipientByPhoneView.countryCodes.firstWhere(
        (c) => c.dialCode == result.dialCode,
        orElse: () => _selectedCountry,
      );
      setState(() => _selectedCountry = match);
      _switchSearchMode(RecipientSearchMode.phone);
      _phoneCtrl.text = result.localNumber;
      // ignore: use_build_context_synchronously
      context.read<SendBloc>().add(SendRecipientSearched(result.phone));
    }
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
    final recipientName = _selectedRecipient?.isKinoaUser == false
        ? _externalRecipientName
        : null;
    context.read<SendBloc>().add(
      SendQuoteRequested(
        recipientIdentifier: _activeCtrl.text.trim(),
        recipientName: recipientName,
        amount: _amount,
        sourceChannel: _selectedSourceChannel!.type,
        destinationChannel: destType,
      ),
    );
  }

  void _goBack() {
    if (_step != SendStep.amount) return;
    setState(() {
      _step = SendStep.recipient;
      _selectedRecipient = null;
      _selectedDestChannel = null;
      _selectedSourceChannel = null;
    });
    _amountCtrl.clear();
    Future.delayed(_refocusDelay, _activeFocus.requestFocus);
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
      builder: (_, state) {
        if (state is SendQuoteReady) {
          return QuoteConfirmationStep(
            quote: state.quote,
            onBack: () => context.read<SendBloc>().add(SendReset()),
          );
        }
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
                  SendAmountStep(
                    recipient: _selectedRecipient!,
                    selectedSource: _selectedSourceChannel,
                    selectedDest: _selectedDestChannel,
                    amountCtrl: _amountCtrl,
                    amountFocus: _amountFocus,
                    onSourceChanged: (ch) =>
                        setState(() => _selectedSourceChannel = ch),
                    onDestChanged: (ch) =>
                        setState(() => _selectedDestChannel = ch),
                    onModifyRecipient: _clearRecipient,
                    onContinue: _requestQuote,
                    onExternalNameChanged: (name) =>
                        setState(() => _externalRecipientName = name),
                  ),
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
    } else if (state is SendError) {
      setState(() => _foundRecipients = []);
      AuthSnackBar.showError(context, state.exception.message);
    } else if (state is SendConfirming) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => const ProcessingStep(),
          fullscreenDialog: true,
        ),
      );
    } else if (state is SendSuccess) {
      final isMobile =
          _selectedSourceChannel?.type.toLowerCase().contains('mobile') ??
          false;
      if (isMobile) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => UssdValidationStep(
              onResolved: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (_) => SendSuccessStep(
                      onClose: () {
                        context.read<SendBloc>().add(SendReset());
                        _resetAll();
                        Navigator.pop(context);
                      },
                      onShowNotification: _showNotification,
                    ),
                    fullscreenDialog: true,
                  ),
                );
              },
            ),
            fullscreenDialog: true,
          ),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => SendSuccessStep(
              onClose: () {
                context.read<SendBloc>().add(SendReset());
                _resetAll();
                Navigator.pop(context);
              },
              onShowNotification: _showNotification,
            ),
            fullscreenDialog: true,
          ),
        );
      }
    }
  }

  Widget _buildBackButton() {
    if (_step == SendStep.recipient) return const SizedBox.shrink();
    return GestureDetector(
      onTap: _goBack,
      child: Container(
        width: 36,
        height: 36,
        margin: const EdgeInsets.only(bottom: 20),
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildProgressBar(),
        const SizedBox(height: 20),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          child: Column(
            key: ValueKey(_step),
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                isRecipient
                    ? SendStrings.stepRecipientTitle
                    : SendStrings.stepAmountTitle,
                style: const TextStyle(
                  color: AppColors.quinoaDark,
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.6,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 4),
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
        ),
      ],
    );
  }

  Widget _buildProgressBar() {
    final isAmount = _step == SendStep.amount;
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 3,
            decoration: BoxDecoration(
              color: AppColors.quinoaDark,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ),
        const SizedBox(width: 6),
        Expanded(
          child: Container(
            height: 3,
            decoration: BoxDecoration(
              color: isAmount
                  ? AppColors.quinoaDark
                  : AppColors.quinoaDark.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRecipientStep(SendState state) {
    final isPhone = _searchMode == RecipientSearchMode.phone;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SearchModeSwitcher(
          isPhoneMode: isPhone,
          onChanged: (v) => _switchSearchMode(
            v ? RecipientSearchMode.phone : RecipientSearchMode.id,
          ),
        ),
        const SizedBox(height: 16),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          child: isPhone
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
}
