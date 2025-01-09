import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:rover/common/service/ioc_container.dart';
import 'package:rover/common/widget/app_root.dart';
import 'package:window_manager/window_manager.dart';

const _MIN_WIDTH = 1024.0;
const _MIN_HEIGHT = 768.0;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  IoCContainer().setup();

  runApp(AppRoot());

  await windowManager.ensureInitialized();
  
  // Temporary BUG FIX(Pavel): bitsdojo_window has a bug where the doWhenWindowReady() is never called until
  // the app is visible. By default (in MainFlutterWindow.swift file), the flag is to hide the app until the window
  // is updated the way we want to. This is broken since newer Flutter versions (3.16 and 3.19)
  appWindow.show();
  _setMinimumWindowSize();
}

void _setMinimumWindowSize() {
  doWhenWindowReady(() {
    appWindow.minSize = Size(_MIN_WIDTH, _MIN_HEIGHT);
    appWindow.maximize();
    appWindow.show();
  });
}
