import "package:flutter_bloc/flutter_bloc.dart";
import "package:kinoapay_app/core/errors/app_exception.dart";
import "package:kinoapay_app/features/send/application/bloc/send_event.dart";
import "package:kinoapay_app/features/send/application/bloc/send_state.dart";
import "package:kinoapay_app/features/send/domain/repositories/recipient_search_repository.dart";
import "package:kinoapay_app/features/send/domain/repositories/send_repository.dart";
import "package:kinoapay_app/features/send/domain/send_error_codes.dart";
import "package:kinoapay_app/features/send/domain/send_strings.dart";

/// Orchestre le flux d'envoi d'argent : recherche → quote → confirm → success.
class SendBloc extends Bloc<SendEvent, SendState> {
  static const int _minSearchLength = 3;
  static const String _idPrefix = "@";
  static const String _simQuoteIdentifier = "sim";

  final SendRepository _repository;
  final RecipientSearchRepository _searchRepository;

  SendBloc({
    required SendRepository repository,
    required RecipientSearchRepository searchRepository,
  }) : _repository = repository,
       _searchRepository = searchRepository,
       super(SendInitial()) {
    on<SendRecipientSearched>(_onSearchRecipient);
    on<SendSimulationRequested>(_onSimulation);
    on<SendQuoteRequested>(_onQuote);
    on<SendConfirmRequested>(_onConfirm);
    on<SendReset>(_onReset);
  }

  /// Exécute la recherche de destinataires. Valide la longueur minimale,
  /// délègue au repository puis émet le résultat ou une erreur normalisée.
  Future<void> _onSearchRecipient(
    SendRecipientSearched event,
    Emitter<SendState> emit,
  ) async {
    emit(SendLoading());
    try {
      final query = event.identifier.trim();
      _assertMinLength(query);
      final matches = await _searchRepository.search(query);
      if (matches.isEmpty) {
        throw AppException(
          message: SendStrings.errorUserNotFound,
          code: SendErrorCodes.notFound,
        );
      }
      emit(SendRecipientFound(recipients: matches));
    } catch (e) {
      emit(SendError(e is AppException ? e : AppException.unknown()));
    }
  }

  /// Vérifie la longueur minimale de la requête (3 caractères hors @).
  void _assertMinLength(String query) {
    final cleanInput = query.replaceAll(" ", "");
    final isId = query.startsWith(_idPrefix);
    final required = isId ? _minSearchLength + 1 : _minSearchLength;
    if (cleanInput.length < required) {
      throw AppException(
        message: SendStrings.errorMinLength,
        code: SendErrorCodes.invalidInput,
      );
    }
  }

  Future<void> _onSimulation(
    SendSimulationRequested event,
    Emitter<SendState> emit,
  ) async {
    try {
      final quote = await _repository.getQuote(
        recipientIdentifier: _simQuoteIdentifier,
        amount: event.amount,
        sourceChannel: event.sourceChannel,
        destinationChannel: event.destinationChannel,
      );
      emit(SendSimulationReady(quote));
    } catch (_) {}
  }

  Future<void> _onQuote(
    SendQuoteRequested event,
    Emitter<SendState> emit,
  ) async {
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

  Future<void> _onConfirm(
    SendConfirmRequested event,
    Emitter<SendState> emit,
  ) async {
    emit(SendConfirming());
    try {
      final tx = await _repository.confirmTransfer(event.quoteId);
      emit(SendSuccess(tx));
    } catch (e) {
      emit(SendError(e is AppException ? e : AppException.unknown()));
    }
  }

  void _onReset(SendReset event, Emitter<SendState> emit) =>
      emit(SendInitial());
}
