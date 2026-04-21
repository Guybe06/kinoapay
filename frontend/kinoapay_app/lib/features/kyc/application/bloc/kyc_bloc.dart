import "package:flutter_bloc/flutter_bloc.dart";
import "package:kinoapay_app/features/kyc/application/bloc/kyc_event.dart";
import "package:kinoapay_app/features/kyc/application/bloc/kyc_state.dart";
import "package:kinoapay_app/features/kyc/infrastructure/kyc_repository.dart";

/// Orchestre le flow de soumission KYC en 3 étapes (document → photo → selfie).
class KycBloc extends Bloc<KycEvent, KycState> {
  final KycRepository _repository;

  KycBloc({required KycRepository repository})
      : _repository = repository,
        super(const KycInitial()) {
    on<KycDocumentTypeSelected>(_onDocumentTypeSelected);
    on<KycDocumentPhotoTaken>(_onDocumentPhotoTaken);
    on<KycSelfiePhotoTaken>(_onSelfiePhotoTaken);
    on<KycSubmitRequested>(_onSubmitRequested);
    on<KycReset>(_onReset);
  }

  void _onDocumentTypeSelected(
    KycDocumentTypeSelected event,
    Emitter<KycState> emit,
  ) {
    emit(KycDocumentSelected(event.documentType));
  }

  void _onDocumentPhotoTaken(
    KycDocumentPhotoTaken event,
    Emitter<KycState> emit,
  ) {
    final current = state;
    if (current is KycDocumentSelected) {
      emit(KycDocumentPhotoCaptured(
        documentType: current.documentType,
        documentImagePath: event.imagePath,
      ));
    }
  }

  void _onSelfiePhotoTaken(
    KycSelfiePhotoTaken event,
    Emitter<KycState> emit,
  ) {
    final current = state;
    if (current is KycDocumentPhotoCaptured) {
      emit(KycReadyToSubmit(
        documentType: current.documentType,
        documentImagePath: current.documentImagePath,
        selfieImagePath: event.imagePath,
      ));
    }
  }

  Future<void> _onSubmitRequested(
    KycSubmitRequested event,
    Emitter<KycState> emit,
  ) async {
    final current = state;
    if (current is! KycReadyToSubmit) return;
    emit(const KycSubmitting());
    try {
      await _repository.submitKyc(
        documentType: current.documentType.name,
        documentImagePath: current.documentImagePath,
        selfieImagePath: current.selfieImagePath,
      );
      emit(const KycSubmitted());
    } catch (e) {
      emit(KycError(e.toString()));
    }
  }

  void _onReset(KycReset event, Emitter<KycState> emit) {
    emit(const KycInitial());
  }
}
