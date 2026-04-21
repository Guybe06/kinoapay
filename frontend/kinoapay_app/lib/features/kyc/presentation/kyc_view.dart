import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:kinoapay_app/core/constants/app_colors.dart";
import "package:kinoapay_app/core/constants/app_routes.dart";
import "package:kinoapay_app/core/helpers/screen_size_helper.dart";
import "package:kinoapay_app/core/navigation/presentation/widgets/app_back_header.dart";
import "package:kinoapay_app/features/kyc/application/bloc/kyc_bloc.dart";
import "package:kinoapay_app/features/kyc/application/bloc/kyc_event.dart";
import "package:kinoapay_app/features/kyc/application/bloc/kyc_state.dart";
import "package:kinoapay_app/features/kyc/domain/kyc_strings.dart";
import "package:kinoapay_app/features/kyc/infrastructure/mock_kyc_repository.dart";
import "package:kinoapay_app/features/kyc/presentation/widgets/kyc_doc_type_step.dart";
import "package:kinoapay_app/features/kyc/presentation/widgets/kyc_photo_step.dart";
import "package:kinoapay_app/features/kyc/presentation/widgets/kyc_selfie_step.dart";
import "package:kinoapay_app/features/kyc/presentation/widgets/kyc_submitted_step.dart";

/// Point d'entrée de la feature KYC — injecte le BLoC et orchestre les étapes.
class KycView extends StatelessWidget {
  const KycView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => KycBloc(repository: MockKycRepository()),
      child: const _KycContent(),
    );
  }
}

class _KycContent extends StatelessWidget {
  const _KycContent();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<KycBloc, KycState>(
      listener: (context, state) {
        if (state is KycSubmitted) {
          // La vue submitted est affichée via le builder — pas de navigation ici.
        }
      },
      builder: (context, state) {
        // Étape 4 — soumis : plein écran sans header.
        if (state is KycSubmitted) {
          return KycSubmittedStep(
            onClose: () => Navigator.pushNamedAndRemoveUntil(
              context,
              AppRoutes.shell,
              (_) => false,
            ),
          );
        }

        // Étape soumission en cours : loading plein écran.
        if (state is KycSubmitting) {
          return const Scaffold(
            backgroundColor: AppColors.quinoaCream,
            body: Center(
              child: CircularProgressIndicator(
                color: AppColors.quinoaDark,
                strokeWidth: 2,
              ),
            ),
          );
        }

        return Scaffold(
          backgroundColor: AppColors.quinoaCream,
          body: Stack(
            children: [
              SafeArea(
                child: SingleChildScrollView(
                  padding: EdgeInsets.fromLTRB(
                    24,
                    88,
                    24,
                    ScreenSizeHelper.adaptiveValue(
                      context,
                      compact: 24,
                      small: 32,
                      medium: 36,
                      large: 40,
                    ),
                  ),
                  child: _buildStep(context, state),
                ),
              ),
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: AppBackHeader(
                  onBack: _onBack(context, state),
                  backLabel: KycStrings.backLabel,
                  title: KycStrings.title,
                  subtitle: KycStrings.headerSubtitle,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStep(BuildContext context, KycState state) {
    final bloc = context.read<KycBloc>();

    if (state is KycInitial) {
      return KycDocTypeStep(
        onSelected: (type) => bloc.add(KycDocumentTypeSelected(type)),
      );
    }

    if (state is KycDocumentSelected) {
      return KycPhotoStep(
        onPhotoCaptured: (path) => bloc.add(KycDocumentPhotoTaken(path)),
      );
    }

    if (state is KycDocumentPhotoCaptured) {
      return KycSelfieStep(
        onSelfieCaptured: (path) => bloc.add(KycSelfiePhotoTaken(path)),
        onConfirm: () => bloc.add(const KycSubmitRequested()),
      );
    }

    if (state is KycReadyToSubmit) {
      return KycSelfieStep(
        onSelfieCaptured: (path) => bloc.add(KycSelfiePhotoTaken(path)),
        onConfirm: () => bloc.add(const KycSubmitRequested()),
      );
    }

    return const SizedBox.shrink();
  }

  VoidCallback _onBack(BuildContext context, KycState state) {
    final bloc = context.read<KycBloc>();
    if (state is KycInitial) return () => Navigator.pop(context);
    return () => bloc.add(const KycReset());
  }
}
