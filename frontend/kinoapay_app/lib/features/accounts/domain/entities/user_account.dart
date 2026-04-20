import "package:equatable/equatable.dart";

/// Représente l'entité utilisateur authentifié au sein du système.
class UserAccount extends Equatable {
  final String id;
  final String email;
  final String? fullName;
  final String? firstName;
  final String? lastName;
  final String? phone;
  final String? countryCode;
  final String? birthDate;
  final bool kycVerified;
  final String? publicHandle;

  const UserAccount({
    required this.id,
    required this.email,
    this.fullName,
    this.firstName,
    this.lastName,
    this.phone,
    this.countryCode,
    this.birthDate,
    this.kycVerified = false,
    this.publicHandle,
  });

  @override
  List<Object?> get props => [
    id,
    email,
    fullName,
    firstName,
    lastName,
    phone,
    countryCode,
    birthDate,
    kycVerified,
    publicHandle,
  ];
}
