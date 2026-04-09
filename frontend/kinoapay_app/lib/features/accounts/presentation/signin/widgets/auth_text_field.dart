import "package:flutter/material.dart";
import "package:lucide_icons/lucide_icons.dart";
import "package:kinoapay_app/core/constants/kinoa_colors.dart";

/// Champ de saisie stylisé avec gestion optionnelle de la visibilité du mot de passe.
class AuthTextField extends StatefulWidget {
  final String label;
  final String? hintText;
  final bool obscureText;
  final TextInputType keyboardType;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final IconData? prefixIcon;

  const AuthTextField({
    super.key,
    required this.label,
    this.hintText,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.controller,
    this.validator,
    this.prefixIcon,
  });

  @override
  State<AuthTextField> createState() => _AuthTextFieldState();
}

class _AuthTextFieldState extends State<AuthTextField> {
  late bool _obscureText;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.obscureText;
  }

  @override
  Widget build(BuildContext context) {
    const borderRadius = BorderRadius.only(
      topLeft: Radius.zero,
      topRight: Radius.circular(24),
      bottomLeft: Radius.circular(24),
      bottomRight: Radius.circular(24),
    );

    return TextFormField(
      controller: widget.controller,
      obscureText: _obscureText,
      keyboardType: widget.keyboardType,
      validator: widget.validator,
      style: const TextStyle(
        color: KinoaColors.stone900,
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),
      cursorColor: KinoaColors.stone900,
      decoration: InputDecoration(
        labelText: widget.label,
        labelStyle: TextStyle(
          color: KinoaColors.stone900.withValues(alpha: 0.5),
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        hintText: widget.hintText,
        hintStyle: TextStyle(
          color: KinoaColors.stone900.withValues(alpha: 0.3),
          fontSize: 14,
        ),
        floatingLabelStyle: const TextStyle(
          color: KinoaColors.stone900,
          fontWeight: FontWeight.w700,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 22),
        prefixIcon: widget.prefixIcon != null 
          ? Icon(
              widget.prefixIcon, 
              color: KinoaColors.stone900, 
              size: 20,
            ) 
          : null,
        suffixIcon: widget.obscureText 
          ? IconButton(
              icon: Icon(
                _obscureText ? LucideIcons.eyeOff : LucideIcons.eye,
                color: KinoaColors.stone900.withValues(alpha: 0.5),
                size: 20,
              ),
              onPressed: () => setState(() => _obscureText = !_obscureText),
            )
          : null,
        filled: true,
        fillColor: Colors.white.withValues(alpha: 0.5),
        enabledBorder: OutlineInputBorder(
          borderRadius: borderRadius,
          borderSide: BorderSide(
            color: KinoaColors.stone900.withValues(alpha: 0.1),
            width: 1.5,
          ),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: borderRadius,
          borderSide: BorderSide(
            color: KinoaColors.stone900,
            width: 2,
          ),
        ),
        errorBorder: const OutlineInputBorder(
          borderRadius: borderRadius,
          borderSide: BorderSide(
            color: KinoaColors.error,
            width: 1.5,
          ),
        ),
        focusedErrorBorder: const OutlineInputBorder(
          borderRadius: borderRadius,
          borderSide: BorderSide(
            color: KinoaColors.error,
            width: 2,
          ),
        ),
        errorStyle: const TextStyle(height: 0, fontSize: 0),
      ),
    );
  }
}
