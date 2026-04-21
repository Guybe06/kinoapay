import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:solar_icons/solar_icons.dart";
import "package:kinoapay_app/core/constants/app_colors.dart";
import "package:kinoapay_app/core/constants/app_routes.dart";
import "package:kinoapay_app/core/helpers/screen_size_helper.dart";
import "package:kinoapay_app/core/navigation/presentation/widgets/app_back_header.dart";
import "package:kinoapay_app/core/widgets/app_scroll_scaffold.dart";
import "package:kinoapay_app/core/widgets/app_snack_bar.dart";
import "package:kinoapay_app/core/widgets/staggered_entrance.dart";
import "package:kinoapay_app/features/accounts/application/bloc/auth_bloc.dart";
import "package:kinoapay_app/features/accounts/application/bloc/auth_state.dart";
import "package:kinoapay_app/features/accounts/domain/entities/user_account.dart";
import "package:kinoapay_app/features/profile/domain/profile_strings.dart";
import "package:kinoapay_app/features/profile/presentation/widgets/profile_widgets.dart";

/// Écran Profil : informations utilisateur, KinoaID et statut KYC.
class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final authState = context.watch<AuthBloc>().state;
    final user = authState is Authenticated ? authState.user : null;
    final kycVerified = authState is Authenticated
        ? authState.user.kycVerified
        : false;

    return AppScrollScaffold(
      header: AppBackHeader(
        onBack: () => Navigator.pop(context),
        backLabel: ProfileStrings.backLabel,
        title: ProfileStrings.title,
        subtitle: ProfileStrings.headerSubtitle,
      ),
      builder: (_, ctrl) {
        final compact = ScreenSizeHelper.isCompact(context);
        return SingleChildScrollView(
          controller: ctrl,
          padding: EdgeInsets.fromLTRB(
            20,
            72,
            20,
            ScreenSizeHelper.adaptiveValue(
              context,
              compact: 80,
              small: 100,
              medium: 115,
              large: 120,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: compact ? 4 : 8),
              StaggeredEntrance(
                index: 0,
                child: Text(
                  ProfileStrings.pageTitle,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.quinoaDark,
                    fontSize: compact ? 24 : 28,
                    fontWeight: FontWeight.w900,
                    letterSpacing: -0.8,
                    height: 1.1,
                  ),
                ),
              ),
              SizedBox(height: compact ? 4 : 6),
              StaggeredEntrance(
                index: 1,
                child: Text(
                  ProfileStrings.pageSubtitle,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.quinoaDark.withValues(alpha: 0.40),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    height: 1.4,
                  ),
                ),
              ),
              SizedBox(height: compact ? 24 : 32),
              StaggeredEntrance(
                index: 2,
                child: ProfileAvatar(name: user?.fullName, compact: compact),
              ),
              SizedBox(height: compact ? 10 : 14),
              StaggeredEntrance(
                index: 3,
                child: Text(
                  user?.fullName ?? "",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.quinoaDark,
                    fontSize: compact ? 20 : 22,
                    fontWeight: FontWeight.w900,
                    letterSpacing: -0.5,
                  ),
                ),
              ),
              SizedBox(height: compact ? 2 : 4),
              StaggeredEntrance(
                index: 4,
                child: Text(
                  user?.email ?? "",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.quinoaDark.withValues(alpha: 0.45),
                    fontSize: 14,
                  ),
                ),
              ),
              SizedBox(height: compact ? 2 : 4),
              // KinoaID : affiché comme le email, copiable au tap.
              StaggeredEntrance(
                index: 5,
                child: _KinoaIdInline(
                  handle: user?.publicHandle,
                  onCopied: () => AppSnackBar.showInfo(
                    context,
                    ProfileStrings.kinoaIdCopied,
                  ),
                ),
              ),
              SizedBox(height: compact ? 24 : 32),
              StaggeredEntrance(index: 6, child: _buildInfoSection(user)),
              SizedBox(height: compact ? 16 : 20),
              StaggeredEntrance(
                index: 7,
                child: _KycSection(
                  verified: kycVerified,
                  onVerify: () => Navigator.pushNamed(context, AppRoutes.kyc),
                ),
              ),
              SizedBox(height: compact ? 24 : 32),
              StaggeredEntrance(
                index: 8,
                child: Text(
                  "${ProfileStrings.version} ${ProfileStrings.appVersion}",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.quinoaDark.withValues(alpha: 0.25),
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildInfoSection(UserAccount? user) {
    return ProfileSection(
      title: ProfileStrings.personalInfo,
      children: [
        ProfileInfoRow(
          label: ProfileStrings.email,
          value: user?.email ?? ProfileStrings.empty,
        ),
        ProfileInfoRow(
          label: ProfileStrings.phone,
          value: user?.phone ?? ProfileStrings.empty,
        ),
        ProfileInfoRow(
          label: ProfileStrings.birthDate,
          value: user?.birthDate ?? ProfileStrings.empty,
        ),
      ],
    );
  }
}

/// KinoaID affiché en texte simple sous l'email, copiable au tap.
class _KinoaIdInline extends StatelessWidget {
  final String? handle;
  final VoidCallback onCopied;

  const _KinoaIdInline({required this.handle, required this.onCopied});

  @override
  Widget build(BuildContext context) {
    final hasHandle = handle != null && handle!.isNotEmpty;

    return GestureDetector(
      onTap: hasHandle
          ? () async {
              await Clipboard.setData(ClipboardData(text: handle!));
              onCopied();
            }
          : null,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            hasHandle ? handle! : ProfileStrings.empty,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.quinoaDark.withValues(alpha: 0.45),
              fontSize: 14,
            ),
          ),
          if (hasHandle) ...[
            const SizedBox(width: 6),
            Icon(
              SolarIconsOutline.copy,
              size: 13,
              color: AppColors.quinoaDark.withValues(alpha: 0.25),
            ),
          ],
        ],
      ),
    );
  }
}

/// Section KYC : affiche le statut et un CTA si l'identité n'est pas vérifiée.
class _KycSection extends StatelessWidget {
  final bool verified;
  final VoidCallback onVerify;

  const _KycSection({required this.verified, required this.onVerify});

  @override
  Widget build(BuildContext context) {
    return ProfileSection(
      title: ProfileStrings.kycSection,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ProfileKycBadge(
              verified: verified,
              label: verified
                  ? ProfileStrings.kycVerifiedStatus
                  : ProfileStrings.kycPendingStatus,
            ),
            if (!verified)
              GestureDetector(
                onTap: onVerify,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.quinoaDark,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    ProfileStrings.kycCta,
                    style: TextStyle(
                      color: AppColors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
          ],
        ),
        if (!verified) ...[
          const SizedBox(height: 10),
          Text(
            ProfileStrings.kycBody,
            style: TextStyle(
              color: AppColors.quinoaDark.withValues(alpha: 0.45),
              fontSize: 13,
              height: 1.5,
            ),
          ),
        ],
      ],
    );
  }
}
