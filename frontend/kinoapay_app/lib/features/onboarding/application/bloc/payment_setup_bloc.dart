import "package:flutter_bloc/flutter_bloc.dart";
import "package:kinoapay_app/features/accounts/domain/entities/linked_account.dart";
import "package:kinoapay_app/features/accounts/domain/repositories/payment_channel_repository.dart";
import "package:kinoapay_app/features/onboarding/application/bloc/payment_setup_event.dart";
import "package:kinoapay_app/features/onboarding/application/bloc/payment_setup_state.dart";

class PaymentSetupBloc extends Bloc<PaymentSetupEvent, PaymentSetupState> {
  final PaymentChannelRepository _repo;

  PaymentSetupBloc({required PaymentChannelRepository repo})
      : _repo = repo,
        super(const PaymentSetupInitial()) {
    on<PaymentSetupStarted>(_onStarted);
    on<PaymentAccountAdded>(_onAccountAdded);
    on<PaymentAccountRemoved>(_onAccountRemoved);
    on<PaymentSetupCompleted>(_onCompleted);
  }

  Future<void> _onStarted(PaymentSetupStarted event, Emitter<PaymentSetupState> emit) async {
    emit(const PaymentSetupLoading());
    final accounts = await _repo.getLinkedAccounts();
    emit(PaymentSetupReady(
      linkedAccounts: accounts,
      suggestedPhone: event.suggestedPhone,
      suggestedCountryCode: event.suggestedCountryCode,
    ));
  }

  Future<void> _onAccountAdded(PaymentAccountAdded event, Emitter<PaymentSetupState> emit) async {
    if (state is! PaymentSetupReady) return;
    final current = state as PaymentSetupReady;

    final account = LinkedAccount(
      id: "la_${DateTime.now().millisecondsSinceEpoch}",
      channelType: event.channelType,
      label: event.channelLabel,
      phone: event.phone,
      countryCode: event.countryCode,
    );
    await _repo.addLinkedAccount(account);
    final updated = await _repo.getLinkedAccounts();
    emit(current.copyWith(linkedAccounts: updated));
  }

  Future<void> _onAccountRemoved(PaymentAccountRemoved event, Emitter<PaymentSetupState> emit) async {
    if (state is! PaymentSetupReady) return;
    final current = state as PaymentSetupReady;

    await _repo.removeLinkedAccount(event.accountId);
    final updated = await _repo.getLinkedAccounts();
    emit(current.copyWith(linkedAccounts: updated));
  }

  Future<void> _onCompleted(PaymentSetupCompleted event, Emitter<PaymentSetupState> emit) async {
    await _repo.markSetupDone();
    emit(const PaymentSetupDone());
  }
}
