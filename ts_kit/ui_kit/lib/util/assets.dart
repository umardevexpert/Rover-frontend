import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart' as svg;
import 'package:flutter_svg_provider/flutter_svg_provider.dart' as svg_provider;

// ignore: avoid_classes_with_only_static_members
class Assets {
  static String standardImagePath = 'asset/image';

  static svg.SvgPicture svgImage(
    String name, {
    Key? key,
    double? height,
    double? width,
    BoxFit fit = BoxFit.contain,
    Alignment alignment = Alignment.center,
    bool allowDrawingOutsideViewBox = false,
    Color? color,
  }) {
    return svg.SvgPicture.asset(
      '$standardImagePath/$name.svg',
      key: key,
      height: height,
      width: width,
      fit: fit,
      alignment: alignment,
      allowDrawingOutsideViewBox: allowDrawingOutsideViewBox,
      color: color,
    );
  }

  static Image pngImage(
    String name, {
    Key? key,
    double? height,
    double? width,
    AlignmentGeometry alignment = Alignment.center,
    BoxFit? fit,
  }) {
    return Image.asset(
      '$standardImagePath/$name.png',
      key: key,
      width: width,
      height: height,
      alignment: alignment,
      fit: fit,
    );
  }

  static Image jpgImage(String name, {Key? key, double? height, double? width, BoxFit? fit}) {
    return Image.asset(
      '$standardImagePath/$name.jpg',
      key: key,
      width: width,
      height: height,
      fit: fit,
    );
  }

  static AssetImage jpgAssetImage(String name) {
    return AssetImage('$standardImagePath/$name.jpg');
  }

  static AssetImage pngAssetImage(String name) {
    return AssetImage('$standardImagePath/$name.png');
  }

  static svg_provider.Svg svgAssetImage(String name, {Size? size}) {
    return svg_provider.Svg('$standardImagePath/$name.svg', size: size);
  }
}
