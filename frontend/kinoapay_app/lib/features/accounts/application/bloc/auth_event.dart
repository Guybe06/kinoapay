import "package:equatable/equatable.dart";

/// Définit les événements déclenchant des changements d'état dans le processus d'authentification.
abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class SignInRequested extends AuthEvent {
  final String email;
  final String password;

  const SignInRequested(this.email, this.password);

  @override
  List<Object> get props => [email, password];
}

class SignUpRequested extends AuthEvent {
  final String firstName;
  final String lastName;
  final String phone;
  final String countryCode;
  final String birthDate;
  final String email;
  final String password;

  const SignUpRequested({
    required this.firstName,
    required this.lastName,
    required this.phone,
    required this.countryCode,
    required this.birthDate,
    required this.email,
    required this.password,
  });

  @override
  List<Object> get props => [firstName, lastName, phone, countryCode, birthDate, email, password];
}

class SendOtpRequested extends AuthEvent {
  final String phone;
  final String countryCode;

  const SendOtpRequested({required this.phone, required this.countryCode});

  @override
  List<Object> get props => [phone, countryCode];
}

class VerifyOtpRequested extends AuthEvent {
  final String phone;
  final String countryCode;
  final String code;

  const VerifyOtpRequested({required this.phone, required this.countryCode, required this.code});

  @override
  List<Object> get props => [phone, countryCode, code];
}

class SignOutRequested extends AuthEvent {}

/// Restaure l'utilisateur depuis le stockage (token + user_data) au démarrage de l'app.
class AuthSessionRestoreRequested extends AuthEvent {
  const AuthSessionRestoreRequested();
}

/// Demande d’envoi du code de réinitialisation (email ou téléphone).
class RequestPasswordResetRequested extends AuthEvent {
  final String contact;
  final bool isEmail;

  const RequestPasswordResetRequested({required this.contact, required this.isEmail});

  @override
  List<Object> get props => [contact, isEmail];
}

/// Vérification du code OTP reçu pour la réinitialisation.
class VerifyResetOtpRequested extends AuthEvent {
  final String contact;
  final String code;

  const VerifyResetOtpRequested({required this.contact, required this.code});

  @override
  List<Object> get props => [contact, code];
}

/// Soumission du nouveau mot de passe après validation OTP.
class ResetPasswordRequested extends AuthEvent {
  final String resetToken;
  final String newPassword;

  const ResetPasswordRequested({required this.resetToken, required this.newPassword});

  @override
  List<Object> get props => [resetToken, newPassword];
}
