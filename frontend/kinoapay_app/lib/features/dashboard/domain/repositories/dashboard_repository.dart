import "package:kinoapay_app/features/dashboard/domain/entities/dashboard_stats.dart";
import "package:kinoapay_app/features/dashboard/domain/entities/payment_channel.dart";
import "package:kinoapay_app/features/dashboard/domain/entities/transaction.dart";

/// Définit le contrat pour la récupération des données du tableau de bord.
abstract class DashboardRepository {
  /// Récupère les statistiques de transaction pour une période donnée.
  Future<DashboardStats> getStats({required int month, required int year});

  /// Récupère la liste des transactions récentes.
  Future<List<Transaction>> getRecentTransactions();

  /// Récupère les canaux de paiement configurés pour l'utilisateur.
  Future<List<PaymentChannel>> getUserChannels();
}
