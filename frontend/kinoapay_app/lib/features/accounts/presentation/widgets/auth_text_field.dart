import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import "package:kinoapay_app/core/constants/app_colors.dart";

/// Champ de saisie standardisé pour les formulaires d'authentification.
class AuthTextField extends StatefulWidget {
  final String label;
  final String? hintText;
  final bool obscureText;
  final TextInputType keyboardType;
  final TextEditingController? controller;
  final String? Function(String?)? validator;

  const AuthTextField({
    super.key,
    required this.label,
    this.hintText,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.controller,
    this.validator,
  });

  @override
  State<AuthTextField> createState() => _AuthTextFieldState();
}

class _AuthTextFieldState extends State<AuthTextField> {
  late bool _obscure;
  final _focusNode = FocusNode();
  bool _hasFocus = false;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _obscure = widget.obscureText;
    _focusNode.addListener(() => setState(() => _hasFocus = _focusNode.hasFocus));
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const borderRadius = BorderRadius.only(
      topRight: Radius.circular(24),
      bottomLeft: Radius.circular(24),
      bottomRight: Radius.circular(24),
    );

    final ringColor = _hasError
        ? KinoaColors.quinoaRed.withValues(alpha: 0.12)
        : KinoaColors.quinoaGold.withValues(alpha: 0.14);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOut,
      decoration: BoxDecoration(
        borderRadius: borderRadius,
        boxShadow: [
          BoxShadow(
            color: (_hasFocus || _hasError) ? ringColor : Colors.transparent,
            spreadRadius: 3,
            blurRadius: 0,
          ),
        ],
      ),
      child: TextFormField(
        controller: widget.controller,
        focusNode: _focusNode,
        obscureText: _obscure,
        keyboardType: widget.keyboardType,
        onChanged: (_) { if (_hasError) setState(() => _hasError = false); },
        validator: (value) {
          final result = widget.validator?.call(value);
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted && _hasError != (result != null)) {
              setState(() => _hasError = result != null);
            }
          });
          return result;
        },
        style: const TextStyle(color: KinoaColors.quinoaDark, fontSize: 16, fontWeight: FontWeight.w600),
        cursorColor: KinoaColors.quinoaGold,
        decoration: InputDecoration(
          labelText: widget.label,
          labelStyle: TextStyle(color: KinoaColors.quinoaDark.withValues(alpha: 0.45), fontSize: 14, fontWeight: FontWeight.w500),
          hintText: widget.hintText,
          hintStyle: TextStyle(color: KinoaColors.quinoaDark.withValues(alpha: 0.25), fontSize: 14),
          floatingLabelStyle: const TextStyle(color: KinoaColors.quinoaGold, fontWeight: FontWeight.w700),
          contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 22),
          suffixIcon: widget.obscureText
              ? IconButton(
                  icon: Icon(
                    _obscure ? CupertinoIcons.eye_slash_fill : CupertinoIcons.eye_fill,
                    color: KinoaColors.quinoaDark.withValues(alpha: 0.4),
                    size: 20,
                  ),
                  onPressed: () => setState(() => _obscure = !_obscure),
                )
              : null,
          filled: true,
          fillColor: _hasFocus ? KinoaColors.white : KinoaColors.white.withValues(alpha: 0.65),
          enabledBorder: OutlineInputBorder(
            borderRadius: borderRadius,
            borderSide: BorderSide(color: KinoaColors.quinoaDark.withValues(alpha: 0.12), width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: borderRadius,
            borderSide: BorderSide(color: KinoaColors.quinoaGold.withValues(alpha: 0.6), width: 1.5),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: borderRadius,
            borderSide: BorderSide(color: KinoaColors.quinoaRed.withValues(alpha: 0.35), width: 1),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: borderRadius,
            borderSide: BorderSide(color: KinoaColors.quinoaRed.withValues(alpha: 0.6), width: 1.5),
          ),
          errorStyle: const TextStyle(color: KinoaColors.quinoaRed, fontSize: 12, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }
}
