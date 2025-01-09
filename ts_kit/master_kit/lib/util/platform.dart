import 'dart:io' as dartio;

// This is copy of the kIsWeb constant which is only for Flutter
const _kIsWeb = identical(0, 0.0);

enum Platform {
  linux,
  macOS,
  windows,
  iOS,
  android,
  fuchsia,
  web;

  static Platform get current {
    if (_kIsWeb) {
      return Platform.web;
    }
    if (dartio.Platform.isIOS) {
      return Platform.iOS;
    }
    if (dartio.Platform.isAndroid) {
      return Platform.android;
    }
    if (dartio.Platform.isWindows) {
      return Platform.windows;
    }
    if (dartio.Platform.isMacOS) {
      return Platform.macOS;
    }
    if (dartio.Platform.isLinux) {
      return Platform.linux;
    }
    if (dartio.Platform.isFuchsia) {
      return Platform.fuchsia;
    }
    return Platform.web;
  }
}

const MOBILE_PLATFORMS = <Platform>{Platform.iOS, Platform.android};
const NON_MOBILE_PLATFORMS = <Platform>{
  Platform.linux,
  Platform.macOS,
  Platform.web,
  Platform.windows,
  Platform.fuchsia,
};

extension PlatformExtension on Platform {
  bool get isMobile => MOBILE_PLATFORMS.contains(this);
  bool get isAndroid => this == Platform.android;
  bool get isWeb => this == Platform.web;
  bool get isIOS => this == Platform.iOS;
  bool get isApple => {Platform.iOS, Platform.macOS}.contains(this);
}
