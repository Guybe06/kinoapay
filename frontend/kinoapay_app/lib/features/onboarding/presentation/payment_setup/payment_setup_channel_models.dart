import "package:flutter/material.dart";

/// Métadonnées d'un canal Mobile Money affiché sur l'écran de configuration.
class PaymentSetupChannelDef {
  final String type;
  final String label;
  final String shortLabel;
  final Color color;
  final Color textColor;

  const PaymentSetupChannelDef({
    required this.type,
    required this.label,
    required this.shortLabel,
    required this.color,
    required this.textColor,
  });
}

/// Canaux supportés au MVP (MTN et Airtel).
const List<PaymentSetupChannelDef> paymentSetupChannels = [
  PaymentSetupChannelDef(
    type: "mtn_money",
    label: "MTN Mobile Money",
    shortLabel: "MTN",
    color: Color(0xFFFFCC00),
    textColor: Color(0xFF1A1400),
  ),
  PaymentSetupChannelDef(
    type: "airtel_money",
    label: "Airtel Money",
    shortLabel: "Airtel",
    color: Color(0xFFE4002B),
    textColor: Colors.white,
  ),
];
