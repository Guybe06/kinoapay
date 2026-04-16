import "package:flutter/material.dart";
import "package:intl/intl.dart";
import "package:kinoapay_app/core/constants/app_colors.dart";
import "package:kinoapay_app/features/dashboard/domain/dashboard_strings.dart";

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
    DashboardTxNature.processing => AppColors.quinoaGold,
    DashboardTxNature.refused => AppColors.quinoaDark,
  };

  String get label => switch (this) {
    DashboardTxNature.sent => DashboardStrings.txSent,
    DashboardTxNature.received => DashboardStrings.txReceived,
    DashboardTxNature.pending => DashboardStrings.txPending,
    DashboardTxNature.processing => DashboardStrings.txProcessing,
    DashboardTxNature.refused => DashboardStrings.txFailed,
  };
}

/// Libellé court pour l’horodatage (relatif ou date + heure).
String dashboardTxRelativeDate(DateTime dt) {
  final now = DateTime.now();
  final diff = now.difference(dt);

  if (diff.inMinutes < 1) return DashboardStrings.txJustNow;
  if (diff.inMinutes < 60) return DashboardStrings.txMinutesAgo(diff.inMinutes);

  final today = DateTime(now.year, now.month, now.day);
  final yesterday = today.subtract(const Duration(days: 1));
  final dtDay = DateTime(dt.year, dt.month, dt.day);
  final hhmm = DateFormat("HH:mm", "fr_FR").format(dt);

  if (dtDay == today) return DashboardStrings.txToday(hhmm);
  if (dtDay == yesterday) return DashboardStrings.txYesterday(hhmm);
  if (diff.inDays < 7) {
    final day = DateFormat("EEE.", "fr_FR").format(dt);
    return "${day[0].toUpperCase()}${day.substring(1)} $hhmm";
  }

  final d = DateFormat("EEE. d MMM", "fr_FR").format(dt);
  return "${d[0].toUpperCase()}${d.substring(1)}";
}
