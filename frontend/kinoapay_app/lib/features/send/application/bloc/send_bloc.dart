import "package:flutter_bloc/flutter_bloc.dart";
import "package:kinoapay_app/core/errors/app_exception.dart";
import "package:kinoapay_app/features/send/application/bloc/send_event.dart";
import "package:kinoapay_app/features/send/application/bloc/send_state.dart";
import "package:kinoapay_app/features/send/domain/repositories/send_repository.dart";
import "package:kinoapay_app/features/dashboard/domain/entities/payment_channel.dart";

/// Orchestre le flux d'envoi d'argent : recherche → quote → confirm → success.
class SendBloc extends Bloc<SendEvent, SendState> {
  final SendRepository _repository;

  SendBloc({required SendRepository repository})
      : _repository = repository,
        super(SendInitial()) {
    on<SendRecipientSearched>(_onSearchRecipient);
    on<SendSimulationRequested>(_onSimulation);
    on<SendQuoteRequested>(_onQuote);
    on<SendConfirmRequested>(_onConfirm);
    on<SendReset>(_onReset);
  }

  Future<void> _onSearchRecipient(SendRecipientSearched event, Emitter<SendState> emit) async {
    emit(SendLoading());
    try {
      await Future.delayed(const Duration(milliseconds: 800));
      
      if (event.identifier.contains("error")) {
        throw AppException(message: "Utilisateur non trouvé", code: "NOT_FOUND");
      }

      final mockChannels = [
        PaymentChannel(
          id: "1", 
          type: "MTN Mobile Money", 
          label: "Principal", 
          value: "06 444 55 66", 
          short: "MTN", 
          status: "active",
          txCount: 12,
        ),
        PaymentChannel(
          id: "2", 
          type: "Airtel Money", 
          label: "Secondaire", 
          value: "04 111 22 33", 
          short: "AIRTEL", 
          status: "active",
          txCount: 5,
        ),
      ];

      emit(SendRecipientFound(name: "Jean Dupont", channels: mockChannels));
    } catch (e) {
      emit(SendError(e is AppException ? e : AppException.unknown()));
    }
  }

  Future<void> _onSimulation(SendSimulationRequested event, Emitter<SendState> emit) async {
    try {
      final quote = await _repository.getQuote(
        recipientIdentifier: "sim", 
        amount: event.amount,
        sourceChannel: event.sourceChannel,
        destinationChannel: event.destinationChannel,
      );
      emit(SendSimulationReady(quote));
    } catch (_) {}
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
