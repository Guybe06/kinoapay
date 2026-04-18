import "package:kinoapay_app/features/dashboard/domain/entities/payment_channel.dart";

/// Liste mock des comptes source disponibles pour l'utilisateur courant.
/// À remplacer par une source de données réelle (profil utilisateur / repository).
abstract final class SourceAccountsMock {
  static const List<PaymentChannel> list = [
    PaymentChannel(
      id: "src_mtn",
      type: "MTN Mobile Money",
      label: "MTN Money",
      value: "+237 6XX XXX XXX",
      short: "MTN",
      status: "active",
    ),
    PaymentChannel(
      id: "src_orange",
      type: "Orange Money",
      label: "Orange Money",
      value: "+237 6XX XXX XXX",
      short: "Orange",
      status: "active",
    ),
    PaymentChannel(
      id: "src_airtel",
      type: "Airtel Money",
      label: "Airtel Money",
      value: "+242 05 XX XX XX",
      short: "Airtel",
      status: "active",
    ),
    PaymentChannel(
      id: "src_visa",
      type: "Visa Card",
      label: "Visa •••• 4242",
      value: "•••• 4242",
      short: "Visa",
      status: "active",
    ),
    PaymentChannel(
      id: "src_mastercard",
      type: "Mastercard",
      label: "Mastercard •••• 8888",
      value: "•••• 8888",
      short: "MC",
      status: "active",
    ),
  ];
}
