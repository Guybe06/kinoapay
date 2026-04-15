import "package:flutter/material.dart";
import "package:intl/intl.dart";
import "package:kinoapay_app/core/constants/app_colors.dart";

/// Interprétation visuelle du statut et du sens d’une transaction.
enum DashboardTxNature {
  sent,
  received,
  pending,
  processing,
  refused;

  Color get color => switch (this) {
        DashboardTxNature.sent => AppColors.quinoaDark,
        DashboardTxNature.received => AppColors.accentDark,
        DashboardTxNature.pending => AppColors.quinoaGold,
        DashboardTxNature.processing => const Color(0xFF2979FF),
        DashboardTxNature.refused => AppColors.quinoaRed,
      };

  String get label => switch (this) {
        DashboardTxNature.sent => "Envoyé",
        DashboardTxNature.received => "Reçu",
        DashboardTxNature.pending => "En attente",
        DashboardTxNature.processing => "En traitement",
        DashboardTxNature.refused => "Échoué",
      };
}

/// Libellé court pour l’horodatage (relatif ou date + heure).
String dashboardTxRelativeDate(DateTime dt) {
  final now = DateTime.now();
  final diff = now.difference(dt);

  if (diff.inMinutes < 1) return "À l'instant";
  if (diff.inMinutes < 60) return "il y a ${diff.inMinutes} min";

  final today = DateTime(now.year, now.month, now.day);
  final yesterday = today.subtract(const Duration(days: 1));
  final dtDay = DateTime(dt.year, dt.month, dt.day);
  final hhmm = DateFormat("HH:mm", "fr_FR").format(dt);

  if (dtDay == today) return "Aujourd'hui $hhmm";
  if (dtDay == yesterday) return "Hier $hhmm";
  if (diff.inDays < 7) {
    final day = DateFormat("EEE.", "fr_FR").format(dt);
    return "${day[0].toUpperCase()}${day.substring(1)} $hhmm";
  }

  final d = DateFormat("EEE. d MMM", "fr_FR").format(dt);
  return "${d[0].toUpperCase()}${d.substring(1)}";
}
