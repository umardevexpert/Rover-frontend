import 'dart:math';

import 'package:flutter/material.dart';
import 'package:material_color_utilities/material_color_utilities.dart';

const _MATERIAL_TONAL_PALETTE_TONES = <double>[0, 10, 20, 30, 40, 50, 60, 70, 80, 90, 95, 99, 100];

extension ColorExtension on Color {
  static const HUE_MAX_VALUE = 360.0;
  static const TONE_MAX_VALUE = 100.0;

  /// Chroma has different max value for every color.
  /// According to https://m3.material.io/styles/color/system/how-the-system-works
  /// "Chroma values in HCT top out at roughly 120".
  static const CHROMA_MAX_VALUE = 120.0;

  Color get inverseColor {
    return Color.fromARGB(alpha, 255 - red, 255 - green, 255 - blue);
  }

  MaterialColor get asMaterialColor {
    final strengths = <double>[.05];
    final swatch = <int, Color>{};
    final r = red, g = green, b = blue;

    for (var i = 1; i < 10; i++) {
      strengths.add(0.1 * i);
    }
    for (final strength in strengths) {
      final ds = 0.5 - strength;
      swatch[(strength * 1000).round()] = Color.fromRGBO(
        r + ((ds < 0 ? r : (255 - r)) * ds).round(),
        g + ((ds < 0 ? g : (255 - g)) * ds).round(),
        b + ((ds < 0 ? b : (255 - b)) * ds).round(),
        1,
      );
    }
    return MaterialColor(value, swatch);
  }

  /// includeAlpha value null means "auto alpha": Alpha is only included if this color is not 100% opaque
  String toHexString({bool withHashSignPrefix = true, bool? includeAlpha, bool uppercase = true}) {
    final alphaHexOrEmpty = (includeAlpha ?? alpha < 255) ? _componentAsHex(alpha) : '';
    final optionalHexSign = withHashSignPrefix ? '#' : '';

    final lowerCaseHex = '$optionalHexSign'
        '$alphaHexOrEmpty'
        '${_componentAsHex(red)}'
        '${_componentAsHex(green)}'
        '${_componentAsHex(blue)}';
    return uppercase ? lowerCaseHex.toUpperCase() : lowerCaseHex;
  }

  String _componentAsHex(int component) => component.toRadixString(16).padLeft(2, '0');

  HSLColor get asHSL => HSLColor.fromColor(this);

  double get lightness => asHSL.lightness;

  double get hue => asHSL.hue;

  double get saturation => asHSL.saturation;

  Color withLightness(double lightness) {
    assert(lightness >= 0 && lightness <= 1);
    return asHSL.withLightness(max(0, min(lightness, 1))).toColor();
  }

  Color withHue(double hue) {
    assert(hue >= 0 && hue <= HUE_MAX_VALUE);
    return asHSL.withHue(max(0, min(hue, HUE_MAX_VALUE))).toColor();
  }

  /// this color mapped to Material design's custom hue, chroma, tone color model
  Hct get asHct => Hct.fromInt(value);

  /// hue in Material design's custom hue, chroma, tone
  double get hue360 => asHct.hue;

  double get tone => asHct.tone;

  double get chroma => asHct.chroma;

  // Sometimes returning negative false, depends if comparing RGB or HCT
  // real example: Color(0xff31111d) => H359 C24 T10 != Color(0xff31101d) H359 C24 T10
  bool areSameInHctModel(Color otherColor) {
    return hue360 == otherColor.hue360 && tone == otherColor.tone && chroma == otherColor.chroma;
  }

  Color withTone(double tone) => asHct.withTone(tone).toColor();

  Color withChroma(double chroma) => asHct.withChroma(chroma).toColor();

  static Color hctFrom(double hue, double chroma, double tone) => Hct.from(hue, chroma, tone).toColor();

  Iterable<Color> approximateMaterialTonalPalette() => _MATERIAL_TONAL_PALETTE_TONES.map(withTone);
}

extension HctExtension on Hct {
  Color toColor() => Color(toInt());

  Hct withTone(double tone) {
    assert(tone >= 0 && tone <= ColorExtension.TONE_MAX_VALUE);
    return Hct.from(hue, chroma, max(0, min(tone, ColorExtension.TONE_MAX_VALUE)));
  }

  Hct withChroma(double chroma) {
    assert(chroma >= 0 && chroma <= ColorExtension.CHROMA_MAX_VALUE);
    return Hct.from(hue, max(0, min(chroma, ColorExtension.CHROMA_MAX_VALUE)), tone);
  }

  Hct from(double hue, double chroma, double tone) {
    return Hct.from(
      hue,
      max(0, min(chroma, ColorExtension.CHROMA_MAX_VALUE)),
      max(0, min(tone, ColorExtension.CHROMA_MAX_VALUE)),
    );
  }
}
