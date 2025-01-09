// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:ui_kit/util/obtainable_theme_extension.dart';

/// The [InputDecorationErrorTheme] supplies styling to ValidatedTextFormField (and only this form field, it will
/// not work with any other).
///
/// It is used to also supply error colors for properties, which do not have their own error theming (like [labelStyle]
/// and [suffixIconColor]).
class InputDecorationErrorTheme extends ThemeExtension<InputDecorationErrorTheme> {
  const InputDecorationErrorTheme({
    this.border,
    this.focusedBorder,
    this.labelColor,
    this.labelStyle,
    this.floatingLabelStyle,
    this.suffixIconColor,
    this.cursorColor,
  });

  static InputDecorationErrorTheme? of(BuildContext context) =>
      ObtainableThemeExtension.of<InputDecorationErrorTheme>(context);

  /// Error decoration for when Input field.
  ///
  /// ## Border priority ordering:
  ///
  /// *CustomDecoration.errorBorder* -> *InputDecorationErrorTheme.border* -> *Theme.errorBorder* ->
  /// *CustomDecoration.border* -> *Theme.border* ->
  /// *Material3.focusedBorder* -> *Material3.border*
  ///
  /// Where:
  /// - **InputDecorationErrorTheme** = instance of this class
  /// - **CustomDecoration** = decoration directly supplied to field via the style property.
  /// - **Theme** = default theme
  /// - **Material3** = if nothing of the previous is applied, then the default values (specified by Material3) will be used
  final InputBorder? border;

  /// Error decoration for when Input field is in focused state.
  ///
  /// ## Focused border priority ordering:
  ///
  /// *CustomDecoration.focusedErrorBorder* -> *InputDecorationErrorTheme.focusedBorder* -> *Theme.focusedErrorBorder* ->
  /// *CustomDecoration.errorBorder* -> *InputDecorationErrorTheme.border* -> *Theme.errorBorder* ->
  /// *CustomDecoration.focusedBorder* -> *Theme.focusedBorder* ->
  /// *CustomDecoration.border* -> *Theme.border* ->
  /// *Material3.focusedBorder* -> *Material3.border*
  ///
  /// Where:
  /// - **InputDecorationErrorTheme** = instance of this class
  /// - **CustomDecoration** = decoration directly supplied to field via the style property.
  /// - **Theme** = default theme
  /// - **Material3** = if nothing of the previous is applied, then the default values (specified by Material3) will be used
  final InputBorder? focusedBorder;

  /// The error color which will be used when [labelStyle] or [floatingLabelStyle] are not supplied for their
  /// reflective styles.
  ///
  /// If the style is not supplied, then the default style will be used and on this default style the [labelColor] will
  /// be applied.
  ///
  /// If the [labelColor] is not supplied as well, then the default style will be used with no changes
  final Color? labelColor;

  /// Error decoration for label displayed within the input field
  ///
  /// The [labelStyle] property has the highest priority in the application of decoration.
  ///
  /// ### Note:
  /// !This style will not be used for [floatingLabelStyle]!
  ///
  /// ## Label style priority ordering:
  ///
  /// *InputDecorationErrorTheme.labelStyle* -> *CustomDecoration.labelStyle* -> *Theme.labelStyle* -> *Material3.labelStyle*
  ///
  /// If [labelColor] is supplied, then this color will be also applied to the to all of these
  /// label styles (excluding the [labelStyle] property)
  ///
  /// Where:
  /// - **InputDecorationErrorTheme** = instance of this class
  /// - **CustomDecoration** = decoration directly supplied to field via the style property.
  /// - **Theme** = default theme
  /// - **Material3** = if nothing of the previous is applied, then the default values (specified by Material3) will be used
  final TextStyle? labelStyle;

  /// Error decoration for label displayed within the input field
  ///
  /// The [labelStyle] property has the highest priority in the application of decoration.
  ///
  /// ### Note:
  /// !This style will not be used for [labelStyle]!
  ///
  /// ## Label style priority ordering:
  ///
  /// *InputDecorationErrorTheme.floatingLabelStyle* -> *CustomDecoration.floatingLabelStyle* -> *Theme.floatingLabelStyle* -> *Material3.labelStyle*
  ///
  /// If [labelColor] is supplied, then this color will be also applied to the to all of these
  /// floating label styles (excluding the [floatingLabelStyle] property)
  ///
  /// Where:
  /// - **InputDecorationErrorTheme** = instance of this class
  /// - **CustomDecoration** = decoration directly supplied to field via the style property.
  /// - **Theme** = default theme
  /// - **Material3** = if nothing of the previous is applied, then the default values (specified by Material3) will be used
  ///
  /// ### Note:
  /// *Material3 has same specification for [labelStyle] and [floatingLabelStyle] so the same one will be used for both cases.
  final TextStyle? floatingLabelStyle;

  /// When [suffixIconColor] is specified, then the suffix Icon will use this color with highest priority (when the
  /// form field is in error state)
  ///
  /// ## Suffix icon style priority ordering:
  ///
  /// *InputDecorationErrorTheme.suffixIconColor* -> *CustomDecoration.suffixIconColor* -> *Theme.suffixIconColor* -> *Material3.suffixIconColor*
  ///
  /// Where:
  /// - **InputDecorationErrorTheme** = instance of this class
  /// - **CustomDecoration** = decoration directly supplied to field via the style property.
  /// - **Theme** = default theme
  /// - **Material3** = if nothing of the previous is applied, then the default values (specified by Material3) will be used
  final Color? suffixIconColor;

  /// When [cursorColor] is specified, then the cursor color will use this color with highest priority (when the
  /// form field is in error state). Otherwise the default cursor color will be used
  final Color? cursorColor;

  InputDecorationErrorTheme copyWith({
    InputBorder? border,
    InputBorder? focusedBorder,
    Color? labelColor,
    TextStyle? labelStyle,
    TextStyle? floatingLabelStyle,
    Color? suffixIconColor,
    Color? cursorColor,
  }) {
    return InputDecorationErrorTheme(
      border: border ?? this.border,
      focusedBorder: focusedBorder ?? this.focusedBorder,
      labelColor: labelColor ?? this.labelColor,
      labelStyle: labelStyle ?? this.labelStyle,
      floatingLabelStyle: floatingLabelStyle ?? this.floatingLabelStyle,
      suffixIconColor: suffixIconColor ?? this.suffixIconColor,
      cursorColor: cursorColor ?? this.cursorColor,
    );
  }

  @override
  ThemeExtension<InputDecorationErrorTheme> lerp(
    covariant ThemeExtension<InputDecorationErrorTheme>? other,
    // ignore: avoid_renaming_method_parameters
    double progress,
  ) {
    if (other is! InputDecorationErrorTheme) {
      return this;
    }

    return InputDecorationErrorTheme(
      // TODO(Pavel): [border] and [focusedBorder] do not have lerp property so they are not animating. Fix this
      border: border,
      focusedBorder: focusedBorder,
      labelColor: Color.lerp(labelColor, other.labelColor, progress),
      labelStyle: TextStyle.lerp(labelStyle, other.labelStyle, progress),
      floatingLabelStyle: TextStyle.lerp(floatingLabelStyle, other.floatingLabelStyle, progress),
      suffixIconColor: Color.lerp(suffixIconColor, other.suffixIconColor, progress),
      cursorColor: Color.lerp(cursorColor, other.cursorColor, progress),
    );
  }
}
