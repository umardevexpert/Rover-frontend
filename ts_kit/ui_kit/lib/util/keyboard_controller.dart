import 'package:flutter/services.dart';

// ignore: avoid_classes_with_only_static_members
class KeyboardController {
  static void showKeyboard() {
    SystemChannels.textInput.invokeMethod('TextInput.show');
  }

  static void hideKeyboard() {
    SystemChannels.textInput.invokeMethod('TextInput.hide');
  }
}
