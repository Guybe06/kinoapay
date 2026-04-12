import "package:flutter_bloc/flutter_bloc.dart";
import "package:kinoapay_app/features/wallet/application/bloc/wallet_event.dart";
import "package:kinoapay_app/features/wallet/application/bloc/wallet_state.dart";
import "package:kinoapay_app/features/wallet/domain/repositories/wallet_repository.dart";

/// Gère la logique métier et les états liés au portefeuille de l'utilisateur.
class WalletBloc extends Bloc<WalletEvent, WalletState> {
  final WalletRepository _walletRepository;

  WalletBloc({required WalletRepository walletRepository})
      : _walletRepository = walletRepository,
        super(WalletInitial()) {
    on<WalletStarted>(_onStarted);
    on<WalletRefreshRequested>(_onRefreshRequested);
  }

  /// Traite le démarrage du portefeuille en effectuant le chargement initial.
  Future<void> _onStarted(WalletStarted event, Emitter<WalletState> emit) async {
    emit(WalletLoading());
    try {
      final wallet = await _walletRepository.getWallet();
      emit(WalletLoadSuccess(wallet));
    } catch (e) {
      emit(const WalletLoadFailure("Échec du chargement du portefeuille"));
    }
  }

  /// Rafraîchit les données du portefeuille lors d'une action explicite.
  Future<void> _onRefreshRequested(WalletRefreshRequested event, Emitter<WalletState> emit) async {
    try {
      final wallet = await _walletRepository.refreshBalance();
      emit(WalletLoadSuccess(wallet));
    } catch (e) {
      // Émet l'erreur pour informer l'utilisateur de l'échec de mise à jour.
      emit(const WalletLoadFailure("Échec de la mise à jour du solde"));
    }
  }
}
