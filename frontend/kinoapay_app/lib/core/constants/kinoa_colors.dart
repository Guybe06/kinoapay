import "package:flutter/material.dart";

/// Définit la palette de couleurs officielle de l'application KinoaPay.
class KinoaColors {
  // Couleurs de marque
  static const Color primary = Color(0xFFC8964A);
  static const Color primaryLowOpacity = Color(0x40C8964A);
  
  // Palette Stone (Inspirée par Tailwind CSS)
  static const Color stone50 = Color(0xFFFAFAF9);
  static const Color stone100 = Color(0xFFF5F5F4);
  static const Color stone200 = Color(0xFFE7E5E4);
  static const Color stone300 = Color(0xFFD6D3D1);
  static const Color stone400 = Color(0xFFA8A29E);
  static const Color stone500 = Color(0xFF78716C);
  static const Color stone600 = Color(0xFF57534E);
  static const Color stone700 = Color(0xFF44403C);
  static const Color stone800 = Color(0xFF292524);
  static const Color stone900 = Color(0xFF1C1917);
  static const Color stone950 = Color(0xFF0C0A09);

  // Burt Pastel Gradient
  static const Color burtViolet = Color(0xFFE2D1F9);
  static const Color burtOrange = Color(0xFFFEE1C7);
  static const Color burtCyan = Color(0xFFD1F2F9);

  static const List<Color> burtGradient = [
    burtViolet,
    burtOrange,
    burtCyan,
  ];

  // Alias sémantiques
  static const Color background = stone950;
  static const Color textMain = stone900;
  static const Color textMuted = stone500;
  static const Color border = stone200;

  static const Color success = Color(0xFF10B981); // Emerald 500
  static const Color error = Color(0xFFE11D48);   // Rose 600
}
