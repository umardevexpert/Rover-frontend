import 'package:flutter/material.dart';

const Set<MaterialState> _DEFAULT_STATES = <MaterialState>{};

abstract mixin class ResolvableWithError<T> {
  MaterialPropertyResolver<T> get callback;
  bool get hasError;

  T resolve(Set<MaterialState> states) {
    if (hasError) {
      states.add(MaterialState.error);
    }

    return callback(states);
  }

  // BUG FIX: Flutter does not swap different resolvers if they're equal to each other.
  // This leads to a problem with values provided by Widgets, for example:
  // - Let us assume that we have bool flag hasError (since our widget does not support error state - TextField).
  //   We want to return errorColor when this flag is true. However Flutter, when we create new instance of
  //   MaterialStateColor does not detect any change in this provided instance, thus it does not swap the resolver
  //   and instead uses the one with the old flag value.
  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is ResolvableWithError && callback == other.callback && hasError == other.hasError;
  }

  @override
  int get hashCode => callback.hashCode ^ hasError.hashCode;
}

class MaterialStateUnderlinedInputBorderWithError extends UnderlineInputBorder
    with ResolvableWithError<InputBorder>
    implements MaterialStateProperty<InputBorder> {
  @override
  final MaterialPropertyResolver<InputBorder> callback;
  @override
  final bool hasError;

  MaterialStateUnderlinedInputBorderWithError.resolveWith(this.callback, {required this.hasError});
}

class MaterialStateOutlineInputBorderWithError extends OutlineInputBorder
    with ResolvableWithError<InputBorder>
    implements MaterialStateProperty<InputBorder> {
  @override
  final MaterialPropertyResolver<InputBorder> callback;
  @override
  final bool hasError;

  MaterialStateOutlineInputBorderWithError.resolveWith(this.callback, {required this.hasError});
}

class MaterialStateTextStyleWithError extends TextStyle
    with ResolvableWithError<TextStyle>
    implements MaterialStateProperty<TextStyle> {
  @override
  final MaterialPropertyResolver<TextStyle> callback;
  @override
  final bool hasError;

  MaterialStateTextStyleWithError.resolveWith(this.callback, {required this.hasError});
}

class MaterialStateColorWithError extends Color
    with ResolvableWithError<Color>
    implements MaterialStateProperty<Color> {
  @override
  final MaterialPropertyResolver<Color> callback;
  @override
  final bool hasError;
  MaterialStateColorWithError.resolveWith(this.callback, {required this.hasError})
      : super(callback(_DEFAULT_STATES).value);
}
