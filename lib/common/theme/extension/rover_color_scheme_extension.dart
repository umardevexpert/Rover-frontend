import 'package:flutter/material.dart';

class RoverColorScheme {
  final Color primary;
  final Color primaryDark;
  final Color primaryLight;

  final Color secondary;
  final Color secondaryDark;
  final Color secondaryLight;

  final Color blue;
  final Color blueDark;
  final Color blueLight;

  final Color red;
  final Color redDark;
  final Color redLight;

  final Color yellow;
  final Color yellowDark;
  final Color yellowLight;

  final Color green;
  final Color greenDark;
  final Color greenLight;

  final Color grey100;
  final Color grey200;
  final Color grey300;
  final Color grey400;
  final Color grey500;
  final Color grey600;
  final Color grey700;
  final Color grey800;
  final Color grey900;

  final Color colorScale0;
  final Color colorScale1;
  final Color colorScale2;
  final Color colorScale3;
  final Color colorScale4;

  const RoverColorScheme({
    required this.primary,
    required this.primaryDark,
    required this.primaryLight,
    required this.secondary,
    required this.secondaryDark,
    required this.secondaryLight,
    required this.blue,
    required this.blueDark,
    required this.blueLight,
    required this.red,
    required this.redDark,
    required this.redLight,
    required this.yellow,
    required this.yellowDark,
    required this.yellowLight,
    required this.green,
    required this.greenDark,
    required this.greenLight,
    required this.grey100,
    required this.grey200,
    required this.grey300,
    required this.grey400,
    required this.grey500,
    required this.grey600,
    required this.grey700,
    required this.grey800,
    required this.grey900,
    required this.colorScale0,
    required this.colorScale1,
    required this.colorScale2,
    required this.colorScale3,
    required this.colorScale4,
  });

  RoverColorScheme copyWith({
    Color? primary,
    Color? primaryDark,
    Color? primaryLight,
    Color? secondary,
    Color? secondaryDark,
    Color? secondaryLight,
    Color? blue,
    Color? blueDark,
    Color? blueLight,
    Color? red,
    Color? redDark,
    Color? redLight,
    Color? yellow,
    Color? yellowDark,
    Color? yellowLight,
    Color? green,
    Color? greenDark,
    Color? greenLight,
    Color? grey100,
    Color? grey200,
    Color? grey300,
    Color? grey400,
    Color? grey500,
    Color? grey600,
    Color? grey700,
    Color? grey800,
    Color? grey900,
    Color? colorScale0,
    Color? colorScale1,
    Color? colorScale2,
    Color? colorScale3,
    Color? colorScale4,
  }) {
    return RoverColorScheme(
      primary: primary ?? this.primary,
      primaryDark: primaryDark ?? this.primaryDark,
      primaryLight: primaryLight ?? this.primaryLight,
      secondary: secondary ?? this.secondary,
      secondaryDark: secondaryDark ?? this.secondaryDark,
      secondaryLight: secondaryLight ?? this.secondaryLight,
      blue: blue ?? this.blue,
      blueDark: blueDark ?? this.blueDark,
      blueLight: blueLight ?? this.blueLight,
      red: red ?? this.red,
      redDark: redDark ?? this.redDark,
      redLight: redLight ?? this.redLight,
      yellow: yellow ?? this.yellow,
      yellowDark: yellowDark ?? this.yellowDark,
      yellowLight: yellowLight ?? this.yellowLight,
      green: green ?? this.green,
      greenDark: greenDark ?? this.greenDark,
      greenLight: greenLight ?? this.greenLight,
      grey100: grey100 ?? this.grey100,
      grey200: grey200 ?? this.grey200,
      grey300: grey300 ?? this.grey300,
      grey400: grey400 ?? this.grey400,
      grey500: grey500 ?? this.grey500,
      grey600: grey600 ?? this.grey600,
      grey700: grey700 ?? this.grey700,
      grey800: grey800 ?? this.grey800,
      grey900: grey900 ?? this.grey900,
      colorScale0: colorScale0 ?? this.colorScale0,
      colorScale1: colorScale1 ?? this.colorScale1,
      colorScale2: colorScale2 ?? this.colorScale2,
      colorScale3: colorScale3 ?? this.colorScale3,
      colorScale4: colorScale4 ?? this.colorScale4,
    );
  }

  RoverColorScheme lerp(RoverColorScheme other, double t) {
    return RoverColorScheme(
      primary: Color.lerp(primary, other.primary, t) ?? primary,
      primaryDark: Color.lerp(primaryDark, other.primaryDark, t) ?? primaryDark,
      primaryLight: Color.lerp(primaryLight, other.primaryLight, t) ?? primaryLight,
      secondary: Color.lerp(secondary, other.secondary, t) ?? secondary,
      secondaryDark: Color.lerp(secondaryDark, other.secondaryDark, t) ?? secondaryDark,
      secondaryLight: Color.lerp(secondaryLight, other.secondaryLight, t) ?? secondaryLight,
      blue: Color.lerp(blue, other.blue, t) ?? blue,
      blueDark: Color.lerp(blueDark, other.blueDark, t) ?? blueDark,
      blueLight: Color.lerp(blueLight, other.blueLight, t) ?? blueLight,
      red: Color.lerp(red, other.red, t) ?? red,
      redDark: Color.lerp(redDark, other.redDark, t) ?? redDark,
      redLight: Color.lerp(redLight, other.redLight, t) ?? redLight,
      yellow: Color.lerp(yellow, other.yellow, t) ?? yellow,
      yellowDark: Color.lerp(yellowDark, other.yellowDark, t) ?? yellowDark,
      yellowLight: Color.lerp(yellowLight, other.yellowLight, t) ?? yellowLight,
      green: Color.lerp(green, other.green, t) ?? green,
      greenDark: Color.lerp(greenDark, other.greenDark, t) ?? greenDark,
      greenLight: Color.lerp(greenLight, other.greenLight, t) ?? greenLight,
      grey100: Color.lerp(grey100, other.grey100, t) ?? grey100,
      grey200: Color.lerp(grey200, other.grey200, t) ?? grey200,
      grey300: Color.lerp(grey300, other.grey300, t) ?? grey300,
      grey400: Color.lerp(grey400, other.grey400, t) ?? grey400,
      grey500: Color.lerp(grey500, other.grey500, t) ?? grey500,
      grey600: Color.lerp(grey600, other.grey600, t) ?? grey600,
      grey700: Color.lerp(grey700, other.grey700, t) ?? grey700,
      grey800: Color.lerp(grey800, other.grey800, t) ?? grey800,
      grey900: Color.lerp(grey900, other.grey900, t) ?? grey900,
      colorScale0: Color.lerp(colorScale0, other.colorScale0, t) ?? colorScale0,
      colorScale1: Color.lerp(colorScale1, other.colorScale1, t) ?? colorScale1,
      colorScale2: Color.lerp(colorScale2, other.colorScale2, t) ?? colorScale2,
      colorScale3: Color.lerp(colorScale3, other.colorScale3, t) ?? colorScale3,
      colorScale4: Color.lerp(colorScale4, other.colorScale4, t) ?? colorScale4,
    );
  }
}
