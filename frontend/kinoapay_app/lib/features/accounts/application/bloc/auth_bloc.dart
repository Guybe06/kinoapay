import "package:flutter_bloc/flutter_bloc.dart";
import "package:kinoapay_app/core/errors/kinoa_exception.dart";
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
    on<SignInRequested>(_onSignInRequested);
    on<SignUpRequested>(_onSignUpRequested);
    on<SignOutRequested>(_onSignOutRequested);
  }

  Future<void> _onSignInRequested(SignInRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final user = await _repository.signIn(event.email, event.password, rememberMe: event.rememberMe);
      await _storage.markFirstOpenApp();
      emit(Authenticated(user));
    } catch (e) {
      emit(AuthError(e is KinoaException ? e : KinoaException.unknown()));
    }
  }

  Future<void> _onSignUpRequested(SignUpRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final user = await _repository.signUp(event.email, event.password);
      await _storage.markFirstOpenApp();
      emit(Authenticated(user));
    } catch (e) {
      emit(AuthError(e is KinoaException ? e : KinoaException.unknown()));
    }
  }

  Future<void> _onSignOutRequested(SignOutRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    await _repository.signOut();
    emit(Unauthenticated());
  }
}
