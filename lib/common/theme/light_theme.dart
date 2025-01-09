import 'package:flutter/material.dart' hide MenuBarTheme;
import 'package:google_fonts/google_fonts.dart';
import 'package:rover/common/theme/extension/app_theme.dart';
import 'package:rover/common/theme/extension/rover_color_scheme_extension.dart';
import 'package:rover/common/theme/extension/rover_text_theme_extension.dart';
import 'package:rover/common/theme/shared_ui_constants.dart';
import 'package:ui_kit/input/compliant_text_field/theme/input_decoration_error_theme.dart';
import 'package:ui_kit/input/dropdown/theme/drop_down_facade_theme.dart';
import 'package:ui_kit/input/dropdown/theme/drop_down_popup_theme.dart';
import 'package:ui_kit/navigation/theme/tabbed_menu_theme.dart';

const _PRIMARY = Color(0xFF3997D8);
const _PRIMARY_DARK = Color(0xFF123146);
const _PRIMARY_LIGHT = Color(0xFFEEF6FB);
const _SECONDARY = Color(0xFFE7B277);
const _SECONDARY_DARK = Color(0xFFBA8C50);
const _SECONDARY_LIGHT = Color(0xFFFDF7F1);
const _BLUE = Color(0xFF427FE6);
const _BLUE_DARK = Color(0xFF002147);
const _BLUE_LIGHT = Color(0xFFECF2FC);
const _RED = Color(0xFFE95959);
const _RED_DARK = Color(0xFF47130A);
const _RED_LIGHT = Color(0xFFFDEEEE);
const _YELLOW = Color(0xFFDF984A);
const _YELLOW_DARK = Color(0xFF473405);
const _YELLOW_LIGHT = Color(0xFFFCF5ED);
const _GREEN = Color(0xFF0FA760);
const _GREEN_DARK = Color(0xFF003F25);
const _GREEN_LIGHT = Color(0xFFE7F6EF);
const _GREY_100 = Color(0xFFF8F9FA);
const _GREY_200 = Color(0xFFE9ECEF);
const _GREY_300 = Color(0xFFDEE2E6);
const _GREY_400 = Color(0xFFCED4DA);
const _GREY_500 = Color(0xFFADB5BD);
const _GREY_600 = Color(0xFF6C757D);
const _GREY_700 = Color(0xFF495057);
const _GREY_800 = Color(0xFF343A40);
const _GREY_900 = Color(0xFF212529);
const _COLOR_SCALE_0 = Color(0xFFB77D3D);
const _COLOR_SCALE_1 = Color(0xFFF4ECE2);
const _COLOR_SCALE_2 = Color(0xFFBEDAED);
const _COLOR_SCALE_3 = Color(0xFF7B94B4);
const _COLOR_SCALE_4 = Color(0xFF1A5C89);

final _buttonTextStyle = GoogleFonts.inter(
  fontWeight: FontWeight.w600,
  fontSize: 16,
);

final lightTheme = ThemeData(
  colorScheme: ColorScheme.fromSwatch(
    primarySwatch: Colors.blue,
    backgroundColor: Colors.white,
    errorColor: _RED,
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: Colors.white,
    hoverColor: _GREY_100,
    focusColor: _GREY_100,
    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    labelStyle: TextStyle(color: _GREY_600),
    floatingLabelStyle: TextStyle(color: _PRIMARY_DARK),
    border: OutlineInputBorder(
      borderSide: BorderSide(color: _GREY_500),
      borderRadius: BorderRadius.circular(8.0),
    ),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: _GREY_400),
      borderRadius: BorderRadius.circular(8.0),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: _PRIMARY_DARK, width: 2),
      borderRadius: BorderRadius.circular(8.0),
    ),
    disabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: _GREY_400),
      borderRadius: BorderRadius.circular(8.0),
    ),
    errorBorder: OutlineInputBorder(
      borderSide: BorderSide(color: _RED),
      borderRadius: BorderRadius.circular(8.0),
    ),
    iconColor: _GREY_500,
    suffixIconColor: _GREY_500,
  ),
  textSelectionTheme: TextSelectionThemeData(
    cursorColor: _PRIMARY_DARK,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ButtonStyle(
      shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(7.0))),
      visualDensity: VisualDensity.standard,
      padding: MaterialStateProperty.all(const EdgeInsets.symmetric(horizontal: 16.0, vertical: 11.0)),
      maximumSize: MaterialStateProperty.all(Size.infinite),
      elevation: MaterialStateProperty.all(0),
      foregroundColor: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.disabled)) {
          return _GREY_600;
        }
        return _GREY_100;
      }),
      textStyle: MaterialStateProperty.all(_buttonTextStyle),
    ),
  ),
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: ButtonStyle(
      shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(7.0))),
      visualDensity: VisualDensity.standard,
      padding: MaterialStateProperty.all(const EdgeInsets.symmetric(horizontal: 16.0, vertical: 11.0)),
      maximumSize: MaterialStateProperty.all(Size.infinite),
      elevation: MaterialStateProperty.all(0),
      textStyle: MaterialStateProperty.all(_buttonTextStyle),
    ),
  ),
  textButtonTheme: TextButtonThemeData(
    style: ButtonStyle(
      padding: MaterialStateProperty.all(const EdgeInsets.all(2)),
      visualDensity: VisualDensity.standard,
      foregroundColor: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.disabled)) {
          return _GREY_500;
        }
        if (states.contains(MaterialState.pressed)) {
          return _PRIMARY;
        }
        if (states.contains(MaterialState.hovered) || states.contains(MaterialState.focused)) {
          return _GREY_600;
        }
        return _GREY_900;
      }),
      textStyle: MaterialStateProperty.all(_buttonTextStyle),
    ),
  ),
  scaffoldBackgroundColor: _GREY_100,
  textTheme: GoogleFonts.interTextTheme(),
  hintColor: _GREY_600,
  extensions: [
    AppTheme(
      colorScheme: _createColorScheme(),
      textTheme: _createTextTheme(),
    ),
    TabbedMenuTheme(
      tabBarPadding: const EdgeInsets.all(4.0),
      tabBarItemPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      indicatorDecoration: BoxDecoration(
        color: _PRIMARY_LIGHT,
        borderRadius: BorderRadius.circular(6.0),
      ),
      labelStyle: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),
      foregroundColor: _PRIMARY,
    ),
    DropDownFacadeTheme(
      backgroundColor: Colors.white,
      border: Border.all(color: _GREY_400),
      borderRadius: STANDARD_BORDER_RADIUS,
      padding: EdgeInsets.symmetric(horizontal: 12),
      hintStyle: TextStyle(
        fontSize: 16,
        color: Colors.grey[700],
      ),
    ),
    DropDownPopupTheme(
      backgroundColor: Colors.white,
      border: Border.all(color: _GREY_200),
      borderRadius: STANDARD_BORDER_RADIUS,
      elevation: 4,
      popupToElementGap: 4,
    ),
    InputDecorationErrorTheme(labelColor: _RED),
  ],
);

RoverColorScheme _createColorScheme() => RoverColorScheme(
      primary: _PRIMARY,
      primaryDark: _PRIMARY_DARK,
      primaryLight: _PRIMARY_LIGHT,
      secondary: _SECONDARY,
      secondaryDark: _SECONDARY_DARK,
      secondaryLight: _SECONDARY_LIGHT,
      blue: _BLUE,
      blueDark: _BLUE_DARK,
      blueLight: _BLUE_LIGHT,
      red: _RED,
      redDark: _RED_DARK,
      redLight: _RED_LIGHT,
      yellow: _YELLOW,
      yellowDark: _YELLOW_DARK,
      yellowLight: _YELLOW_LIGHT,
      green: _GREEN,
      greenDark: _GREEN_DARK,
      greenLight: _GREEN_LIGHT,
      grey100: _GREY_100,
      grey200: _GREY_200,
      grey300: _GREY_300,
      grey400: _GREY_400,
      grey500: _GREY_500,
      grey600: _GREY_600,
      grey700: _GREY_700,
      grey800: _GREY_800,
      grey900: _GREY_900,
      colorScale0: _COLOR_SCALE_0,
      colorScale1: _COLOR_SCALE_1,
      colorScale2: _COLOR_SCALE_2,
      colorScale3: _COLOR_SCALE_3,
      colorScale4: _COLOR_SCALE_4,
    );

RoverTextTheme _createTextTheme() {
  final headingStyle = GoogleFonts.inter(
    fontWeight: FontWeight.w700,
    height: 1.3,
    letterSpacing: 0,
    color: _GREY_900,
  );

  final titleStyle = GoogleFonts.inter(
    fontWeight: FontWeight.w600,
    height: 1.5,
    letterSpacing: 0,
    color: _GREY_900,
  );

  final bodyStyle = GoogleFonts.inter(
    fontWeight: FontWeight.w400,
    height: 1.5,
    letterSpacing: 0,
    color: _GREY_900,
  );

  return RoverTextTheme(
    headingHero: headingStyle.copyWith(fontSize: 40),
    headingH1: headingStyle.copyWith(fontSize: 36),
    headingH2: headingStyle.copyWith(fontSize: 32),
    titleXL: titleStyle.copyWith(fontSize: 20),
    titleL: titleStyle.copyWith(fontSize: 16),
    titleM: titleStyle.copyWith(fontSize: 14),
    titleS: titleStyle.copyWith(fontSize: 12),
    bodyXL: bodyStyle.copyWith(fontSize: 20),
    bodyL: bodyStyle.copyWith(fontSize: 16),
    bodyM: bodyStyle.copyWith(fontSize: 14),
    bodyS: bodyStyle.copyWith(fontSize: 12),
  );
}
