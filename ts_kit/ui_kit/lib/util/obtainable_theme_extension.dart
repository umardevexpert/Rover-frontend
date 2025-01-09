import 'package:flutter/material.dart';

abstract class ObtainableThemeExtension {
  const ObtainableThemeExtension._();

  static T? of<T>(BuildContext context) {
    final theme = Theme.of(context);
    // ThemeData.extension<T> does not return null if the T is not registered as extension but throws error
    if (theme.extensions.containsKey(T)) {
      return theme.extension<T>()!;
    }
    return null;
  }
}
