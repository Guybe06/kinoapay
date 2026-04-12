import "package:equatable/equatable.dart";
import "package:kinoapay_app/core/errors/kinoa_exception.dart";
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

class AuthError extends AuthState {
  final KinoaException exception;

  const AuthError(this.exception);

  @override
  List<Object?> get props => [exception];
}
