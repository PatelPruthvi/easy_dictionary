import 'package:flutter/material.dart';

class AppPalette extends ThemeExtension<AppPalette> {
  const AppPalette({
    required this.cardPurple,
    required this.accentPurple,
    required this.strongPurple,
    required this.cardOrange,
    required this.accentOrange,
    required this.cardBlue,
    required this.accentBlue,
    required this.cardGreen,
    required this.accentGreen,
    required this.cardLavender,
    required this.cardPeach,
    required this.error,
    required this.divider,
    required this.shimmerBase,
    required this.shimmerHighlight,
    required this.tagDefault,
    required this.textPrimary,
    required this.textSecondary,
    required this.textFaint,
    required this.background,
  });

  final Color cardPurple;
  final Color accentPurple;
  final Color strongPurple;
  final Color cardOrange;
  final Color accentOrange;
  final Color cardBlue;
  final Color accentBlue;
  final Color cardGreen;
  final Color accentGreen;
  final Color cardLavender;
  final Color cardPeach;
  final Color error;
  final Color divider;
  final Color shimmerBase;
  final Color shimmerHighlight;
  final Color tagDefault;
  final Color textPrimary;
  final Color textSecondary;
  final Color textFaint;
  final Color background;

  static AppPalette of(BuildContext context) =>
      Theme.of(context).extension<AppPalette>()!;

  static const light = AppPalette(
    cardPurple: Color(0xffEFEDFD),
    accentPurple: Color(0xffD5D3FB),
    strongPurple: Color(0xff7F77CE),
    cardOrange: Color(0xffFBF2EE),
    accentOrange: Color(0xffF6DED2),
    cardBlue: Color(0xffECF7FE),
    accentBlue: Color(0xffB7E3FC),
    cardGreen: Color(0xffF0F9EC),
    accentGreen: Color(0xffD7F8B3),
    cardLavender: Color(0xffF2EEFF),
    cardPeach: Color(0xFFFBF2EE),
    error: Color(0xFFE53935),
    divider: Color(0xFFE0E0E0),
    shimmerBase: Color(0xFFE0E0E0),
    shimmerHighlight: Color(0xFFF5F5F5),
    tagDefault: Color(0xFFF5F5F5),
    textPrimary: Colors.black,
    textSecondary: Color(0xFF757575),
    textFaint: Color(0xFF9E9E9E),
    background: Colors.white,
  );

  static const dark = AppPalette(
    cardPurple: Color(0xFF28243D),
    accentPurple: Color(0xFF3D3860),
    strongPurple: Color(0xFF9B93E0),
    cardOrange: Color(0xFF302820),
    accentOrange: Color(0xFF4D3D2A),
    cardBlue: Color(0xFF1C2835),
    accentBlue: Color(0xFF2A4560),
    cardGreen: Color(0xFF1C2D20),
    accentGreen: Color(0xFF2A4D30),
    cardLavender: Color(0xFF221E35),
    cardPeach: Color(0xFF302820),
    error: Color(0xFFEF5350),
    divider: Color(0xFF2A2A3E),
    shimmerBase: Color(0xFF2A2A3E),
    shimmerHighlight: Color(0xFF3A3A4E),
    tagDefault: Color(0xFF2A2A3E),
    textPrimary: Colors.white,
    textSecondary: Color(0xB3FFFFFF),
    textFaint: Color(0x61FFFFFF),
    background: Color(0xFF12121E),
  );

  @override
  AppPalette copyWith({
    Color? cardPurple,
    Color? accentPurple,
    Color? strongPurple,
    Color? cardOrange,
    Color? accentOrange,
    Color? cardBlue,
    Color? accentBlue,
    Color? cardGreen,
    Color? accentGreen,
    Color? cardLavender,
    Color? cardPeach,
    Color? error,
    Color? divider,
    Color? shimmerBase,
    Color? shimmerHighlight,
    Color? tagDefault,
    Color? textPrimary,
    Color? textSecondary,
    Color? textFaint,
    Color? background,
  }) {
    return AppPalette(
      cardPurple: cardPurple ?? this.cardPurple,
      accentPurple: accentPurple ?? this.accentPurple,
      strongPurple: strongPurple ?? this.strongPurple,
      cardOrange: cardOrange ?? this.cardOrange,
      accentOrange: accentOrange ?? this.accentOrange,
      cardBlue: cardBlue ?? this.cardBlue,
      accentBlue: accentBlue ?? this.accentBlue,
      cardGreen: cardGreen ?? this.cardGreen,
      accentGreen: accentGreen ?? this.accentGreen,
      cardLavender: cardLavender ?? this.cardLavender,
      cardPeach: cardPeach ?? this.cardPeach,
      error: error ?? this.error,
      divider: divider ?? this.divider,
      shimmerBase: shimmerBase ?? this.shimmerBase,
      shimmerHighlight: shimmerHighlight ?? this.shimmerHighlight,
      tagDefault: tagDefault ?? this.tagDefault,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      textFaint: textFaint ?? this.textFaint,
      background: background ?? this.background,
    );
  }

  @override
  AppPalette lerp(AppPalette? other, double t) {
    if (other is! AppPalette) return this;
    return AppPalette(
      cardPurple: Color.lerp(cardPurple, other.cardPurple, t)!,
      accentPurple: Color.lerp(accentPurple, other.accentPurple, t)!,
      strongPurple: Color.lerp(strongPurple, other.strongPurple, t)!,
      cardOrange: Color.lerp(cardOrange, other.cardOrange, t)!,
      accentOrange: Color.lerp(accentOrange, other.accentOrange, t)!,
      cardBlue: Color.lerp(cardBlue, other.cardBlue, t)!,
      accentBlue: Color.lerp(accentBlue, other.accentBlue, t)!,
      cardGreen: Color.lerp(cardGreen, other.cardGreen, t)!,
      accentGreen: Color.lerp(accentGreen, other.accentGreen, t)!,
      cardLavender: Color.lerp(cardLavender, other.cardLavender, t)!,
      cardPeach: Color.lerp(cardPeach, other.cardPeach, t)!,
      error: Color.lerp(error, other.error, t)!,
      divider: Color.lerp(divider, other.divider, t)!,
      shimmerBase: Color.lerp(shimmerBase, other.shimmerBase, t)!,
      shimmerHighlight: Color.lerp(shimmerHighlight, other.shimmerHighlight, t)!,
      tagDefault: Color.lerp(tagDefault, other.tagDefault, t)!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      textFaint: Color.lerp(textFaint, other.textFaint, t)!,
      background: Color.lerp(background, other.background, t)!,
    );
  }
}
