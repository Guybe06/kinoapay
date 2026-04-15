import "package:flutter_bloc/flutter_bloc.dart";
import "package:kinoapay_app/core/errors/app_exception.dart";
import "package:kinoapay_app/features/send/application/bloc/send_event.dart";
import "package:kinoapay_app/features/send/application/bloc/send_state.dart";
import "package:kinoapay_app/features/send/domain/repositories/send_repository.dart";

/// Orchestre le flux d'envoi d'argent : quote → confirm → success.
class SendBloc extends Bloc<SendEvent, SendState> {
  final SendRepository _repository;

  SendBloc({required SendRepository repository})
      : _repository = repository,
        super(SendInitial()) {
    on<SendQuoteRequested>(_onQuote);
    on<SendConfirmRequested>(_onConfirm);
    on<SendReset>(_onReset);
  }

  Future<void> _onQuote(SendQuoteRequested event, Emitter<SendState> emit) async {
    emit(SendLoading());
    try {
      final quote = await _repository.getQuote(
        recipientIdentifier: event.recipientIdentifier,
        amount: event.amount,
        sourceChannel: event.sourceChannel,
        destinationChannel: event.destinationChannel,
      );
      emit(SendQuoteReady(quote));
    } catch (e) {
      emit(SendError(e is AppException ? e : AppException.unknown()));
    }
  }

  Future<void> _onConfirm(SendConfirmRequested event, Emitter<SendState> emit) async {
    emit(SendConfirming());
    try {
      final tx = await _repository.confirmTransfer(event.quoteId);
      emit(SendSuccess(tx));
    } catch (e) {
      emit(SendError(e is AppException ? e : AppException.unknown()));
    }
  }

  void _onReset(SendReset event, Emitter<SendState> emit) => emit(SendInitial());
}
