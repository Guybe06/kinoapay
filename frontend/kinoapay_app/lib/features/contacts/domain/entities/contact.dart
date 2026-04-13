import "package:equatable/equatable.dart";

/// Contact issu du répertoire téléphonique, enrichi avec son statut KinoaPay.
class Contact extends Equatable {
  final String id;
  final String fullName;
  final String phone;
  final bool isOnKinoaPay;

  /// Identifiant KinoaPay, disponible uniquement si [isOnKinoaPay] est true.
  final String? kinoaId;

  const Contact({
    required this.id,
    required this.fullName,
    required this.phone,
    required this.isOnKinoaPay,
    this.kinoaId,
  });

  @override
  List<Object?> get props => [id, phone];
}
