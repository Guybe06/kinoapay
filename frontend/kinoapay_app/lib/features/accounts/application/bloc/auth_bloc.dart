import "package:flutter/foundation.dart";
import "package:flutter/services.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:kinoapay_app/core/errors/app_exception.dart";
import "package:kinoapay_app/core/storage/secure_storage_service.dart";
import "package:kinoapay_app/features/accounts/application/bloc/auth_event.dart";
import "package:kinoapay_app/features/accounts/application/bloc/auth_state.dart";
import "package:kinoapay_app/features/accounts/domain/repositories/auth_repository.dart";

/// Orchestre les processus d'authentification et la gestion des sessions utilisateur.
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _repository;
  final SecureStorageService _storage;

  AuthBloc({required AuthRepository repository, required SecureStorageService storage})
      : _repository = repository,
        _storage = storage,
        super(AuthInitial()) {
    on<AuthSessionRestoreRequested>(_onAuthSessionRestoreRequested);
    on<SignInRequested>(_onSignInRequested);
    on<SignUpRequested>(_onSignUpRequested);
    on<SendOtpRequested>(_onSendOtpRequested);
    on<VerifyOtpRequested>(_onVerifyOtpRequested);
    on<SignOutRequested>(_onSignOutRequested);
    on<RequestPasswordResetRequested>(_onRequestPasswordReset);
    on<VerifyResetOtpRequested>(_onVerifyResetOtp);
    on<ResetPasswordRequested>(_onResetPassword);
  }

  /// Recharge [Authenticated] depuis le stockage si une session persistante existe.
  Future<void> _onAuthSessionRestoreRequested(AuthSessionRestoreRequested event, Emitter<AuthState> emit) async {
    final user = await _repository.getCurrentUser();
    if (user != null) emit(Authenticated(user));
  }

  Future<void> _onSignInRequested(SignInRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final user = await _repository.signIn(event.email, event.password);
      await _storage.markFirstOpenApp();
      emit(Authenticated(user));
    } on KinoaException catch (e) {
      emit(AuthError(e));
    } on PlatformException catch (e) {
      emit(AuthError(KinoaException.localStorage(e.message)));
    } catch (e, st) {
      debugPrint("AuthBloc signIn: $e\n$st");
      emit(AuthError(KinoaException.unknown()));
    }
  }

  /// Inscription → création du compte puis connexion automatique (tokens persistés).
  Future<void> _onSignUpRequested(SignUpRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      await _repository.signUp(
        email: event.email,
        password: event.password,
        firstName: event.firstName,
        lastName: event.lastName,
        phone: event.phone,
        countryCode: event.countryCode,
        birthDate: event.birthDate,
      );
      final user = await _repository.signIn(event.email, event.password);
      await _storage.markFirstOpenApp();
      emit(Authenticated(user));
    } on KinoaException catch (e) {
      emit(AuthError(e));
    } on PlatformException catch (e) {
      emit(AuthError(KinoaException.localStorage(e.message)));
    } catch (e, st) {
      debugPrint("AuthBloc signUp: $e\n$st");
      emit(AuthError(KinoaException.unknown()));
    }
  }

  Future<void> _onSendOtpRequested(SendOtpRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      await _repository.sendOtp(event.phone, event.countryCode);
      emit(OtpSent());
    } catch (e) {
      emit(AuthError(e is KinoaException ? e : KinoaException.unknown()));
    }
  }

  Future<void> _onVerifyOtpRequested(VerifyOtpRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      await _repository.verifyOtp(event.phone, event.countryCode, event.code);
      emit(OtpVerified());
    } catch (e) {
      emit(AuthError(e is KinoaException ? e : KinoaException.unknown()));
    }
  }

  Future<void> _onSignOutRequested(SignOutRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    await _repository.signOut();
    emit(Unauthenticated());
  }

  // ── Réinitialisation mot de passe ──────────────────────────────────────────

  Future<void> _onRequestPasswordReset(RequestPasswordResetRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      await _repository.requestPasswordReset(event.contact, isEmail: event.isEmail);
      emit(ResetOtpSent());
    } catch (e) {
      emit(AuthError(e is KinoaException ? e : KinoaException.unknown()));
    }
  }

  Future<void> _onVerifyResetOtp(VerifyResetOtpRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final token = await _repository.verifyResetOtp(event.contact, event.code);
      emit(ResetOtpVerified(token));
    } catch (e) {
      emit(AuthError(e is KinoaException ? e : KinoaException.unknown()));
    }
  }

  Future<void> _onResetPassword(ResetPasswordRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      await _repository.resetPassword(event.resetToken, event.newPassword);
      emit(PasswordResetSuccess());
    } catch (e) {
      emit(AuthError(e is KinoaException ? e : KinoaException.unknown()));
    }
  }
}
