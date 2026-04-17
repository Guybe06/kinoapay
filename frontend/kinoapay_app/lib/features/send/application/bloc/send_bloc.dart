import "package:flutter_bloc/flutter_bloc.dart";
import "package:kinoapay_app/core/errors/app_exception.dart";
import "package:kinoapay_app/features/send/application/bloc/send_event.dart";
import "package:kinoapay_app/features/send/application/bloc/send_state.dart";
import "package:kinoapay_app/features/send/domain/repositories/send_repository.dart";
import "package:kinoapay_app/features/dashboard/domain/entities/payment_channel.dart";

/// Mock user pour la recherche
class _MockUser {
  final String kinoaId;
  final String name;
  final String phone;
  final List<PaymentChannel> channels;
  const _MockUser({
    required this.kinoaId,
    required this.name,
    required this.phone,
    required this.channels,
  });
}

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

  Future<void> _onSearchRecipient(
    SendRecipientSearched event,
    Emitter<SendState> emit,
  ) async {
    emit(SendLoading());
    try {
      await Future.delayed(const Duration(milliseconds: 800));

      final searchInput = event.identifier.trim();

      // Validation: minimum 3 caractères requis (hors @ pour les IDs)
      final cleanInput = searchInput.replaceAll(" ", "");
      final isId = searchInput.startsWith("@");
      final minLength = isId ? 4 : 3; // @ + 3 pour ID, 3 pour numéro
      if (cleanInput.length < minLength) {
        throw AppException(
          message: "Entrez au moins 3 caractères",
          code: "INVALID_INPUT",
        );
      }

      // Mock users avec IDs partagés et numéros partagés
      final mockUsers = [
        // Groupe ID "956" ---
        _MockUser(
          kinoaId: "956231",
          name: "Jean Dupont",
          phone: "06 444 55 66",
          channels: [
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
          ],
        ),
        _MockUser(
          kinoaId: "956847",
          name: "Lucas Moreau",
          phone: "05 123 45 67",
          channels: [
            PaymentChannel(
              id: "7",
              type: "Orange Money",
              label: "Perso",
              value: "05 123 45 67",
              short: "Orange",
              status: "active",
              txCount: 3,
            ),
          ],
        ),
        _MockUser(
          kinoaId: "956912",
          name: "Emma Dubois",
          phone: "06 888 99 00",
          channels: [
            PaymentChannel(
              id: "8",
              type: "MTN Mobile Money",
              label: "Perso",
              value: "06 888 99 00",
              short: "MTN",
              status: "active",
              txCount: 7,
            ),
          ],
        ),
        // Groupe ID "847" ---
        _MockUser(
          kinoaId: "847291",
          name: "Marie Curie",
          phone: "06 777 88 99",
          channels: [
            PaymentChannel(
              id: "3",
              type: "Orange Money",
              label: "Perso",
              value: "06 777 88 99",
              short: "Orange",
              status: "active",
              txCount: 8,
            ),
          ],
        ),
        _MockUser(
          kinoaId: "847563",
          name: "Thomas Petit",
          phone: "05 444 22 11",
          channels: [
            PaymentChannel(
              id: "9",
              type: "Airtel Money",
              label: "Pro",
              value: "05 444 22 11",
              short: "Airtel",
              status: "active",
              txCount: 12,
            ),
          ],
        ),
        // Autres ---
        _MockUser(
          kinoaId: "152847",
          name: "Pierre Martin",
          phone: "06 222 33 44",
          channels: [
            PaymentChannel(
              id: "4",
              type: "MTN Mobile Money",
              label: "Pro",
              value: "06 222 33 44",
              short: "MTN",
              status: "active",
              txCount: 23,
            ),
            PaymentChannel(
              id: "5",
              type: "Visa Card",
              label: "Carte",
              value: "•••• 4242",
              short: "Visa",
              status: "active",
              txCount: 0,
            ),
          ],
        ),
        _MockUser(
          kinoaId: "639482",
          name: "Sophie Bernard",
          phone: "05 555 66 77",
          channels: [
            PaymentChannel(
              id: "6",
              type: "Airtel Money",
              label: "Principal",
              value: "05 555 66 77",
              short: "Airtel",
              status: "active",
              txCount: 15,
            ),
          ],
        ),
      ];

      // Détection du type de recherche
      final isKinoaId = searchInput.startsWith("@");

      // Recherche de TOUS les users correspondants
      final matches = mockUsers.where((user) {
        if (isKinoaId) {
          final searchId = cleanInput.substring(1);
          return user.kinoaId.startsWith(searchId);
        } else {
          final cleanPhone = user.phone.replaceAll(" ", "");
          return cleanPhone.contains(cleanInput);
        }
      }).toList();

      if (matches.isEmpty) {
        throw AppException(
          message: "Utilisateur non trouvé",
          code: "NOT_FOUND",
        );
      }

      emit(
        SendRecipientFound(
          recipients: matches
              .map((u) => RecipientResult(name: u.name, channels: u.channels))
              .toList(),
        ),
      );
    } catch (e) {
      emit(SendError(e is AppException ? e : AppException.unknown()));
    }
  }

  Future<void> _onSimulation(
    SendSimulationRequested event,
    Emitter<SendState> emit,
  ) async {
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
