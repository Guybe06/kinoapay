/// Données transmises de l’étape 1 vers l’OTP puis l’étape 2 d’inscription.
class SignupStep1Args {
  final String firstName;
  final String lastName;
  final String phone;
  final String countryCode;
  final String birthDate;

  const SignupStep1Args({
    required this.firstName,
    required this.lastName,
    required this.phone,
    required this.countryCode,
    required this.birthDate,
  });
}
