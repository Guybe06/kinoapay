import "package:equatable/equatable.dart";
import "package:kinoapay_app/core/errors/app_exception.dart";
import "package:kinoapay_app/features/accounts/domain/entities/user_account.dart";

/// Définit les états du cycle d'authentification.
abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class Authenticated extends AuthState {
  final UserAccount user;

  const Authenticated(this.user);

  @override
  List<Object?> get props => [user];
}

class Unauthenticated extends AuthState {}

class OtpSent extends AuthState {}

class OtpVerified extends AuthState {}

class AuthError extends AuthState {
  final AppException exception;

  const AuthError(this.exception);

  @override
  List<Object?> get props => [exception];
}

/// Code de réinitialisation envoyé (email/SMS selon le contact).
class ResetOtpSent extends AuthState {}

/// OTP de réinitialisation validé ; [resetToken] sert à la dernière étape.
class ResetOtpVerified extends AuthState {
  final String resetToken;
  const ResetOtpVerified(this.resetToken);

  @override
  List<Object?> get props => [resetToken];
}

/// Mot de passe mis à jour côté serveur (mock ou API).
class PasswordResetSuccess extends AuthState {}
