import 'package:flutter/material.dart';

/// Golden yellow & white palette used across the Investor mode.
class InvestorColors {
  InvestorColors._();

  // ─── Gold core ───────────────────────────────────────────────────────────
  static const Color gold = Color(0xFFD4A017);
  static const Color goldPrimary = Color(0xFFC99910);
  static const Color goldDeep = Color(0xFF9C7A0C);
  static const Color goldDark = Color(0xFF7A5C06);
  static const Color goldLight = Color(0xFFF5E7B8);
  static const Color goldSoft = Color(0xFFFFF6DC);
  static const Color goldMist = Color(0xFFFFF9EC);
  static const Color goldBg = Color(0xFFFFFCF4);

  // ─── Neutrals (warm whites) ──────────────────────────────────────────────
  static const Color ink = Color(0xFF2A2010);
  static const Color inkSoft = Color(0xFF57492E);
  static const Color textMuted = Color(0xFF8A7A56);
  static const Color border = Color(0xFFF0E6C8);
  static const Color card = Colors.white;

  // ─── Accents for charts / tags ────────────────────────────────────────────
  static const Color green = Color(0xFF0E9F6E);
  static const Color greenSoft = Color(0xFFE7F8F0);
  static const Color red = Color(0xFFE04444);
  static const Color redSoft = Color(0xFFFDEBEB);
  static const Color blue = Color(0xFF2563EB);
  static const Color blueSoft = Color(0xFFE8F0FE);
  static const Color purple = Color(0xFF7C3AED);
  static const Color purpleSoft = Color(0xFFF1EAFE);
  static const Color orange = Color(0xFFEA580C);
  static const Color orangeSoft = Color(0xFFFFF2E7);
  static const Color teal = Color(0xFF0F766E);
  static const Color tealSoft = Color(0xFFE6F5F3);

  // ─── Gradients ────────────────────────────────────────────────────────────
  static const LinearGradient goldGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFC99910), Color(0xFFE9C04F)],
  );

  static const LinearGradient headerGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF8B6914), Color(0xFFC99910), Color(0xFFE3B548)],
  );

  static const LinearGradient goldShimmer = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFC99910), Color(0xFFF0C75C)],
  );

  static const LinearGradient heroGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF7A5C06), Color(0xFFB8860B), Color(0xFFD4A017)],
  );

  static const List<Color> chartPalette = [
    Color(0xFFD4A017),
    Color(0xFF0E9F6E),
    Color(0xFF2563EB),
    Color(0xFF7C3AED),
    Color(0xFFEA580C),
    Color(0xFF0F766E),
  ];

  static const Map<String, Color> _colorKeys = {
    'gold': gold,
    'green': green,
    'blue': blue,
    'purple': purple,
    'orange': orange,
    'teal': teal,
    'red': red,
  };

  static const Map<String, Color> _softKeys = {
    'gold': goldSoft,
    'green': greenSoft,
    'blue': blueSoft,
    'purple': purpleSoft,
    'orange': orangeSoft,
    'teal': tealSoft,
    'red': redSoft,
  };

  static Color colorForKey(String key) => _colorKeys[key] ?? gold;

  static Color softForKey(String key) => _softKeys[key] ?? goldSoft;
}