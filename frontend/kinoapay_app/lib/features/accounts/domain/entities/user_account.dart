import "package:equatable/equatable.dart";

/// Représente l'entité utilisateur authentifié au sein du système.
class UserAccount extends Equatable {
  final String id;
  final String email;
  final String? fullName;

  const UserAccount({
    required this.id,
    required this.email,
    this.fullName,
  });

  @override
  List<Object?> get props => [id, email, fullName];
}
