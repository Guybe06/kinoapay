import "package:flutter/material.dart";
import "package:kinoapay_app/core/constants/kinoa_colors.dart";

/// Champ de saisie.
class AuthTextField extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      validator: validator,
      style: const TextStyle(
        color: KinoaColors.stone900,
        fontSize: 16,
        fontWeight: FontWeight.w500,
      ),
      cursorColor: KinoaColors.primary,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(
          color: KinoaColors.stone500,
          fontSize: 14,
        ),
        hintText: hintText,
        hintStyle: const TextStyle(
          color: KinoaColors.stone300,
          fontSize: 14,
        ),
        floatingLabelStyle: const TextStyle(
          color: KinoaColors.primary,
          fontWeight: FontWeight.w600,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        prefixIcon: prefixIcon != null 
          ? Icon(
              prefixIcon, 
              color: KinoaColors.stone400, 
              size: 20,
            ) 
          : null,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24),
          borderSide: const BorderSide(
            color: KinoaColors.stone200,
            width: 1.5,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24),
          borderSide: const BorderSide(
            color: KinoaColors.primary,
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24),
          borderSide: const BorderSide(
            color: KinoaColors.error,
            width: 1.5,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24),
          borderSide: const BorderSide(
            color: KinoaColors.error,
            width: 2,
          ),
        ),
        errorStyle: const TextStyle(height: 0, fontSize: 0), // Cache le texte sous le champ
        filled: false,
      ),
    );
  }
}
