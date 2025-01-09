import 'package:flutter/material.dart';

class RoverTextTheme {
  final TextStyle headingHero;
  final TextStyle headingH1;
  final TextStyle headingH2;
  final TextStyle titleXL;
  final TextStyle titleL;
  final TextStyle titleM;
  final TextStyle titleS;
  final TextStyle bodyXL;
  final TextStyle bodyL;
  final TextStyle bodyM;
  final TextStyle bodyS;

  const RoverTextTheme({
    required this.headingHero,
    required this.headingH1,
    required this.headingH2,
    required this.titleXL,
    required this.titleL,
    required this.titleM,
    required this.titleS,
    required this.bodyXL,
    required this.bodyL,
    required this.bodyM,
    required this.bodyS,
  });

  RoverTextTheme copyWith({
    TextStyle? headingHero,
    TextStyle? headingH1,
    TextStyle? headingH2,
    TextStyle? titleXL,
    TextStyle? titleL,
    TextStyle? titleM,
    TextStyle? titleS,
    TextStyle? bodyXL,
    TextStyle? bodyL,
    TextStyle? bodyM,
    TextStyle? bodyS,
  }) {
    return RoverTextTheme(
      headingHero: headingHero ?? this.headingHero,
      headingH1: headingH1 ?? this.headingH1,
      headingH2: headingH2 ?? this.headingH2,
      titleXL: titleXL ?? this.titleXL,
      titleL: titleL ?? this.titleL,
      titleM: titleM ?? this.titleM,
      titleS: titleS ?? this.titleS,
      bodyXL: bodyXL ?? this.bodyXL,
      bodyL: bodyL ?? this.bodyL,
      bodyM: bodyM ?? this.bodyM,
      bodyS: bodyS ?? this.bodyS,
    );
  }

  RoverTextTheme lerp(RoverTextTheme other, double t) {
    return RoverTextTheme(
      headingHero: TextStyle.lerp(headingHero, other.headingHero, t) ?? headingHero,
      headingH1: TextStyle.lerp(headingH1, other.headingH1, t) ?? headingH1,
      headingH2: TextStyle.lerp(headingH2, other.headingH2, t) ?? headingH2,
      titleXL: TextStyle.lerp(titleXL, other.titleXL, t) ?? titleXL,
      titleL: TextStyle.lerp(titleL, other.titleL, t) ?? titleL,
      titleM: TextStyle.lerp(titleM, other.titleM, t) ?? titleM,
      titleS: TextStyle.lerp(titleS, other.titleS, t) ?? titleS,
      bodyXL: TextStyle.lerp(bodyXL, other.bodyXL, t) ?? bodyXL,
      bodyL: TextStyle.lerp(bodyL, other.bodyL, t) ?? bodyL,
      bodyM: TextStyle.lerp(bodyM, other.bodyM, t) ?? bodyM,
      bodyS: TextStyle.lerp(bodyS, other.bodyS, t) ?? bodyS,
    );
  }
}
