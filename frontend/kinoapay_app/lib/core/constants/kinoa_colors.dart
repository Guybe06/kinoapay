import "package:flutter/material.dart";

/// Palette de couleurs officielle KinoaPay, toute valeur hexadécimale doit être définie ici, jamais dans le code.
class KinoaColors {
  static const Color quinoaGold = Color(0xFFC8964A);
  static const Color quinoaGoldLight = Color(0xFFE8C98A);
  static const Color quinoaGoldLowOpacity = Color(0x40C8964A);
  static const Color quinoaRed = Color(0xFF8B3A2F);
  static const Color quinoaDark = Color(0xFF2C2416);
  static const Color quinoaDeep = Color(0xFF080503);
  static const Color quinoaBlank = Color(0xFFF5E6C8);
  static const Color quinoaSand = Color(0xFFEDD9A3);
  static const Color quinoaCream = Color(0xFFFBF5E9);
  static const Color quinoaWarmGray = Color(0xFF7A6A55);
  static const Color accent = Color(0xFFBBCB64);
  static const Color accentDark = Color(0xFFA6CC00);
  static const Color accentLowOpacity = Color(0x33D9FF19);
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
  static const Color burtViolet = Color(0xFFE2D1F9);
  static const Color burtOrange = Color(0xFFFEE1C7);
  static const Color burtCyan = Color(0xFFD1F2F9);

  /// Dégradé complet Burt dans l'ordre [violet, orange, cyan] pour LinearGradient.
  static const List<Color> burtGradient = [
    burtViolet,
    burtOrange,
    burtCyan,
  ];

  static const Color surfaceDark = Color(0xFF0D0D0D);
  static const Color surfaceCard = Color(0xFF1A1A1A);
  static const Color surfaceOverlay = Color(0x80000000);
  static const Color surfaceGlass = Color(0x1AFFFFFF);
  static const Color surfaceGlassBorder = Color(0x33FFFFFF);
  static const Color primary = quinoaGold;
  static const Color background = quinoaCream;
  static const Color backgroundLight = quinoaCream;
  static const Color backgroundDark = quinoaDark;
  static const Color backgroundShell = stone950;
  static const Color textMain = quinoaDark;
  static const Color textLight = quinoaBlank;
  static const Color textMuted = quinoaWarmGray;
  static const Color border = stone200;
  static const Color borderDark = stone700;
  static const Color success = Color(0xFF10B981);
  static const Color successLowOpacity = Color(0x2010B981);
  static const Color error = Color(0xFFE11D48);
  static const Color errorLowOpacity = Color(0x20E11D48);
  static const Color warning = Color(0xFFF59E0B);
  static const Color warningLowOpacity = Color(0x20F59E0B);
  static const Color pending = Color(0xFF6366F1);
  static const Color pendingLowOpacity = Color(0x206366F1);
  static const Color navBackground = stone950;
  static const Color navActive = quinoaGold;
  static const Color navInactive = stone500;
  static const Color mtnYellow = Color(0xFFFFCC00);
  static const Color airtelRed = Color(0xFFEE1B24);
  static const Color white = Color(0xFFFFFFFF);
  static const Color transparent = Color(0x00000000);
}
