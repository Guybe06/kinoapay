import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:kinoapay_app/core/constants/app_colors.dart";
import "package:kinoapay_app/core/constants/app_routes.dart";
import "package:kinoapay_app/core/widgets/staggered_entrance.dart";
import "package:kinoapay_app/features/accounts/application/bloc/auth_bloc.dart";
import "package:kinoapay_app/features/accounts/application/bloc/auth_event.dart";
import "package:kinoapay_app/features/accounts/application/bloc/auth_state.dart";
import "package:kinoapay_app/features/accounts/domain/entities/user_account.dart";
import "package:kinoapay_app/features/profile/domain/profile_strings.dart";

/// Écran Profil : infos utilisateur et déconnexion.
class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final topInset = MediaQuery.of(context).padding.top;
    final authState = context.watch<AuthBloc>().state;
    final user = authState is Authenticated ? authState.user : null;

    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(20, topInset + 80, 20, 120),
      child: Column(
        children: [
          KinoaEntrance(index: 0, child: _buildAvatar(user?.fullName)),
          const SizedBox(height: 14),
          KinoaEntrance(
            index: 1,
            child: Text(
              user?.fullName ?? "",
              style: const TextStyle(color: KinoaColors.quinoaDark, fontSize: 22, fontWeight: FontWeight.w900, letterSpacing: -0.5),
            ),
          ),
          const SizedBox(height: 4),
          KinoaEntrance(
            index: 2,
            child: Text(
              user?.email ?? "",
              style: TextStyle(color: KinoaColors.quinoaDark.withValues(alpha: 0.45), fontSize: 14),
            ),
          ),
          const SizedBox(height: 32),
          KinoaEntrance(index: 3, child: _buildInfoSection(user)),
          const SizedBox(height: 16),
          KinoaEntrance(index: 4, child: _buildSignOutBtn(context)),
          const SizedBox(height: 24),
          KinoaEntrance(
            index: 5,
            child: Text(
              "${ProfileStrings.version} 1.0.0",
              style: TextStyle(color: KinoaColors.quinoaDark.withValues(alpha: 0.25), fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvatar(String? name) {
    final initials = _initials(name ?? "");
    return Container(
      width: 72,
      height: 72,
      decoration: BoxDecoration(
        color: KinoaColors.quinoaGold.withValues(alpha: 0.15),
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: Text(
        initials,
        style: const TextStyle(color: KinoaColors.quinoaGold, fontSize: 26, fontWeight: FontWeight.w900),
      ),
    );
  }

  Widget _buildInfoSection(UserAccount? user) {
    return _Section(
      title: ProfileStrings.personalInfo,
      children: [
        _InfoRow(label: ProfileStrings.email, value: user?.email ?? "—"),
        _InfoRow(label: ProfileStrings.phone, value: user?.phone ?? "—"),
        _InfoRow(label: ProfileStrings.birthDate, value: user?.birthDate ?? "—"),
      ],
    );
  }

  Widget _buildSignOutBtn(BuildContext context) {
    return GestureDetector(
      onTap: () => _confirmSignOut(context),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 18),
        decoration: BoxDecoration(
          color: KinoaColors.quinoaRed.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: KinoaColors.quinoaRed.withValues(alpha: 0.15)),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.logout_rounded, size: 18, color: KinoaColors.quinoaRed),
            SizedBox(width: 10),
            Text(
              ProfileStrings.signOut,
              style: TextStyle(color: KinoaColors.quinoaRed, fontSize: 15, fontWeight: FontWeight.w800),
            ),
          ],
        ),
      ),
    );
  }

  void _confirmSignOut(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: KinoaColors.quinoaCream,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(ProfileStrings.signOutConfirmTitle, style: TextStyle(fontWeight: FontWeight.w800)),
        content: const Text(ProfileStrings.signOutConfirmBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text("Annuler", style: TextStyle(color: KinoaColors.quinoaDark.withValues(alpha: 0.5))),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              context.read<AuthBloc>().add(SignOutRequested());
              Navigator.pushNamedAndRemoveUntil(context, KinoaRoutes.signin, (_) => false);
            },
            child: const Text(ProfileStrings.signOut, style: TextStyle(color: KinoaColors.quinoaRed, fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }

  String _initials(String name) {
    final parts = name.trim().split(" ");
    if (parts.length >= 2) return "${parts[0][0]}${parts[1][0]}".toUpperCase();
    return name.isNotEmpty ? name[0].toUpperCase() : "?";
  }
}

class _Section extends StatelessWidget {
  final String title;
  final List<Widget> children;
  const _Section({required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: KinoaColors.quinoaDark.withValues(alpha: 0.06)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title.toUpperCase(), style: TextStyle(color: KinoaColors.quinoaDark.withValues(alpha: 0.35), fontSize: 10, fontWeight: FontWeight.w800, letterSpacing: 0.8)),
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: KinoaColors.quinoaDark.withValues(alpha: 0.5), fontSize: 13, fontWeight: FontWeight.w500)),
          Text(value, style: const TextStyle(color: KinoaColors.quinoaDark, fontSize: 14, fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
}
