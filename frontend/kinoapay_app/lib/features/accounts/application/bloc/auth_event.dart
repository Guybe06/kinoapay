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
  final bool rememberMe;

  const SignInRequested(this.email, this.password, {this.rememberMe = true});

  @override
  List<Object> get props => [email, password, rememberMe];
}

class SignUpRequested extends AuthEvent {
  final String email;
  final String password;

  const SignUpRequested(this.email, this.password);

  @override
  List<Object> get props => [email, password];
}

class SignOutRequested extends AuthEvent {}
