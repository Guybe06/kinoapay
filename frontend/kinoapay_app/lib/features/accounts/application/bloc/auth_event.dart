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
