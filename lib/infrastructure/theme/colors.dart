import 'package:flutter/material.dart';

final class KColor {
  // ── Existing brand colors ──────────────────────────────────────────────────
  static Color secondaryColor = const Color(0xFFF66435);
  static Color secondarySecondColor = const Color(0xFF9D1F15);
  static Color primaryColor = const Color(0xFFF4EFCA);
  static Color primarySecondColor = const Color(0xFFFBF7BA);

  // ── Dark backgrounds ──────────────────────────────────────────────────────
  /// Deepest dark background (main.dart mesh, gradient stop)
  static const Color darkDeepest = Color(0xFF0A0E27);

  /// Scaffold / app-level dark background
  static const Color darkScaffold = Color(0xFF1A1A2E);

  /// Dark navy used in card / panel backgrounds
  static const Color darkNavy = Color(0xFF0A1628);

  /// Deep navy used as gradient partner of [darkNavy]
  static const Color deepNavy = Color(0xFF001529);

  /// Very deep navy (darkest gradient stop)
  static const Color deepestNavy = Color(0xFF000A1F);

  /// Near-black (alternative deep dark)
  static const Color nearBlack = Color(0xFF000108);

  /// Dark navy overlay / floating element bg
  static const Color darkOverlay = Color(0xFF1A1F3A);

  /// Dark slate (menu / hover tint)
  static const Color darkSlate = Color(0xFF23304A);

  /// Dark grey (secondary header / panel)
  static const Color darkGrey = Color(0xFF2A2A2A);

  // ── Primary blue ──────────────────────────────────────────────────────────
  /// Primary action / accent blue
  static const Color accentBlue = Color(0xFF0A4A8E);

  // ── Border / neutral ──────────────────────────────────────────────────────
  /// Generic border / divider grey
  static const Color borderGrey = Color(0xFF444444);

  // ── Red variants ─────────────────────────────────────────────────────────
  /// Bright alert red
  static const Color alertRed = Color(0xFFFF4444);

  /// Dark red (shimmer base / error card bg)
  static const Color darkRed = Color(0xFF8B0000);

  /// Darker red (shimmer gradient)
  static const Color darkerRed = Color(0xFF4B0000);

  /// Dark red variant
  static const Color darkRedAlt = Color(0xFF6B0000);

  /// Darkest red variant
  static const Color darkestRed = Color(0xFF3B0000);

  // ── Green variants ────────────────────────────────────────────────────────
  /// Bright success green
  static const Color successGreen = Color(0xFF00C853);

  /// Medium success green
  static const Color mediumGreen = Color(0xFF00A843);

  /// Dark success green
  static const Color darkGreen = Color(0xFF008833);

  // ── Footer / UI tints ────────────────────────────────────────────────────
  /// Footer foreground / text tint
  static const Color footerForeground = Color(0xFFC7D3B6);

  // ── CLI / code-editor colors ─────────────────────────────────────────────
  /// CLI terminal background
  static const Color cliBg = Color(0xFF232323);

  /// CLI prompt green
  static const Color cliPromptGreen = Color(0xFF6A9955);

  /// CLI normal output grey
  static const Color cliOutputGrey = Color(0xFFD4D4D4);

  /// CLI cursor / type-highlight blue
  static const Color cliCursorBlue = Color(0xFF9CDCFE);

  /// Code syntax – string green
  static const Color syntaxGreen = Color(0xFF7EC699);

  /// Code syntax – number / keyword yellow
  static const Color syntaxYellow = Color(0xFFCCAA6E);

  /// Code syntax – error / value red
  static const Color syntaxRed = Color(0xFFE86671);

  // ── Traffic-light / window chrome ─────────────────────────────────────────
  /// Traffic light – close (red)
  static const Color trafficRed = Color(0xFFFF5F56);

  /// Traffic light – close accent
  static const Color trafficRedAlt = Color(0xFFED6A5E);

  /// Traffic light – minimise (yellow)
  static const Color trafficYellow = Color(0xFFFFBD2E);

  /// Traffic light – minimise accent
  static const Color trafficYellowAlt = Color(0xFFF5BF4F);

  /// Traffic light – maximise (green)
  static const Color trafficGreen = Color(0xFF27C93F);

  // ── Mesh / glow ──────────────────────────────────────────────────────────
  /// Cyan glow used in mesh background painter
  static const Color meshGlow = Color(0xFF00D9FF);

  /// Mesh bg – dark blue-black
  static const Color meshDark1 = Color(0xFF0F0F23);

  /// Mesh bg – dark purple-blue
  static const Color meshDark2 = Color(0xFF1A1A3E);

  /// Mesh bg – dark navy
  static const Color meshDark3 = Color(0xFF0D1B2A);

  /// Mesh bg – dark slate blue
  static const Color meshDark4 = Color(0xFF1B263B);

  // ── File-card / admin gradient palette ───────────────────────────────────
  static const Color gradientPurple = Color(0xFF7F53AC);
  static const Color gradientIndigo = Color(0xFF647DEE);
  static const Color gradientTeal = Color(0xFF43C6AC);
  static const Color gradientOrange = Color(0xFFF7971E);
  static const Color gradientDeepIndigo = Color(0xFF191654);

  // ── Barrier / overlay ────────────────────────────────────────────────────
  /// Semi-transparent black barrier
  static const Color barrierBlack = Color(0x66000000);
}
